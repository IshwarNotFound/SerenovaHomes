import 'package:flutter/material.dart';
import 'package:real_estate_app/models/property.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Property> _favorites = [];

  List<Property> get favorites => _favorites;

  bool isFavorite(Property property) {
    return _favorites.any((p) => p.id == property.id);
  }

  void toggleFavorite(Property property) {
    if (isFavorite(property)) {
      _favorites.removeWhere((p) => p.id == property.id);
    } else {
      _favorites.add(property);
    }
    notifyListeners();
  }

  void addFavorite(Property property) {
    if (!isFavorite(property)) {
      _favorites.add(property);
      notifyListeners();
    }
  }

  void removeFavorite(Property property) {
    _favorites.removeWhere((p) => p.id == property.id);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  int get favoriteCount => _favorites.length;
}
