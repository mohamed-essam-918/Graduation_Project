import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/them/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/screens/firsscreen.dart';

class PersonalInfoPage extends StatefulWidget {
  static const String routename = "PersonalInfoPage";

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  DateTime? _birthDate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _savePersonalData() async {
    if (_currentUser != null) {
      try {
        await _firestore.collection('users').doc(_currentUser!.uid).set({
          'name': _nameController.text,
          'nationalId': _nationalIdController.text,
          'birthDate': _birthDate?.toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ البيانات الشخصية بنجاح')),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FirsScreen()),
            (route) => false).then((value) => PersonalInfoPage.routename);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ في حفظ البيانات الشخصية')),
        );
      }
    }
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('معلومات المستخدم',
              style: TextStyle(color: Color_Them.primaryColor))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الطفل',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _selectBirthDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'تاريخ الميلاد',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _birthDate != null
                          ? "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}"
                          : 'اختر التاريخ',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nationalIdController,
                  decoration: const InputDecoration(
                    labelText: 'الرقم القومي',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _savePersonalData,
              child: const Text('حفظ البيانات'),
            ),
          ],
        ),
      ),
    );
  }
}
