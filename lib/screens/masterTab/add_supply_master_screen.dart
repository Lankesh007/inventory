import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class AddSupplyMasterScreen extends StatefulWidget {
  const AddSupplyMasterScreen({Key? key}) : super(key: key);

  @override
  State<AddSupplyMasterScreen> createState() => _AddSupplyMasterScreenState();
}

class _AddSupplyMasterScreenState extends State<AddSupplyMasterScreen> {
  double height = 0;
  double width = 0;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final gstNumberController = TextEditingController();
  final supplierNameController = TextEditingController();
  final supplierAddrressController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Supply Master",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Container(
                height: height * 0.75,
                width: width,
                decoration: const BoxDecoration(
                    color: Appcolors.whiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(90),
                        topRight: Radius.circular(90))),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    textFieldsWidget(),
                    const SizedBox(
                      height: 40,
                    ),
                    registerBttonWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget textFieldsWidget() {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: height * 0.45,
        width: width * 0.87,
        child: Card(
          elevation: 15,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: height * 0.07,
                width: width,
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Supplier Name is empty';
                    }
                    return null;
                  },
                  controller: supplierNameController,
                  decoration: const InputDecoration(
                      hintText: "Supplier Name",
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Supplier address is empty';
                    }
                    return null;
                  },
                  controller:supplierAddrressController,
                  decoration: const InputDecoration(
                      hintText: "Supplier address",
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email is empty';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email",
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
                  keyboardType:TextInputType.number,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Phone Number is empty';
                    }
                    return null;
                  },
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                      hintText: "Phone Number",
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Gst Number is empty';
                    }
                    return null;
                  },
                  controller: gstNumberController,
                  decoration: const InputDecoration(
                      hintText: "Gst Number",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerBttonWidget() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          addTaxMaster();
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

  //-------------------Store to cloud firestore --------------//

  Future addTaxMaster() async {
    setState(() {
      loading = true;
    });
    if (emailController.text.isEmpty &&
        phoneNumberController.text.isEmpty &&
        gstNumberController.text.isEmpty &&
        supplierNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Appcolors.primaryColor,
          content: Text(
            "Something is Missing !!",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    } else {
      final userDoc =
          FirebaseFirestore.instance.collection('supplyMaster').doc();

      final json = {
        'supplier_address': supplierAddrressController.text.toString(),
        'supplier_email': emailController.text.toString(),
        'gst_number': gstNumberController.text.toString(),
        'phone_number': phoneNumberController.text.toString(),
        'supplier_name': supplierNameController.text.toString(),
      };

      await userDoc.set(json);
      setState(() {
        Navigator.pop(context);
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Appcolors.primaryColor,
            content: Text(
              "Supply Master Added Successfully !!",
              style: TextStyle(fontWeight: FontWeight.bold),
            )));
      });
    }
  }

}
