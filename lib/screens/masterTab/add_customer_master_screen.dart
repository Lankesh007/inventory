import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';

class AddCustomerMasterScreen extends StatefulWidget {
  const AddCustomerMasterScreen({Key? key}) : super(key: key);

  @override
  State<AddCustomerMasterScreen> createState() =>
      _AddCustomerMasterScreenState();
}

class _AddCustomerMasterScreenState extends State<AddCustomerMasterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final gstNumberController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerAddressController = TextEditingController();
  double height = 0;
  double width = 0;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        title: const Text(
          "Add Customer",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              textFieldsWidget(),
              const SizedBox(
                height: 20,
              ),
              addCustomerButton(),
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
                      return 'Customer Name is empty';
                    }
                    return null;
                  },
                  controller: customerNameController,
                  decoration: const InputDecoration(
                      hintText: "Customer Name *",
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
                  keyboardType: TextInputType.number,
                 
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                      hintText: "Mobile Number",
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
                 
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: " Customer Email",
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
                  keyboardType: TextInputType.number,
                 
                  controller: gstNumberController,
                  decoration: const InputDecoration(
                      hintText: "Customer GST",
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
                 
                  controller: customerAddressController,
                  decoration: const InputDecoration(
                      hintText: "Customer Address",
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

  Widget addCustomerButton() {
    return InkWell(
      onTap: () {
         if (_formKey.currentState!.validate()) {
          addCustomerDetails();
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
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          loading == true ? "Please Wait..." : "Add Customer",
          style: const TextStyle(
              color: Appcolors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
//***************************** add details to firebase *********************//

  Future addCustomerDetails() async {
    setState(() {
      loading = true;
    });
    if (customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Appcolors.primaryColor,
          content: Text(
            "Customer Name is required !!",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
    } else {
      final userDoc =
          FirebaseFirestore.instance.collection('customerMaster').doc();

      final json = {
        'address': customerAddressController.text.toString(),
        'email': emailController.text.toString(),
        'gst': gstNumberController.text.toString(),
        'mobile_number': phoneNumberController.text.toString(),
        'customer_name': customerNameController.text.toString(),
      };

      await userDoc.set(json);
      setState(() {
        Navigator.pop(context);
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Appcolors.primaryColor,
            content: Text(
              "Customer Master Added Successfully !!",
              style: TextStyle(fontWeight: FontWeight.bold),
            )));
      });
    }
  }
}
