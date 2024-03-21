import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/auth/signout.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
            final AuthResponse authResponse = await supabaseClient.auth.signUp(email: emailController.text, password: passwordController.text, data: {'username': usernameController.text});
            final Session? session = authResponse.session;
            final User? user = authResponse.user;

            if (session != null && user != null) {
              sm.showSnackBar(SnackBar(content: Text('Signed up as ${user.email}')));
            } else {
              sm.showSnackBar(const SnackBar(content: Text('Sign up failed')));
            }
          } on AuthException catch (e) {
            sm.showSnackBar(SnackBar(content: Text('Sign up failed: ${e.message}')));
          }
        }, child: const Text('Sign Up')),
        MaterialButton(onPressed: () {
          Navigator.pushNamed(context, '/signin');
        }, child: const Text('Sign In')),
        const SignOut(),
      ],
    );
  }
}