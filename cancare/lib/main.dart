import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Doctor View'),
                Tab(text: 'Patient View'),
              ],
            ),
            title: Text('Cancare'),
          ),
          body: TabBarView(
            children: [
              DoctorView(),
              PatientView(),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Doctor View'),
    );
  }
}

class PatientView extends StatefulWidget {
  @override
  _PatientViewState createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  String _actionTaken = "";
  double _mood = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How are you feeling today?"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text("Input Form"),
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
        ],
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  String _actionTaken = "none";
  double _mood = 3;
  DateTime _currentTime = DateTime.now();
  String _medicationName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Action Taken"),
              value: "nap",
              items: [
                DropdownMenuItem(
                  child: Text("Nap"),
                  value: "nap",
                ),
                DropdownMenuItem(
                  child: Text("Medication"),
                  value: "med",
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _actionTaken = value ?? "";
                });
              },
            ),
            // If _actionTaken is 'med', show the TextField for medication name
            _actionTaken == 'med'
                ? TextField(
                    decoration: InputDecoration(labelText: 'Medication Name'),
                    onChanged: (value) {
                      setState(() {
                        _medicationName = value;
                      });
                    },
                  )
                : Container(),
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
    Navigator.pop(context,
        {'actionTaken': _actionTaken, 'mood': _mood, 'time': _currentTime});
  }
}
