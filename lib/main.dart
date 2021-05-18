import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safeshopping/controllers/bindings/AuthBindings.dart';
import 'package:safeshopping/utils/Root.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      home: Root(),
      theme: ThemeData.light(),
    );
  }
}

//TODO: add method to show selected store
//TODO: need to set main screen to select store
//TODO: add vendor order reject message
//TODO: add method to get customer data
