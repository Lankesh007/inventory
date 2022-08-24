import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/screens/masterTab/add_customer_master_screen.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../models/customer_master_model.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
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
          "Customer Master",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCustomerMasterScreen()));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder<List<CustomerMasterModel>>(
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

  Widget itemMasterWidget(CustomerMasterModel item) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: height * 0.28,
        width: width * 0.97,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer Name:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.customerName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer email:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.email,
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer Gst:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.gst,
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer mobile :",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.mobileNumber,
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                width: width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer Address :",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 40,
                      width: width * 0.5,
                      child: Text(
                        item.address,
                        style: const TextStyle(),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Stream<List<CustomerMasterModel>> getUserDetails() =>
      FirebaseFirestore.instance.collection('customerMaster').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => CustomerMasterModel.fromJson(doc.data()))
              .toList());
}
