import 'package:flutter/material.dart';
import 'package:sae_mobile/models/annonce.dart';
import 'package:sae_mobile/views/components/CustomTextField.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/models/queries/distant/annonce.dart' as daq;
import 'package:sae_mobile/models/User.dart' as user_model;
import 'package:sae_mobile/models/Builder.dart' as builder_model;
import 'package:sae_mobile/models/queries/distant/typeAnnonce.dart';
import 'package:sae_mobile/models/queries/local/annonce.dart' as aq;
import 'package:sae_mobile/models/TypeAnnonce.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';
import 'package:sae_mobile/views/components/CustomButton.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class CreateAnnonce extends StatefulWidget {
  const CreateAnnonce({Key? key}) : super(key: key);

  @override
  State<CreateAnnonce> createState() => _CreateAnnonceState();
}

class _CreateAnnonceState extends State<CreateAnnonce> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateDebController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();
  int? _selectedTypeAnnonceIndex;
  List<TypeAnnonce>? typesAnnonce;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Créer l'annonce"),
            CustomTextField(controller: _titleController, hintText: 'Titre'),
            CustomTextField(
                controller: _descriptionController, hintText: 'Description'),
            TextField(
                controller: _dateDebController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _dateDebController.text = date.toString();
                  }
                }),
            TextField(
                controller: _dateFinController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _dateFinController.text = date.toString();
                  }
                }),
            FutureBuilder<List<TypeAnnonce>>(
              future: builder_model.Builder.buildTypesAnnonceDistant(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                typesAnnonce = snapshot.data!;
                if (_selectedTypeAnnonceIndex == null &&
                    typesAnnonce!.isNotEmpty) {
                  _selectedTypeAnnonceIndex = 0;
                }
                return DropdownButton<int>(
                  value: _selectedTypeAnnonceIndex,
                  items: typesAnnonce!.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value.libelle),
                    );
                  }).toList(),
                  onChanged: (int? newIndex) {
                    setState(() {
                      _selectedTypeAnnonceIndex = newIndex;
                    });
                    print(_selectedTypeAnnonceIndex);
                  },
                  hint: Text('Selectionne une catégorie'),
                );
              },
            ),
            FutureBuilder(
              future: builder_model.Builder.buildUserById(
                  supabaseClient.auth.currentUser!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final user = snapshot.data as user_model.User;

                return CustomButton(
                  onPressed: () async {
                    final selectedTypeAnnonce =
                        typesAnnonce![_selectedTypeAnnonceIndex!];
                    final annonce = await aq.AnnonceQueries.createAnnonce(
                      user.id,
                      _titleController.text,
                      _descriptionController.text,
                      DateTime.parse(_dateDebController.text),
                      DateTime.parse(_dateFinController.text),
                      1,
                      1,
                      selectedTypeAnnonce!.id,
                    );
                    Annonce annonceReel = Annonce.fromJson(annonce, user);
                    await daq.AnnonceQueries.publishAnnonce(annonceReel);

                    Navigator.pushNamed(context, '/categorie');
                  },
                  buttonText: "Créer l'annonce",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
