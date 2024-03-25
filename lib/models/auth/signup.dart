import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class SignUp {
  static Future<void> signUpWithPassword(String email, String password) async {
    final AuthResponse authResponse = await supabaseClient.auth.signUp(email: email, password: password);
    final Session? session = authResponse.session;
    final User? user = authResponse.user;

    if (session == null && user == null) {
      throw const AuthException('Sign up failed');
    }
    return;
  }
}