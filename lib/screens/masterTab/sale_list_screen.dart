import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/models/sale_model.dart';
import 'package:demo_test/screens/masterTab/sale_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class SaleListScreen extends StatefulWidget {
  const SaleListScreen({Key? key}) : super(key: key);

  @override
  State<SaleListScreen> createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  double height = 0;
  double width = 0;

  @override
  void initState() {
    var data = FirebaseFirestore.instance.collection('saleMaster').get();

    data.then((value) => (value.docs));
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
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SaleScreen()));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder<List<SaleMasterModel>>(
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

  Widget itemMasterWidget(SaleMasterModel item) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: height * 0.3,
        width: width * 0.97,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer Name:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.customer,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Item Name:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.selectedItem,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Quantity:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.quantity,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Price:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.price,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                width: width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Item Discount:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.discount,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.totalAmount,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Stream<List<SaleMasterModel>> getUserDetails() => FirebaseFirestore.instance
      .collection('saleMaster')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SaleMasterModel.fromJson(doc.data()))
          .toList());
}
