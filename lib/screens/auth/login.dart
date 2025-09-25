import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart'; // 🔸 إضافة Firestore
import 'package:firebase_messaging/firebase_messaging.dart'; // 🔸 إضافة FCM

import 'package:final_year_project/screens/firsscreen.dart';
import 'package:final_year_project/them/color.dart';
import 'package:final_year_project/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  static const String routename = "LogIn";
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final auth = FirebaseAuth.instance;
  late String email;
  late String password;

  Future<void> saveTokenToFirestore(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
        'email': email, // اختياري
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                          image: AssetImage('images/id-card.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome In please Log In ',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color_Them.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color_Them.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => password = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                    prefixIcon: Icon(
                      Icons.password,
                      color: Color_Them.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyButton(
                  text: 'Log In ',
                  color: Color_Them.secondaryColor,
                  onpressd: () async {
                    try {
                      final UserCredential userCredential =
                          await auth.signInWithEmailAndPassword(
                              email: email, password: password);

                      if (userCredential.user != null) {
                        // حفظ FCM Token
                        await saveTokenToFirestore(userCredential.user!.uid);
                        print(
                            'FCM Token00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: ${await FirebaseMessaging.instance.getToken()}');
                        // الانتقال إلى الشاشة الرئيسية
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => FirsScreen()),
                          (route) => false,
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('البريد الإلكتروني غير مسجل')),
                        );
                      } else if (e.code == 'wrong-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('كلمة المرور غير صحيحة')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ: ${e.message}')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
