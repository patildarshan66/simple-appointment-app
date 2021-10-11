import 'package:appointment_app/appointment/vm_appointment.dart';
import 'package:appointment_app/appointment/your_appointments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment/appointment_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VmAppointment(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String _selectedName = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedName),
      ),
      bottomNavigationBar: getBottomNavigationBar(),
      body: getMainBody(),
    );
  }

  getMainBody() {
    switch (_selectedIndex) {
      case 0:
        return AppointmentHome();
        break;
      case 1:
        return YourAppointments();
        break;
    }
  }

  getBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: _selectedIndex,
      onTap: (value) {
        if (_selectedIndex != value) {
          _selectedIndex = value;

          if (value == 0) {
            _selectedName = 'Home';
          } else {
            _selectedName = 'Your Appointments';
          }
          setState(() {});
        }
        // Respond to item press.
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Your Appointments',
          icon: new Stack(
            children: <Widget>[
              Icon(Icons.my_library_books),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Consumer<VmAppointment>(
                    builder: (ctx, vmAppointment, ch) => Text(
                      '${vmAppointment.getAllAppointmentCount()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // child: ,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
