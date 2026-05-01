import 'package:flutter/material.dart';

class FormRecommendations extends StatelessWidget {
  final String recommendations;
  final Function(String) onChanged;

  const FormRecommendations({
    super.key,
    required this.recommendations,
    required this.onChanged,
  });

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
          onChanged: onChanged,
        ),
      ],
    );
  }
}
