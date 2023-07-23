import 'package:flutter/material.dart';

import 'routes.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multithreading',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: const BasicImplementation(),
      // home: const MyBasicIsolateExample(),
       home: const CounterApp(),
      //home: const UsingCompute(),
    );
  }
}
