import 'package:flutter/material.dart';
import 'package:sae_mobile/models/TypeAnnonce.dart' as taq;
import 'package:sae_mobile/models/Builder.dart' as builder_model;
import 'package:flutter/material.dart';
import 'package:sae_mobile/models/queries/local/typeAnnonce.dart' as taq;

class AnnonceListPage extends StatefulWidget {
  @override
  _AnnonceListPageState createState() => _AnnonceListPageState();
}

class _AnnonceListPageState extends State<AnnonceListPage> {
  late Future<List<taq.TypeAnnonce>> _typeAnnonceList;

  @override
  void initState() {
    super.initState();
    _typeAnnonceList = builder_model.Builder.buildTypesAnnonce();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catégorie'),
      ),
      body: FutureBuilder<List<taq.TypeAnnonce>>(
        future: _typeAnnonceList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final typeAnnonce = snapshot.data![index];
                return ListTile(
                  title: Text(typeAnnonce.libelle),
                );
              },
            );
          }
        },
      ),
    );
  }
}
