import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_project/firebase_options.dart';
import 'package:flutter_project/notification_service.dart';
import 'package:flutter_project/SplashScreen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashscreenPage(),
    );
  }
}
