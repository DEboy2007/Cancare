import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class MedicinesPage extends StatefulWidget {
  @override
  _MedicinesPageState createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  List<Medicine> _medicines = [];
  TextEditingController _controller = TextEditingController();
  List<String> _times = ['Morning', 'Afternoon', 'Evening'];
  List<bool> _selected = [false, false, false];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  void _loadMedicines() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/medicines.json');
      String contents = await file.readAsString();
      List collection = jsonDecode(contents);
      List<Medicine> medicines =
          collection.map((json) => Medicine.fromJson(json)).toList();
      setState(() {
        _medicines = medicines;
      });
    } catch (e) {
      print(e);
    }
  }

  void _saveMedicines() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/medicines.json');
    String jsonString = jsonEncode(_medicines);
    await file.writeAsString(jsonString);
  }

  void _addMedicine() {
    setState(() {
      _medicines.add(Medicine(
        name: _controller.text,
        times: _selected.asMap().entries
            .where((entry) => entry.value == true)
            .map((entry) => _times[entry.key])
            .toList(),
      ));
    });
    _controller.clear();
    _selected = [false, false, false];
    _saveMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _medicines.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_medicines[index].name),
                  subtitle: Text(_medicines[index].times.join(', ')),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hint
