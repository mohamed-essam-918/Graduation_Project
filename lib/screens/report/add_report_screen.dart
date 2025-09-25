import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'report_model.dart';
import '../../them/color.dart';

class AddReportScreen extends StatefulWidget {
  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diseaseController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _medicationController = TextEditingController();
  final Map<String, int> _medications = {};
  int _currentQuantity = 1;

  @override
  void dispose() {
    _diseaseController.dispose();
    _treatmentController.dispose();
    _medicationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('إضافة تقرير جديد'),
        actions: [
          IconButton(
            color: Color_Them.secondaryColor,
            icon: const Icon(Icons.save_alt),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _diseaseController,
                  decoration: const InputDecoration(
                    labelText: 'نوع المرض',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'يجب إدخال نوع المرض' : null,
                ),
                const SizedBox(height: 20),
                const Text('الأدوية الموصوفة:', style: TextStyle(fontSize: 16)),
                ..._medications.entries.map((entry) => ListTile(
                      title: Text(entry.key),
                      trailing: Text('${entry.value} جرعة'),
                      subtitle: const Divider(),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _medicationController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الدواء',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: '1',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'الكمية',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            _currentQuantity = int.tryParse(value) ?? 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addMedication,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _treatmentController,
                  decoration: const InputDecoration(
                    labelText: 'تفاصيل العلاج',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'يجب إدخال تفاصيل العلاج' : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addMedication() {
    if (_medicationController.text.isNotEmpty) {
      setState(() {
        _medications[_medicationController.text] = _currentQuantity;
        _medicationController.clear();
        _currentQuantity = 1;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _medications.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
        );
        return;
      }
      final newReport = MedicalReport(
        diseaseType: _diseaseController.text,
        medications: _medications.keys.toList(),
        medicationQuantities: _medications,
        treatmentDetails: _treatmentController.text,
      );
      try {
        await FirebaseFirestore.instance
            .collection('medical_reports')
            .doc(user.uid)
            .collection('reports')
            .add(newReport.toJson());
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')),
        );
      }
    } else if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب إضافة دواء واحد على الأقل')),
      );
    }
  }
}
