import 'dart:ui';

import 'package:flutter/material.dart';
import 'assignment_page.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;

class ClassPage extends StatelessWidget {
  final classroom.ClassroomApi api;
  final List<classroom.Course> courses;
  /*
  {"user": googleUser, "authHeaders": googleUser.authHeaders}
  */

  ClassPage(this.api, this.courses);
  // api has to be passed in because
  // I have to use it to get coursework which is higher on the tree :|

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text("Courses",
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.purple,
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 1.0,
                    child: Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)))),
                            child: Text(courses[index].name!),
                            onPressed: () {
                              api.courses.courseWork
                                  .list(courses[index].id!)
                                  .then((resp) {
                                Navigator.push(
                                    context, // I hate how vs code does this "clean up"
                                    MaterialPageRoute(
                                        builder: (context) => AssignmentPage(
                                            api,
                                            api.courses,
                                            courses[index],
                                            resp.courseWork != null
                                                ? resp.courseWork!
                                                : [])));
                              });
                            })));
              })
        ])));
  }
}
