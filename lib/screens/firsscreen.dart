import 'package:final_year_project/screens/news/newsscreen.dart';
import 'package:final_year_project/screens/report/reports_screen.dart';
import 'package:final_year_project/screens/vaccine/health_vaccination.dart';
import 'package:flutter/material.dart';

class FirsScreen extends StatefulWidget {
  static const String routename = "FirsScreen";

  const FirsScreen({super.key});

  @override
  State<FirsScreen> createState() => _FirsScreenState();
}

class _FirsScreenState extends State<FirsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'الأخبار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vaccines),
            label: 'التطعيمات',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/pills.png')),
            label: 'التقارير',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (currentIndex) {
      case 0:
        return NewsScreen();
      case 1:
        return HealthVaccination();
      case 2:
        return ReportsScreen();
      default:
        return Center(child: Text('الشاشة غير متوفرة'));
    }
  }
}
