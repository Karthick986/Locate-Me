import 'package:flutter/material.dart';
import 'package:locate_me_on_map/locate_address.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
        create: (context) => LocationProvider(), child:
    MaterialApp(
      title: 'Locate Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LocateAddress(),
      debugShowCheckedModeBanner: false,
    ));
  }
}