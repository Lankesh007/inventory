// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';

class UnitMasterScreen extends StatefulWidget {
  const UnitMasterScreen({Key? key}) : super(key: key);

  @override
  State<UnitMasterScreen> createState() => _UnitMasterScreenState();
}

class _UnitMasterScreenState extends State<UnitMasterScreen> {
  bool isTap = true;
  bool loading = false;
  double height = 0;
  double width = 0;
  final _formKey = GlobalKey<FormState>();
  final unitNameController = TextEditingController();

  // to clear the textfield data after submitting
  void clearText() {
    unitNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Unit Master",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: height,
            child: Column(children: [
              const SizedBox(
                height: 120,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: const Text(
                        "Unit Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              unitTextFieldWidget(),
              const SizedBox(
                height: 10,
              ),
              switchButtonWidget(),
              const SizedBox(
                height: 20,
              ),
              submitButtonWidget(),
            ]),
          ),
        ],
      ),
    );
  }

//------------------All Widgets------------------//

  Widget switchButtonWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: Transform.scale(
          scale: 1,
          child: Switch(
            onChanged: (value) {
              setState(() {
                isTap = !isTap;
                log("isTap--->$isTap");
                if (isTap == true) {}
              });
            },
            value: isTap,
            activeColor: Colors.white,
            activeTrackColor: Appcolors.primaryColor,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.orange,
          )),
    );
  }

  Widget unitTextFieldWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: height * 0.08,
      width: width,
      child: Form(
        key: _formKey,
        child: Card(
          child: TextFormField(
            textAlign: TextAlign.center,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Unit is required!';
              }
              return null;
            },
            controller: unitNameController,
            decoration: const InputDecoration(
                hintText: "Enter your Unit",
                hintStyle: TextStyle(fontSize: 14),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  Widget submitButtonWidget() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          submitUnit();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Appcolors.primaryColor,
              content: Text(
                "Please Fill the Field!!",
                style: TextStyle(fontWeight: FontWeight.bold),
              )));
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: height * 0.07,
        width: width * 0.9,
        decoration: BoxDecoration(
          color: Appcolors.primaryColor,
          borderRadius: BorderRadius.circular(
            10,
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

// -------------------- Firebase Cloud Store Function-------------------------//

  Future submitUnit() async {
    setState(() {
      loading = true;
    });
    final userDoc = FirebaseFirestore.instance.collection('unitMaster').doc();
    final json = {
      'unit': unitNameController.text.toString(),
      'action': isTap,
    };

    await userDoc.set(json);
    setState(() {
      clearText();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Appcolors.primaryColor,
          content: Text(
            "Unit Submitted Successfully !!",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    });

    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }
}
