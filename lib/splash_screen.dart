import 'dart:async';

import 'package:flutter/material.dart';

import 'login.dart';

class ProductsSplashScreen extends StatefulWidget {
  const ProductsSplashScreen({Key? key}) : super(key: key);

  @override
  _ProductsSplashScreenState createState() => _ProductsSplashScreenState();
}

class _ProductsSplashScreenState extends State<ProductsSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/ecom_logo.png",
            height: 380,
            width: 380,
            fit: BoxFit.cover,
          ),
          const Text(
            "Powered by Ecommerce",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
