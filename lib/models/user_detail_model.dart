// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

UserDetail userDetailFromJson(String str) =>
    UserDetail.fromJson(json.decode(str));

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
  User user;
  List<String> permissions;
  String message;
  int code;

  UserDetail({
    required this.user,
    required this.permissions,
    required this.message,
    required this.code,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        user: User.fromJson(json["user"]),
        permissions: List<String>.from(json["permissions"].map((x) => x)),
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
        "message": message,
        "code": code,
      };
}

class User {
  dynamic id;
  dynamic employeeId;
  String username;
  String email;
  String apiToken;
  DateTime updatedAt;

  User({
    required this.id,
    required this.employeeId,
    required this.username,
    required this.email,
    required this.apiToken,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        employeeId: json["employee_id"],
        username: json["username"],
        email: json["email"],
        apiToken: json["api_token"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "username": username,
        "email": email,
        "api_token": apiToken,
        "updated_at": updatedAt.toIso8601String(),
      };
}
