import 'package:flutter/material.dart';
import 'screens/lock_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/record_form_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedRecordApp());
}

class MedRecordApp extends StatelessWidget {
  const MedRecordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedRecord App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/lock',
      routes: {
        '/lock': (context) => const LockScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/add_record': (context) => const RecordFormScreen(),
      },
    );
  }
}
