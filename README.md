

# SerenovaHomes

A luxury real estate property listing app built with Flutter. 

## What it does

Browse high-end properties, save your favorites, and send inquiries - all in a clean, modern interface.

## Features

- Property search and filtering by type (Apartment, Villa, Penthouse, Studio)
- Sort by price, area, or newest listings
- Save properties to favorites
- Detailed property pages with amenities
- Contact form for inquiries
- Responsive design for web and mobile

## Tech Stack

- Flutter 3.0+
- Provider for state management
- Material Design 3
- Custom animations

## Setup

```bash
flutter pub get
flutter run -d chrome
```

## Structure

```
lib/
├── screens/         # Main app screens
├── widgets/         # Reusable components
├── models/          # Data models
├── providers/       # State management
└── data/           # Mock property data
```

## Color Scheme

Primary: #5B9BD5 (Blue)  
Theme: Dark with blue accents

## Dependencies

- provider: ^6.0.5
- intl: ^0.18.1
- animations: ^2.0.7

## Notes

This was built as a college project to demonstrate Flutter UI/UX skills and state management patterns. Property data is mocked - in production this would connect to a real backend.

