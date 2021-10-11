import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ModelAppointment modelAppointmentFromJson(String str) =>
    ModelAppointment.fromJson(json.decode(str));

String modelAppointmentToJson(ModelAppointment data) =>
    json.encode(data.toJson());

class ModelAppointment {
  ModelAppointment({
    @required this.appointmentId,
    @required this.appointmentName,
    @required this.id,
    @required this.appointmentDate,
    @required this.appointmentTime,
  });

  final String appointmentId;
  final int id;
  final String appointmentName;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;

  factory ModelAppointment.fromJson(Map<String, dynamic> json) =>
      ModelAppointment(
        appointmentId: json["appointmentId"],
        id: json["id"],
        appointmentName: json["appointmentName"],
        appointmentDate: json["appointmentDate"],
        appointmentTime: json["appointmentTime"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentId": appointmentId,
        "appointmentName": appointmentName,
        "id": id,
        "appointmentDate": appointmentDate,
        "appointmentTime": appointmentTime,
      };
}
