
import 'dart:developer';
import 'dart:io';

import 'package:demo_test/utils/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ItemMasterScreen extends StatefulWidget {
  const ItemMasterScreen({Key? key}) : super(key: key);

  @override
  State<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends State<ItemMasterScreen> {
  double height = 0;
  double width = 0;
  String dropdownvalue = 'Item 1';
  final _formKey = GlobalKey<FormState>();

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  PlatformFile? pickedFile;


  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }


  Future uploadFile()async{

    final path='files/${pickedFile!.path}';
    final file=File(pickedFile!.path!);

    final ref=FirebaseStorage.instance.ref().child(path);
   final uploadTask= ref.putFile(file);

   final snapShot=await uploadTask.whenComplete(() => (){});
   final urlDownload=await snapShot.ref.getDownloadURL();
   log('Image download link---->$urlDownload');
  }

  final itemNameController = TextEditingController();

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
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: height * 0.19,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border:
                          Border.all(color: Appcolors.primaryColor, width: 2)),

                  child:pickedFile==null? IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      selectFile();
                    },
                  ):InkWell(
                    onTap: (){
                      selectFile();
                    },
                    child: Container(
                      height: height * 0.19,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border:
                            Border.all(color: Appcolors.primaryColor, width: 1,),
                            image: DecorationImage(image: FileImage(File(pickedFile!.path!),),fit: BoxFit.cover,)
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
                      textAlign: TextAlign.center,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Unit is required!';
                        }
                        return null;
                      },
                      controller: itemNameController,
                      decoration: const InputDecoration(
                          hintText: "Item Name",
                          hintStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none),
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
                      "Unit Name*",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                DropdownButton(
                  // Initial Value
                  value: dropdownvalue,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: SizedBox(
                          height: height * 0.09,
                          width: width * 0.87,
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(items))),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      "Company Name*",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                DropdownButton(
                  // Initial Value
                  value: dropdownvalue,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: SizedBox(
                          height: height * 0.09,
                          width: width * 0.87,
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(items))),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                submitButtonWidget(),
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
        uploadFile();
        // if (_formKey.currentState!.validate()) {
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //       backgroundColor: Appcolors.primaryColor,
        //       content: Text(
        //         "Please Fill the Field!!",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       )));
        // }
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
        child: const Text(
          "Submit",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
