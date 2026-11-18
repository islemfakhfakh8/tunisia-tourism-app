
import 'package:flutter/material.dart';

import '../models/place.dart';
import '../data/places_data.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  final _formKey = GlobalKey<FormState>();

  // Contrôleurs des champs
  final nameController = TextEditingController();
  final regionController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final seasonController = TextEditingController();
  final durationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Catégorie sélectionnée
  PlaceCategory selectedCategory = PlaceCategory.history;

  // Liste des catégories
  final List<PlaceCategory> categories = [
    PlaceCategory.history,
    PlaceCategory.beach,
    PlaceCategory.desert,
    PlaceCategory.nature,
    PlaceCategory.medina,
  ];

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

  // Ajouter un nouveau lieu
  void addPlace() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final latitude = double.tryParse(
      latitudeController.text.trim(),
    );

    final longitude = double.tryParse(
      longitudeController.text.trim(),
    );

    if (latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir des coordonnées GPS valides.'),
        ),
      );

      return;
    }

    // Création de l'objet Place
    final newPlace = Place(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      region: regionController.text.trim(),
      category: selectedCategory,
      description: descriptionController.text.trim(),
      imagePath: imageController.text.trim(),
      bestSeason: seasonController.text.trim(),
      suggestedDuration: durationController.text.trim(),
    );

    // Ajout dans la liste principale
    places.add(newPlace);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lieu ajouté avec succès !'),
        backgroundColor: Colors.green,
      ),
    );

    // Retour à l'écran précédent
    Navigator.pop(context, newPlace);
  }

  // Champ de formulaire réutilisable
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,

        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    regionController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    seasonController.dispose();
    durationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Ajouter un lieu',
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

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(18),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // Titre
              const Text(
                'Nouveau lieu touristique',

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Remplissez les informations pour ajouter une destination.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              // Nom
              buildTextField(
                label: 'Nom du lieu',
                controller: nameController,
                icon: Icons.place,
              ),

              // Région
              buildTextField(
                label: 'Région',
                controller: regionController,
                icon: Icons.location_city,
              ),

              // Catégorie
              Padding(
                padding: const EdgeInsets.only(bottom: 16),

                child: DropdownButtonFormField<PlaceCategory>(
                  value: selectedCategory,

                  decoration: InputDecoration(
                    labelText: 'Catégorie',
                    prefixIcon: const Icon(Icons.category),
                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(categoryName(category)),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
              ),

              // Description
              buildTextField(
                label: 'Description',
                controller: descriptionController,
                icon: Icons.description,
                maxLines: 4,
              ),

              // Image
              buildTextField(
                label: 'Chemin de l’image',
                controller: imageController,
                icon: Icons.image,
              ),

              // Meilleure saison
              buildTextField(
                label: 'Meilleure saison',
                controller: seasonController,
                icon: Icons.wb_sunny,
              ),

              // Durée conseillée
              buildTextField(
                label: 'Durée conseillée',
                controller: durationController,
                icon: Icons.access_time,
              ),

              const SizedBox(height: 10),

              const Text(
                'Coordonnées géographiques',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Latitude
              buildTextField(
                label: 'Latitude',
                controller: latitudeController,
                icon: Icons.gps_fixed,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),

              // Longitude
              buildTextField(
                label: 'Longitude',
                controller: longitudeController,
                icon: Icons.gps_fixed,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),

              const SizedBox(height: 15),

              // Bouton Ajouter
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: addPlace,

                  icon: const Icon(Icons.add),

                  label: const Text(
                    'Ajouter le lieu',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,

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
      ),
    );
  }
}