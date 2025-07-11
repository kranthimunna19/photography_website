# PhotoLens - Modern Photography Website 🌟

A beautiful, modern photography website built with Flutter that showcases stunning photography, provides the latest photography news, and offers expert equipment reviews.

## 🚀 Live Demo

**🌐 Website:** [PhotoLens Live](https://your-username.github.io/photography_website/)

**📱 Mobile Friendly:** Responsive design that works on all devices

## ✨ Features

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

## 🛠️ Technology Stack

- **Frontend:** Flutter Web
- **State Management:** Provider
- **Navigation:** GoRouter
- **UI Framework:** Material Design 3
- **Deployment:** GitHub Pages + GitHub Actions
- **Fonts:** Google Fonts
- **Images:** CachedNetworkImage

## 📱 Screenshots

The app features a modern, clean interface with:
- Hero section with stunning photography background
- Featured photos carousel
- Category filtering chips
- Search functionality
- Responsive grid layouts
- Professional typography

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Git

### Local Development

1. **Clone the repository:**
```bash
git clone https://github.com/your-username/photography_website.git
cd photography_website
```

2. **Navigate to the Flutter project:**
```bash
cd photo_lens
```

3. **Install dependencies:**
```bash
flutter pub get
```

4. **Run the app:**
```bash
# For web
flutter run -d chrome

# For mobile
flutter run
```

### Deployment

The app is automatically deployed to GitHub Pages when you push to the `main` branch.

1. **Push your changes:**
```bash
git add .
git commit -m "Update photography website"
git push origin main
```

2. **Check deployment:** The app will be available at `https://your-username.github.io/photography_website/`

## 📁 Project Structure

```
photography_website/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions deployment
├── photo_lens/                 # Flutter project
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── models/             # Data models
│   │   ├── providers/          # State management
│   │   ├── screens/            # App screens
│   │   └── widgets/            # Reusable widgets
│   ├── assets/                 # Images and resources
│   ├── pubspec.yaml           # Dependencies
│   └── README.md              # Flutter project docs
├── .gitignore                 # Git ignore rules
└── README.md                  # Main project documentation
```

## 🎯 Key Features in Detail

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

## 🔧 Customization

### Adding New Photos
Update the `GalleryProvider` class in `photo_lens/lib/providers/gallery_provider.dart` to add new photos to the mock data.

### Adding News Articles
Update the `NewsProvider` class in `photo_lens/lib/providers/news_provider.dart` to add new articles.

### Theme Customization
Modify the theme configuration in `photo_lens/lib/main.dart` to customize colors, fonts, and styling.

## 🚀 Deployment Options

### GitHub Pages (Current)
- Automatic deployment via GitHub Actions
- Free hosting
- Custom domain support

### Vercel
- Excellent performance
- Automatic deployments
- Custom domain support

### Netlify
- Easy deployment
- Form handling
- Custom domain support

### Firebase Hosting
- Google's hosting solution
- Fast CDN
- Custom domain support

## 🔮 Future Enhancements

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
- [ ] PWA (Progressive Web App) features
- [ ] Offline support
- [ ] Push notifications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Material Design** for the beautiful design system
- **Unsplash** for the stunning photography
- **Google Fonts** for the typography

## 📞 Support

For support and questions:
- 📧 Email: hello@photolens.com
- 🌐 Website: www.photolens.com
- 📱 Social Media: @photolens_official
- 🐛 Issues: [GitHub Issues](https://github.com/your-username/photography_website/issues)

---

<div align="center">
  <p>Made with ❤️ for photographers</p>
  <p>⭐ Star this repository if you found it helpful!</p>
</div> 