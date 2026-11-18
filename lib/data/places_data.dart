
import '../models/place.dart';

List<Place> places = [
  Place(
    id: '1',
    name: 'Djerba',
    region: 'Médenine',
    category: PlaceCategory.beach,
    description: 'Djerba est une magnifique île tunisienne connue pour ses plages de sable fin, ses paysages et son patrimoine culturel.',
    imagePath: 'assets/images/djerba.jpg',
    bestSeason: 'Printemps et été',
    suggestedDuration: '2 à 3 jours',
  ),

  Place(
    id: '2',
    name: 'Tozeur',
    region: 'Tozeur',
    category: PlaceCategory.nature,
    description: 'Tozeur est une ville du sud tunisien célèbre pour ses oasis, ses palmeraies et son architecture traditionnelle.',
    imagePath: 'assets/images/tozeur.jpg',
    bestSeason: 'Automne et printemps',
    suggestedDuration: '2 jours',
  ),

  Place(
    id: '3',
    name: 'Sidi Bou Saïd',
    region: 'Tunis',
    category: PlaceCategory.medina,
    description: 'Sidi Bou Saïd est un village touristique célèbre pour ses maisons blanches, ses portes bleues et sa magnifique vue sur la mer.',
    imagePath: 'assets/images/sidi_bou_said.jpg',
    bestSeason: 'Printemps et automne',
    suggestedDuration: 'Une demi-journée',
  ),

  Place(
    id: '4',
    name: 'Carthage',
    region: 'Tunis',
    category: PlaceCategory.history,
    description: 'Carthage est un site archéologique historique qui témoigne de la richesse de la civilisation carthaginoise.',
    imagePath: 'assets/images/carthage.jpg',
    bestSeason: 'Printemps et automne',
    suggestedDuration: 'Une demi-journée',
  ),

  Place(
    id: '5',
    name: 'Bizerte',
    region: 'Bizerte',
    category: PlaceCategory.nature,
    description: 'Bizerte est une ville côtière connue pour son vieux port, ses plages et ses magnifiques paysages naturels.',
    imagePath: 'assets/images/bizerte.jpg',
    bestSeason: 'Printemps et été',
    suggestedDuration: '1 à 2 jours',
  ),
  Place(
   id: '6',
  name: 'Douz',
  region: 'Kébili',
  category: PlaceCategory.desert,
  description:
      'Douz est une magnifique destination située au sud de la Tunisie. '
      'Elle est connue comme la porte du Sahara. Les visiteurs peuvent '
      'profiter des balades à dos de chameau et découvrir les dunes de sable.',
  imagePath: 'assets/images/douz.jpg',
  bestSeason: 'Automne et printemps',
  suggestedDuration: '2 jours',
),
Place(
   id: '7',
  name: 'matmata',
  region: 'gabés',
  category: PlaceCategory.desert,
  description:
      'Matmata est un village berbère du sud de la Tunisie '
      'se situe dans le sud de la Tunisie, au sein du gouvernorat de Gabès, à environ 40 km au sud-ouest de la ville de Gabès ',
  imagePath: 'assets/images/matmata.jpg',
  bestSeason: 'Automne et printemps',
  suggestedDuration: '2 jours',
),
];
