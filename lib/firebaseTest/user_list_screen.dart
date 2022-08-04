import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_test/models/user_model.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "User List",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: getUserDetails(),
        builder: (context, snapshot) {

          if(snapshot.hasError){
            return Text('Something went error--->${snapshot.error}');
          }
         else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: users.map(userWidget).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget userWidget(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      height: height * 0.08,
      width: width * 0.97,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5)),
      child:  ListTile(
        title: Text(user.fullName),
        trailing: Text(user.email),
        subtitle: Text(user.phoneNumber),
      ),
    );
  }

  Stream<List<UserModel>> getUserDetails() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
}
