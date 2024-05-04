import 'package:ar_furniture_app/Views/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ar_furniture_app/Bindings/binding.dart';
import 'package:get/get.dart';
import 'Views/result_analysis.dart';

import 'Views/Login.dart';
import 'Widgets/Constants.dart';

Future<void> main() async
{
  try
  {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  catch (errorMsg)
  {
    debugPrint("Error::" + errorMsg.toString());
  }

  runApp(GetMaterialApp(
    home: FirebaseAuth.instance.currentUser==null?const Login(): const MainPage(),
    debugShowCheckedModeBanner: false,
    theme: lightTheme,
    initialBinding: defaultBinding(),
    darkTheme: darkTheme,
    themeMode: ThemeMode.system,
    defaultTransition: Transition.leftToRightWithFade,
  ));
}



