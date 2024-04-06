import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/views/profile.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';
import 'package:sae_mobile/views/components/CustomTextField.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'images/home.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  _buildOne(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOne(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              buttonText: "Créer un compte",
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signin');
              },
              child: Text(
                "J'ai déjà un compte",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge, // Appliquer le style bodyText1
              ),
            ),
            SizedBox(height: 23),
          ],
        ),
      ),
    );
  }
}
