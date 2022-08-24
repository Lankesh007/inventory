// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/screens/masterTab/add_customer_master_screen.dart';
import 'package:demo_test/screens/masterTab/purchase_item_screen.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({Key? key}) : super(key: key);

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  double height = 0;
  double listTotalAmount = 0;
  double width = 0;
  bool fixedTap = true;
  bool percentageTap = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool customerSupport = false;
  double totalPrice = 0;
  List customerMasterList = [];
  List itemMasterList = [];
  String customerMasterValue = 'Select Customer';
  _getCustomerMasterdata() {
    var data = FirebaseFirestore.instance.collection('customerMaster').get();

    data.then((value) {
      setState(() {
        customerMasterList.clear();
        customerMasterList.add({
          "customer_name": "Select Customer",
        });
        customerMasterList.addAll(value.docs);
      });
    });
  }

  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  String itemMasterValue = 'Select Item';
  _getItemMasterData() {
    var data = FirebaseFirestore.instance.collection('itemMaster').get();

    data.then((value) {
      setState(() {
        itemMasterList.clear();
        itemMasterList.add({
          "item_name": "Select Item",
        });
        itemMasterList.addAll(value.docs);
      });
    });
  }

  double totalFinal = 0;
  void calculation() {
    for (var element in finalList) {
      totalFinal = totalFinal + double.parse(element['totalAmont'].toString());
    }
    log("-->$totalFinal");
  }

  void removef() {
    for (var element in finalList) {
      totalFinal = totalFinal - double.parse(element['totalAmont'].toString());
      log("------->$totalFinal");
    }
  }

  double quantity = 0;
  double price = 0;
  double discount = 0;
  double minmumAmount = 0;
  double totalAmount = 0;
  double discountAmount = 0;

  getTotalAmount() {
    if (percentageTap == true) {
      if (quantityController.text.isEmpty &&
          priceController.text.isEmpty &&
          discountController.text.isEmpty) {
        totalAmount = 0.0;
      } else {
        quantity = double.parse(quantityController.text);
        price = double.parse(priceController.text);
        // tax = double.parse(taxController.text);
        discount = double.parse(discountController.text);
        minmumAmount = quantity * price;
        // taxPrice = minmumAmount * tax / 100;
        // taxablePrice = taxPrice + minmumAmount;
        discountAmount = minmumAmount * discount / 100;
        totalAmount = minmumAmount - discountAmount;
      }
    }
    if (fixedTap == true) {
      if (quantityController.text.isEmpty &&
          priceController.text.isEmpty &&
          discountController.text.isEmpty) {
        totalAmount = 0.0;
      } else {
        quantity = double.parse(quantityController.text);
        price = double.parse(priceController.text);
        // tax = double.parse(taxController.text);
        discount = double.parse(discountController.text);
        minmumAmount = quantity * price;
        // taxPrice = minmumAmount * tax / 100;
        // taxablePrice = taxPrice + minmumAmount;
        totalAmount = minmumAmount - discount;
      }
    }
  }

  List finalList = [];

  @override
  void initState() {
    _getCustomerMasterdata();
    _getItemMasterData();
    finalList.clear();
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
          "Sale Master",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              textfieldsWidget(),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 20,
              ),
              itemSalesWidget(),
              const SizedBox(
                height: 20,
              ),
              finalList.isNotEmpty ? submitButtonWidget() : Container(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemSalesWidget() {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: finalList.length,
          itemBuilder: (context, index) {
            // log("total price--->$listTotalAmount");
            return Column(
              children: [
                SizedBox(
                  height: height * 0.12,
                  width: width * 0.9,
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Item : "),
                                        Text(finalList[index]['item']
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("T-Price : "),
                                        Text(
                                            " ${finalList[index]['totalAmont'].toString()}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 90,
                              width: 1,
                              child: VerticalDivider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("dis : "),
                                        Text(finalList[index]['discount']
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("price : "),
                                        Text(
                                            " ${finalList[index]['price'].toString()}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 90,
                              width: 1,
                              child: VerticalDivider(
                                color: Colors.black,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                width: width * 0.1,
                                height: 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        removef();
                                        setState(() {
                                          finalList.removeAt(index);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                "Item Removed Successfully !!",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                      iconSize: 35,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget textfieldsWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customerSupport == false
                  ? SizedBox(
                      width: width * 0.7,
                      height: height * 0.06,
                      child: Card(
                        child: DropdownButton(
                          underline: const SizedBox(),
                          // Initial Value
                          value: customerMasterValue,
                          // Down Arrow Icon
                          // Array list of items

                          items: customerMasterList.map((items) {
                            return DropdownMenuItem(
                              value: items['customer_name'],
                              child: SizedBox(
                                  height: height * 0.09,
                                  width: width * 0.6,
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(items['customer_name']))),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (newValue) {
                            setState(() {
                              customerMasterValue = newValue.toString();
                            });
                          },
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: height * 0.07,
                      width: width * 0.7,
                      child: Card(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: customerMasterValue,
                              hintStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AddCustomerMasterScreen()));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.05,
                  width: width * 0.11,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.black)),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.7,
                height: height * 0.06,
                child: Card(
                  child: DropdownButton(
                    underline: const SizedBox(),
                    // Initial Value
                    value: itemMasterValue,
                    // Down Arrow Icon
                    // Array list of items

                    items: itemMasterList.map((items) {
                      return DropdownMenuItem(
                        value: items['item_name'],
                        child: SizedBox(
                            height: height * 0.09,
                            width: width * 0.6,
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(items['item_name']))),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (newValue) {
                      setState(() {
                        itemMasterValue = newValue.toString();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PurchaseItemScreen()));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.05,
                  width: width * 0.11,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.black)),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.07,
            width: width * 0.83,
            child: Card(
              child: TextFormField(
                controller: quantityController,
                onChanged: (value) {
                  setState(() {
                    getTotalAmount();
                  });
                },
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Quantity is required !!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Quantity",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.07,
            width: width * 0.83,
            child: Card(
              child: TextFormField(
                controller: priceController,
                onChanged: (value) {
                  setState(() {
                    getTotalAmount();
                  });
                },
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Price is required !!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      fixedTap = true;
                      if (fixedTap == true) {
                        percentageTap = false;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Fixed",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Container(
                          height: 17,
                          width: 17,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.black)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 13,
                                width: 13,
                                decoration: BoxDecoration(
                                  color: fixedTap == true
                                      ? Colors.red
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      percentageTap = true;
                      if (percentageTap == true) {
                        fixedTap = false;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Percentage",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Container(
                          height: 17,
                          width: 17,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.black)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 13,
                                width: 13,
                                decoration: BoxDecoration(
                                  color: percentageTap == true
                                      ? Colors.red
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.07,
            width: width * 0.83,
            child: Card(
              child: TextFormField(
                controller: discountController,
                onChanged: (value) {
                  setState(() {
                    getTotalAmount();
                  });
                },
                keyboardType: TextInputType.number,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Discount is required !!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: fixedTap == true
                        ? "Discount in Fixed Price"
                        : percentageTap == true
                            ? "Discount in Percentage %"
                            : "",
                    hintStyle: const TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Amount :$totalFinal"),
                InkWell(
                  onTap: () {
                    if (quantityController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        discountController.text.isNotEmpty &&
                        customerMasterValue != "Select Customer" &&
                        itemMasterValue != "Select Item") {
                      finalList.add({
                        "qty": quantityController.text,
                        "price": priceController.text,
                        "discount": fixedTap == true
                            ? "₹ ${discountController.text.toString()}"
                            : percentageTap == true
                                ? "${discountController.text.toString()} %"
                                : "",
                        "customer": customerMasterValue,
                        "item": itemMasterValue,
                        "totalAmont": totalAmount.toString(),
                      });
                      calculation();
                      setState(() {
                        quantityController.clear();
                        priceController.clear();
                        discountController.clear();
                        itemMasterValue = "Select Item";
                        customerSupport = true;
                        listTotalAmount += totalPrice;
                        log("total price--->$listTotalAmount");
                      });

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Successfully Added Item !!"),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Required all fields !!"),
                      ));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    height: height * 0.05,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blueAccent,
                    ),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget() {
    return InkWell(
      onTap: () {
        addCustomerDetails();
      },
      child: Container(
        alignment: Alignment.center,
        height: height * 0.06,
        width: width * 0.8,
        decoration: BoxDecoration(
          color: Appcolors.primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          loading == true ? "loading..." : "Sale Now",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //****************** Save Sale Now  into Firebase firestore********************//

  Future addCustomerDetails() async {
    setState(() {
      loading = true;
    });

    var collection = FirebaseFirestore.instance.collection('saleMaster');
    collection
        .doc() // <-- Document ID
        .set({"data": FieldValue.arrayUnion(finalList)}) // <-- Add data
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));

    // final userDoc = FirebaseFirestore.instance.collection('saleMaster').doc();

    // final json = {
    //   'selected_customer': customerMasterValue.toString(),
    //   'selected_item': itemMasterValue.toString(),
    //   'quantity': quantityController.text.toString(),
    //   'price': priceController.text.toString(),
    //   'discount': "${discountController.text.toString()} %",
    //   'total_amount': totalAmount.toString(),
    // };

    // await userDoc.set(json);
    setState(() {
      Navigator.pop(context);
      loading = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Appcolors.primaryColor,
          content: Text(
            "Sale done Successfully !!",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    });
  }
}
