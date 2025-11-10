import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/providers/favorites_provider.dart';
import 'package:real_estate_app/widgets/property_card.dart';
import 'dart:math' as math;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAnimatedAppBar(favorites.length),
              favorites.isEmpty
                  ? SliverFillRemaining(
                      child: _buildEmptyState(),
                    )
                  : _buildFavoritesList(favorites), // Pass list
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAppBar(int count) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      stops: [
                        _headerController.value,
                        _headerController.value + 0.5,
                        _headerController.value + 1,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'My Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            if (count > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return CustomPaint(
                  painter: FavoriteBackgroundPainter(
                    animationValue: _headerController.value,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.secondary.withAlpha(100),
                    theme.colorScheme.primary.withAlpha(100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline.withAlpha(100),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withAlpha(100),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 80,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            'No Favorites Yet',
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              'Start exploring properties and add them to your favorites!',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to home if needed
            },
            icon: const Icon(Icons.explore_rounded),
            label: const Text('Explore Properties'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // <<<--- BUG FIX: Replaced SliverPadding with SliverLayoutBuilder
  Widget _buildFavoritesList(List favorites) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2; // Default for mobile
        double childAspectRatio = 0.7;

        if (constraints.crossAxisExtent > 1200) {
          crossAxisCount = 4; // Desktop
          childAspectRatio = 0.75;
        } else if (constraints.crossAxisExtent > 800) {
          crossAxisCount = 3; // Tablet
          childAspectRatio = 0.72;
        }

        return SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // <<<--- STAGGERED FADE + SLIDE ANIMATION ---<<<
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: PropertyCard(property: favorites[index]),
                      ),
                    );
                  },
                );
              },
              childCount: favorites.length,
            ),
          ),
        );
      },
    );
  }
}

class FavoriteBackgroundPainter extends CustomPainter {
  final double animationValue;

  FavoriteBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw floating hearts
    for (int i = 0; i < 15; i++) {
      final x = (size.width * (i / 15) +
              animationValue * 50 * math.sin(i.toDouble())) %
          size.width;
      final y = (size.height * 0.5 +
              50 * math.sin(i + animationValue * math.pi * 2)) %
          size.height;

      paint.color = const Color(0xFFFF5A33)
          .withAlpha(((0.1 + 0.2 * math.sin(i + animationValue * math.pi)) * 255).round());

      // Draw heart shape (simplified)
      final path = Path();
      final scale = 1.0 + 0.5 * math.sin(i + animationValue * math.pi);
      path.moveTo(x, y + 5 * scale);
      path.cubicTo(x - 3 * scale, y, x - 6 * scale, y - 3 * scale,
          x - 3 * scale, y - 6 * scale);
      path.cubicTo(x - 3 * scale, y - 9 * scale, x, y - 9 * scale, x,
          y - 6 * scale);
      path.cubicTo(
          x, y - 9 * scale, x + 3 * scale, y - 9 * scale, x + 3 * scale, y - 6 * scale);
      path.cubicTo(x + 6 * scale, y - 3 * scale, x + 3 * scale, y, x,
          y + 5 * scale);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(FavoriteBackgroundPainter oldDelegate) => true;
}