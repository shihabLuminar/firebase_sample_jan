import 'package:firebase_sample_jan/controller/loginscreen_controller.dart';
import 'package:firebase_sample_jan/controller/registration_screen_controller.dart';
import 'package:firebase_sample_jan/view/home_screen/home_screen.dart';
import 'package:firebase_sample_jan/view/registration_screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login Now",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: passController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isNotEmpty &&
                      passController.text.isNotEmpty) {
                    // registration funciton
                    context
                        .read<LoginScreenController>()
                        .onLogin(
                            context: context,
                            email: emailController.text,
                            password: passController.text)
                        .then((value) {
                      if (value == true) {
                        // login success
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Login Successs")));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false);
                      } else {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     backgroundColor: Colors.red,
                        //     content: Text("Registration Failed")));
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Enter a valid email and password")));
                  }
                },
                child: Text("Login")),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Dont have account"),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ));
                    },
                    child: Text("Register")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
