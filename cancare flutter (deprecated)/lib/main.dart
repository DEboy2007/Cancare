import 'package:flutter/material.dart';
import 'package:cancare/Medicines.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      title: 'Cancare',
      home: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("Medicines")
              .doc("user1")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MedicinesPage();
            } else {
              return SplashScreen();
            }
          }),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
