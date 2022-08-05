import 'package:googleapis/classroom/v1.dart' as classroom;

getClasses(classroom.ClassroomApi apiClient, user) {
  Future<classroom.UserProfile> profile = apiClient.userProfiles.get(user.id);
}
