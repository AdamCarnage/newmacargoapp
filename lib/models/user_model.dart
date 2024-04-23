import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final dynamic id;
  final dynamic employeeId;
  final String username;
  final String email;
  final List<String> permissions;

  UserModel({
    this.id,
    this.employeeId,
    required this.username,
    required this.email,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        employeeId: json["employee_id"],
        username: json["username"],
        email: json["email"],
        permissions: List<String>.from(json["permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "username": username,
        "email": email,
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
      };
}
