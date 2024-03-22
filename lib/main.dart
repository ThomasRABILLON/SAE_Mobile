import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/views/signin.dart';
import 'package:sae_mobile/views/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yrlokmgbwiaahzzcczpt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlybG9rbWdid2lhYWh6emNjenB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAzMjAyODMsImV4cCI6MjAyNTg5NjI4M30.tQdZKvked71WX-OKfrEcLw6y3eAKiNaMDyyQB1DfZ8c',
  );

  runApp(const MyApp());
}

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
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const Scaffold(
          body: SignUpView(),
        ),
        '/signin': (context) => const Scaffold(
          body: SignInView(),
        ),
      }
    );
  }
}