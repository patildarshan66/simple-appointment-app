import 'package:appointment_app/appointment/model_appointment.dart';
import 'package:appointment_app/appointment/vm_data.dart';
import 'package:flutter/material.dart';

import 'book_appointment.dart';

class AppointmentHome extends StatefulWidget {
  @override
  _AppointmentHomeState createState() => _AppointmentHomeState();
}

class _AppointmentHomeState extends State<AppointmentHome> {
  @override
  Widget build(BuildContext context) {
    final _list = VmData().getDataList;
    return Scaffold(
      body: ListView.builder(

        padding: EdgeInsets.all(5),
        itemCount: _list.length,
        itemBuilder: (ctx, i) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => BookAppointment(
                      modelData: _list[i],
                      modelAppointment: ModelAppointment(
                        appointmentName: _list[i].name,
                      ),
                    ),
                  ),
                );
              },
              leading: Icon(Icons.person),
              title: Text(_list[i].name),
              subtitle: Row(
                children: [
                  Text('Open: ' + _list[i].openTime.format(context)),
                  const SizedBox(width: 5),
                  Text('Closed: ' + _list[i].closeTime.format(context)),
                ],
              ),
            ),
            Divider(thickness: 2,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
