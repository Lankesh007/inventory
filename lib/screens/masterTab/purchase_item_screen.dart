// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseItemScreen extends StatefulWidget {
  const PurchaseItemScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseItemScreen> createState() => _PurchaseItemScreenState();
}

class _PurchaseItemScreenState extends State<PurchaseItemScreen> {
  double height = 0;
  double width = 0;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  List unitMasterList = [];
  String unitMasterValue = "Select Item";
  late FocusNode myFocusNode;

  final supplierController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final taxController = TextEditingController();
  final pricInTaxController = TextEditingController();
  final totalAmountController = TextEditingController();
  final barCodeController = TextEditingController();

  double totalAmount = 0;
  double netPrice = 0;
  double taxPrice = 0;
  double quantity = 0;
  double price = 0;
  double discount = 0;
  double tax = 0;
  double minmumAmount = 0;
  double taxablePrice = 0;
  double discountAmount = 0;

  getTotalAmount() {
    quantity = double.parse(quantityController.text);
    price = double.parse(priceController.text);
    tax = double.parse(taxController.text);
    discount = double.parse(discountController.text);

    minmumAmount = quantity * price;
    taxPrice = minmumAmount * tax / 100;
    taxablePrice = taxPrice + minmumAmount;
    discountAmount = taxablePrice * discount / 100;
    totalAmount = taxablePrice - discountAmount;
  }

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

  @override
  void initState() {
    _getUnimasterData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Purchase Item",
          style: TextStyle(
              color: Appcolors.whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              unitTextFieldWidget(),
            ],
          )
        ],
      ),
    );
  }

  Widget unitTextFieldWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            width: width,
            child: Card(
              child: TextFormField(
                controller: supplierController,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Supplier Name is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "  Supplier Name",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.96,
            child: Card(
              child: DropdownButton(
                underline: SizedBox(),
                // Initial Value
                value: unitMasterValue,
                // Down Arrow Icon
                // Array list of items

                items: unitMasterList.map((items) {
                  return DropdownMenuItem(
                    value: items['item_name'],
                    child: SizedBox(
                        height: height * 0.09,
                        width: width * 0.72,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
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
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            width: width,
            child: Card(
              child: TextFormField(
                controller: quantityController,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      totalAmount = 0;
                      taxablePrice = 0;
                    } else {
                      getTotalAmount();
                    }
                  });
                },
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Qunatity  is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "  Qunatity ",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            width: width,
            child: Card(
              child: TextFormField(
                controller: priceController,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      totalAmount = 0;
                      taxablePrice = 0;
                    } else {
                      getTotalAmount();
                    }
                  });
                },
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Price is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "  Price",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            width: width,
            child: Card(
              child: TextFormField(
                controller: taxController,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      totalAmount = 0;
                      taxablePrice = 0;
                    } else {
                      getTotalAmount();
                    }
                  });
                },
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Tax is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "  Tax",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            width: width,
            child: Card(
              child: TextFormField(
                controller: discountController,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      totalAmount = 0;
                      taxablePrice = 0;
                    } else {
                      getTotalAmount();
                    }
                  });
                },
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Discount is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "  Discount",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 10),
          //   height: height * 0.08,
          //   width: width,
          //   child: Card(
          //     child: TextFormField(
          //       controller: pricInTaxController,
          //       readOnly: true,
          //       keyboardType: TextInputType.number,
          //       validator: (text) {
          //         if (text == null || text.isEmpty) {
          //           return 'Price Including Tax is required!';
          //         }
          //         return null;
          //       },
          //       decoration: InputDecoration(
          //           hintText: taxablePrice == 0
          //               ? "  Tax Include price"
          //               : "  ₹ $taxablePrice  Included Tax ",
          //           hintStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
          //           border: InputBorder.none),
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 10),
          //   height: height * 0.08,
          //   width: width,
          //   child: Card(
          //     child: TextFormField(
          //       controller: totalAmountController,
          //       readOnly: true,
          //       keyboardType: TextInputType.number,
          //       validator: (text) {
          //         if (text == null || text.isEmpty) {
          //           return 'Amount is required!';
          //         }
          //         return null;
          //       },
          //       decoration: InputDecoration(
          //         hintText: totalAmount == 0
          //             ? "Total Amount"
          //             : "  ₹ $totalAmount  Total Amount",
          //               hintStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
          //           border: InputBorder.none),

          //     ),
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            width: width,
            child: Card(
              child: TextFormField(
                controller: barCodeController,
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Bar Code is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "  Bar Code",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          SizedBox(
            height: 65,
            width: MediaQuery.of(context).size.width / 1.05,
            child: Card(
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
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              taxablePrice == 0
                  ? "  Tax Include price"
                  : quantityController.text.isEmpty &&
                          priceController.text.isEmpty &&
                          taxController.text.isEmpty &&
                          discountController.text.isEmpty
                      ? "Tax Include Amount"
                      : "  ₹ $taxablePrice  Included Tax ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              totalAmount == 0
                  ? "  Total Amount"
                  : quantityController.text.isEmpty &&
                          priceController.text.isEmpty &&
                          taxController.text.isEmpty &&
                          discountController.text.isEmpty
                      ? " Total Amount"
                      : "  ₹ $totalAmount  Total Amount ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          submitButtonWidget(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
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

  Widget submitButtonWidget() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          savePurchaseItemData();
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
          loading == true ? "Please Wait..." : "Purchase",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//############   Data save to firebase cloudstore   ################

  Future savePurchaseItemData() async {
    setState(() {
      loading = true;
    });

    final userDoc = FirebaseFirestore.instance.collection('purchaseItem').doc();

    final json = {
      "barcode": barCodeController.text.toString(),
      "discount": discountController.text.toString(),
      "expiry_date": expiryDate.toString(),
      "itemName": unitMasterValue.toString(),
      "price": priceController.text.toString(),
      "quantity": quantityController.text.toString(),
      "supplierName": supplierController.text.toString(),
      "tax": taxController.text.toString(),
      "taxable_price": taxablePrice.toString(),
      "total_amount": totalAmount.toString(),
    };

    await userDoc.set(json);

 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Appcolors.primaryColor,
              content: Text(
                "Successfully Purchased Item !!",
                style: TextStyle(fontWeight: FontWeight.bold),
              )));
    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }
}
