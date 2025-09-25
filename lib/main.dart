import 'package:final_year_project/firebase_options.dart';
import 'package:final_year_project/screens/firsscreen.dart';
import 'package:final_year_project/screens/personalinf.dart';
import 'package:final_year_project/screens/auth/login.dart';
import 'package:final_year_project/screens/auth/sin_up.dart';
import 'package:final_year_project/screens/news/newsscreen.dart';
import 'package:final_year_project/screens/report/reports_screen.dart';
import 'package:final_year_project/screens/vaccine/health_vaccination.dart'
    show HealthVaccination;
import 'package:final_year_project/service/notification_service.dart';
import 'package:final_year_project/them/color.dart';
import 'package:final_year_project/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // تهيئة الإشعارات
  await NotificationService.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color_Them.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color_Them.primaryColor,
          secondary: Color_Them.secondaryColor,
          outline: Color_Them.secondaryColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color_Them.secondaryColor), // النص العادي
          bodyMedium: TextStyle(color: Color_Them.secondaryColor),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        FirsScreen.routename: (context) => FirsScreen(),
        NewsScreen.routename: (context) => NewsScreen(),
        HealthVaccination.routename: (context) => HealthVaccination(),
        ReportsScreen.routename: (context) => ReportsScreen(),
        WelcomeScrean.routename: (context) => WelcomeScrean(),
        SinUp.routename: (context) => SinUp(),
        LogIn.routename: (context) => LogIn(),
        PersonalInfoPage.routename: (context) => PersonalInfoPage(),
      },
      initialRoute: WelcomeScrean.routename,
    );
  }
}
