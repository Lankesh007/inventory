import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class OpeningStockScreen extends StatefulWidget {
  const OpeningStockScreen({Key? key}) : super(key: key);

  @override
  State<OpeningStockScreen> createState() => _OpeningStockScreenState();
}

class _OpeningStockScreenState extends State<OpeningStockScreen> {
  double height = 0;
  double width = 0;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  List unitMasterList = [];
  String unitMasterValue = "Select Item" ;
  late FocusNode myFocusNode;

  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final taxController = TextEditingController();
  final barCodeController = TextEditingController();

  _getUnimasterData() {
    var data = FirebaseFirestore.instance.collection('itemMaster').get();

    data.then((value) {
      setState(() {
        unitMasterList.clear();
        unitMasterList.add({
          "item_name": "Select Item",
        });
        unitMasterList.addAll(value.docs);
      });
    });
  }

  double quantity = 0;
  double price = 0;
  double tax = 0;
  double totalPrice = 0;
  double netPrice = 0;
  double taxPrice = 0;

  @override
  void initState() {
    _getUnimasterData();
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Opening Stock",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              textFieldsWidget(),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      child: Text(totalPrice.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              submitButtonWidget(),
            ],
          ),
        ],
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  final _date = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateFormat formatter =
        DateFormat('dd/MM/yyyy'); //specifies day/month/year format

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(
          text: formatter.format(picked),
        ); //Use formatter to format selected date and assign to text field
      });
    }
  }

  DateTime expiryDate = DateTime.now();
  final expirydate = TextEditingController();

  Future<void> _selectExpiryDate(BuildContext context) async {
    DateFormat formatter =
        DateFormat('dd/MM/yyyy'); //specifies day/month/year format

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: expiryDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != expiryDate) {
      setState(() {
        expiryDate = picked;
        expirydate.value = TextEditingValue(
          text: formatter.format(picked),
        ); //Use formatter to format selected date and assign to text field
      });
    }
  }

  Widget textFieldsWidget() {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: height * 0.63,
        width: width * 0.87,
        child: Card(
          elevation: 15,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.1,
                child: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _date,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Select Date',
                        prefixIcon: Icon(
                          Icons.date_range,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Container(
                width: width * 0.8,
                child: DropdownButton(
                  underline: const SizedBox(),
                  // Initial Value
                  value: unitMasterValue,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: unitMasterList.map((items) {
                    return DropdownMenuItem(
                      value: items['item_name'],
                      child: SizedBox(
                          height: height * 0.09,
                          width: width * 0.72,
                          child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              alignment: Alignment.centerLeft,
                              child: Text(items['item_name']))),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (newValue) {
                    setState(() {
                      unitMasterValue = newValue.toString();
                    });
                  },
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: height * 0.07,
                width: width,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      quantity = double.parse(quantityController.text);
                      price = double.parse(priceController.text);
                      tax = double.parse(taxController.text);
                      netPrice = quantity * price;
                      taxPrice = netPrice * tax / 100;
                      totalPrice = taxPrice + netPrice;
                      log("----->$totalPrice");
                    });
                  },
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Qunatity is empty';
                    }
                    return null;
                  },
                  controller: quantityController,
                  decoration: const InputDecoration(
                      hintText: "Qunatity",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: height * 0.07,
                width: width,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      quantity = double.parse(quantityController.text);
                      price = double.parse(priceController.text);
                      tax = double.parse(taxController.text);
                      netPrice = quantity * price;
                      taxPrice = netPrice * tax / 100;
                      totalPrice = taxPrice + netPrice;
                      log("----->$totalPrice");
                    });
                  },
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Price is empty';
                    }
                    return null;
                  },
                  controller: priceController,
                  decoration: const InputDecoration(
                      hintText: "Price",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: height * 0.07,
                width: width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  onChanged: (value) {
                    if (value.length == 2) {
                      setState(() {
                        taxController.text = "$value.";
                        taxController.selection = TextSelection.collapsed(
                            offset: taxController.text.length);
                      });
                    } else if (value.length > 5) {
                      setState(() {
                        taxController.clear();
                      });
                    }
                    setState(() {
                      quantity = double.parse(quantityController.text);
                      price = double.parse(priceController.text);
                      tax = double.parse(taxController.text);
                      netPrice = quantity * price;
                      taxPrice = netPrice * tax / 100;
                      totalPrice = taxPrice + netPrice;
                      log("----->$totalPrice");
                    });
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Tax is empty';
                    }
                    return null;
                  },
                  controller: taxController,
                  decoration: const InputDecoration(
                      hintText: "Tax",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: height * 0.07,
                width: width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Bar Code Number is empty';
                    }
                    return null;
                  },
                  controller: barCodeController,
                  decoration: const InputDecoration(
                      hintText: "Bar code Number",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.1,
                child: GestureDetector(
                  onTap: () {
                    _selectExpiryDate(context);
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: expirydate,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Select Expiry Date',
                        prefixIcon: Icon(
                          Icons.date_range,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButtonWidget() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          saveOpeningStockData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Appcolors.primaryColor,
              content: Text(
                "Please Fill the all Fields!!",
                style: TextStyle(fontWeight: FontWeight.bold),
              )));
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: height * 0.07,
        width: width * 0.87,
        decoration: BoxDecoration(
          color: Appcolors.primaryColor,
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Text(
          loading == true ? "Please Wait..." : "Submit",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//############# upload to firebase cloud Store ######################

  Future saveOpeningStockData() async {
    setState(() {
      loading = true;
    });

    final userDoc = FirebaseFirestore.instance.collection('openingStock').doc();

    final json = {
      'barcode': barCodeController.text.toString(),
      'expiryDate': expiryDate.toString(),
      'item': unitMasterValue.toString(),
      'price': priceController.text.toString(),
      'quantity': quantity.toString(),
      'selectedDate': selectedDate.toString(),
      'tax': taxController.text.toString(),
      'totalPrice': totalPrice.toString(),
    };

    await userDoc.set(json);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }
}
