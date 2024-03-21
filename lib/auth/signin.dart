import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
            final AuthResponse authResponse = await supabaseClient.auth.signInWithPassword(email: emailController.text, password: passwordController.text);
            final Session? session = authResponse.session;
            final User? user = authResponse.user;

            if (session != null && user != null) {
              sm.showSnackBar(SnackBar(content: Text('Signed in as ${user.email}')));
            } else {
              sm.showSnackBar(const SnackBar(content: Text('Sign in failed')));
            }
          } on AuthException catch (e) {
            sm.showSnackBar(SnackBar(content: Text('Sign in failed: ${e.message}')));
          }
        }, child: const Text('Sign In')),
      ],
    );
  }
}