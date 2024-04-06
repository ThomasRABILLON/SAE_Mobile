import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class UserQueries {
  static Future<PostgrestList> getUsers() async {
    final response = await supabaseClient.from('USERS').select();
    if (response.isEmpty) {
      throw Exception('Failed to get users');
    }
    return response;
  }

  static Future<PostgrestList> getUserById(String id) async {
    final response = await supabaseClient.from('USERS').select().eq('id', id);
    if (response.isEmpty) {
      throw Exception('Failed to get user');
    }
    return response;
  }
}