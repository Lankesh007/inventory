import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/models/item_master_model.dart';
import 'package:demo_test/screens/masterTab/item_master_screen.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';


class ItemMasterDetailsScreen extends StatefulWidget {
  const ItemMasterDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ItemMasterDetailsScreen> createState() =>
      _ItemMasterDetailsScreenState();
}

class _ItemMasterDetailsScreenState extends State<ItemMasterDetailsScreen> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Item Master Details ",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ItemMasterScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: StreamBuilder<List<ItemMasterModel>>(
        stream: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went error--->${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: users.map(itemMasterWidget).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget itemMasterWidget(ItemMasterModel item) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: height * 0.15,
        width: width * 0.97,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Card(
          elevation: 5,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height * 0.14,
                    width: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(item.imageLink),
                            ),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),bottomLeft: Radius.circular(5))),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   width: 100,
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     item.itemName,
                  //     style: const TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  // ),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: width * 0.55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Category:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          item.categoryName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: width * 0.55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "item:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          item.itemName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: width * 0.55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "unit:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          item.unitName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin:
                  //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //   width: width * 0.55,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       const Text(
                  //         "tax:",
                  //         style: TextStyle(fontWeight: FontWeight.w600),
                  //       ),
                  //       Text(
                  //         item.itemTax,
                  //         style: const TextStyle(fontWeight: FontWeight.w600),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ));
  }

  Stream<List<ItemMasterModel>> getUserDetails() => FirebaseFirestore.instance
      .collection('itemMaster')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ItemMasterModel.fromJson(doc.data()))
          .toList());
}
