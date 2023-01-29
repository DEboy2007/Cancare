import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Cancare"),
          ),
          body: Scrollbar(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text("How are you feeling today?"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return InputForm();
                        },
                      ),
                    );
                  },
                ),
              ),
              StreamBuilder(
                stream: firestore.collection("Patient").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.docs.map((document) {
                          return ListTile(
                            title: Text(
                                "Medication: " + document['medicationName']),
                            subtitle: Text("Side effect: " +
                                document['sideEffect'] +
                                "\nMood: " +
                                document["mood"].toString()),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  double _mood = 3;
  DateTime _currentTime = DateTime.now();
  String? _sideEffect = "";
  String _medicationName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Input Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Medication Name'),
              onChanged: (value) {
                setState(() {
                  _medicationName = value;
                });
              },
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Side Effect"),
              value: "none",
              items: [
                DropdownMenuItem(
                  child: Text("Headache"),
                  value: "headache",
                ),
                DropdownMenuItem(
                  child: Text("Drowsiness"),
                  value: "drowsiness",
                ),
                DropdownMenuItem(
                  child: Text("Hair loss"),
                  value: "hair_loss",
                ),
                DropdownMenuItem(
                  child: Text("Nausea"),
                  value: "nausea",
                ),
                DropdownMenuItem(
                  child: Text("Pain"),
                  value: "pain",
                ),
                DropdownMenuItem(
                  child: Text("None!"),
                  value: "none",
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _sideEffect = value;
                });
              },
            ),
            Slider(
              value: _mood,
              min: 1,
              max: 5,
              divisions: 4,
              label: _mood.round().toString(),
              onChanged: (value) {
                setState(() {
                  _mood = value;
                });
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: _saveForm,
            ),
          ],
        ),
      ),
    );
  }

  void _saveForm() {
    // Save form data here
    firestore.collection("Patient").add({
      'medicationName': _medicationName,
      'sideEffect': _sideEffect,
      'mood': _mood,
      'time': _currentTime
    });
    Navigator.pop(context);
  }
}
