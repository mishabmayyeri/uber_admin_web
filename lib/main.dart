import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber_admin_web/dashboard/side_navigation_drawer.dart';
import 'package:uber_admin_web/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Uber Web App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: SideNavigationDrawer(),
    );
  }
}
