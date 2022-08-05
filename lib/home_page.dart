import 'package:flutter/material.dart';
import 'sign_in_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: [
      Padding(
          padding: EdgeInsets.all(
              150.0)), //distance of the logo and the sign in button from the top
      const Image(image: AssetImage('assets/FOCI.png')),
      Align(alignment: Alignment.center, child: sign_In_Button())
    ])));
  }
}
