import 'package:flutter/material.dart';
import 'package:sae_mobile/models/TypeAnnonce.dart' as taq;
import 'package:sae_mobile/models/Builder.dart' as builder_model;
import 'package:sae_mobile/views/annonces.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  late Future<List<taq.TypeAnnonce>> _typeAnnonceList;

  @override
  void initState() {
    super.initState();
    _typeAnnonceList = builder_model.Builder.buildTypesAnnonceDistant();
    _typeAnnonceList.then((value) {
      print('Valeur de _typeAnnonceList: $value');
    });
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnoncesView(
                            categoryId: typeAnnonce.id.toString(),
                            categoryName: typeAnnonce.libelle),
                      ),
                    );
                  },
                  child: Container(
                    height: 90.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage('images/${typeAnnonce.libelle}.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        typeAnnonce.libelle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          backgroundColor: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
