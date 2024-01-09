import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:myapp/consts/routes.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_services.dart';
import 'package:myapp/utilities/showerrordialog.dart';

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
                final userCredential = await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
                // ignore: use_build_context_synchronously
              } on UserNotFoundAuthException {
                // ignore: use_build_context_synchronously
                await showErroDialog(context, "User not found");
              } on WrongPasswordAuthException {
                // ignore: use_build_context_synchronously
                await showErroDialog(context, "Wrong Password");
              } on GenericAuthException {
                // ignore: use_build_context_synchronously
                await showErroDialog(context, "Something went wrong.");
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
