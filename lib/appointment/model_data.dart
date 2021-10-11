import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ModelData modelDataFromJson(String str) => ModelData.fromJson(json.decode(str));

String modelDataToJson(ModelData data) => json.encode(data.toJson());

class ModelData {
  ModelData({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.openTime,
    @required this.closeTime,
    @required this.perAppointmentTime,
  });

  final int id;
  final String name;
  final String type;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final int perAppointmentTime;

  factory ModelData.fromJson(Map<String, dynamic> json) => ModelData(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        openTime: json["openTime"],
        closeTime: json["closeTime"],
        perAppointmentTime: json["perAppointmentTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "openTime": openTime,
        "closeTime": closeTime,
        "perAppointmentTime": perAppointmentTime,
      };
}
