import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    showDialog(
      context: context,
      builder: ((context) => const Center(
            child: CircularProgressIndicator(),
          )),
    );
    //make sure passwords match
    if (passwordController.text != confirmPasswordTextController.text) {
      //pop loading circle
      Navigator.pop(context);
      // Show error to user
      displayMessage("Passwords dont match");
      return;
    }

    //try creating the user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: usernameController.text,
              password: passwordController.text);

      //After creating a user, Creating a new doc in firbase called Users
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email!)
          .set({
        'username': usernameController.text.split('@')[0], // Initial Username
        'bio': 'Empty bio...' //Initally empty bio
      });

      //pop circle
      // if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // Show error to user
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Lets create an account for you!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter some text';
                  }
                  return null;
                },
              ),
              // MyTextField(
              //   controller: usernameController,
              //   hintText: 'Username',
              //   obscureText: false,
              // ),

              const SizedBox(height: 10),

              // Confirm Password textfield
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter some text';
                  }
                  return null;
                },
              ),

              // MyTextField(
              //   controller: passwordController,
              //   hintText: 'Password',
              //   obscureText: true,
              // ),

              const SizedBox(height: 10),

              // password textfield
              TextFormField(
                controller: confirmPasswordTextController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter some text';
                  }
                  return null;
                },
              ),
              // MyTextField(
              //   controller: confirmPasswordTextController,
              //   hintText: 'Confirm Password',
              //   obscureText: true,
              // ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign up button
              MyButton(
                onTap: signUserUp,
                text: 'Sign Up',
              ),

              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ?"),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  )
                ],
              ),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      // child: Text(
                      //   'Or continue with',
                      //   style: TextStyle(color: Colors.grey[700]),
                      // ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     // google button
              //     SquareTile(imagePath: 'lib/images/google.png'),

              //     SizedBox(width: 25),

              //     // apple button
              //     SquareTile(imagePath: 'lib/images/apple.png')
              //   ],
              // ),

              const SizedBox(height: 50),

              // not a member? register now
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Not a member?',
              //       style: TextStyle(color: Colors.grey[700]),
              //     ),
              //     const SizedBox(width: 4),
              //     const Text(
              //       'Register now',
              //       style: TextStyle(
              //         color: Colors.blue,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
