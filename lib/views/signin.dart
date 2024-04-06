import 'package:flutter/material.dart';
import 'package:sae_mobile/views/components/CustomTextField.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';
import 'package:sae_mobile/models/auth/signin.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInState();
}

class _SignInState extends State<SignInView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset('images/signin.png',
                      fit: BoxFit.cover, width: double.infinity),
                  Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 29, vertical: 34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          CustomTextField(controller: emailController, hintText: 'Email'),
          SizedBox(height: 10),
          CustomTextField(
              controller: passwordController,
              hintText: 'Mot de passe',
              obscureText: true),
          SizedBox(height: 10),
          CustomButton(
            onPressed: () async {
              final ScaffoldMessengerState sm = ScaffoldMessenger.of(context);
              try {
                await SignIn.signInWithPassword(
                    emailController.text, passwordController.text);
                sm.showSnackBar(const SnackBar(content: Text('Signed in')));
                Navigator.pushNamed(context, '/categorie');
              } on AuthException catch (e) {
                sm.showSnackBar(
                    SnackBar(content: Text('Sign in failed: ${e.message}')));
              }
            },
            buttonText: "Se connecter",
          ),
        ],
      ),
    );
  }
}
