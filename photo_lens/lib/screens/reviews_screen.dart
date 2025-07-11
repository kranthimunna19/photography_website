import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock review data
    final reviews = [
      {
        'title': 'Canon EOS R5 Review',
        'subtitle': 'The Ultimate Mirrorless Camera?',
        'image': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
        'rating': 4.8,
        'summary': 'A comprehensive review of Canon\'s flagship mirrorless camera with 8K video capabilities.',
        'category': 'Camera',
        'date': '2024-01-15',
        'author': 'John Smith',
      },
      {
        'title': 'Sony A7 IV Review',
        'subtitle': 'Perfect Balance of Performance and Price',
        'image': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
        'rating': 4.6,
        'summary': 'An in-depth look at Sony\'s popular full-frame mirrorless camera.',
        'category': 'Camera',
        'date': '2024-01-10',
        'author': 'Sarah Johnson',
      },
      {
        'title': 'DJI Mini 3 Pro Review',
        'subtitle': 'The Best Drone for Photography?',
        'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'rating': 4.7,
        'summary': 'Exploring the capabilities of DJI\'s lightweight drone for aerial photography.',
        'category': 'Drone',
        'date': '2024-01-08',
        'author': 'Mike Wilson',
      },
      {
        'title': 'Adobe Lightroom Classic Review',
        'subtitle': 'Still the King of Photo Editing?',
        'image': 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
        'rating': 4.5,
        'summary': 'A detailed review of Adobe\'s professional photo editing software.',
        'category': 'Software',
        'date': '2024-01-05',
        'author': 'Lisa Chen',
      },
      {
        'title': 'Manfrotto MT055 Tripod Review',
        'subtitle': 'Professional Stability for Heavy Gear',
        'image': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800',
        'rating': 4.4,
        'summary': 'Testing the durability and stability of this professional tripod.',
        'category': 'Accessories',
        'date': '2024-01-03',
        'author': 'David Brown',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Reviews'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Navigate to review detail page
                // context.go('/reviews/${review['id']}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                                              child: CachedNetworkImage(
                          imageUrl: review['image'] as String,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.error,
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            review['category'] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Title
                        Text(
                          review['title'] as String,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Subtitle
                        Text(
                          review['subtitle'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Rating
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < (review['rating'] as double).floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              review['rating'].toString(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Summary
                        Text(
                          review['summary'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Author and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  review['author'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  review['date'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Read More Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Navigate to full review
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Read Full Review'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 