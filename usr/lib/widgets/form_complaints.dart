import 'package:flutter/material.dart';

class FormComplaints extends StatelessWidget {
  final Map<String, bool> complaints;
  final Function(Map<String, bool>) onChanged;

  const FormComplaints({super.key, required this.complaints, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: complaints.keys.map((key) {
        return CheckboxListTile(
          title: Text(key),
          value: complaints[key],
          onChanged: (val) {
            final newComplaints = Map<String, bool>.from(complaints);
            newComplaints[key] = val ?? false;
            onChanged(newComplaints);
          },
        );
      }).toList(),
    );
  }
}
