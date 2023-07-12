import 'package:flutter/material.dart';
import 'package:storage_stock_task/screen/storage_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/storagePage",
      routes: {
        "/storagePage": (context) => StoragePage()
      },
    );
  }
}

