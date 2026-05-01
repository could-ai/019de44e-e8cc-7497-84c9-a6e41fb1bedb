import 'package:flutter/material.dart';

class FormPatientInfo extends StatefulWidget {
  final Function(Map<String, dynamic>) onChanged;

  const FormPatientInfo({super.key, required this.onChanged});

  @override
  State<FormPatientInfo> createState() => _FormPatientInfoState();
}

class _FormPatientInfoState extends State<FormPatientInfo> {
  final mrnCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String sex = 'Male';

  void _notify() {
    widget.onChanged({
      'mrn': mrnCtrl.text,
      'name': nameCtrl.text,
      'sex': sex,
      'age': int.tryParse(ageCtrl.text) ?? 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: mrnCtrl,
          decoration: const InputDecoration(labelText: 'Patient ID/MRN'),
          onChanged: (_) => _notify(),
        ),
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Patient Name'),
          onChanged: (_) => _notify(),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: ageCtrl,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _notify(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: sex,
                decoration: const InputDecoration(labelText: 'Sex'),
                items: ['Male', 'Female'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => sex = val);
                    _notify();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
