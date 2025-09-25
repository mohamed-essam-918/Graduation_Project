import 'package:cloud_firestore/cloud_firestore.dart'; // 🔸 Firestore
import 'package:firebase_messaging/firebase_messaging.dart'; // 🔸 FCM

import 'package:final_year_project/screens/personalinf.dart';
import 'package:final_year_project/them/color.dart';
import 'package:final_year_project/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SinUp extends StatefulWidget {
  static const String routename = "SinUp";
  const SinUp({super.key});

  @override
  State<SinUp> createState() => _SinUpState();
}

class _SinUpState extends State<SinUp> {
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
                        'Welcome In please Signup ',
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
                    onChanged: (value) {
                      email = value;
                    },
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
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Color_Them.secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: 'Sign Up ',
                    color: Color_Them.secondaryColor,
                    onpressd: () async {
                      try {
                        UserCredential userCredential =
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                        if (userCredential.user != null) {
                          // حفظ FCM Token
                          await saveTokenToFirestore(userCredential.user!.uid);

                          // الانتقال إلى صفحة المعلومات الشخصية
                          Navigator.pushReplacementNamed(
                              context, PersonalInfoPage.routename);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ في التسجيل: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
