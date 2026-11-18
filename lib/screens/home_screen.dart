
import 'package:flutter/material.dart';
import '../data/places_data.dart';
import '../models/place.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  PlaceCategory? selectedCategory;
  String? selectedRegion;
  bool showFavoritesOnly = false;

  final Color primaryColor = const Color(0xFFE85D4A);
  final Color backgroundColor = const Color(0xFFF8F7F4);

  List<String> get availableRegions {
    return places.map((place) => place.region).toSet().toList()..sort();
  }

  List<Place> get filteredPlaces {
    return places.where((place) {
      final matchesSearch =
          place.name.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == null || place.category == selectedCategory;

      final matchesRegion =
          selectedRegion == null || place.region == selectedRegion;

      final matchesFavorites =
          !showFavoritesOnly || place.isFavorite;

      return matchesSearch &&
          matchesCategory &&
          matchesRegion &&
          matchesFavorites;
    }).toList();
  }

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

  IconData categoryIcon(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.history:
        return Icons.account_balance;
      case PlaceCategory.beach:
        return Icons.beach_access;
      case PlaceCategory.desert:
        return Icons.landscape;
      case PlaceCategory.nature:
        return Icons.park;
      case PlaceCategory.medina:
        return Icons.location_city;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.explore,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Découvre Tunisie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showFavoritesOnly = !showFavoritesOnly;
                          });
                        },
                        icon: Icon(
                          showFavoritesOnly
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Explore la beauté de la Tunisie 🇹🇳',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Découvre des endroits magnifiques et crée tes souvenirs.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SEARCH BAR
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Rechercher une destination...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                children: [
                  // CATEGORIES
                  const Text(
                    'Explorer par catégorie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        categoryChip(null, 'Tout', Icons.apps),
                        ...PlaceCategory.values.map(
                          (category) => categoryChip(
                            category,
                            categoryName(category),
                            categoryIcon(category),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // REGIONS
                  const Text(
                    'Choisir une région',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        regionChip(null, 'Toutes'),
                        ...availableRegions.map(
                          (region) => regionChip(region, region),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // DESTINATIONS TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Destinations à découvrir',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${filteredPlaces.length} lieux',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // PLACES LIST
                  if (filteredPlaces.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 55,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Aucune destination trouvée',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...filteredPlaces.map(
                      (place) => placeCard(place),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORY CHIP
  Widget categoryChip(
    PlaceCategory? category,
    String title,
    IconData icon,
  ) {
    final isSelected = selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedCategory = category;
          });
        },
        avatar: Icon(
          icon,
          size: 17,
          color: isSelected ? Colors.white : primaryColor,
        ),
        label: Text(title),
        selectedColor: primaryColor,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? primaryColor : Colors.grey.shade200,
          ),
        ),
      ),
    );
  }

  // REGION CHIP
  Widget regionChip(String? region, String title) {
    final isSelected = selectedRegion == region;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedRegion = region;
          });
        },
        label: Text(title),
        selectedColor: const Color(0xFFFFE2DC),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? primaryColor : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? primaryColor : Colors.grey.shade200,
          ),
        ),
      ),
    );
  }

  // PLACE CARD
  Widget placeCard(Place place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(place: place),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    place.imagePath,
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 190,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 45,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),

                  // FAVORITE BUTTON
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            place.isFavorite = !place.isFavorite;
                          });
                        },
                        icon: Icon(
                          place.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),

                  // CATEGORY LABEL
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categoryName(place.category),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 17,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.region,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Voir détails',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 13,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
