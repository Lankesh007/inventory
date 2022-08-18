import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/models/item_master_model.dart';
import 'package:demo_test/screens/masterTab/item_master_screen.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'update_item_master.dart';

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
      height: height * 0.08,
      width: width * 0.97,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateItemMasterScreen(
                        companyName: item.companyName,
                        itemName: item.itemName,
                        unitName: item.unitName,
                      )));
        },
        title: Text(item.companyName),
        trailing: Text(item.itemName),
        subtitle: Text(item.unitName),
      ),
    );
  }

  Stream<List<ItemMasterModel>> getUserDetails() => FirebaseFirestore.instance
      .collection('itemMaster')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ItemMasterModel.fromJson(doc.data()))
          .toList());
}
