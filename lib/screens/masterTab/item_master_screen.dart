// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemMasterScreen extends StatefulWidget {
  const ItemMasterScreen({Key? key}) : super(key: key);

  @override
  State<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends State<ItemMasterScreen> {
  double height = 0;
  double width = 0;
  bool loading = false;
  String dropdownvalue = 'Select';
  String unitMasterValue = "Select";
  String catergoryNameValue = "Select";
  String taxNameValue = "Select";
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  File? _image;
  String image = "";
  String base64Image = "";
  final itemNameController = TextEditingController();
  List unitMasterList = [];
  List categoryMasterList = [];
  List userCompanyList = [];
  List taxMasterList = [];

  _getUnimasterData() {
    var data = FirebaseFirestore.instance.collection('unitMaster').get();

    data.then((value) {
      setState(() {
        unitMasterList.clear();
        unitMasterList.add({"unit": "Select", "action": true});
        unitMasterList.addAll(value.docs);
      });
    });
  }

  _getTaxMasterData() {
    var data = FirebaseFirestore.instance.collection('taxMaster').get();
    data.then((value) {
      setState(() {
        taxMasterList.clear();
        taxMasterList.add({
          "taxName": "Select",
        });
        taxMasterList.addAll(value.docs);
      });
    });
  }

  _getCategoryData() {
    var data = FirebaseFirestore.instance.collection('categoryMaster').get();

    data.then((value) {
      setState(() {
        categoryMasterList.clear();
        categoryMasterList.add({
          "category_name": "Select",
        });
        categoryMasterList.addAll(value.docs);
      });
    });
  }

  _getUsersData() {
    var userData = FirebaseFirestore.instance.collection('users').get();

    userData.then((val) {
      setState(() {
        userCompanyList.clear();
        userCompanyList.add({
          "firm_name": "Select",
          "gst_number": "1233445",
          "email": "rohitkumarbain10@gmail.com",
          "phone_number": "7505711386"
        });
        userCompanyList.addAll(val.docs);
      });
    });
  }

  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1024, maxWidth: 1024);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        var imageBytes = _image!.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      } else {
        log('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1024, maxWidth: 1024);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        var imageBytes = _image!.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      } else {
        log('No image selected.');
      }
    });
  }

  void modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 150.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Gallery"),
                  onTap: () {
                    (Navigator.pop(context));
                    getImagefromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    getImageFromCamera();
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    _getUnimasterData();
    _getCategoryData();
    _getUsersData();
    _getTaxMasterData();
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
          "Item Master",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: height * 0.3,
                  width: width * 0.99,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                          color: const Color.fromRGBO(255, 140, 0, 1),
                          width: 2)),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                modalBottomSheetMenu();
                              },
                            ),
                            const Text("Add Image")
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            modalBottomSheetMenu();
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            height: height * 0.35,
                            width: width * 0.99,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Appcolors.primaryColor,
                                  width: 1,
                                ),
                                image: DecorationImage(
                                    image: _image == null
                                        ? NetworkImage(image) as ImageProvider
                                        : FileImage(_image!),
                                    fit: BoxFit.cover)),
                            child: const Icon(
                              Icons.mode_edit_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    "Category Name*",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Card(
                  child: DropdownButton(
                    value: catergoryNameValue,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: categoryMasterList.map((items) {
                      return DropdownMenuItem(
                        value: items['category_name'],
                        child: SizedBox(
                          height: height * 0.09,
                          width: width * 0.87,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              items['category_name'],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (newValue) {
                      setState(() {
                        catergoryNameValue = newValue.toString();
                      });
                    },
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      "Item Name*",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: height * 0.08,
                  width: width,
                  child: Card(
                    child: TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'item is required!';
                        }
                        return null;
                      },
                      controller: itemNameController,
                      decoration: const InputDecoration(
                          hintText: "   Enter Item Name",
                          hintStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    "Unit Name*",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Card(
                  child: DropdownButton(
                    value: unitMasterValue,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: unitMasterList.map((items) {
                      return DropdownMenuItem(
                        value: items['unit'],
                        child: SizedBox(
                          height: height * 0.09,
                          width: width * 0.87,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              items['unit'],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (newValue) {
                      setState(() {
                        unitMasterValue = newValue.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   margin: const EdgeInsets.symmetric(horizontal: 15),
                //   child: const Text(
                //     "Tax Name",
                //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                //   ),
                // ),
                // Card(
                //   child: DropdownButton(
                //     value: taxNameValue,
                //     underline: const SizedBox(),
                //     icon: const Icon(Icons.keyboard_arrow_down),
                //     items: taxMasterList.map((items) {
                //       return DropdownMenuItem(
                //         value: items['taxName'],
                //         child: SizedBox(
                //           height: height * 0.09,
                //           width: width * 0.87,
                //           child: Container(
                //             margin: const EdgeInsets.symmetric(horizontal: 20),
                //             alignment: Alignment.centerLeft,
                //             child: Text(
                //               items['taxName'],
                //             ),
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //     // After selecting the desired option,it will
                //     // change button value to selected value
                //     onChanged: (newValue) {
                //       setState(() {
                //         taxNameValue = newValue.toString();
                //       });
                //     },
                //   ),
                // ),
                const SizedBox(
                  height: 40,
                ),
                submitButtonWidget(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          if (base64Image == "") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Appcolors.primaryColor,
                content: Text(
                  "Please Select the Image !!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )));
          } else {
            if (unitMasterValue != "Select") {
              if (catergoryNameValue == "Select") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Appcolors.primaryColor,
                    content: Text(
                      "Please Select the unit Name !!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )));
              } else {
                saveItemMasterData();
              }
            }
          }
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

  Future saveItemMasterData() async {
    setState(() {
      loading = true;
    });
    final userDoc = FirebaseFirestore.instance.collection('itemMaster').doc();

    final json = {
      'image_link': base64Image.toString(),
      'item_name': itemNameController.text.toString(),
      'unit_name': unitMasterValue.toString(),
      "category_name": catergoryNameValue.toString(),
      "item_tax": taxNameValue.toString(),
    };

    await userDoc.set(json);

    Navigator.pop(context);
    setState(() {
      loading = false;
    });
  }
}
