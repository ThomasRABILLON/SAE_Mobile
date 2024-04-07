import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/views/annonces.dart';
import 'package:sae_mobile/views/signout.dart';
import 'package:sae_mobile/models/queries/distant/user.dart' as udq;
import 'package:sae_mobile/models/User.dart' as user_model;

final SupabaseClient supabaseClient = Supabase.instance.client;

class ProfileView extends StatefulWidget {
  final user_model.User user;
  const ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileView> {
  late Future<PostgrestList> futureAvis;

  @override
  void initState() {
    super.initState();
    futureAvis = udq.UserQueries.getUtilisateurAvis(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Profile'),
        Text('Email: ${widget.user.email}'),
        Text('Name: ${widget.user.username}'),
        const SignOut(),
        SizedBox(height: 20),
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
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnnoncesView(
                  categoryId: '1',
                  categoryName: 'Mes reservations',
                  isUserAnnonces: true,
                  isReponduAnnonces: false,
                ),
              ),
            );
          },
          child: Text('Mes Reservations'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnnoncesView(
                  categoryId: '1',
                  categoryName: 'Mes prets',
                  isUserAnnonces: false,
                  isReponduAnnonces: true,
                ),
              ),
            );
          },
          child: Text('Mes Prets'),
        ),
      ],
    );
  }
}
