import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/models/queries/distant/user.dart' as udq;
import 'package:sae_mobile/views/components/CustomButton.dart';
import 'package:sae_mobile/views/components/CustomTextField.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class DetailUserPage extends StatefulWidget {
  final String userId;

  const DetailUserPage({Key? key, required this.userId}) : super(key: key);

  @override
  _DetailUserPageState createState() => _DetailUserPageState();
}

class _DetailUserPageState extends State<DetailUserPage> {
  late Future<PostgrestList> futureAvis;
  final TextEditingController avisController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureAvis = udq.UserQueries.getUtilisateurAvis(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de l'utilisateur"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Avis:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FutureBuilder<PostgrestList>(
                future: futureAvis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]['avis']),
                          subtitle: Text(
                              'Par ${snapshot.data![index]['users']['username']}'),
                        );
                      },
                    );
                  }
                },
              ),
              CustomTextField(
                controller: avisController,
                hintText: 'Avis',
              ),
              CustomButton(
                onPressed: () async {
                  await udq.UserQueries.mettreAvisUtilisateur(
                    supabaseClient.auth.currentUser!.id,
                    widget.userId,
                    avisController.text,
                  );
                  avisController.clear();
                  setState(() {
                    futureAvis =
                        udq.UserQueries.getUtilisateurAvis(widget.userId);
                  });
                },
                buttonText: 'Publier la critique',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
