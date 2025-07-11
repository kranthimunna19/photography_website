class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime date;
  final String category;
  final int readTime;
  final List<String> tags;
  final String url;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.category,
    required this.readTime,
    required this.tags,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      author: json['author'] as String,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      readTime: json['readTime'] as int,
      tags: List<String>.from(json['tags'] as List),
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'imageUrl': imageUrl,
      'author': author,
      'date': date.toIso8601String(),
      'category': category,
      'readTime': readTime,
      'tags': tags,
      'url': url,
    };
  }
} 