import 'package:curenzee_application/cameraScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.1),
              Image.asset("assets/logo.png", height: 120),
              SizedBox(height: height * 0.2),
              //make image button
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                ),
                child: Container(
                  width: 366,
                  height: 175,
                  child: Center(
                      child: Image.asset("assets/detect_cur.png", height: 120)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
