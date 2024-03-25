import 'package:flutter/material.dart';
import 'package:sae_mobile/models/auth/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/views/signin.dart';
import 'package:sae_mobile/views/signup.dart';
import 'package:sae_mobile/views/profile.dart';
import 'package:sae_mobile/views/createAnnonce.dart';
import 'package:sae_mobile/views/annonces.dart';

import 'package:sae_mobile/models/user.dart' as user_model;
import 'package:sae_mobile/models/builder.dart' as user_builder;
import 'package:sae_mobile/models/queries/userQueries.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yrlokmgbwiaahzzcczpt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlybG9rbWdid2lhYWh6emNjenB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAzMjAyODMsImV4cCI6MjAyNTg5NjI4M30.tQdZKvked71WX-OKfrEcLw6y3eAKiNaMDyyQB1DfZ8c',
  );

  runApp(const MyApp());
}

final SupabaseClient supabaseClient = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/annonces',
      routes: {
        '/signup': (context) => const Scaffold(
          body: SignUpView(),
        ),
        '/signin': (context) => const Scaffold(
          body: SignInView(),
        ),
        '/createAnnonce': (context) => Scaffold(
          body: CreateAnnonce(),
        ),
        '/annonces': (context) => Scaffold(
          body: const AnnoncesView(),
        ),
        '/profile': (context) => Scaffold(
          body: FutureBuilder(
            future: UserQueries.getUserById(supabaseClient.auth.currentUser!.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final user = user_model.User.fromJson(snapshot.data![0]);
              return ProfileView(user: user);
            },
          )
        ),
      }
    );
  }
}