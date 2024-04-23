// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

CompanyModel companyModelFromJson(String str) =>
    CompanyModel.fromJson(json.decode(str));

String companyModelToJson(CompanyModel data) => json.encode(data.toJson());

class CompanyModel {
  final String id;
  final String name;
  late final String code;
  final String aka;
  final String icon;
  final String basUrl;
  final List<String> modules;

  CompanyModel({
    required this.id,
    required this.name,
    required this.code,
    required this.aka,
    required this.icon,
    required this.basUrl,
    required this.modules,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        aka: json["aka"],
        icon: json["icon"],
        basUrl: json["bas_url"],
        modules: List<String>.from(json["modules"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "aka": aka,
        "icon": icon,
        "bas_url": basUrl,
        "modules": List<dynamic>.from(modules.map((x) => x)),
      };
}
