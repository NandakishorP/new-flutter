import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:myapp/consts/routes.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_services.dart';
import 'package:myapp/utilities/showerrordialog.dart';

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
                // ignore: unused_local_variable
                final userCredential = await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                // ignore: use_build_context_synchronously
                await showErroDialog(context, 'Weak Password');
              } on EmailAlreadyInUseAuthException {
                // ignore: use_build_context_synchronously
                await showErroDialog(context, 'Email already in use');
              } on InvalidEmailAuthException {
                // ignore: use_build_context_synchronously
                await showErroDialog(context, 'Invalid email');
              } on GenericAuthException {
                // ignore: use_build_context_synchronously
                await showErroDialog(context, 'Something went bad');
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
