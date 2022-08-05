import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'lockdown_utilities.dart' as ld;

class StartScreen extends StatelessWidget {
  final classroom.ClassroomApi api;
  final String courseId;
  final classroom.CourseWork courseWork;
  final classroom.Date dueDate;
  final classroom.TimeOfDay dueTime;

  StartScreen(
      classroom.Date this.dueDate,
      classroom.TimeOfDay this.dueTime,
      classroom.ClassroomApi this.api,
      String this.courseId,
      classroom.CourseWork this.courseWork);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(courseWork.title!,
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.purple,
            )),
        body: Align(
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: courseWork.description != ""
                            ? courseWork.description.toString()
                            : "No description",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            '\n\nDue ${DateTime.utc(dueDate.year!, dueDate.month!, dueDate.day!, dueTime.hours != null ? dueTime.hours! : 0, dueTime.minutes != null ? dueTime.minutes! : 0, 0).toLocal().toString()}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ])),
                  OutlinedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(500)))),
                    child: Text("start"),
                    onPressed: () => ld.lockdown(),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(500)))),
                    child: Text("stop"),
                    onPressed: () => ld.undoLockdown(
                        DateTime.utc(
                                dueDate.year!,
                                dueDate.month!,
                                dueDate.day!,
                                dueTime.hours != null ? dueTime.hours! : 0,
                                dueTime.minutes != null ? dueTime.minutes! : 0,
                                0)
                            .toLocal(),
                        context,
                        api.courses,
                        courseWork,
                        courseId),
                  ) // going to be the actual method call
                ])));
  }
}
