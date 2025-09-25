import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/screens/vaccine/models/vaccine_model.dart';
import 'package:final_year_project/them/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'vaccine_detail_screen.dart';

class HealthVaccination extends StatefulWidget {
  static const String routename = "HealthVaccination";

  const HealthVaccination({Key? key}) : super(key: key);

  @override
  _HealthVaccinationState createState() => _HealthVaccinationState();
}

class _HealthVaccinationState extends State<HealthVaccination> {
  late Future<List<Vaccine>> _vaccinesFuture;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  DateTime? _birthDate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _vaccinesFuture = _loadVaccines();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
        _vaccinesFuture = _loadVaccines();
        if (_currentUser != null) {
          _saveFCMToken(); // Save the FCM token when the user is logged in
        }
      });
    });
  }

  Future<void> _saveFCMToken() async {
    String? token = await _firebaseMessaging.getToken();

    if (token != null && _currentUser != null) {
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  Future<List<Vaccine>> _loadVaccines() async {
    List<Vaccine> vaccines = defaultVaccines;

    if (_currentUser != null) {
      try {
        final doc =
            await _firestore.collection('users').doc(_currentUser!.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _nameController.text = data['name'] ?? '';
          _nationalIdController.text = data['nationalId'] ?? '';
          _birthDate = data['birthDate'] != null
              ? DateTime.parse(data['birthDate'])
              : null;
        }

        final vaccineSnapshot = await _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('vaccinations')
            .get();

        if (vaccineSnapshot.docs.isNotEmpty) {
          final userVaccines = vaccineSnapshot.docs;
          Map<String, dynamic> userVaccineData = {
            for (var doc in userVaccines) doc.id: doc.data()
          };

          vaccines = defaultVaccines.map((vaccine) {
            if (userVaccineData.containsKey(vaccine.id)) {
              return vaccine.copyWith(
                isTaken: userVaccineData[vaccine.id]['isTaken'] ?? false,
              );
            }
            return vaccine;
          }).toList();
        }
      } catch (e) {
        print('🔥 خطأ أثناء التحميل من Firestore: $e');
      }
    }
    return vaccines;
  }

  Future<void> _savePersonalData() async {
    if (_currentUser != null && _birthDate != null) {
      try {
        await _firestore.collection('users').doc(_currentUser!.uid).set({
          'name': _nameController.text,
          'nationalId': _nationalIdController.text,
          'birthDate': _birthDate!.toIso8601String(),
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ في حفظ البيانات الشخصية: $e')),
        );
      }
    }
  }

  Future<void> _toggleVaccine(Vaccine vaccine, bool value) async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
      );
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('vaccinations')
          .doc(vaccine.id)
          .set({
        'vaccineName': vaccine.name,
        'isTaken': value,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _vaccinesFuture = _loadVaccines();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ حالة التطعيم بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في حفظ البيانات: $e')),
      );
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
      await _savePersonalData();
    }
  }

  void _showUserProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('معلومات المستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الاسم: ${_nameController.text}'),
            Text('الرقم القومي: ${_nationalIdController.text}'),
            if (_birthDate != null)
              Text('تاريخ الميلاد: ${DateFormat.yMd().format(_birthDate!)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('التطعيمات الصحية',
            style: TextStyle(color: Color_Them.secondaryColor)),
        actions: [
          IconButton(
            color: Color_Them.secondaryColor,
            icon: Icon(_currentUser != null ? Icons.person : Icons.login),
            onPressed: () {
              if (_currentUser == null) {
                Navigator.pushNamed(context, 'LogIn');
              } else {
                _showUserProfile();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Vaccine>>(
        future: _vaccinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ في تحميل البيانات'));
          }

          final vaccines = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الطفل',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _savePersonalData(),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: _selectBirthDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'تاريخ الميلاد',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _birthDate != null
                                ? DateFormat.yMd().format(_birthDate!)
                                : 'اختر التاريخ',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nationalIdController,
                        decoration: const InputDecoration(
                          labelText: 'الرقم القومي',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _savePersonalData(),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vaccines.length,
                  itemBuilder: (context, index) {
                    final vaccine = vaccines[index];
                    final date = _birthDate != null
                        ? vaccine.calculateDate(_birthDate!)
                        : null;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: vaccine.isTaken,
                          onChanged: (value) => _toggleVaccine(vaccine, value!),
                        ),
                        title: Text(vaccine.name),
                        subtitle: date != null
                            ? Text(DateFormat.yMd().format(date))
                            : const Text('حدد تاريخ الميلاد'),
                        trailing: const Icon(Icons.info),
                        onTap: () {
                          if (_birthDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('حدد تاريخ الميلاد أولاً')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VaccineDetailScreen(
                                vaccine: vaccine,
                                birthDate: _birthDate!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
