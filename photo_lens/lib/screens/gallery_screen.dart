import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/gallery_provider.dart';
import '../widgets/photo_card.dart';
import '../widgets/category_chip.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GalleryProvider>().loadPhotos();
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
        title: const Text('Photo Gallery'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surface,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search photos...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Category Filters
                Consumer<GalleryProvider>(
                  builder: (context, galleryProvider, child) {
                    final categories = galleryProvider.getCategories();
                    
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
                              });
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
          
          // Photos Grid
          Expanded(
            child: Consumer<GalleryProvider>(
              builder: (context, galleryProvider, child) {
                if (galleryProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (galleryProvider.error != null) {
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
                          galleryProvider.error!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            galleryProvider.loadPhotos();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                List<dynamic> filteredPhotos = galleryProvider.photos;
                
                // Apply category filter
                if (selectedCategory != null) {
                  filteredPhotos = galleryProvider.getPhotosByCategory(selectedCategory!);
                }
                
                // Apply search filter
                if (_searchController.text.isNotEmpty) {
                  filteredPhotos = filteredPhotos.where((photo) {
                    return photo.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                           photo.description.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                           photo.photographer.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                           photo.category.toLowerCase().contains(_searchController.text.toLowerCase());
                  }).toList();
                }
                
                if (filteredPhotos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No photos found',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filter criteria',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredPhotos.length,
                  itemBuilder: (context, index) {
                    return PhotoCard(photo: filteredPhotos[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 