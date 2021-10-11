import 'package:appointment_app/appointment/model_data.dart';
import 'package:flutter/material.dart';

class VmData {
  List<ModelData> _dataList = [
    ModelData(
      id: 1,
      name: 'Doctor',
      type: 'Hospital',
      openTime: TimeOfDay(hour: 10,minute: 00),
      closeTime: TimeOfDay(hour: 20,minute: 00),
      perAppointmentTime: 1,
    ),
    ModelData(
      id: 2,
      name: 'Parlour',
      type: 'Parlour',
      openTime: TimeOfDay(hour: 10,minute: 00),
      closeTime: TimeOfDay(hour: 24,minute: 00),
      perAppointmentTime: 2,
    ),
    ModelData(
      id: 3,
      name: 'Chartered Accountant',
      type: 'Office',
      openTime: TimeOfDay(hour: 10,minute: 00),
      closeTime: TimeOfDay(hour: 18,minute: 00),
      perAppointmentTime: 1,
    ),
  ];

  List<ModelData> get getDataList {
    return [..._dataList];
  }
}
