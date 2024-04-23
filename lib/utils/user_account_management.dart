import 'package:enquiry/models/user_detail_model.dart';
import 'package:enquiry/utils/pref.dart';
import 'dart:convert';

class UserAccountManagement {
  Future<UserDetail?> getUserDetail() async {
    dynamic userData = await Pref().getPref('userDetail');

    if (userData != null && userData.isNotEmpty) {
      try {
        if (userData is Map<String, dynamic>) {
          return UserDetail.fromJson(userData);
        } else if (userData is String) {
          Map<String, dynamic> userMap = json.decode(userData);
          return UserDetail.fromJson(userMap);
        }
      } catch (e) {
        print('Error decoding user data: $e');
        return null;
      }
    }
    return null;
  }
}
