import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chip.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String? selectedCategory;
  String? selectedTrendingTopic;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().loadArticles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Photography News'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          // AI Mode Toggle
          Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              return Switch(
                value: newsProvider.isAIMode,
                onChanged: (value) {
                  newsProvider.toggleAIMode();
                },
                activeColor: colorScheme.primary,
              );
            },
          ),
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<NewsProvider>().refreshNews();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // AI Status Banner
          Consumer<NewsProvider>(
            builder: (context, newsProvider, child) {
              if (newsProvider.isAIMode) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: colorScheme.primaryContainer,
                  child: Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI-Powered News • Real-time updates',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surface,
            child: Column(
              children: [
                // Search Bar with AI Search
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search with AI...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _isSearching 
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : const Icon(Icons.psychology),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isSearching = value.isNotEmpty;
                          });
                          if (value.isNotEmpty) {
                            _performSearch(value);
                          } else {
                            context.read<NewsProvider>().loadArticles();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Trending Topics
                Consumer<NewsProvider>(
                  builder: (context, newsProvider, child) {
                    if (newsProvider.trendingTopics.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🔥 Trending Topics',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...newsProvider.trendingTopics.map((topic) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(topic),
                                    selected: selectedTrendingTopic == topic,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedTrendingTopic = selected ? topic : null;
                                      });
                                      if (selected) {
                                        _searchController.text = topic;
                                        _performSearch(topic);
                                      }
                                    },
                                    backgroundColor: colorScheme.surfaceVariant,
                                    selectedColor: colorScheme.primaryContainer,
                                    checkmarkColor: colorScheme.onPrimaryContainer,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                
                // Category Filters
                Consumer<NewsProvider>(
                  builder: (context, newsProvider, child) {
                    final categories = newsProvider.getCategories();
                    
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(
                            category: 'All',
                            isSelected: selectedCategory == null,
                            onTap: () {
                              setState(() {
                                selectedCategory = null;
                                selectedTrendingTopic = null;
                              });
                              context.read<NewsProvider>().loadArticles();
                            },
                          ),
                          const SizedBox(width: 8),
                          ...categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CategoryChip(
                                category: category,
                                isSelected: selectedCategory == category,
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category;
                                    selectedTrendingTopic = null;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Articles List
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                if (newsProvider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading AI-powered news...'),
                      ],
                    ),
                  );
                }
                
                if (newsProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          newsProvider.error!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            newsProvider.loadArticles();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                List<dynamic> filteredArticles = newsProvider.articles;
                
                // Apply category filter
                if (selectedCategory != null) {
                  filteredArticles = newsProvider.getArticlesByCategory(selectedCategory!);
                }
                
                // Apply trending topic filter
                if (selectedTrendingTopic != null) {
                  filteredArticles = newsProvider.getArticlesByTag(selectedTrendingTopic!);
                }
                
                if (filteredArticles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No articles found',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          newsProvider.isAIMode 
                            ? 'Try searching for a different topic or check back later for updates'
                            : 'Try adjusting your search or filter criteria',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (newsProvider.isAIMode) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              newsProvider.refreshNews();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh News'),
                          ),
                        ],
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    await newsProvider.refreshNews();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NewsCard(article: filteredArticles[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      _isSearching = true;
    });
    
    try {
      await context.read<NewsProvider>().searchArticles(query);
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }
} 