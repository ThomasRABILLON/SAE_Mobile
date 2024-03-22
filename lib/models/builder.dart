import 'package:sae_mobile/models/queries/userQueries.dart';
import 'package:sae_mobile/models/user.dart' as user_model;

class Builder {
  static Future<user_model.User> buildUserById(String id) async {
    final data = await UserQueries.getUserById(id).then((value) => value.first);

    return user_model.User.fromJson(data);
  }
}