// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CategoryMasterScreen extends StatefulWidget {
  const CategoryMasterScreen({Key? key}) : super(key: key);

  @override
  State<CategoryMasterScreen> createState() => _CategoryMasterScreenState();
}

class _CategoryMasterScreenState extends State<CategoryMasterScreen> {
  double height = 0;
  double width = 0;
  File? _image;
  String image = "";
  String base64Image = "";
  bool loading = false;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final categoryNameController = TextEditingController();
  final categoryDiscriptionController = TextEditingController();

  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        var imageBytes = _image!.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
        log(base64Image);
        // postprofile();
      } else {
        log('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        var imageBytes = _image!.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
        log(base64Image);
        // postprofile();
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
                    Navigator.pop(context);
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
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Category Master",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 3,
              ),
              uploadImageWidget(),
              textFieldsWidget(),
              submitButtonWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget uploadImageWidget() {
    return Container(
      height: height * 0.35,
      width: width * 0.99,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
              color: const Color.fromRGBO(255, 140, 0, 1), width: 2)),
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
            saveCategoryMasterData();
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: height * 0.07,
        width: width * 0.95,
        decoration: BoxDecoration(
          color: Appcolors.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          loading == true ? "Please Wait..." : "Submit",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget textFieldsWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.08,
            width: width,
            child: Card(
              child: TextFormField(
                controller: categoryNameController,
                textAlign: TextAlign.center,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Category Name is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Category Name",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.2,
            width: width,
            child: Card(
              child: TextFormField(
                controller: categoryDiscriptionController,
                maxLines: 8,
                textAlign: TextAlign.center,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Category Description  is required!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Category Description",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  // ************** save data to cloud store firebase******************//

  Future saveCategoryMasterData() async {
    setState(() {
      loading = true;
    });
    final userDoc =
        FirebaseFirestore.instance.collection('categoryMaster').doc();

    final json = {
      'category_description': categoryDiscriptionController.text.toString(),
      'category_image': base64Image.toString(),
      'category_name': categoryNameController.text.toString(),
    };

    await userDoc.set(json);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Appcolors.primaryColor,
        content: Text(
          "Category saved Successfully !!",
          style: TextStyle(fontWeight: FontWeight.bold),
        )));
    setState(() {
      loading = false;
    });
  }
}
