import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:myapp/consts/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('Login')),
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
                // ignore: unused_local_variable
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                log(e.code);
                if (e.code == 'user-not-found') {
                  // ignore: use_build_context_synchronously
                  await showErroDialog(context, "User not found");
                } else if (e.code == 'invalid-credential') {
                  // ignore: use_build_context_synchronously
                  await showErroDialog(context, "Wrong credentials");
                } else {
                  // ignore: use_build_context_synchronously
                  await showErroDialog(context, e.code.toString());
                }
              } catch (f) {
                log(f.toString());
              }
            },
            child: const Text(
              'Login',
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here'))
        ],
      ),
    );
  }
}

Future<void> showErroDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error occured'),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('ok'))
          ],
        );
      });
}
