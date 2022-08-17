import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/models/tax_master_model.dart';
import 'package:demo_test/screens/masterTab/add_tax_screen.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';

class TaxDetailsScreen extends StatefulWidget {
  const TaxDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TaxDetailsScreen> createState() => _TaxDetailsScreenState();
}

class _TaxDetailsScreenState extends State<TaxDetailsScreen> {
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
          "Tax Master Details ",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTaxScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: StreamBuilder<List<TaxMasterModel>>(
        stream: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went error--->${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            print("");
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

  Widget itemMasterWidget(TaxMasterModel item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: height * 0.08,
      width: width * 0.97,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        onTap: () {},
        title: Text(item.taxName),
        trailing: Text(item.taxPercentage),
      ),
    );
  }

  Stream<List<TaxMasterModel>> getUserDetails() => FirebaseFirestore.instance
      .collection('taxMaster')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => TaxMasterModel.fromJson(doc.data()))
          .toList());
}
