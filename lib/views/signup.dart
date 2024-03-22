import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/models/auth/signup.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(hintText: 'Email'),
        ),
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(hintText: 'Username'),
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        MaterialButton(onPressed: () async {
          final ScaffoldMessengerState sm = ScaffoldMessenger.of(context);
          try {
            await SignUp.signUpWithPassword(emailController.text, passwordController.text);
            sm.showSnackBar(const SnackBar(content: Text('Signed up')));
          } on AuthException catch (e) {
            sm.showSnackBar(SnackBar(content: Text('Sign up failed: ${e.message}')));
          }
        }, child: const Text('Sign Up')),
        MaterialButton(onPressed: () {
          Navigator.pushNamed(context, '/signin');
        }, child: const Text('Sign In')),
      ],
    );
  }
}