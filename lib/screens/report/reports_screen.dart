import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'add_report_screen.dart';
import 'report_model.dart';

class ReportsScreen extends StatefulWidget {
  static const String routename = "ReportsScreen";
  const ReportsScreen({Key? key}) : super(key: key);
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<MedicalReport> _reports = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('medical_reports')
          .doc(user.uid)
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .get();
      _reports = snapshot.docs
          .map((doc) => MedicalReport.fromJson(doc.data()))
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل التقارير: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('التقارير الطبية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddReport,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? const Center(child: Text('لا توجد تقارير مسجلة'))
              : ListView.builder(
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(report.diseaseType),
                        subtitle: Text(DateFormat('yyyy/MM/dd – HH:mm')
                            .format(report.createdAt)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReport(report.id),
                        ),
                        onTap: () => _showReportDetails(report),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _navigateToAddReport() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddReportScreen()),
    );
    await _loadReports();
  }

  Future<void> _deleteReport(String reportId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      // حذف التقرير من Firestore
      await FirebaseFirestore.instance
          .collection('medical_reports')
          .doc(user.uid)
          .collection('reports')
          .doc(reportId)
          .delete(); // تحديث واجهة المستخدم بعد الحذف
      setState(() {
        _reports.removeWhere((report) => report.id == reportId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف التقرير بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حذف التقرير: $e')),
      );
    }
  }

  void _showReportDetails(MedicalReport report) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(report.diseaseType),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'التاريخ: ${DateFormat('yyyy/MM/dd – HH:mm').format(report.createdAt)}'),
              const SizedBox(height: 16),
              const Text('الأدوية:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...report.medications.map((med) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        '• $med (${report.medicationQuantities[med]} جرعة)'),
                  )),
              const SizedBox(height: 16),
              const Text('تفاصيل العلاج:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(report.treatmentDetails),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
