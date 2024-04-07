import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:sae_mobile/models/annonce.dart';
import 'package:sae_mobile/models/queries/distant/annonce.dart' as adq;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';
import 'package:sae_mobile/views/components/CustomTextField.dart';
import 'package:sae_mobile/views/userDetail.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class DetailAnnoncePage extends StatefulWidget {
  final Annonce annonce;

  const DetailAnnoncePage({Key? key, required this.annonce}) : super(key: key);

  @override
  _DetailAnnoncePageState createState() => _DetailAnnoncePageState();
}

class _DetailAnnoncePageState extends State<DetailAnnoncePage> {
  late Future<PostgrestList> futureAvis;
  final TextEditingController avisController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureAvis = adq.AnnonceQueries.getAnnonceAvis(widget.annonce.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.annonce.titre),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.annonce.description),
              SizedBox(height: 10),
              Text(
                'Auteur:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailUserPage(userId: widget.annonce.auteur.id),
                    ),
                  );
                },
                child: Text(
                  widget.annonce.auteur.username,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
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
                    if (snapshot.data!.length == 0) {
                      return Text("Pas encore d'avis sur le produit");
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
                  }
                },
              ),
              CustomTextField(
                controller: avisController,
                hintText: 'Avis',
              ),
              CustomButton(
                onPressed: () async {
                  try {
                    await widget.annonce.mettreAvis(
                        supabaseClient.auth.currentUser!.id,
                        avisController.text);
                    avisController.clear();
                    setState(() {
                      futureAvis =
                          adq.AnnonceQueries.getAnnonceAvis(widget.annonce.id);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                buttonText: 'mettre un avis',
              ),
              CustomButton(
                onPressed: () async {
                  try {
                    widget.annonce
                        .repondre(supabaseClient.auth.currentUser!.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Annonce répondu")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                buttonText: 'Répondre',
              ),
              CustomButton(
                onPressed: () async {
                  try {
                    widget.annonce.cloturer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Annonce cloturer")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                buttonText: 'Cloturer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
