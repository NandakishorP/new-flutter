import 'package:flutter/material.dart';
import 'package:myapp/services/auth/auth_services.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Column(
        children: [
          const Text(
            "We've send you the email verification. Please verifiy the email address",
          ),
          const Text('If you   have not recieved it yet, press the button'),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send email verification'))
        ],
      ),
    );
  }
}
