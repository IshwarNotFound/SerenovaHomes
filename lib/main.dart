import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/providers/favorites_provider.dart';
import 'package:real_estate_app/screens/favorites_screen.dart';
import 'package:real_estate_app/screens/home_screen.dart';
import 'package:animations/animations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: const SerenovaHomesApp(),
    ),
  );
}

class SerenovaHomesApp extends StatelessWidget {
  const SerenovaHomesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenova Homes - Luxury Properties',
      theme: _buildLuxuryBlueTheme(),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLuxuryBlueTheme() {
    // LUXURY BLUE COLOR SCHEME
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0A4D8C), // Deep Royal Blue
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme.copyWith(
        primary: const Color(0xFF5B9BD5), // Luxury Blue
        secondary: const Color(0xFF7BA3CC), // Light Blue
        tertiary: const Color(0xFF5B9BD5), // CHANGED: Blue instead of gold
        surface: const Color(0xFF0F0F0F),
        surfaceContainerHighest: const Color(0xFF1A1A1A),
      ),
      scaffoldBackgroundColor: const Color(0xFF000000),
      
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        color: const Color(0xFF1A1A1A),
      ),
      
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B9BD5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF5B9BD5).withValues(alpha: 0.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = [
    HomeScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 600),
        reverse: _selectedIndex == 0,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A1A).withValues(alpha: 0.95),
              const Color(0xFF0A0A0A),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          elevation: 0,
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 28),
              selectedIcon: _GradientIcon(
                icon: Icons.home,
                color: Color(0xFF5B9BD5),
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border, size: 28),
              selectedIcon: _GradientIcon(
                icon: Icons.favorite,
                color: Color(0xFF5B9BD5),
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _GradientIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 28, color: color);
  }
}
