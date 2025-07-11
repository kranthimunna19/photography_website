import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/gallery_provider.dart';
import '../providers/news_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/photo_card.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GalleryProvider>().loadPhotos();
      context.read<NewsProvider>().loadArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'PhotoLens',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  context.watch<ThemeProvider>().isDarkMode 
                    ? Icons.light_mode 
                    : Icons.dark_mode,
                  color: colorScheme.onSurface,
                ),
                onPressed: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
            ],
          ),
          
          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200',
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                  // Content
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Capture the World',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Discover stunning photography, latest camera reviews, and expert tips from professional photographers.',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => context.go('/gallery'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  'Explore Gallery',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () => context.go('/news'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  'Latest News',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Featured Photos Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Photos',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<GalleryProvider>(
                    builder: (context, galleryProvider, child) {
                      if (galleryProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (galleryProvider.error != null) {
                        return Center(
                          child: Text(
                            galleryProvider.error!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        );
                      }
                      
                      final featuredPhotos = galleryProvider.photos.take(3).toList();
                      
                      return SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredPhotos.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < featuredPhotos.length - 1 ? 16 : 0,
                              ),
                              child: SizedBox(
                                width: 280,
                                child: PhotoCard(photo: featuredPhotos[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Categories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browse by Category',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<GalleryProvider>(
                    builder: (context, galleryProvider, child) {
                      final categories = galleryProvider.getCategories();
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: categories.map((category) {
                          return CategoryChip(
                            category: category,
                            onTap: () => context.go('/gallery?category=$category'),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Latest News Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Latest News',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/news'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<NewsProvider>(
                    builder: (context, newsProvider, child) {
                      if (newsProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (newsProvider.error != null) {
                        return Center(
                          child: Text(
                            newsProvider.error!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        );
                      }
                      
                      final latestNews = newsProvider.articles.take(2).toList();
                      
                      return Column(
                        children: latestNews.map((article) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: NewsCard(article: article),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(context, 'Gallery', Icons.photo_library, '/gallery'),
                  _buildNavItem(context, 'News', Icons.article, '/news'),
                  _buildNavItem(context, 'Reviews', Icons.rate_review, '/reviews'),
                  _buildNavItem(context, 'About', Icons.info, '/about'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, IconData icon, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
} 