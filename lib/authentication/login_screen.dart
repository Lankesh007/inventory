import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/authentication/otp_screen.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double height = 0;
  double width = 0;
  bool loading = false;
  int otp = 0;

  _genrateOtp() {}

  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _genrateOtp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 250,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(
                      height: 120,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: height * 0.7,
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
                      height: 20,
                    ),
                    // const Text("Forgot Password ?",style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(
                      height: 40,
                    ),
                    loginButtonWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have  account ? "),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                color: Appcolors.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
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
    return SizedBox(
      height: height * 0.1,
      width: width * 0.87,
      child: Form(
        key: _formKey,
        child: Card(
          elevation: 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: height * 0.07,
                width: width,
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Phone Number is empty';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButtonWidget() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          loginUser(otpName: "userOtp");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Appcolors.primaryColor,
              content: Text(
                "Phone number required!!",
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
          loading == true ? "Please Wait..." : "Login",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-------------------Store to cloud firestore --------------//

  Future loginUser({required String otpName}) async {
    setState(() {
      loading = true;
    });
    var value = Random();
    var otp = value.nextInt(9000) + 1000;
    log(otp);
    if (phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Appcolors.primaryColor,
          content: Text(
            "Phone Number is Missing !!",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    } else {
      final userDoc = FirebaseFirestore.instance.collection('userOtp').doc();

      final json = {
        'otp': otp.toString(),
      };

      await userDoc.set(json);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                    otp: otp.toString(),
                  )));

      setState(() {
        loading = false;
      });
    }
  }
}
