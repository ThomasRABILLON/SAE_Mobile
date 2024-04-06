import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class TypeAnnonceQueries {
  static Future<PostgrestList> getTypeAnnonces() async {
    final response = await supabaseClient.from('TYPE_ANNONCES').select();
    if (response.isEmpty) {
      throw Exception('Failed to get type annonces');
    }
    return response;
  }
}
