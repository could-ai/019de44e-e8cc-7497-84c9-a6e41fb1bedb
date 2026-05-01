import 'package:flutter/material.dart';

class FormRecommendations extends StatelessWidget {
  final String recommendations;
  final String riskScore;
  final Function(Map<String, dynamic>) onChanged;
  
  // To auto-calculate risk scores, we'd need more data from other tabs,
  // but for simplicity, we allow manual input or basic selection.
  // In a full implementation, we'd pass the whole PatientRecord here.

  const FormRecommendations({
    super.key,
    required this.recommendations,
    required this.riskScore,
    required this.onChanged,
  });

  void _notify(String newRecs, String newRisk) {
    onChanged({
      'recommendations': newRecs,
      'riskScore': newRisk,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recommendations', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: recommendations,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter recommendations / plan'),
          maxLines: 5,
          onChanged: (val) => _notify(val, riskScore),
        ),
        const SizedBox(height: 20),
        const Text('Risk Scores', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: riskScore,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g., CHA2DS2-VASc: 2, GRACE: 105'),
          maxLines: 3,
          onChanged: (val) => _notify(recommendations, val),
        ),
        // Add quick calculation tools or links if needed here.
      ],
    );
  }
}
