import 'package:appointment_app/appointment/model_appointment.dart';
import 'package:appointment_app/appointment/model_data.dart';
import 'package:appointment_app/appointment/vm_appointment.dart';
import 'package:appointment_app/appointment/vm_data.dart';
import 'package:appointment_app/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'book_appointment.dart';

class YourAppointments extends StatefulWidget {
  @override
  _YourAppointmentsState createState() => _YourAppointmentsState();
}

class _YourAppointmentsState extends State<YourAppointments> {
  @override
  Widget build(BuildContext context) {
    final appointmentsList =
        Provider.of<VmAppointment>(context).getAllAppointments;
    return Container(
      child: appointmentsList.length == 0
          ? Center(
              child: Text(
                'No appointment book yet.',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: appointmentsList.length,
              itemBuilder: (cx, i) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 100,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: " + appointmentsList[i].appointmentName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Appointment Date: ' +
                                DateFormat('dd-MMM-yyyy').format(
                                    appointmentsList[i].appointmentDate),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Appointment Time: ' +
                                appointmentsList[i]
                                    .appointmentTime
                                    .format(context),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                ModelData modelData = VmData()
                                    .getDataList
                                    .firstWhere((element) =>
                                        element.id == appointmentsList[i].id);
                                _editAppointment(
                                    appointmentsList[i], modelData);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              )),
                          IconButton(
                              onPressed: () {
                                _cancelAppointment(
                                    appointmentsList[i].appointmentId);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ))
                        ],
                      )
                    ],
                  ),
                  Divider(thickness: 2)
                ],
              ),
            ),
    );
  }

  void _cancelAppointment(String appointmentId) {
    Provider.of<VmAppointment>(context, listen: false)
        .cancelAppointment(appointmentId);
    showCustomSnackBar(context, "Appointment canceled successfully.");
  }

  void _editAppointment(
      ModelAppointment modelAppointment, ModelData modelData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BookAppointment(
          modelAppointment: modelAppointment,
          modelData: modelData,
          isEdit: true,
        ),
      ),
    );
  }
}
