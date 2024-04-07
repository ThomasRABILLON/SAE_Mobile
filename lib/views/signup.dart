import 'package:flutter/material.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';
import 'package:sae_mobile/views/components/CustomTextField.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/models/queries/local/user.dart' as uql;
import 'package:sae_mobile/models/auth/signup.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            child: Image.asset(
              'images/signup.png',
            ),
          ),
        ),
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height *
                    0.07), // ajout d'une marge en bas égale à 10% de la hauteur de l'écran
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: usernameController,
                    hintText: 'pseudonyme',
                  ),
                  SizedBox(height: 10.0),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'email',
                  ),
                  SizedBox(height: 10.0),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'mot de passe',
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  ButtonTheme(
                    child: CustomButton(
                      onPressed: () async {
                        final ScaffoldMessengerState sm =
                            ScaffoldMessenger.of(context);
                        try {
                          await SignUp.signUpWithPassword(
                            emailController.text,
                            passwordController.text,
                            usernameController.text,
                          );
                          final userId = supabaseClient.auth.currentUser!.id;
                          await uql.UserQueries.createUser(
                            userId,
                            emailController.text,
                            usernameController.text,
                          );
                          sm.showSnackBar(
                              const SnackBar(content: Text('Bienvenue !')));
                          Navigator.pushNamed(context, '/accountCreated');
                        } catch (e) {
                          sm.showSnackBar(SnackBar(
                              content:
                                  Text('Sign up failed: ${e.toString()}')));
                        }
                      },
                      buttonText: 'Créer un compte',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
