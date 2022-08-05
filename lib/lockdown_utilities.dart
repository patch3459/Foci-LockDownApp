import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:kiosk_mode/kiosk_mode.dart' as kioskMode;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// miscelaneous functions

void lockdown() {
  kioskMode.startKioskMode();
}

bool dueDateDone(DateTime dueDate) {
  return DateTime.now().isAfter(dueDate) ||
      DateTime.now().isAtSameMomentAs(dueDate);
  // seems kind of use less in the latter but you never know
}

Future<bool> isAssignmentDone(classroom.CoursesResource course,
    classroom.CourseWork assignment, String courseId) async {
  classroom.ListCourseWorkResponse cw = await course.courseWork.list(
    courseId,
  );

  classroom.ListStudentSubmissionsResponse work =
      await course.courseWork.studentSubmissions.list(courseId, "-");

  for (classroom.StudentSubmission c in work.studentSubmissions!) {
    if (c.courseWorkId! == assignment.id) {
      return c.state == "TURNED_IN" ||
          c.state == "RETURNED"; // checking it's state

    }
  }
  return false;
}

Future<void> undoLockdown(
    DateTime dueDate,
    BuildContext context,
    classroom.CoursesResource course,
    classroom.CourseWork cw,
    String courseId) async {
  bool isDone = await isAssignmentDone(course, cw, courseId);

  /*course.courseWork.studentSubmissions.list(courseId, "-").then((value) =>
      print(value.studentSubmissions![0].assignmentSubmission?.attachments)); */

  if (dueDateDone(dueDate) || isDone) {
    kioskMode.stopKioskMode();

    FirebaseAuth.instance.signOut();

    Navigator.of(context).popUntil((route) => route.isFirst); // send home

  }
}

List<classroom.CourseWork> screenDueDates(
    List<classroom.CourseWork> assignments) {
  // assignments that
  // 1) have a due date
  // 2) have a description
  List<classroom.CourseWork> new_assignments = [];

  for (classroom.CourseWork cw in assignments) {
    if (cw.dueDate != null && cw.description != null) {
      if (cw.dueTime != null) {
        cw.dueTime = classroom.TimeOfDay(hours: 23, minutes: 59, seconds: 59);
      }
      new_assignments.add(cw);
    }
  }

  return new_assignments;
}
