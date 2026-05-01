import 'package:flutter/material.dart';

class FormPastHistory extends StatelessWidget {
  final Map<String, bool> pastHistory;
  final String acsInfo;
  final String admissionInfo;
  final String otherInfo;
  final String medications;
  final Function(Map<String, dynamic>) onChanged;

  const FormPastHistory({
    super.key,
    required this.pastHistory,
    required this.acsInfo,
    required this.admissionInfo,
    required this.otherInfo,
    required this.medications,
    required this.onChanged,
  });

  void _notify(Map<String, bool> newHistory, String newAcs, String newAdm, String newOth, String newMeds) {
    onChanged({
      'pastHistory': newHistory,
      'acsInfo': newAcs,
      'admissionInfo': newAdm,
      'otherInfo': newOth,
      'medications': newMeds,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...pastHistory.keys.map((key) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(key),
                value: pastHistory[key],
                onChanged: (val) {
                  final newHistory = Map<String, bool>.from(pastHistory);
                  newHistory[key] = val ?? false;
                  _notify(newHistory, acsInfo, admissionInfo, otherInfo, medications);
                },
              ),
              if (key == 'History of ACS' && pastHistory[key] == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    initialValue: acsInfo,
                    decoration: const InputDecoration(labelText: 'Additional Info for ACS'),
                    onChanged: (val) => _notify(pastHistory, val, admissionInfo, otherInfo, medications),
                  ),
                ),
              if (key == 'History of admission to hospital' && pastHistory[key] == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    initialValue: admissionInfo,
                    decoration: const InputDecoration(labelText: 'Additional Info for Admission'),
                    onChanged: (val) => _notify(pastHistory, acsInfo, val, otherInfo, medications),
                  ),
                ),
              if (key == 'Others' && pastHistory[key] == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    initialValue: otherInfo,
                    decoration: const InputDecoration(labelText: 'Additional Info for Others'),
                    onChanged: (val) => _notify(pastHistory, acsInfo, admissionInfo, val, medications),
                  ),
                ),
            ],
          );
        }),
        const Divider(),
        TextFormField(
          initialValue: medications,
          decoration: const InputDecoration(labelText: 'Medication List', border: OutlineInputBorder()),
          maxLines: 3,
          onChanged: (val) => _notify(pastHistory, acsInfo, admissionInfo, otherInfo, val),
        ),
      ],
    );
  }
}
