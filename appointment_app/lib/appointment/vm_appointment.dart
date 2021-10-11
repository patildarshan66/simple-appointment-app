import 'dart:math';

import 'package:appointment_app/appointment/model_appointment.dart';
import 'package:appointment_app/appointment/model_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VmAppointment with ChangeNotifier {
  Map<String, ModelAppointment> _appointmentMap = {};

  List<ModelAppointment> get getAllAppointments {
    return [..._appointmentMap.values.toList()];
  }

  int getAllAppointmentCount() {
    return _appointmentMap.length;
  }

  bool checkIfSlotBooked(String key) {
    bool isBooked = false;

    if (_appointmentMap.containsKey(key)) {
      isBooked = true;
    }
    return isBooked;
  }

  Future<void> bookAppointment({
    String key,
    int id,
    String appointmentName,
    DateTime date,
    TimeOfDay time,
  }) async {
    _appointmentMap.putIfAbsent(
      key,
      () => ModelAppointment(
        appointmentId: key,
        id: id,
        appointmentName: appointmentName,
        appointmentDate: date,
        appointmentTime: time,
      ),
    );

    notifyListeners();
  }

  void cancelAppointment(String key) {
    if (!_appointmentMap.containsKey(key)) {
      return;
    }
    _appointmentMap.remove(key);
    notifyListeners();
  }

  Future<void> editAppointment({
    String newKey,
    String oldKey,
    DateTime date,
    TimeOfDay time,
    int id,
    String appointmentName,
  }) async {
    if (!_appointmentMap.containsKey(oldKey)) {
      return;
    }
    _appointmentMap.remove(oldKey);

    _appointmentMap.putIfAbsent(
      newKey,
      () => ModelAppointment(
        appointmentId: newKey,
        id: id,
        appointmentName: appointmentName,
        appointmentDate: date,
        appointmentTime: time,
      ),
    );
    notifyListeners();
  }
}
