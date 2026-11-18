
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/add_screen.dart';

void main() {
  runApp(const MyApp());
}

// Application principale
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Découvre la Tunisie',

      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),

      home: const MainNavigation(),
    );
  }
}

// Navigation entre les écrans
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int selectedIndex = 0;

  // Permet de rafraîchir les écrans après un ajout
  int refreshKey = 0;

  // Ouvrir l'écran Ajouter
  Future<void> openAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddScreen(),
      ),
    );

    setState(() {
      refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Écrans principaux
    final List<Widget> screens = [
      HomeScreen(
        key: ValueKey('home_$refreshKey'),
      ),

      FavoritesScreen(
        key: ValueKey('favorites_$refreshKey'),
      ),
    ];

    return Scaffold(

      body: screens[selectedIndex],

      // Navigation inférieure
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: selectedIndex,

        selectedItemColor: Colors.red[700],

        unselectedItemColor: Colors.grey,

        backgroundColor: Colors.white,

        type: BottomNavigationBarType.fixed,

        onTap: (index) {

          if (index == 2) {
            openAddScreen();
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Ajouter',
          ),

        ],
      ),
    );
  }
}
