import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/ai_news_service.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String? _error;
  List<String> _trendingTopics = [];
  bool _isAIMode = true; // Enable AI mode by default

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get trendingTopics => _trendingTopics;
  bool get isAIMode => _isAIMode;

  Future<void> loadArticles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_isAIMode) {
        // Use AI-powered news service
        _articles = await AINewsService.fetchLatestNews();
        _trendingTopics = await AINewsService.getTrendingTopics();
      } else {
        // Fallback to mock data
        await _loadMockArticles();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load articles: $e';
      _isLoading = false;
      notifyListeners();
      
      // Fallback to mock data if AI service fails
      await _loadMockArticles();
    }
  }

  Future<void> _loadMockArticles() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data for fallback
    _articles = [
      NewsArticle(
        id: '1',
        title: 'Canon Announces Revolutionary EOS R5 Mark II',
        summary: 'The new flagship mirrorless camera features 8K video recording and 45MP sensor',
        content: 'Canon has officially announced the EOS R5 Mark II, their latest flagship mirrorless camera that pushes the boundaries of what\'s possible in both photography and videography. The new camera features a 45-megapixel full-frame CMOS sensor, 8K video recording capabilities, and advanced autofocus system that can track subjects with incredible precision.',
        imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
        author: 'Tech Photography',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Camera News',
        readTime: 5,
        tags: ['Canon', 'Mirrorless', '8K', 'Photography'],
        url: 'https://www.canon.com/news/eos-r5-mark-ii',
      ),
      NewsArticle(
        id: '2',
        title: 'AI-Powered Photo Editing: The Future of Post-Processing',
        summary: 'How artificial intelligence is revolutionizing the way we edit and enhance photographs',
        content: 'Artificial intelligence is transforming the landscape of photo editing, making complex adjustments accessible to photographers of all skill levels. From automatic sky replacement to intelligent portrait retouching, AI tools are becoming an integral part of the modern photographer\'s workflow.',
        imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
        author: 'Digital Arts Magazine',
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Technology',
        readTime: 8,
        tags: ['AI', 'Editing', 'Technology', 'Software'],
        url: 'https://www.digitalartsmag.com/ai-photo-editing',
      ),
      NewsArticle(
        id: '3',
        title: 'The Rise of Mobile Photography: Smartphones vs DSLRs',
        summary: 'Exploring how smartphone cameras are challenging traditional photography equipment',
        content: 'With each new generation of smartphones, the gap between mobile photography and traditional DSLR cameras continues to narrow. Advanced computational photography, multiple lenses, and AI-powered features are making it possible to capture professional-quality images with just a phone.',
        imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
        author: 'Mobile Photography Weekly',
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Mobile Photography',
        readTime: 6,
        tags: ['Mobile', 'Smartphone', 'DSLR', 'Comparison'],
        url: 'https://www.mobilephotoweekly.com/smartphones-vs-dslrs',
      ),
      NewsArticle(
        id: '4',
        title: 'Sustainable Photography: Eco-Friendly Practices for Photographers',
        summary: 'How photographers can reduce their environmental impact while pursuing their passion',
        content: 'As environmental awareness grows, photographers are increasingly looking for ways to practice their craft sustainably. From using solar-powered equipment to choosing eco-friendly printing materials, there are numerous ways photographers can minimize their carbon footprint.',
        imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
        author: 'Green Photography',
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: 'Sustainability',
        readTime: 7,
        tags: ['Sustainability', 'Environment', 'Green', 'Practice'],
        url: 'https://www.greenphotography.com/eco-friendly-practices',
      ),
      NewsArticle(
        id: '5',
        title: 'Mastering Natural Light: A Complete Guide for Portrait Photographers',
        summary: 'Essential techniques for harnessing natural light to create stunning portraits',
        content: 'Natural light is one of the most beautiful and challenging aspects of portrait photography. Understanding how to work with different types of natural light, from golden hour to overcast conditions, can dramatically improve your portrait work.',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
        author: 'Portrait Masters',
        date: DateTime.now().subtract(const Duration(days: 4)),
        category: 'Tutorial',
        readTime: 10,
        tags: ['Portrait', 'Natural Light', 'Tutorial', 'Technique'],
        url: 'https://www.portraitmasters.com/natural-light-guide',
      ),
    ];
    
    _trendingTopics = [
      'AI Photography',
      'Mirrorless Cameras',
      'Mobile Photography',
      'Drone Photography',
      'Street Photography',
    ];
  }

  Future<void> searchArticles(String query) async {
    if (query.isEmpty) {
      await loadArticles();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_isAIMode) {
        // Use AI-powered search
        _articles = await AINewsService.searchNews(query);
      } else {
        // Local search
        _articles = _articles.where((article) =>
          article.title.toLowerCase().contains(query.toLowerCase()) ||
          article.summary.toLowerCase().contains(query.toLowerCase()) ||
          article.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))
        ).toList();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Search failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAIMode() async {
    _isAIMode = !_isAIMode;
    await loadArticles();
  }

  Future<void> refreshNews() async {
    await loadArticles();
  }

  List<NewsArticle> getArticlesByCategory(String category) {
    return _articles.where((article) => article.category == category).toList();
  }

  List<String> getCategories() {
    return _articles.map((article) => article.category).toSet().toList();
  }

  List<NewsArticle> getArticlesByTag(String tag) {
    return _articles.where((article) => 
      article.tags.any((articleTag) => articleTag.toLowerCase().contains(tag.toLowerCase()))
    ).toList();
  }

  List<NewsArticle> getLatestArticles({int limit = 5}) {
    final sortedArticles = List<NewsArticle>.from(_articles);
    sortedArticles.sort((a, b) => b.date.compareTo(a.date));
    return sortedArticles.take(limit).toList();
  }

  List<NewsArticle> getTrendingArticles() {
    // Simple trending algorithm based on recency and tags
    final sortedArticles = List<NewsArticle>.from(_articles);
    sortedArticles.sort((a, b) {
      final aScore = _calculateTrendingScore(a);
      final bScore = _calculateTrendingScore(b);
      return bScore.compareTo(aScore);
    });
    return sortedArticles.take(5).toList();
  }

  double _calculateTrendingScore(NewsArticle article) {
    final hoursSincePublished = DateTime.now().difference(article.date).inHours;
    final recencyScore = 1.0 / (hoursSincePublished + 1); // More recent = higher score
    final tagScore = article.tags.length * 0.1; // More tags = higher score
    return recencyScore + tagScore;
  }
} 