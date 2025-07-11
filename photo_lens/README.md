# PhotoLens - Modern Photography Website

A beautiful, modern photography website built with Flutter that showcases stunning photography, provides the latest photography news, and offers expert equipment reviews.

## Features

### 🖼️ Photo Gallery
- Curated collection of high-quality photographs
- Category-based filtering (Landscape, Portrait, Street, Wildlife, etc.)
- Search functionality to find specific photos
- Responsive grid layout with beautiful photo cards
- Photo details including photographer, date, likes, and views

### 📰 Photography News
- Latest industry news and updates
- Category-based filtering (Camera News, Technology, Tutorials, etc.)
- Search functionality for articles
- Article cards with read time, author, and tags
- Professional news layout

### 📊 Equipment Reviews
- Comprehensive camera and equipment reviews
- Star ratings and detailed summaries
- Professional review layout with images
- Categorized by equipment type

### 🎨 Modern UI/UX
- Material Design 3 with beautiful theming
- Dark/Light mode toggle
- Responsive design for all screen sizes
- Smooth animations and transitions
- Google Fonts integration

### 🔧 Technical Features
- State management with Provider
- Navigation with GoRouter
- Image caching with CachedNetworkImage
- Local storage for theme preferences
- Error handling and loading states

## Screenshots

The app features a modern, clean interface with:
- Hero section with stunning photography background
- Featured photos carousel
- Category filtering chips
- Search functionality
- Responsive grid layouts
- Professional typography

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Chrome browser (for web development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd photo_lens
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web
flutter run -d chrome

# For mobile
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point and configuration
├── models/                   # Data models
│   ├── photo.dart           # Photo model
│   └── news_article.dart    # News article model
├── providers/               # State management
│   ├── theme_provider.dart  # Theme state management
│   ├── gallery_provider.dart # Photo gallery state
│   └── news_provider.dart   # News state management
├── screens/                 # App screens
│   ├── home_screen.dart     # Home page with hero section
│   ├── gallery_screen.dart  # Photo gallery with filters
│   ├── news_screen.dart     # News articles
│   ├── reviews_screen.dart  # Equipment reviews
│   └── about_screen.dart    # About page
└── widgets/                 # Reusable widgets
    ├── photo_card.dart      # Photo display card
    ├── news_card.dart       # News article card
    └── category_chip.dart   # Category filter chip
```

## Dependencies

- **flutter**: Core Flutter framework
- **google_fonts**: Beautiful typography
- **provider**: State management
- **go_router**: Navigation
- **cached_network_image**: Image caching
- **intl**: Internationalization
- **shared_preferences**: Local storage
- **shimmer**: Loading animations
- **lottie**: Animation support
- **http**: HTTP requests
- **dio**: HTTP client
- **url_launcher**: URL handling
- **share_plus**: Content sharing

## Features in Detail

### Home Screen
- Hero section with background image and call-to-action buttons
- Featured photos horizontal scroll
- Category browsing chips
- Latest news preview
- Navigation to all sections

### Gallery Screen
- Grid layout of photos
- Search functionality
- Category filtering
- Photo cards with detailed information
- Loading and error states

### News Screen
- List of news articles
- Search and category filtering
- Article cards with metadata
- Professional news layout

### Reviews Screen
- Equipment review cards
- Star ratings
- Review summaries
- Professional layout

### About Screen
- Company information
- Mission statement
- Feature highlights
- Contact information

## Customization

### Adding New Photos
Update the `GalleryProvider` class in `lib/providers/gallery_provider.dart` to add new photos to the mock data.

### Adding News Articles
Update the `NewsProvider` class in `lib/providers/news_provider.dart` to add new articles.

### Theme Customization
Modify the theme configuration in `lib/main.dart` to customize colors, fonts, and styling.

## Future Enhancements

- [ ] User authentication and profiles
- [ ] Photo upload functionality
- [ ] Comments and likes system
- [ ] Advanced search filters
- [ ] Photo detail pages
- [ ] User portfolios
- [ ] Photography tutorials
- [ ] Equipment comparison tools
- [ ] Mobile app versions
- [ ] API integration for real data

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact:
- Email: hello@photolens.com
- Website: www.photolens.com
- Social Media: @photolens_official

---

Made with ❤️ for photographers
