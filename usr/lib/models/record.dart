import 'dart:convert';

class PatientRecord {
  final int? id;
  final String datetime;
  final String mrn;
  final String name;
  final String sex;
  final int age;
  
  // Complaints
  final Map<String, dynamic> complaints;
  
  // Past Medical History
  final Map<String, dynamic> pastHistory;
  
  // Medications
  final String medications;
  
  // Examination
  final Map<String, dynamic> examination;
  
  // ECG & Echo
  final String ecgComment;
  final String ecgPhotoPath;
  final String echoType;
  
  // Labs
  final Map<String, dynamic> labs;
  
  // Recommendations
  final String recommendations;
  
  // Scores
  final int cha2ds2VascScore;
  final int graceScore;

  PatientRecord({
    this.id,
    required this.datetime,
    required this.mrn,
    required this.name,
    required this.sex,
    required this.age,
    required this.complaints,
    required this.pastHistory,
    required this.medications,
    required this.examination,
    required this.ecgComment,
    required this.ecgPhotoPath,
    required this.echoType,
    required this.labs,
    required this.recommendations,
    required this.cha2ds2VascScore,
    required this.graceScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime,
      'mrn': mrn,
      'name': name,
      'sex': sex,
      'age': age,
      'complaints': jsonEncode(complaints),
      'past_history': jsonEncode(pastHistory),
      'medications': medications,
      'examination': jsonEncode(examination),
      'ecg_comment': ecgComment,
      'ecg_photo_path': ecgPhotoPath,
      'echo_type': echoType,
      'labs': jsonEncode(labs),
      'recommendations': recommendations,
      'cha2ds2_vasc_score': cha2ds2VascScore,
      'grace_score': graceScore,
    };
  }

  factory PatientRecord.fromMap(Map<String, dynamic> map) {
    return PatientRecord(
      id: map['id'],
      datetime: map['datetime'],
      mrn: map['mrn'],
      name: map['name'],
      sex: map['sex'],
      age: map['age'],
      complaints: jsonDecode(map['complaints']),
      pastHistory: jsonDecode(map['past_history']),
      medications: map['medications'],
      examination: jsonDecode(map['examination']),
      ecgComment: map['ecg_comment'],
      ecgPhotoPath: map['ecg_photo_path'],
      echoType: map['echo_type'],
      labs: jsonDecode(map['labs']),
      recommendations: map['recommendations'],
      cha2ds2VascScore: map['cha2ds2_vasc_score'],
      graceScore: map['grace_score'],
    );
  }
}
