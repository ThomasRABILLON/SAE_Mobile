import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class SignOut extends StatefulWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        final ScaffoldMessengerState sm = ScaffoldMessenger.of(context);
        try {
          await supabaseClient.auth.signOut();
          sm.showSnackBar(const SnackBar(content: Text('Signed out')));
        } on AuthException catch (e) {
          sm.showSnackBar(SnackBar(content: Text('Sign out failed: ${e.message}')));
        }
      },
      child: const Text('Sign Out'),
    );
  }
}