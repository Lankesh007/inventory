import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/models/supply_master_model.dart';
import 'package:demo_test/screens/masterTab/add_supply_master_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/app_color.dart';

class SuppliesMasterScreen extends StatefulWidget {
  const SuppliesMasterScreen({Key? key}) : super(key: key);

  @override
  State<SuppliesMasterScreen> createState() => _SuppliesMasterScreenState();
}

class _SuppliesMasterScreenState extends State<SuppliesMasterScreen> {
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
          "Supplies Master Details ",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddSupplyMasterScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: StreamBuilder<List<SupplyMasterModel>>(
        stream: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went error--->${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            // print(snapshot.data.documents[0].id)
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

  Widget itemMasterWidget(SupplyMasterModel item) {
    return InkWell(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
          height: height * 0.34,
          width: width * 0.99,
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Supplier Name : ",
                      ),
                      Text(item.supplierName)
                    ],
                  ),
                ),
                const Divider(
                  color: Appcolors.primaryColor,
                ),
                     Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        " Address : ",
                      ),
                      Text(item.supplyAddress)
                    ],
                  ),
                ),
                const Divider(
                  color: Appcolors.primaryColor,
                ),
               
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Email Id : ",
                      ),
                      Text(item.emailId)
                    ],
                  ),
                ),
                const Divider(
                  color: Appcolors.primaryColor,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Gst Number : "),
                      Text(item.gstNumber)
                    ],
                  ),
                ),
                const Divider(
                  color: Appcolors.primaryColor,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mobile Number : ",
                      ),
                      Text(item.mobileNumber)
                    ],
                  ),
                ),
                const Divider(
                  color: Appcolors.primaryColor,
                )
              ],
            ),
          ),
        ));
  }

  Stream<List<SupplyMasterModel>> getUserDetails() => FirebaseFirestore.instance
      .collection('supplyMaster')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SupplyMasterModel.fromJson(doc.data()))
          .toList());
}
