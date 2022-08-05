import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'start_screen.dart';
import 'lockdown_utilities.dart' as ld;

class AssignmentPage extends StatelessWidget {
  final classroom.Course course;
  final classroom.CoursesResource cr; // i dont have a better name :|
  List<classroom.CourseWork> assignments;
  final classroom.ClassroomApi api;

  AssignmentPage(
      classroom.ClassroomApi this.api,
      classroom.CoursesResource this.cr,
      classroom.Course this.course,
      List<classroom.CourseWork> this.assignments);

  @override
  Widget build(BuildContext context) {
    this.assignments = ld.screenDueDates(this.assignments);

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text("Assignments",
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.purple,
            )), // (course.name.toString())),
        body: SingleChildScrollView(
            child: Column(children: [
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 1.0,
                    child: Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(300),
                                        side: BorderSide(
                                          width: 10.0,
                                          color: Colors.blue,
                                          // style: BorderStyle.solid,
                                        )))),
                            child: Text(
                                assignments[index].title!), // assignment names
                            onPressed: () {
                              Navigator.push(
                                  context, // I hate how vs code does this "clean up"
                                  MaterialPageRoute(
                                      builder: (context) => StartScreen(
                                          assignments[index].dueDate
                                              as classroom.Date,
                                          assignments[index].dueTime
                                              as classroom.TimeOfDay,
                                          api,
                                          course.id!,
                                          assignments[index])));
                            })));
              })
        ])));
  }
}
