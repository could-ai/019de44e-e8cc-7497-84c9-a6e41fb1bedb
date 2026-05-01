import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/record.dart';

class PdfExport {
  static Future<File> generatePdf(PatientRecord record) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Patient Record: ${record.name}')),
          pw.Text('MRN: ${record.mrn}'),
          pw.Text('Date/Time: ${record.datetime}'),
          pw.Text('Sex: ${record.sex} | Age: ${record.age}'),
          pw.SizedBox(height: 20),
          
          pw.Header(level: 1, child: pw.Text('Complaints')),
          ...record.complaints.entries.map((e) => pw.Text('- ${e.key}: ${e.value}')),
          
          pw.SizedBox(height: 20),
          pw.Header(level: 1, child: pw.Text('Past Medical History')),
          ...record.pastHistory.entries.map((e) => pw.Text('- ${e.key}: ${e.value}')),
          pw.Text('Medications: ${record.medications}'),
          
          pw.SizedBox(height: 20),
          pw.Header(level: 1, child: pw.Text('Examination')),
          ...record.examination.entries.map((e) => pw.Text('${e.key}: ${e.value}')),
          
          pw.SizedBox(height: 20),
          pw.Header(level: 1, child: pw.Text('ECG & Echo')),
          pw.Text('ECG Comment: ${record.ecgComment}'),
          pw.Text('Echo Type: ${record.echoType}'),
          
          pw.SizedBox(height: 20),
          pw.Header(level: 1, child: pw.Text('Labs')),
          ...record.labs.entries.map((e) => pw.Text('${e.key}: ${e.value}')),
          
          pw.SizedBox(height: 20),
          pw.Header(level: 1, child: pw.Text('Recommendations & Scores')),
          pw.Text('Recommendations: ${record.recommendations}'),
          pw.Text('CHA2DS2-VASc: ${record.cha2ds2VascScore}'),
          pw.Text('GRACE: ${record.graceScore}'),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/record_${record.id ?? DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
