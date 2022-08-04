import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user_list_screen.dart';

class FireStoreTestScreen extends StatefulWidget {
  const FireStoreTestScreen({Key? key}) : super(key: key);
  @override
  State<FireStoreTestScreen> createState() => _FireStoreTestScreenState();
}

class _FireStoreTestScreenState extends State<FireStoreTestScreen> {
  double height = 0;
  double width = 0;
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("FireStore Test"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: height * 0.6,
                width: width * 0.97,
                child: Card(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: height * 0.07,
                        width: width * 0.9,
                        child: TextField(
                          controller: fullnameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "full name",
                              fillColor: Colors.white70),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: height * 0.07,
                        width: width * 0.9,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "email",
                              fillColor: Colors.white70),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: height * 0.07,
                        width: width * 0.9,
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "phone number",
                              fillColor: Colors.white70),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: height * 0.07,
                        width: width * 0.9,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "Password",
                              fillColor: Colors.white70),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          updateUser();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.07,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserListScreen()));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          height: 20,
                          child: const Text("User List",style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }



  Future createUser({required String name}) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc('user-id');

    final json = {
      'full_name': fullnameController.text.toString(),
      'email': emailController.text.toString(),
      'phone_number': phoneNumberController.text.toString(),
      'password': passwordController.text.toString(),
    };

    await userDoc.set(json);
  }

  Future updateUser() async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc('user-id');
    userDoc.update({
      'full_name': fullnameController.text.toString(),
      'email': emailController.text.toString(),
      'phone_number': phoneNumberController.text.toString(),
      'password': passwordController.text.toString(),
    });
  }
}
