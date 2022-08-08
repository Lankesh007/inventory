import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/authentication/login_screen.dart';
import 'package:demo_test/screens/homepage_screen.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double height = 0;
  double width = 0;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final firmNameController = TextEditingController();
  final gstNumberController = TextEditingController();
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
                height: 200,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(
                      height: 70,
                    ),
                    Text(
                      "Register Now !",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already Have an account ? "),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            "Login",
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
    return Form(
      key: _formKey,
      child: SizedBox(
        height: height * 0.38,
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Firm Name is empty';
                    }
                    return null;
                  },
                  controller: firmNameController,
                  decoration: const InputDecoration(
                      hintText: "Firm Name",
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
          registerUser(name: "users");
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
          loading == true ? "Please Wait..." : "Register",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-------------------Store to cloud firestore --------------//

  Future registerUser({required String name}) async {
    setState(() {
      loading = true;
    });
    if (emailController.text.isEmpty &&
        phoneNumberController.text.isEmpty &&
        firmNameController.text.isEmpty &&
        gstNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Appcolors.primaryColor,
          content: Text(
            "Something is Missing !!",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    } else {
      final userDoc = FirebaseFirestore.instance.collection('users').doc();

      final json = {
        'email': emailController.text.toString(),
        'phone_number': phoneNumberController.text.toString(),
        'firm_name': firmNameController.text.toString(),
        'gst_number': gstNumberController.text.toString(),
      };

      await userDoc.set(json);
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomePageScreen()));

      setState(() {
        loading = false;
      });
    }
  }
}
