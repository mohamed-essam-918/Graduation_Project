import 'package:final_year_project/screens/vaccine/models/vaccine_model.dart';
import 'package:final_year_project/them/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VaccineDetailScreen extends StatelessWidget {
  final Vaccine vaccine;
  final DateTime birthDate;

  const VaccineDetailScreen({
    required this.vaccine,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final vaccineDate = vaccine.calculateDate(birthDate);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color_Them.primaryColor,
        title: Text(vaccine.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              vaccine.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 100),
            Column(
              children: [
                Text(
                  'الموعد: ${dateFormat.format(vaccineDate)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color_Them.secondaryColor),
                ),
                const SizedBox(height: 20),
                Text(
                  vaccine.isTaken ? 'تم التطعيم' : 'لم يتم التطعيم بعد',
                  style: TextStyle(
                    color: vaccine.isTaken ? Colors.green : Colors.red,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
