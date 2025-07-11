import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About PhotoLens'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PhotoLens',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Gateway to Photography Excellence',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Mission Section
            Text(
              'Our Mission',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PhotoLens is dedicated to inspiring and empowering photographers of all skill levels. We believe that photography is more than just capturing images—it\'s about telling stories, preserving memories, and expressing creativity through visual art.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // What We Offer Section
            Text(
              'What We Offer',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              context,
              icon: Icons.photo_library,
              title: 'Curated Photo Gallery',
              description: 'Explore stunning photography from talented artists around the world, organized by categories and styles.',
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              context,
              icon: Icons.article,
              title: 'Latest Photography News',
              description: 'Stay updated with the latest trends, technology advancements, and industry insights in photography.',
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              context,
              icon: Icons.rate_review,
              title: 'Expert Equipment Reviews',
              description: 'Get detailed, unbiased reviews of cameras, lenses, and accessories from professional photographers.',
            ),
            
            const SizedBox(height: 32),
            
            // Team Section
            Text(
              'Our Team',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PhotoLens is built by a passionate team of photographers, developers, and content creators who share a common love for visual storytelling. We\'re committed to providing you with the best resources and inspiration for your photographic journey.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Contact Section
            Text(
              'Get in Touch',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildContactItem(
              context,
              icon: Icons.email,
              title: 'Email',
              subtitle: 'hello@photolens.com',
            ),
            
            const SizedBox(height: 12),
            
            _buildContactItem(
              context,
              icon: Icons.web,
              title: 'Website',
              subtitle: 'www.photolens.com',
            ),
            
            const SizedBox(height: 12),
            
            _buildContactItem(
              context,
              icon: Icons.social_distance,
              title: 'Social Media',
              subtitle: '@photolens_official',
            ),
            
            const SizedBox(height: 48),
            
            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2024 PhotoLens. All rights reserved.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Made with ❤️ for photographers',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 