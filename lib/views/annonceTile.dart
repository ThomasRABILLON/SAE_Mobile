import 'package:flutter/material.dart';
import 'package:sae_mobile/models/Annonce.dart';
import 'package:intl/intl.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnonceTile extends StatelessWidget {
  final Annonce annonce;

  const AnnonceTile({Key? key, required this.annonce}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(annonce.description),
        Text('Date début : ${DateFormat('dd/MM/yyyy').format(annonce.dateDeb)}'),
        Text('Date fin : ${DateFormat('dd/MM/yyyy').format(annonce.dateFin)}'),
        Text(annonce.auteur.username),
        Text(annonce.etat.toString()),
        MaterialButton(onPressed: () {
          annonce.cloturer();

          Navigator.pushNamed(context, '/annonces');
          },
          child: const Text('cloturer'),
        )
      ],
    );
  }
}