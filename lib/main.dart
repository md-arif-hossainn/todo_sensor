import 'package:flutter/material.dart';
import 'package:todo_sensor/services/notification_services.dart';
import 'package:todo_sensor/widget/custom_elevated_button.dart';
import 'package:todo_sensor/screen/sensor_tracking.dart';
import 'package:todo_sensor/screen/todo_home_page.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServices.init();
  runApp(const SensorTrackingApp());
}

class SensorTrackingApp extends StatelessWidget {
  const SensorTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
                text: "A To-Do List",
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromRGBO(54, 224, 224, 1.0),
                buttonCallback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TodoHomePage()),
                  );
                }),
            const SizedBox(height: 20),
            CustomElevatedButton(
                text: "Sensor Tracking",
                backgroundColor: const Color.fromRGBO(63, 105, 225, 100),
                buttonCallback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SensorTrackingScreen()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
