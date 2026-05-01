# Cardiac Patient Records App

This is a comprehensive, offline-first mobile application built for medical professionals to manage cardiac patient records efficiently. It features a robust multi-step form to collect patient information, complaints, medical history, examination findings, ECG/Echo data, laboratory results, and recommendations. 

## App Features

- **Dashboard & Trends:** View recent patient records and track their GRACE risk scores on a visual chart.
- **Biometric Security:** Secure access to patient data using a local lock screen integrated with PIN and device biometric authentication.
- **Patient Information:** Capture detailed demographic data and assign a Medical Record Number (MRN).
- **Complaints & History:** Select typical symptoms (chest pain, dyspnea, orthopnea, etc.) and record past medical history including ACS, hospital admissions, diabetes, hypertension, and medication usage.
- **Physical Examination:** Document vital signs, BP, HR, SpO2, and chest auscultation.
- **ECG & Echo Integration:** Write comments, capture voice notes using Speech-to-Text, and attach ECG photos via the camera. Support for selecting Bedside or Formal Echo types.
- **Laboratory Results:** Extensive lab value entry with built-in reference range checks. Automatically flags abnormal results in red for patient safety, and allows toggling unit measurements between standard (umol/mmol) and mg/dL.
- **Risk Scores & Recommendations:** Log clinical plans and scores like CHA₂DS₂-VASc and GRACE.
- **PDF Export & Share:** Generate comprehensive PDF reports for each patient record and share them via built-in system sharing.
- **Local Database:** Fully functional local SQLite storage ensuring data privacy and fast, offline access.

## Tech Stack

- **Flutter:** Cross-platform framework.
- **Dart:** Application logic.
- **sqflite:** Local structured storage.
- **share_plus & pdf:** Record exportation and sharing.
- **speech_to_text:** Voice dictated ECG notes.
- **image_picker:** Camera and gallery integration for ECG records.
- **fl_chart:** Visual representation of risk scores.
- **local_auth:** Biometric and PIN authentication layer.

## Setup and Run

1. Make sure you have the latest [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
2. Clone this repository.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on your preferred platform (iOS, Android, or Web for testing):
   ```bash
   flutter run
   ```

---

## About CouldAI

This application was generated with [CouldAI](https://could.ai), an AI app builder for cross-platform apps that turns prompts into real native iOS, Android, Web, and Desktop apps with autonomous AI agents that architect, build, test, deploy, and iterate production-ready applications.