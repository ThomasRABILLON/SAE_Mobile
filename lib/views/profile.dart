import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/views/signout.dart';

import 'package:sae_mobile/models/User.dart' as user_model;

final SupabaseClient supabaseClient = Supabase.instance.client;

class ProfileView extends StatefulWidget {
  final user_model.User user;
  const ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Profile'),
        Text('Email: ${widget.user.email}'),
        Text('Name: ${widget.user.username}'),
        const SignOut(),
      ],
    );
  }
}
