import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/models/unit_master_model.dart';
import 'package:demo_test/screens/masterTab/unit_master_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class UnitMasterDetailsScreen extends StatefulWidget {
  const UnitMasterDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UnitMasterDetailsScreen> createState() =>
      _UnitMasterDetailsScreenState();
}

class _UnitMasterDetailsScreenState extends State<UnitMasterDetailsScreen> {
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
          "Unit Master Details ",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UnitMasterScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: StreamBuilder<List<UnitMaster>>(
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

  Widget itemMasterWidget(UnitMaster user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: height * 0.08,
      width: width * 0.97,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        title: Text(user.unit),
        trailing: Text(user.action.toString()),
      ),
    );
  }

  Stream<List<UnitMaster>> getUserDetails() => FirebaseFirestore.instance
      .collection('unitMaster')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UnitMaster.fromJson(doc.data()))
          .toList());
}
