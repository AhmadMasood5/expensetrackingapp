import 'package:expensetrackingapp/pages/home.dart';
import 'package:expensetrackingapp/services/DatabaseMethods.dart';
import 'package:expensetrackingapp/services/SharedPreferenceHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensetrackingapp/pages/loginpage.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  registeration() async {
    String name = nameController.text.trim();
    String email = mailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        // Create user with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Use FirebaseAuth UID instead of random ID
        String uid = userCredential.user!.uid;

        Map<String, dynamic> userInfoMap = {
          "Name": name,
          "Email": email,
          "id": uid,
        };

        // Save user info in Firestore
        await DatabaseMethods.addUserInfo(userInfoMap, uid);

        // Save user info locally
        await SharedPreferenceHelper().saveUserId(uid);
        await SharedPreferenceHelper().saveUserName(name);
        await SharedPreferenceHelper().saveUserEmail(email);

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Registered Successfully",
                style: TextStyle(fontSize: 20.0)),
          ),
        );

        // Navigate to Home page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        String message = "";
        if (e.code == "weak-password") {
          message = "Password provided is too weak";
        } else if (e.code == "email-already-in-use") {
          message = "Account already exists";
        } else {
          message = e.message ?? "Registration failed";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(message, style: TextStyle(fontSize: 18.0)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please fill all fields",
              style: TextStyle(fontSize: 18.0)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/signup.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create\nan Account!',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 35.0)),
                  SizedBox(height: 50.0),

                  // Name
                  Text('Name:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person,
                              size: 28.0, color: Color(0xff904c6e)),
                          hintText: 'Enter Name',
                          hintStyle: TextStyle(fontSize: 18.0)),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  // Email
                  Text('Email:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: mailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email,
                              size: 28.0, color: Color(0xff904c6e)),
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(fontSize: 18.0)),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  // Password
                  Text('Password:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock,
                              size: 28.0, color: Color(0xff904c6e)),
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(fontSize: 18.0)),
                    ),
                  ),

                  SizedBox(height: 40.0),

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 60.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Next',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => registeration(),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Color(0xff904c6e),
                                borderRadius: BorderRadius.circular(60)),
                            child: Icon(Icons.arrow_forward,
                                size: 40.0, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50.0),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginpage()));
                        },
                        child: Text(' Login',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xff904c6e),
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
