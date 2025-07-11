class Photo {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String photographer;
  final DateTime date;
  final int likes;
  final int views;

  Photo({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.photographer,
    required this.date,
    required this.likes,
    required this.views,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      photographer: json['photographer'] as String,
      date: DateTime.parse(json['date'] as String),
      likes: json['likes'] as int,
      views: json['views'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'photographer': photographer,
      'date': date.toIso8601String(),
      'likes': likes,
      'views': views,
    };
  }
} 