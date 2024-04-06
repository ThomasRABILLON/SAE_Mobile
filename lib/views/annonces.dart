import 'package:flutter/material.dart';
import 'package:sae_mobile/models/Builder.dart' as builder_model;
import 'package:sae_mobile/views/annonceTile.dart';
import 'package:sae_mobile/models/annonce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnoncesView extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const AnnoncesView(
      {Key? key, required this.categoryId, required this.categoryName})
      : super(key: key);

  @override
  State<AnnoncesView> createState() => _AnnoncesViewState();
}

class _AnnoncesViewState extends State<AnnoncesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: FutureBuilder(
        future:
            builder_model.Builder.buildAnnoncesDistantByType(widget.categoryId),
        builder: (context, AsyncSnapshot<List<Annonce>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text("Pas d'annonces"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final annonce = snapshot.data![index];
                  return Container(
                    height: 200,
                    child: Card(
                      margin: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'images/box_base.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: AnnonceTile(annonce: annonce),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
