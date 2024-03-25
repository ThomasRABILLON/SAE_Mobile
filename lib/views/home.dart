import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/views/profile.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';

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
                    child: Image.asset('images/home.png', fit: BoxFit.cover),
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
        padding: EdgeInsets.symmetric(horizontal: 31, vertical: 44),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
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
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 23),
            Divider(
              indent: 14,
              endIndent: 18,
            ),
            SizedBox(height: 10),
            Text(
              "ou-se connecter avec",
              style: TextStyle(fontSize: 16, color: Colors.blueGrey[100]),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
