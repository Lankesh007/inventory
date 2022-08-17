import 'package:demo_test/bottomNavigationBar/app.dart';
import 'package:demo_test/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String otp;
  const OtpScreen({required this.otp, Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
} 

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();
  double height = 0;
  double width = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              imageWidget(),
              const Text(
                "Enter Otp to Verify its you !!",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Your Otp --->   ${widget.otp}",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              verifyOtpwidget(),
              const SizedBox(
                height: 80,
              ),
              verifyOtpButtonWidget(),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.bottomRight,
                child: const Text(
                  "Resend Otp!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget imageWidget() {
    return Container(
      height: height * 0.5,
      width: width * 0.9,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/otpImage2.gif"),
              fit: BoxFit.cover)),
    );
  }

  Widget verifyOtpwidget() {
    return SizedBox(
      width: width * 0.8,
      child: Pinput(
        controller: otpController,
        defaultPinTheme: PinTheme(
          width: 56,
          height: 56,
          textStyle: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 87, 30, 30),
              fontWeight: FontWeight.w600),
          decoration: BoxDecoration(
            border: Border.all(color: Appcolors.primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        keyboardType: TextInputType.number,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget verifyOtpButtonWidget() {
    return InkWell(
      onTap: () {
        if (widget.otp == otpController.text) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  const App()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Appcolors.primaryColor,
              content: Text(
                "Invalid otp!!",
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
        child: const Text(
          "Verify Otp",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
