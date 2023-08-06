import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/home_screen.dart';

Future<void> main() async
{
  try
  {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  catch (errorMsg)
  {
    print("Error::" + errorMsg.toString());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AR Furniture App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

