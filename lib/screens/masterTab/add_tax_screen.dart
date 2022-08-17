import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';

class AddTaxScreen extends StatefulWidget {
  const AddTaxScreen({Key? key}) : super(key: key);

  @override
  State<AddTaxScreen> createState() => _AddTaxScreenState();
}

class _AddTaxScreenState extends State<AddTaxScreen> {
  double height = 0;
  double width = 0;
  final taxController = TextEditingController();
  final percentageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Add Tax Master",
          style: TextStyle(
              color: Appcolors.whiteColor,
              fontSize: 18,
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
          ),
        ],
      ),
    );
  }

  Widget textFieldsWidget() {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: height * 0.2,
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
                      return 'Tax Name is required !!';
                    }
                    return null;
                  },
                  controller: taxController,
                  decoration: const InputDecoration(
                      hintText: "Tax Name",
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Tax percentage is required';
                    }
                    return null;
                  },
                  controller: percentageController,
                  decoration: const InputDecoration(
                      hintText: "Tax Percentage",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none),
                ),
              ),
              const Divider(
                color: Colors.black,
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
          addSupplyMaster();
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

  Future addSupplyMaster() async {
    setState(() {
      loading = true;
    });
    if (taxController.text.isEmpty && percentageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Appcolors.primaryColor,
          content: Text(
            "Something is Missing !!",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    } else {
      final userDoc = FirebaseFirestore.instance.collection('taxMaster').doc();

      final json = {
        'taxName': taxController.text.toString(),
        'taxPercentage': percentageController.text.toString(),
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
