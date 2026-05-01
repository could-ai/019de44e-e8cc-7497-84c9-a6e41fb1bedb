import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FormEcgEcho extends StatefulWidget {
  final String ecgComment;
  final String ecgPhotoPath;
  final String echoType;
  final Function(Map<String, dynamic>) onChanged;

  const FormEcgEcho({
    super.key,
    required this.ecgComment,
    required this.ecgPhotoPath,
    required this.echoType,
    required this.onChanged,
  });

  @override
  State<FormEcgEcho> createState() => _FormEcgEchoState();
}

class _FormEcgEchoState extends State<FormEcgEcho> {
  final ImagePicker _picker = ImagePicker();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late TextEditingController _ecgCtrl;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _ecgCtrl = TextEditingController(text: widget.ecgComment);
  }

  void _notify(String newEcg, String newPhoto, String newEcho) {
    widget.onChanged({
      'ecgComment': newEcg,
      'ecgPhotoPath': newPhoto,
      'echoType': newEcho,
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _notify(_ecgCtrl.text, image.path, widget.echoType);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _ecgCtrl.text = widget.ecgComment + " " + val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
               _notify(_ecgCtrl.text, widget.ecgPhotoPath, widget.echoType);
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _notify(_ecgCtrl.text, widget.ecgPhotoPath, widget.echoType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ECG Comment', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ecgCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                maxLines: 3,
                onChanged: (val) => _notify(val, widget.ecgPhotoPath, widget.echoType),
              ),
            ),
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : null),
              onPressed: _listen,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Attach ECG Photo'),
        ),
        if (widget.ecgPhotoPath.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Photo attached: ${widget.ecgPhotoPath.split('/').last}'),
          ),
        const SizedBox(height: 20),
        const Text('Echo Type', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          value: widget.echoType,
          items: ['Bedside', 'Formal'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {
            if (val != null) _notify(_ecgCtrl.text, widget.ecgPhotoPath, val);
          },
        ),
      ],
    );
  }
}
