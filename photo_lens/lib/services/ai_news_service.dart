import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';
import '../config/api_config.dart';

class AINewsService {

  // Cache for storing fetched news
  static List<NewsArticle> _cachedArticles = [];
  static DateTime _lastFetchTime = DateTime.now().subtract(const Duration(hours: 1));

  /// Fetch latest photography news using AI-powered aggregation
  static Future<List<NewsArticle>> fetchLatestNews() async {
    // Check if we have recent cached data
    if (_cachedArticles.isNotEmpty && 
        DateTime.now().difference(_lastFetchTime).inMinutes < APIConfig.newsCacheDurationMinutes) {
      return _cachedArticles;
    }

    try {
      // Check if we're in demo mode or API keys are not configured
      if (APIConfig.isDemoMode || !APIConfig.isConfigured) {
        return _getDemoArticles();
      }

      // Fetch news from multiple sources
      final List<NewsArticle> allArticles = [];
      
      // 1. Fetch from News API (photography, camera, tech news)
      final newsApiArticles = await _fetchFromNewsAPI();
      allArticles.addAll(newsApiArticles);
      
      // 2. Generate AI-curated content using OpenAI
      final aiGeneratedArticles = await _generateAIContent();
      allArticles.addAll(aiGeneratedArticles);
      
      // 3. Fetch photography industry news
      final industryArticles = await _fetchIndustryNews();
      allArticles.addAll(industryArticles);
      
      // Sort by date (newest first)
      allArticles.sort((a, b) => b.date.compareTo(a.date));
      
      // Update cache
      _cachedArticles = allArticles;
      _lastFetchTime = DateTime.now();
      
      return allArticles;
    } catch (e) {
      print('Error fetching news: $e');
      // Return demo data if API fails
      return _getDemoArticles();
    }
  }

