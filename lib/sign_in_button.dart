import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:provider/provider.dart';
import "class_page.dart";
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'google_auth_client.dart';

class sign_In_Button extends StatelessWidget {
  /* to do
    Fix constructor for image and function and title and add
    some flex? */

  //sign_In_Button(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.65;
    final double height = MediaQuery.of(context).size.height * 0.15;

    return SizedBox(
        width: width,
        height: height,
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                0, 10, 0, 60), //spacing of the gap of the sign in rectangle
            child: ButtonTheme(
                child: OutlinedButton(
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInWindow>(context,
                          listen: false);
                      provider.login().then((user) {
                        final googleClient =
                            GoogleAuthClient(user['authHeaders']);
                        final classroomAPI =
                            classroom.ClassroomApi(googleClient);

                        classroomAPI.courses.list(studentId: "me").then((r) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClassPage(classroomAPI, r.courses!)));
                        });
                      });
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45)))),
                    child: Row(children: <Widget>[
                      Image(
                          image: AssetImage("assets/googleLogo.png"),
                          width: width * .15,
                          height: height - 20),
                      SizedBox(width: 15),
                      Text("Sign in with Google",
                          style: TextStyle(color: Colors.grey, fontSize: 18))
                    ])))));
  }
}
