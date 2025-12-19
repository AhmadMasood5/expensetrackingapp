import 'package:expensetrackingapp/pages/loginpage.dart';
import 'package:expensetrackingapp/services/support_widget.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8edc2),

      // FIX: Wrap everything in SingleChildScrollView
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 120),

            // Onboarding Image
            Image.asset(
              'images/onboard.png',
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 50.0),

            // White rounded container
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              padding: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Manage Your Daily\nLife Expense',
                    textAlign: TextAlign.center,
                    style: AppWidget.headlineTextStyle(22.0),
                  ),

                  const SizedBox(height: 10),

                  // Description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Expense Tracker is a simple and efficient personal finance management app that allows you to track your daily expenses.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40.0),

                  // Get Started Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const loginpage()),
                      );
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        height: 70.0,
                        decoration: BoxDecoration(
                          color: const Color(0xffee6856),
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
