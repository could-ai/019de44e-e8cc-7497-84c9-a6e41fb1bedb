import 'package:flutter/material.dart';

class FormLabs extends StatefulWidget {
  final Map<String, dynamic> labs;
  final Function(Map<String, dynamic>) onChanged;

  const FormLabs({super.key, required this.labs, required this.onChanged});

  @override
  State<FormLabs> createState() => _FormLabsState();
}

class _FormLabsState extends State<FormLabs> {
  bool isMgDl = true;

  final Map<String, List<double>> referenceRanges = {
    'Hgb': [12.0, 16.0],
    'TLC': [4.0, 11.0],
    'Plt': [150, 400],
    'Urea': [7.0, 20.0], // mg/dL
    'Creatinine': [0.6, 1.2], // mg/dL
    'Na+': [135, 145],
    'K+': [3.5, 5.0],
    'Mg2+': [1.7, 2.2],
    'Ca2+': [8.5, 10.5],
    'CRP': [0, 10],
    'AST': [0, 40],
    'ALT': [0, 40],
    'Troponin': [0, 0.04],
    'CK-MB': [0, 5.0],
    'D-dimer': [0, 0.5],
    'Total bilirubin': [0.1, 1.2],
    'Direct bilirubin': [0, 0.3],
    'Serum albumin': [3.4, 5.4],
  };

  void _notify() {
    widget.onChanged(widget.labs);
  }

  bool _isAbnormal(String key, String value) {
    if (value.isEmpty) return false;
    final val = double.tryParse(value);
    if (val == null) return false;
    
    final range = referenceRanges[key];
    if (range == null) return false;
    
    if (key == 'Creatinine' || key == 'Urea') {
      double checkVal = val;
      if (!isMgDl) {
         if (key == 'Creatinine') checkVal = val / 88.4; // umol/L to mg/dL
         if (key == 'Urea') checkVal = val * 0.357; // mmol/L to mg/dL (approx)
      }
      return checkVal < range[0] || checkVal > range[1];
    }
    
    return val < range[0] || val > range[1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Use mg/dL for Creatinine/Urea'),
          value: isMgDl,
          onChanged: (val) {
            setState(() => isMgDl = val);
            _notify();
          },
        ),
        ...referenceRanges.keys.map((key) {
          final isAbnormal = _isAbnormal(key, widget.labs[key] ?? '');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              initialValue: widget.labs[key],
              decoration: InputDecoration(
                labelText: '$key' + (key == 'Creatinine' || key == 'Urea' ? (isMgDl ? ' (mg/dL)' : ' (umol/mmol)') : ''),
                labelStyle: TextStyle(color: isAbnormal ? Colors.red : null),
                border: const OutlineInputBorder(),
                filled: isAbnormal,
                fillColor: isAbnormal ? Colors.red.withOpacity(0.1) : null,
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                setState(() {
                  widget.labs[key] = val;
                });
                _notify();
              },
            ),
          );
        }).toList(),
      ],
    );
  }
}
