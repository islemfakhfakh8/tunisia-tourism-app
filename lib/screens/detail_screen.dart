
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../models/place.dart';
import '../models/review.dart';
import '../widgets/review_form.dart';

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

  // Liste des avis de la destination
  final List<Review> reviews = [];

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

  // Ajouter un nouvel avis
  void addReview(Review review) {
    setState(() {
      reviews.insert(0, review);
    });
  }

  // Calculer la note moyenne
  double get averageRating {
    if (reviews.isEmpty) return 0;

    int total = 0;

    for (var review in reviews) {
      total += review.rating;
    }

    return total / reviews.length;
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

            // GRANDE IMAGE DU LIEU
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

                // NOM SUPERPOSÉ SUR L'IMAGE
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

            // INFORMATIONS PRINCIPALES
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // RÉGION ET CATÉGORIE
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        place.region,
                        style: const TextStyle(fontSize: 16),
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

                  // DESCRIPTION
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

                  // INFORMATIONS PRATIQUES
                  const Text(
                    'Informations pratiques',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  infoCard(
                    Icons.wb_sunny,
                    'Meilleure saison',
                    place.bestSeason,
                  ),

                  const SizedBox(height: 12),

                  infoCard(
                    Icons.access_time,
                    'Durée conseillée',
                    place.suggestedDuration,
                  ),

                  const SizedBox(height: 30),

                  // BOUTON GOOGLE MAPS
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: openGoogleMaps,
                      icon: const Icon(Icons.map),
                      label: const Text('Voir sur Google Maps'),
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

                  // BOUTON PARTAGER
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: sharePlace,
                      icon: const Icon(Icons.share),
                      label: const Text('Partager ce lieu'),
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

                  const SizedBox(height: 30),

                  // --------------------------------
                  // SECTION AVIS DES VISITEURS
                  // --------------------------------

                  const Text(
                    'Avis des visiteurs',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // NOTE MOYENNE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 35,
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reviews.isEmpty
                                  ? 'Pas encore de note'
                                  : '${averageRating.toStringAsFixed(1)} / 5',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              '${reviews.length} avis',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FORMULAIRE POUR AJOUTER UN AVIS
                  ReviewForm(
                    onSubmit: addReview,
                  ),

                  const SizedBox(height: 25),

                  // LISTE DES AVIS
                  const Text(
                    'Commentaires des visiteurs',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (reviews.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 40,
                            color: Colors.grey[400],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Aucun avis pour le moment.',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Soyez le premier à donner votre avis !',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ...reviews.map((review) {
                      return reviewCard(review);
                    }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET POUR AFFICHER UN AVIS
  Widget reviewCard(Review review) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[50],
                child: Icon(
                  Icons.person,
                  color: Colors.red[700],
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  review.author,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Text(
                '${review.date.day}/${review.date.month}/${review.date.year}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.orange,
                size: 20,
              );
            }),
          ),

          const SizedBox(height: 10),

          Text(
            review.comment,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET RÉUTILISABLE POUR LES INFORMATIONS
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
