import 'package:flutter/material.dart';
import 'package:myplaces/views/pg_home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              toolbarHeight: 50,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
        ),
        home: const HomePage());
  }
}
