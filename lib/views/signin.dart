import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/models/auth/signin.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInState();
}

class _SignInState extends State<SignInView> {
  final TextEditingController emailController = TextEditingController();
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
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        MaterialButton(onPressed: () async {
          final ScaffoldMessengerState sm = ScaffoldMessenger.of(context);
          try {
            await SignIn.signInWithPassword(emailController.text, passwordController.text);
            sm.showSnackBar(const SnackBar(content: Text('Signed in')));
            Navigator.pushNamed(context, '/profile');
          } on AuthException catch (e) {
            sm.showSnackBar(SnackBar(content: Text('Sign in failed: ${e.message}')));
          }
        }, child: const Text('Sign In')),
        MaterialButton(onPressed: () {
          Navigator.pushNamed(context, '/signup');
        }, child: const Text('Sign Up')),
      ],
    );
  }
}