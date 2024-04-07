import 'package:flutter/material.dart';
import 'package:sae_mobile/views/theme.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  Navbar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          onItemTapped(index);
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/categorie');
              break;
            case 1:
              Navigator.pushNamed(context, '/categorie');
              break;
            case 2:
              Navigator.pushNamed(context, '/createAnnonce');
              break;
            case 3:
              Navigator.pushNamed(context, '/categorie');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).textTheme.bodyMedium!.color,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            activeIcon: Icon(Icons.home,
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
            activeIcon: Icon(Icons.favorite,
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: '',
            activeIcon: Icon(Icons.upload_file,
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
            activeIcon: Icon(Icons.notifications,
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
            activeIcon: Icon(Icons.person,
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ],
      ),
    );
  }
}
