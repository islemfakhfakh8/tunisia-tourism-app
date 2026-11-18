import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../models/place.dart';

class DetailScreen extends StatefulWidget {
  final Place place;

  const DetailScreen({
    super.key,
    required this.place,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  // Traduction des catégories
  String getCategoryName(PlaceCategory category) {
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

  // Ajouter ou retirer des favoris
  void toggleFavorite() {
    setState(() {
      widget.place.isFavorite = !widget.place.isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.place.isFavorite
              ? 'Lieu ajouté aux favoris ❤️'
              : 'Lieu retiré des favoris',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Ouvrir Google Maps
  Future<void> openGoogleMaps() async {
    final place = widget.place;
    final uri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': '${place.name}, ${place.region}, Tunisie',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’ouvrir Google Maps'),
        ),
      );
    }
  }

  // Partager le lieu
  Future<void> sharePlace() async {
    final place = widget.place;

    final message =
        'Découvrez ${place.name} en Tunisie !\n'
        'Région : ${place.region}\n'
        'Catégorie : ${getCategoryName(place.category)}\n'
        '${place.description}';

    await SharePlus.instance.share(
      ShareParams(text: message),
    );
  }

  @override
  Widget build(BuildContext context) {

    final place = widget.place;

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Détails du lieu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.red[700],

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        actions: [

          // Bouton Favoris
          IconButton(
            onPressed: toggleFavorite,

            icon: Icon(
              place.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Grande image du lieu
            Stack(
              children: [

                Image.asset(
                  place.imagePath,
                  width: double.infinity,
                  height: 270,
                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 270,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                      ),
                    );
                  },
                ),

                // Nom superposé sur l'image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,

                  child: Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),

                    child: Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Informations principales
            Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // Région et catégorie
                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        place.region,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const Spacer(),

                      Chip(
                        label: Text(
                          getCategoryName(place.category),
                        ),

                        backgroundColor: Colors.red[50],

                        labelStyle: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'À propos de ce lieu',

                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    place.description,

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Informations pratiques
                  const Text(
                    'Informations pratiques',

                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Meilleure saison
                  infoCard(
                    Icons.wb_sunny,
                    'Meilleure saison',
                    place.bestSeason,
                  ),

                  const SizedBox(height: 12),

                  // Durée conseillée
                  infoCard(
                    Icons.access_time,
                    'Durée conseillée',
                    place.suggestedDuration,
                  ),

                  const SizedBox(height: 30),

                  // Bouton Google Maps
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: openGoogleMaps,

                      icon: const Icon(Icons.map),

                      label: const Text(
                        'Voir sur Google Maps',
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bouton Partager
                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton.icon(
                      onPressed: sharePlace,

                      icon: const Icon(Icons.share),

                      label: const Text(
                        'Partager ce lieu',
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        padding: const EdgeInsets.all(15),
                        side: BorderSide(
                          color: Colors.red.shade700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget réutilisable pour les informations
  Widget infoCard(
    IconData icon,
    String title,
    String value,
  ) {

    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.red[700],
            size: 28,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
