import 'package:flutter/material.dart';
import 'package:sae_mobile/models/annonce.dart';
import 'package:intl/intl.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnonceTile extends StatelessWidget {
  final Annonce annonce;

  AnnonceTile({Key? key, required this.annonce}) : super(key: key);

  String mapEtatToText(int etat) {
    switch (etat) {
      case 2:
        return 'Non repondu';
      case 3:
        return 'Repondu';
      case 4:
        return 'Cloturer';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(annonce.description),
        Text(
            'Date début : ${DateFormat('dd/MM/yyyy').format(annonce.dateDeb)}'),
        Text('Date fin : ${DateFormat('dd/MM/yyyy').format(annonce.dateFin)}'),
        Text(annonce.auteur.username),
        Text(mapEtatToText(annonce.etat)),
      ],
    );
  }
}
