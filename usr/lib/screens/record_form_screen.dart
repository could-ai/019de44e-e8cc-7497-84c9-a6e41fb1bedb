import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/record.dart';
import '../db/database_helper.dart';

// Sections
import '../widgets/form_patient_info.dart';
import '../widgets/form_complaints.dart';
import '../widgets/form_past_history.dart';
import '../widgets/form_examination.dart';
import '../widgets/form_ecg_echo.dart';
import '../widgets/form_labs.dart';
import '../widgets/form_recommendations.dart';
import '../utils/calculators.dart';

class RecordFormScreen extends StatefulWidget {
  const RecordFormScreen({super.key});

  @override
  State<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends State<RecordFormScreen> {
  int _currentStep = 0;
  
  // Patient Info
  String mrn = '';
  String name = '';
  String sex = 'Male';
  int age = 0;
  
  // Complaints
  Map<String, bool> complaints = {
    'Chest pain typical': false,
    'Chest pain atypical': false,
    'Dyspnea': false,
    'Lower limb edema': false,
    'Orthopnea': false,
    'Dizziness': false,
    'Fainting': false,
    'Palpitations': false,
  };

  // Past History
  Map<String, bool> pastHistory = {
    'Hypertension': false,
    'Diabetes Mellitus': false,
    'Smoker': false,
    'History of ACS': false,
    'History of admission to hospital': false,
    'Others': false,
  };
  String acsInfo = '';
  String admissionInfo = '';
  String otherHistoryInfo = '';
  String medications = '';

  // Examination
  Map<String, dynamic> examination = {
    'CNS': '',
    'Chest auscultation': '',
    'Lower limb and peripheral pulsation': '',
    'BP': '',
    'HR': '',
    'SpO2': '',
    'S1 and S2': '',
    'Others': '',
  };

  // ECG / Echo
  String ecgComment = '';
  String ecgPhotoPath = '';
  String echoType = 'Bedside'; // Bedside, Formal

  // Labs
  Map<String, dynamic> labs = {};

  // Recommendations
  String recommendations = '';

  void _saveRecord() async {
    int cha2ds2Vasc = Calculators.calculateCHA2DS2VASc(age, sex, pastHistory);
    int grace = Calculators.calculateGRACE(age, examination['HR'], examination['BP'], labs['Creatinine']); // Simplified

    final record = PatientRecord(
      datetime: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      mrn: mrn,
      name: name,
      sex: sex,
      age: age,
      complaints: complaints,
      pastHistory: {
        ...pastHistory,
        'acsInfo': acsInfo,
        'admissionInfo': admissionInfo,
        'otherHistoryInfo': otherHistoryInfo,
      },
      medications: medications,
      examination: examination,
      ecgComment: ecgComment,
      ecgPhotoPath: ecgPhotoPath,
      echoType: echoType,
      labs: labs,
      recommendations: recommendations,
      cha2ds2VascScore: cha2ds2Vasc,
      graceScore: grace,
    );

    await DatabaseHelper.instance.insertRecord(record);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Patient Record'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecord,
          )
        ],
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 6) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            _saveRecord();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: const Text('Patient Info'),
            content: FormPatientInfo(
              onChanged: (val) {
                setState(() {
                  mrn = val['mrn'] ?? mrn;
                  name = val['name'] ?? name;
                  sex = val['sex'] ?? sex;
                  age = val['age'] ?? age;
                });
              },
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Complaints'),
            content: FormComplaints(
              complaints: complaints,
              onChanged: (val) => setState(() => complaints = val),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Past History & Meds'),
            content: FormPastHistory(
              pastHistory: pastHistory,
              acsInfo: acsInfo,
              admissionInfo: admissionInfo,
              otherInfo: otherHistoryInfo,
              medications: medications,
              onChanged: (val) {
                setState(() {
                  pastHistory = val['pastHistory'];
                  acsInfo = val['acsInfo'];
                  admissionInfo = val['admissionInfo'];
                  otherHistoryInfo = val['otherInfo'];
                  medications = val['medications'];
                });
              },
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Examination'),
            content: FormExamination(
              examination: examination,
              onChanged: (val) => setState(() => examination = val),
            ),
            isActive: _currentStep >= 3,
          ),
          Step(
            title: const Text('ECG & Echo'),
            content: FormEcgEcho(
              ecgComment: ecgComment,
              ecgPhotoPath: ecgPhotoPath,
              echoType: echoType,
              onChanged: (val) {
                setState(() {
                  ecgComment = val['ecgComment'];
                  ecgPhotoPath = val['ecgPhotoPath'];
                  echoType = val['echoType'];
                });
              },
            ),
            isActive: _currentStep >= 4,
          ),
          Step(
            title: const Text('Labs'),
            content: FormLabs(
              labs: labs,
              onChanged: (val) => setState(() => labs = val),
            ),
            isActive: _currentStep >= 5,
          ),
          Step(
            title: const Text('Recommendations'),
            content: FormRecommendations(
              recommendations: recommendations,
              onChanged: (val) => setState(() => recommendations = val),
            ),
            isActive: _currentStep >= 6,
          ),
        ],
      ),
    );
  }
}
