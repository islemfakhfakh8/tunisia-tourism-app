import 'package:flutter/material.dart';

import '../models/place.dart';
import '../data/places_data.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  // Récupérer uniquement les lieux favoris
  List<Place> get favoritePlaces {
    return places
        .where((place) => place.isFavorite)
        .toList();
  }

  // Traduction des catégories
  String categoryName(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.history:
        return 'Histoire';
      case PlaceCategory.beach:
        return 'Plage';
      case PlaceCategory.desert:
        return 'Désert';
      case PlaceCategory.nature:
        return 'Nature';
      case PlaceCategory.medina:
        return 'Médina';
    }
  }

  // Supprimer un lieu des favoris
  void removeFavorite(Place place) {
    setState(() {
      place.isFavorite = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${place.name} retiré des favoris',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Mes Favoris ❤️',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.red[700],

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: favoritePlaces.isEmpty

          // Aucun favori
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Aucun favori pour le moment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Ajoutez vos lieux préférés !',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )

          // Afficher les favoris
          : GridView.builder(

              padding: const EdgeInsets.all(12),

              itemCount: favoritePlaces.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),

              itemBuilder: (context, index) {

                final place = favoritePlaces[index];

                return Dismissible(

                  key: ValueKey(place.id),

                  direction: DismissDirection.horizontal,

                  // Arrière-plan pendant le balayage
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    alignment: Alignment.centerLeft,

                    padding: const EdgeInsets.only(left: 20),

                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),

                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    alignment: Alignment.centerRight,

                    padding: const EdgeInsets.only(right: 20),

                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),

                  // Action de suppression
                  onDismissed: (direction) {
                    removeFavorite(place);
                  },

                  child: Card(
                    elevation: 3,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    clipBehavior: Clip.antiAlias,

                    child: InkWell(

                      // Ouvrir les détails du lieu
                      onTap: () async {

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(place: place),
                          ),
                        );

                        setState(() {});
                      },

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // Image du lieu
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,

                              children: [

                                Image.asset(
                                  place.imagePath,
                                  fit: BoxFit.contain,

                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),

                                // Icône Favoris
                                Positioned(
                                  top: 8,
                                  right: 8,

                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(6),

                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),

                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Informations du lieu
                          Padding(
                            padding: const EdgeInsets.all(10),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  place.name,

                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  place.region,

                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  categoryName(place.category),

                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
