import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class SignIn {

  static Future<void> signInWithPassword(String email, String password) async {
    final AuthResponse authResponse = await supabaseClient.auth.signInWithPassword(email: email, password: password);
    final Session? session = authResponse.session;
    final User? user = authResponse.user;

    if (session == null && user == null) {
      throw const AuthException('Sign in failed');
    }
    return;
  }
}