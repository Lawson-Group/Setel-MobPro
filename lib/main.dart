import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:coba_setel/firebase_options.dart';
import 'package:coba_setel/pages/feedback_page.dart';
import 'package:coba_setel/pages/history_page.dart';
import 'package:coba_setel/pages/home_page.dart';
import 'package:coba_setel/pages/info_shelter_page.dart';
import 'package:coba_setel/pages/login_page.dart';
import 'package:coba_setel/pages/scan_qr_page.dart';
import 'package:coba_setel/pages/user_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'Setel Mobile App',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 163, 41, 41)),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) => HomePage(name: 'Jannatin'),
        '/': (context) => LoginPage(),
        '/scan-qr': (context) => ScanPage(),
        '/history': (context) => TripHistoryPage(),
        '/profile': (context) => ProfilePage(),
        '/feedback': (context) => FeedbackForm(),
        '/info': (context) => InfoShelterPage()
      },
    );
  }
}
