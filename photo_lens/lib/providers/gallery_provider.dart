import 'package:flutter/material.dart';
import '../models/photo.dart';

class GalleryProvider extends ChangeNotifier {
  List<Photo> _photos = [];
  bool _isLoading = false;
  String? _error;

  List<Photo> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPhotos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data for now - in a real app, this would come from an API
      _photos = [
        Photo(
          id: '1',
          title: 'Sunset at Golden Gate',
          description: 'A breathtaking sunset captured at the iconic Golden Gate Bridge',
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
          category: 'Landscape',
          photographer: 'John Doe',
          date: DateTime.now().subtract(const Duration(days: 5)),
          likes: 1247,
          views: 8900,
        ),
        Photo(
          id: '2',
          title: 'Urban Street Photography',
          description: 'Life in the city captured through candid moments',
          imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
          category: 'Street',
          photographer: 'Jane Smith',
          date: DateTime.now().subtract(const Duration(days: 3)),
          likes: 892,
          views: 5600,
        ),
        Photo(
          id: '3',
          title: 'Portrait in Natural Light',
          description: 'A stunning portrait using only natural window light',
          imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
          category: 'Portrait',
          photographer: 'Mike Johnson',
          date: DateTime.now().subtract(const Duration(days: 1)),
          likes: 2156,
          views: 12000,
        ),
        Photo(
          id: '4',
          title: 'Macro Flower Photography',
          description: 'Intricate details of a blooming rose captured in macro',
          imageUrl: 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=800',
          category: 'Macro',
          photographer: 'Sarah Wilson',
          date: DateTime.now().subtract(const Duration(hours: 12)),
          likes: 567,
          views: 3400,
        ),
        Photo(
          id: '5',
          title: 'Wildlife in Action',
          description: 'A majestic eagle soaring through the mountain peaks',
          imageUrl: 'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=800',
          category: 'Wildlife',
          photographer: 'David Brown',
          date: DateTime.now().subtract(const Duration(hours: 6)),
          likes: 1890,
          views: 7800,
        ),
        Photo(
          id: '6',
          title: 'Architectural Symmetry',
          description: 'Modern architecture showcasing perfect geometric balance',
          imageUrl: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=800',
          category: 'Architecture',
          photographer: 'Lisa Chen',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          likes: 743,
          views: 4200,
        ),
      ];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load photos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Photo> getPhotosByCategory(String category) {
    return _photos.where((photo) => photo.category == category).toList();
  }

  List<String> getCategories() {
    return _photos.map((photo) => photo.category).toSet().toList();
  }
} 