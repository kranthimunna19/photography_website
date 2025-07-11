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
      // Return cached data if available, otherwise return empty list
      return _cachedArticles.isNotEmpty ? _cachedArticles : [];
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
    
    return [];
  }

  /// Get trending topics in photography
  static Future<List<String>> getTrendingTopics() async {
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