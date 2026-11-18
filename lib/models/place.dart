enum PlaceCategory {
  history,
  beach,
  desert,
  nature,
  medina,
}

class Place {
  final String id;
  final String name;
  final String region;
  final PlaceCategory category;
  final String description;
  final String imagePath;
  final String bestSeason;
  final String suggestedDuration;

  bool isFavorite;

  Place({
    required this.id,
    required this.name,
    required this.region,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.bestSeason,
    required this.suggestedDuration,
    this.isFavorite = false,
  });
}