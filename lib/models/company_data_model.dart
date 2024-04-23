// To parse this JSON data, do
//
//     final companyDataModel = companyDataModelFromJson(jsonString);

import 'dart:convert';

CompanyDataModel companyDataModelFromJson(String str) =>
    CompanyDataModel.fromJson(json.decode(str));

String companyDataModelToJson(CompanyDataModel data) =>
    json.encode(data.toJson());

class CompanyDataModel {
  final String id;
  final String name;
  final String code;
  final String aka;
  final String icon;
  final String basUrl;
  final List<Module> modules;

  CompanyDataModel({
    required this.id,
    required this.name,
    required this.code,
    required this.aka,
    required this.icon,
    required this.basUrl,
    required this.modules,
  });

  factory CompanyDataModel.fromJson(Map<String, dynamic> json) =>
      CompanyDataModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        aka: json["aka"],
        icon: json["icon"],
        basUrl: json["bas_url"],
        modules:
            List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "aka": aka,
        "icon": icon,
        "bas_url": basUrl,
        "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
      };
}

class Module {
  final String name;
  final int total;

  Module({
    required this.name,
    required this.total,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        name: json["name"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "total": total,
      };
}
