import 'package:flutter/material.dart';

class FormExamination extends StatelessWidget {
  final Map<String, dynamic> examination;
  final Function(Map<String, dynamic>) onChanged;

  const FormExamination({super.key, required this.examination, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: examination.keys.map((key) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            initialValue: examination[key],
            decoration: InputDecoration(
              labelText: key,
              border: const OutlineInputBorder(),
            ),
            keyboardType: (key == 'BP' || key == 'HR' || key == 'SpO2') ? TextInputType.number : TextInputType.text,
            onChanged: (val) {
              final newExam = Map<String, dynamic>.from(examination);
              newExam[key] = val;
              onChanged(newExam);
            },
          ),
        );
      }).toList(),
    );
  }
}
