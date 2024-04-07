import 'package:flutter/material.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';

class AccountCreatedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/account_created.png'),
            SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                text: 'Compte ',
                style: Theme.of(context).textTheme.displayLarge,
                children: <TextSpan>[
                  TextSpan(text: 'Crée', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            Spacer(),
            CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categorie');
              },
              buttonText: 'Voir les annonces',
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