  /// Fetch news from News API
  static Future<List<NewsArticle>> _fetchFromNewsAPI() async {
    try {
      final response = await http.get(
        Uri.parse('${APIConfig.newsApiUrl}?q=photography OR camera OR "mirrorless camera" OR "DSLR"&language=en&sortBy=publishedAt&pageSize=${APIConfig.maxArticlesPerRequest}&apiKey=${APIConfig.newsApiKey}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        
        return articles.map((article) {
          return NewsArticle(
            id: article['url'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            title: article['title'] ?? 'No Title',
            summary: article['description'] ?? 'No description available',
            content: article['content'] ?? article['description'] ?? 'No content available',
            imageUrl: article['urlToImage'] ?? _getDefaultImageUrl(),
            author: article['author'] ?? 'Unknown Author',
            date: DateTime.parse(article['publishedAt'] ?? DateTime.now().toIso8601String()),
            category: _categorizeArticle(article['title'] ?? ''),
            readTime: _calculateReadTime(article['content'] ?? ''),
            tags: _extractTags(article['title'] ?? '', article['description'] ?? ''),
            url: article['url'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching from News API: $e');
    }
    
    return [];
  }

  /// Generate AI-curated content using OpenAI
  static Future<List<NewsArticle>> _generateAIContent() async {
    try {
      final prompt = '''
Generate 3 recent photography news articles in JSON format. Focus on:
1. Latest camera releases and technology
2. Photography techniques and tips
3. Industry trends and developments

Format each article as:
{
  "title": "Article Title",
  "summary": "Brief summary",
  "content": "Full article content",
  "category": "Category",
  "tags": ["tag1", "tag2"]
}

Make the content current and relevant to photographers.
''';

      final response = await http.post(
        Uri.parse(APIConfig.openaiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${APIConfig.openaiApiKey}',
        },
        body: json.encode({
          'model': APIConfig.openaiModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a photography news expert. Generate current, accurate, and engaging photography news articles.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'max_tokens': APIConfig.maxTokens,
          'temperature': APIConfig.temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Parse the AI-generated content
        return _parseAIGeneratedContent(content);
      }
    } catch (e) {
      print('Error generating AI content: $e');
    }
    
    return [];
  }

  /// Fetch industry-specific photography news
  static Future<List<NewsArticle>> _fetchIndustryNews() async {
    // Simulate industry news - in production, you'd connect to photography-specific APIs
    return [
      NewsArticle(
        id: 'industry_1',
        title: 'Sony Alpha 9 III: Revolutionary Global Shutter Technology',
        summary: 'Sony\'s latest flagship camera introduces groundbreaking global shutter technology',
        content: 'Sony has announced the Alpha 9 III, featuring the world\'s first full-frame global shutter sensor. This revolutionary technology eliminates rolling shutter distortion and enables flash sync at any shutter speed, opening new possibilities for sports and action photography.',
        imageUrl: _getDefaultImageUrl(),
        author: 'Photography Industry News',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        category: 'Camera Technology',
        readTime: 4,
        tags: ['Sony', 'Global Shutter', 'Technology', 'Sports Photography'],
        url: '',
      ),
      NewsArticle(
        id: 'industry_2',
        title: 'Adobe Lightroom AI: Smart Masking Revolution',
        summary: 'Adobe introduces AI-powered smart masking for faster photo editing',
        content: 'Adobe has released a major update to Lightroom with AI-powered smart masking capabilities. The new feature can automatically detect and mask subjects, skies, and objects, dramatically reducing editing time for photographers.',
        imageUrl: _getDefaultImageUrl(),
        author: 'Digital Photography Review',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        category: 'Software',
        readTime: 6,
        tags: ['Adobe', 'Lightroom', 'AI', 'Editing'],
        url: '',
      ),
    ];
  }

  /// Parse AI-generated content
  static List<NewsArticle> _parseAIGeneratedContent(String content) {
    try {
      // Extract JSON from AI response
      final jsonStart = content.indexOf('[');
      final jsonEnd = content.lastIndexOf(']') + 1;
      
      if (jsonStart != -1 && jsonEnd != -1) {
        final jsonContent = content.substring(jsonStart, jsonEnd);
        final articles = json.decode(jsonContent) as List;
        
        return articles.map((article) {
          return NewsArticle(
            id: 'ai_${DateTime.now().millisecondsSinceEpoch}_${articles.indexOf(article)}',
            title: article['title'] ?? 'AI Generated Article',
            summary: article['summary'] ?? 'AI-generated summary',
            content: article['content'] ?? 'AI-generated content',
            imageUrl: _getDefaultImageUrl(),
            author: 'AI Photography News',
            date: DateTime.now().subtract(Duration(hours: articles.indexOf(article))),
            category: article['category'] ?? 'Technology',
            readTime: _calculateReadTime(article['content'] ?? ''),
            tags: List<String>.from(article['tags'] ?? []),
            url: article['url'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      print('Error parsing AI content: $e');
    }
    
    return [];
  }

  /// Categorize article based on title and content
  static String _categorizeArticle(String title) {
    final lowerTitle = title.toLowerCase();
    
    if (lowerTitle.contains('camera') || lowerTitle.contains('dslr') || lowerTitle.contains('mirrorless')) {
      return 'Camera News';
    } else if (lowerTitle.contains('ai') || lowerTitle.contains('artificial intelligence')) {
      return 'Technology';
    } else if (lowerTitle.contains('tutorial') || lowerTitle.contains('tips') || lowerTitle.contains('guide')) {
      return 'Tutorial';
    } else if (lowerTitle.contains('mobile') || lowerTitle.contains('smartphone')) {
      return 'Mobile Photography';
    } else if (lowerTitle.contains('software') || lowerTitle.contains('lightroom') || lowerTitle.contains('photoshop')) {
      return 'Software';
    } else {
      return 'Photography News';
    }
  }

  /// Extract tags from title and description
  static List<String> _extractTags(String title, String description) {
    final text = '${title.toLowerCase()} ${description.toLowerCase()}';
    final tags = <String>[];
    
    // Photography-related keywords
    final keywords = [
      'camera', 'photography', 'dslr', 'mirrorless', 'lens', 'canon', 'nikon', 'sony',
      'fujifilm', 'leica', 'pentax', 'olympus', 'panasonic', 'sigma', 'tamron',
      'portrait', 'landscape', 'street', 'wildlife', 'macro', 'astrophotography',
      'wedding', 'event', 'commercial', 'fine art', 'documentary', 'travel',
      'black and white', 'color', 'composition', 'lighting', 'exposure',
      'aperture', 'shutter speed', 'iso', 'focus', 'depth of field',
      'raw', 'jpeg', 'editing', 'post-processing', 'lightroom', 'photoshop',
      'capture one', 'affinity photo', 'gimp', 'ai', 'artificial intelligence',
      'machine learning', 'computational photography', 'hdr', 'panorama',
      'time-lapse', 'long exposure', 'bokeh', 'vintage', 'film', 'digital'
    ];
    
    for (final keyword in keywords) {
      if (text.contains(keyword) && !tags.contains(keyword)) {
        tags.add(keyword);
      }
    }
    
    return tags.take(5).toList(); // Limit to 5 tags
  }

  /// Calculate estimated read time
  static int _calculateReadTime(String content) {
    final words = content.split(' ').length;
    return (words / 200).ceil(); // Average reading speed: 200 words per minute
  }

  /// Get default image URL
  static String _getDefaultImageUrl() {
    return APIConfig.getDefaultImageForCategory('Camera News');
  }

  /// Search news articles using AI
  static Future<List<NewsArticle>> searchNews(String query) async {
    // Check if we're in demo mode or API keys are not configured
    if (APIConfig.isDemoMode || !APIConfig.isConfigured) {
      return _searchDemoArticles(query);
    }

    try {
      final prompt = '''
Search for photography news related to: "$query"
Return relevant articles in JSON format with:
- title
- summary  
- content
- category
- tags

Focus on recent and relevant information.
''';

      final response = await http.post(
        Uri.parse(APIConfig.openaiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${APIConfig.openaiApiKey}',
        },
        body: json.encode({
          'model': APIConfig.openaiModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a photography news search expert. Find and summarize relevant photography news.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'max_tokens': 1500,
          'temperature': 0.5,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _parseAIGeneratedContent(content);
      }
    } catch (e) {
      print('Error searching news: $e');
    }
    
    return _searchDemoArticles(query);
  }

  /// Search demo articles
  static List<NewsArticle> _searchDemoArticles(String query) {
    final allArticles = _getDemoArticles();
    final lowerQuery = query.toLowerCase();
    
    return allArticles.where((article) =>
      article.title.toLowerCase().contains(lowerQuery) ||
      article.summary.toLowerCase().contains(lowerQuery) ||
      article.content.toLowerCase().contains(lowerQuery) ||
      article.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  /// Get demo articles for testing
  static List<NewsArticle> _getDemoArticles() {
    return [
      NewsArticle(
        id: 'demo_1',
        title: '🤖 AI-Powered Photography: The Future is Here',
        summary: 'Discover how artificial intelligence is revolutionizing photography with smart editing, composition analysis, and automated workflows.',
        content: 'Artificial intelligence is transforming the photography industry at an unprecedented pace. From AI-powered editing tools that can automatically enhance images to intelligent composition analysis that helps photographers improve their skills, the integration of AI is creating new possibilities for both professionals and enthusiasts alike. Leading software companies are now incorporating machine learning algorithms that can detect subjects, analyze lighting conditions, and suggest optimal camera settings. This technology is not just about automation; it\'s about empowering photographers to focus on creativity while AI handles the technical complexities.',
        imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
        author: 'AI Photography Weekly',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        category: 'AI Photography',
        readTime: 6,
        tags: ['AI', 'Technology', 'Photography', 'Machine Learning', 'Editing'],
        url: '',
      ),
      NewsArticle(
        id: 'demo_2',
        title: '📱 iPhone 15 Pro Max: Computational Photography Breakthrough',
        summary: 'Apple\'s latest flagship introduces revolutionary computational photography features that challenge traditional DSLRs.',
        content: 'The iPhone 15 Pro Max represents a significant leap forward in computational photography, featuring advanced AI algorithms that can capture stunning images in challenging lighting conditions. The new A17 Pro chip enables real-time processing of multiple exposures, creating images with exceptional dynamic range and detail. The device\'s ability to simulate shallow depth of field and professional lighting effects is making it a serious contender for professional photography work. This development signals a broader trend in the industry where computational photography is becoming as important as optical quality.',
        imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
        author: 'Mobile Photography Today',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        category: 'Mobile Photography',
        readTime: 8,
        tags: ['iPhone', 'Mobile', 'Computational Photography', 'Apple', 'Technology'],
        url: '',
      ),
      NewsArticle(
        id: 'demo_3',
        title: '📸 Sony A9 III: Global Shutter Revolution',
        summary: 'Sony\'s latest flagship camera introduces the world\'s first full-frame global shutter, eliminating rolling shutter distortion.',
        content: 'Sony has announced the Alpha 9 III, featuring the world\'s first full-frame global shutter sensor. This revolutionary technology eliminates rolling shutter distortion completely, enabling photographers to capture fast-moving subjects with perfect clarity. The global shutter also allows for flash synchronization at any shutter speed, opening new possibilities for sports and action photography. This development represents a significant milestone in camera technology and could reshape how we think about high-speed photography.',
        imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
        author: 'Camera Technology Review',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        category: 'Camera News',
        readTime: 7,
        tags: ['Sony', 'Global Shutter', 'Technology', 'Sports Photography', 'Mirrorless'],
        url: '',
      ),
      NewsArticle(
        id: 'demo_4',
        title: '🎨 Adobe Lightroom AI: Smart Masking Revolution',
        summary: 'Adobe introduces AI-powered smart masking that automatically detects and masks subjects, skies, and objects.',
        content: 'Adobe has released a major update to Lightroom with AI-powered smart masking capabilities that are revolutionizing the editing workflow. The new feature can automatically detect and mask subjects, skies, and objects with incredible accuracy, dramatically reducing editing time for photographers. This technology uses advanced machine learning algorithms to understand image content and create precise selections. The update also includes AI-powered noise reduction and sharpening tools that adapt to different types of content.',
        imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
        author: 'Digital Photography Review',
        date: DateTime.now().subtract(const Duration(hours: 7)),
        category: 'Software',
        readTime: 5,
        tags: ['Adobe', 'Lightroom', 'AI', 'Editing', 'Software'],
        url: '',
      ),
      NewsArticle(
        id: 'demo_5',
        title: '🌅 Mastering Golden Hour: A Complete Guide',
        summary: 'Learn how to harness the magical light of golden hour to create stunning, warm-toned photographs.',
        content: 'Golden hour, the period shortly after sunrise or before sunset, offers photographers the most beautiful natural lighting conditions. The soft, warm light creates flattering portraits, dramatic landscapes, and stunning architectural photography. Understanding how to work with this light involves more than just timing; it requires knowledge of positioning, exposure settings, and post-processing techniques. This comprehensive guide covers everything from finding the perfect location to editing golden hour images for maximum impact.',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
        author: 'Photography Masters',
        date: DateTime.now().subtract(const Duration(hours: 9)),
        category: 'Tutorial',
        readTime: 12,
        tags: ['Golden Hour', 'Natural Light', 'Tutorial', 'Landscape', 'Portrait'],
        url: '',
      ),
    ];
  }

  /// Get trending topics in photography
  static Future<List<String>> getTrendingTopics() async {
    // Check if we're in demo mode or API keys are not configured
    if (APIConfig.isDemoMode || !APIConfig.isConfigured) {
      return [
        'AI Photography',
        'Mirrorless Cameras',
        'Mobile Photography',
        'Drone Photography',
        'Street Photography',
        'Portrait Photography',
        'Landscape Photography',
        'Wedding Photography',
        'Product Photography',
        'Documentary Photography',
      ];
    }

    try {
      final prompt = '''
What are the top 10 trending topics in photography right now?
Return as a JSON array of strings.
Focus on current trends, new technology, and popular techniques.
''';

      final response = await http.post(
        Uri.parse(APIConfig.openaiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${APIConfig.openaiApiKey}',
        },
        body: json.encode({
          'model': APIConfig.openaiModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a photography trend analyst. Identify current trending topics in photography.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Extract JSON array
        final jsonStart = content.indexOf('[');
        final jsonEnd = content.lastIndexOf(']') + 1;
        
        if (jsonStart != -1 && jsonEnd != -1) {
          final jsonContent = content.substring(jsonStart, jsonEnd);
          return List<String>.from(json.decode(jsonContent));
        }
      }
    } catch (e) {
      print('Error getting trending topics: $e');
    }
    
    return [
      'AI Photography',
      'Mirrorless Cameras',
      'Mobile Photography',
      'Drone Photography',
      'Street Photography',
      'Portrait Photography',
      'Landscape Photography',
      'Wedding Photography',
      'Product Photography',
      'Documentary Photography',
    ];
  }
} 