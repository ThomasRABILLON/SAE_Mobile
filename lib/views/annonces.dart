import 'package:flutter/material.dart';
import 'package:sae_mobile/models/Builder.dart' as builder_model;
import 'package:sae_mobile/views/annonceTile.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnoncesView extends StatefulWidget {
  const AnnoncesView({Key? key}) : super(key: key);

  @override
  State<AnnoncesView> createState() => _AnnoncesViewState();
}

class _AnnoncesViewState extends State<AnnoncesView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: builder_model.Builder.buildAnnoncesDistantRepondu(supabaseClient.auth.currentUser!.id),
      //future: builder_model.Builder.buildAnnoncesLocal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].titre),
                subtitle: AnnonceTile(annonce: snapshot.data![index]),
              );
            },
          );
        }
      },
    );
  }
}