import 'dart:async';

import 'package:appointment_app/appointment/model_appointment.dart';
import 'package:appointment_app/appointment/model_data.dart';
import 'package:appointment_app/appointment/vm_appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../global_functions.dart';

class BookAppointment extends StatefulWidget {
  final ModelAppointment modelAppointment;
  final ModelData modelData;
  final bool isEdit;

  BookAppointment({this.modelAppointment, this.isEdit = false, this.modelData});

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  DateTime _appointmentDate;
  TimeOfDay _appointmentTime;
  StreamController<bool> _dateController = StreamController.broadcast();
  StreamController<bool> _timeController = StreamController.broadcast();

  @override
  void dispose() {
    _dateController.close();
    _timeController.close();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.isEdit) {
      _appointmentTime = widget.modelAppointment.appointmentTime;
      _appointmentDate = widget.modelAppointment.appointmentDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Form'),
      ),
      persistentFooterButtons: [
        TextButton(
            onPressed: () {
              _bookAppointment();
            },
            child: Text(
              'Book Appointment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ))
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ' + widget.modelAppointment.appointmentName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream: _dateController.stream,
                    builder: (ctx, snapShot) => Text(
                      _appointmentDate != null
                          ? 'Appointment Date: ' +
                              DateFormat('dd-MMM-yyyy').format(_appointmentDate)
                          : 'Select Appointment Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _selectAppointmentDate();
                    },
                    icon: Icon(
                      Icons.calendar_today_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream: _timeController.stream,
                    builder: (ctx, snapShot) {
                      String timeString = 'Select Appointment Time';

                      if (_appointmentTime != null) {
                        timeString = "Appointment Time: " +
                            _appointmentTime.format(context);
                      }
                      return Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      if (_appointmentDate == null) {
                        showCustomSnackBar(context, 'Please select Date first.',
                            color: Colors.red);
                        return;
                      }
                      _selectAppointmentTime();
                    },
                    icon: Icon(
                      Icons.access_time,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectAppointmentDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != _appointmentDate) {
      _appointmentDate = picked;
      _dateController.add(true);
    }
  }

  Future<void> _selectAppointmentTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime != null && newTime != _appointmentTime) {
      if (DateFormat('dd-MMM-yyyy').format(_appointmentDate) ==
          DateFormat('dd-MMM-yyyy').format(DateTime.now())) {
        TimeOfDay currentTime = TimeOfDay.now();

        if (newTime.hour < currentTime.hour) {
          showCustomSnackBar(context,
              'Invalid time selected.This time is passed, Please selected proper timing.',
              color: Colors.red);
          return;
        }

        if (newTime.minute < currentTime.minute) {
          showCustomSnackBar(context,
              'Invalid time selected.This time is passed, Please selected proper timing.',
              color: Colors.red);
          return;
        }
      }
      _appointmentTime = newTime;
      _timeController.add(true);
    }
  }

  void _bookAppointment() async {
    if (_appointmentDate == null) {
      showCustomSnackBar(context, 'Please select appointment date.',
          color: Colors.red);

      return;
    }
    if (_appointmentTime == null) {
      showCustomSnackBar(context, 'Please select appointment time.',
          color: Colors.red);

      return;
    }

    if (widget.modelData.openTime.hour > _appointmentTime.hour) {
      String msg = widget.modelData.type +
          ' is not opened on your selected time. Please select time slot after ' +
          widget.modelData.openTime.format(context) +
          '.';

      showCustomSnackBar(context, msg, color: Colors.red);
      return;
    }

    if (widget.modelData.closeTime.hour < _appointmentTime.hour) {
      String msg = widget.modelData.type +
          ' is closed on your selected time. Please select time slot before ' +
          widget.modelData.closeTime.format(context) +
          '.Or select time slot for tomorrow.';

      showCustomSnackBar(context, msg, color: Colors.red);
      return;
    }

    String key = widget.modelData.id.toString() +
        '|' +
        DateFormat('dd-MMM-yyyy').format(_appointmentDate) +
        '|' +
        _appointmentTime.hour.toString() +
        '-' +
        (_appointmentTime.hour + widget.modelData.perAppointmentTime)
            .toString();

    final vmAppointment = Provider.of<VmAppointment>(context, listen: false);

    if (vmAppointment.checkIfSlotBooked(key)) {
      showCustomSnackBar(
          context, 'Your time slot is booked. Please booked other time slot.',
          color: Colors.red);
      return;
    }

    if (widget.isEdit) {
      await vmAppointment.editAppointment(
          newKey: key,
          oldKey: widget.modelAppointment.appointmentId,
          id: widget.modelAppointment.id,
          appointmentName: widget.modelAppointment.appointmentName,
          date: _appointmentDate,
          time: _appointmentTime);

      showCustomSnackBar(context, 'Appointment edited successfully.');
    } else {
      await vmAppointment.bookAppointment(
          key: key,
          id: widget.modelData.id,
          appointmentName: widget.modelAppointment.appointmentName,
          date: _appointmentDate,
          time: _appointmentTime);

      showCustomSnackBar(context, 'Appointment booked successfully.');
    }

    Navigator.pop(context);
  }
}
