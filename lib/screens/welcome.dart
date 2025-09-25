import 'package:final_year_project/screens/auth/login.dart';
import 'package:final_year_project/screens/auth/sin_up.dart';
import 'package:final_year_project/them/color.dart';
import 'package:final_year_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class WelcomeScrean extends StatefulWidget {
  static const String routename = "WelcomeScrean";
  const WelcomeScrean({super.key});
  @override
  State<WelcomeScrean> createState() => _WelcomeScreanState();
}

class _WelcomeScreanState extends State<WelcomeScrean> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Welcome In Health Care App ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color_Them.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  MyButton(
                    text: 'Log In ',
                    color: Color_Them.primaryColor,
                    onpressd: () {
                      Navigator.pushNamed(context, LogIn.routename);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    text: 'Sign Up ',
                    color: Color_Them.secondaryColor,
                    onpressd: () {
                      Navigator.pushNamed(context, SinUp.routename);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
