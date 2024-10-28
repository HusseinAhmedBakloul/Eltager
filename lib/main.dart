import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eltager/pages/SplachScreen.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  AwesomeNotifications().initialize(
    null, 
    [
      NotificationChannel(
        channelKey: 'task_channel',
        channelName: 'Task Reminders',
        channelDescription: 'Channel for task reminders',
        defaultColor: Color(0xFF9D50B8),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        criticalAlerts: true,
      ),
    ],
  );

  runApp(const Eltager());
}

class Eltager extends StatelessWidget {
  const Eltager({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eltager',
      home: Splachscreen(),
    );
  }
}
