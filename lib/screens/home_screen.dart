import 'package:flutter/material.dart';

import '../models/place.dart';
import '../data/places_data.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Texte de recherche
  String searchQuery = '';

  // Catégorie sélectionnée
  PlaceCategory? selectedCategory;

  // Afficher uniquement les favoris
  bool showFavoritesOnly = false;

  // Région sélectionnée
  String? selectedRegion;

  // Liste filtrée des lieux
  List<Place> get filteredPlaces {
    return places.where((place) {

      final matchesSearch = place.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesCategory = selectedCategory == null ||
          place.category == selectedCategory;

      final matchesFavorite =
          !showFavoritesOnly || place.isFavorite;

      final matchesRegion = selectedRegion == null ||
          place.region == selectedRegion;

      return matchesSearch &&
          matchesCategory &&
          matchesFavorite &&
          matchesRegion;

    }).toList();
  }

  // Liste des régions disponibles
  List<String> get availableRegions {
    return places
        .map((place) => place.region)
        .toSet()
        .toList()
      ..sort();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[100],

      // Barre supérieure
      appBar: AppBar(
        title: const Text(
          'Découvre la Tunisie',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
        centerTitle: true,
        actions: [

          // Bouton Favoris
          IconButton(
            icon: Icon(
              showFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),

            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un lieu...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Filtres par catégorie
          SizedBox(
            height: 45,

            child: ListView(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              children: [

                categoryChip('Tous', null),

                categoryChip(
                  'Histoire',
                  PlaceCategory.history,
                ),

                categoryChip(
                  'Plage',
                  PlaceCategory.beach,
                ),

                categoryChip(
                  'Désert',
                  PlaceCategory.desert,
                ),

                categoryChip(
                  'Nature',
                  PlaceCategory.nature,
                ),

                categoryChip(
                  'Médina',
                  PlaceCategory.medina,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filtres par région
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                regionChip('Toutes les régions', null),
                ...availableRegions.map(
                  (region) => regionChip(region, region),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Liste des lieux touristiques
          Expanded(
            child: filteredPlaces.isEmpty

                ? const Center(
                    child: Text(
                      'Aucun lieu trouvé',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )

                : ListView.builder(
                    padding: const EdgeInsets.all(12),

                    itemCount: filteredPlaces.length,

                    itemBuilder: (context, index) {

                      final place = filteredPlaces[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),

                        elevation: 3,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: GestureDetector(

                          // Double appui pour ajouter aux favoris
                          onDoubleTap: () {
                            setState(() {
                              place.isFavorite =
                                  !place.isFavorite;
                            });

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  place.isFavorite
                                      ? 'Ajouté aux favoris'
                                      : 'Retiré des favoris',
                                ),
                                duration:
                                    const Duration(seconds: 1),
                              ),
                            );
                          },

                          child: InkWell(

                            // Appui simple pour ouvrir les détails
                            borderRadius:
                                BorderRadius.circular(15),

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
                                ClipRRect(
                                  borderRadius:
                                      const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),

                                  child: Stack(
                                    children: [

                                      Image.asset(
                                        place.imagePath,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.contain,

                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 180,
                                            width: double.infinity,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                            ),
                                          );
                                        },
                                      ),

                                      // Icône Favoris
                                      Positioned(
                                        top: 10,
                                        right: 10,

                                        child: Icon(
                                          place.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: place.isFavorite
                                              ? Colors.red
                                              : Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Informations du lieu
                                Padding(
                                  padding:
                                      const EdgeInsets.all(12),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [

                                            Text(
                                              place.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 5),

                                            Text(
                                              '${place.region} • ${categoryName(place.category)}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
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
          ),
        ],
      ),
    );
  }

  // Widget pour les filtres
  Widget categoryChip(
    String label,
    PlaceCategory? category,
  ) {

    final isSelected = selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),

      child: ChoiceChip(
        label: Text(label),

        selected: isSelected,

        selectedColor: Colors.red[700],

        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),

        onSelected: (selected) {
          setState(() {
            selectedCategory = category;
          });
        },
      ),
    );
  }

  // Widget pour les filtres de région
  Widget regionChip(
    String label,
    String? region,
  ) {

    final isSelected = selectedRegion == region;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),

      child: ChoiceChip(
        label: Text(label),

        selected: isSelected,

        selectedColor: Colors.blue[700],

        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),

        onSelected: (selected) {
          setState(() {
            selectedRegion = region;
          });
        },
      ),
    );
  }
}
