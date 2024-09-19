import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'authen/login.dart';
import 'package:provider/provider.dart';
import 'be/be-provider/be_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDUUjfnEOYep27CoKVbKcx5M1qltDQR4nE",
          authDomain: "app-coking-food.firebaseapp.com",
          projectId: "app-coking-food",
          storageBucket: "app-coking-food.appspot.com",
          messagingSenderId: "1055547289474",
          appId: "1:1055547289474:web:06eb177314980fe1abe99b"));
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider(
      '6LetbwcqAAAAANS1qZP07lm_FJWG2TuxrWHNsDbl',
    ),
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishListPost()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: LoginPage(),
    );
  }
}
