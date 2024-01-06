import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/consts/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter the email'),
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter the password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                log('something bad happened');
                if (e.code == 'weak-password') {
                  log("Weak password");
                } else if (e.code == 'email-already-in-use') {
                  log('Email is already in use');
                } else if (e.code == 'invalid-email') {
                  log('Invalid email');
                } else {
                  log(e.code);
                }
              } catch (e) {
                log('something bad happened');
              }
            },
            child: const Text(
              'Register',
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, loginRoute, (route) => false);
              },
              child: const Text('Already Registered? Login'))
        ],
      ),
    );
  }
}
