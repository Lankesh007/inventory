import 'dart:convert';
import 'dart:developer';

import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonTestScreen extends StatefulWidget {
  const JsonTestScreen({Key? key}) : super(key: key);

  @override
  State<JsonTestScreen> createState() => _JsonTestScreenState();
}

class _JsonTestScreenState extends State<JsonTestScreen> {
  double height = 0;
  double width = 0;

  void getdata() async {
    Map temp = jsonDecode(await rootBundle.loadString("assets/test.json"));

    List arr = temp['arr2'];
    List arr1 = temp['arr1'];

    for (var index = 0; index < arr1.length; index++) {
      for (var indi = 0; indi < arr.length; indi++) {
        if (temp['arr1'][index]['id'] == temp['arr2'][indi]['parent_id']) {
          log("array1----->${temp["arr1"][index]['name']}");
          log("array2---->${temp["arr2"][indi]['name']}");
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getdata();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolors.primaryColor,
          title: const Text("Demo Test"),
        ),
        body: SizedBox());
  }
}
