import 'package:demo_test/screens/inventory_screen.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
             const Text(
                "Home Page",
              ),
            const  SizedBox(height: 50,),
              InkWell(
                onTap: (){
               Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const InventoryScreen()));
                },
                child: const Text(
                  "Navigate",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
