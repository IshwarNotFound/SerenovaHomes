import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/providers/favorites_provider.dart';
import 'package:real_estate_app/screens/details_screen.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final bool isNew; // NEW
  final bool isFeatured; // NEW
  
  const PropertyCard({
    super.key,
    required this.property,
    this.isNew = false,
    this.isFeatured = false,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.05 : 1.0,
          _isHovered ? 1.05 : 1.0,
          1.0,
        ),
        child: Card(
          elevation: _isHovered ? 24 : 6,
          shadowColor: const Color(0xFF5B9BD5).withValues(alpha: _isHovered ? 0.5 : 0.2),
          color: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: _isHovered 
                  ? const Color(0xFF5B9BD5).withValues(alpha: 0.7)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: _isHovered ? 2.5 : 1.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DetailsScreen(property: widget.property),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                        ),
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 700),
                ),
              );
            },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'property_image_${widget.property.id}',
                            child: Image.network(
                              widget.property.imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: const Color(0xFF5B9BD5),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image_rounded,
                                          color: theme.colorScheme.onSurfaceVariant,
                                          size: 64,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Image not available',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(isDesktop ? 18.0 : 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.property.title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isDesktop ? 19 : 17,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: const Color(0xFF5B9BD5),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        widget.property.address.split(',').first,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontSize: isDesktop ? 13 : 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            _buildStatsRow(context, isDesktop),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // PRICE, TYPE & BADGES
                Positioned(
                  top: 14,
                  left: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 16 : 12,
                              vertical: isDesktop ? 10 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B9BD5),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF5B9BD5).withValues(
                                    alpha: 0.4 + (_pulseController.value * 0.3),
                                  ),
                                  blurRadius: 16 + (_pulseController.value * 12),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              priceFormat.format(widget.property.price),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isDesktop ? 15 : 13,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 12 : 10,
                          vertical: isDesktop ? 6 : 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7BA3CC).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getTypeIcon(widget.property.type),
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.property.type,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // NEW BADGE
                      if (widget.isNew) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B9D), Color(0xFFFF1744)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B9D).withValues(alpha: 0.5),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fiber_new_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'NEW',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // FEATURED BADGE
                      if (widget.isFeatured) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFC107), Color(0xFFFFA000)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFC107).withValues(alpha: 0.5),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.black,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'FEATURED',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // FAVORITE BUTTON
                Positioned(
                  top: 12,
                  right: 12,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, provider, child) {
                      final isFavorite = provider.isFavorite(widget.property);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isFavorite 
                                  ? const Color(0xFF5B9BD5).withValues(alpha: 0.7)
                                  : Colors.transparent,
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: RotationTransition(
                                  turns: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              key: ValueKey(isFavorite),
                              color: isFavorite
                                  ? const Color(0xFF5B9BD5)
                                  : Colors.white,
                              size: isDesktop ? 28 : 26,
                            ),
                          ),
                          onPressed: () {
                            provider.toggleFavorite(widget.property);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Apartment':
        return Icons.apartment_rounded;
      case 'Penthouse':
        return Icons.roofing_rounded;
      case 'Villa':
        return Icons.villa_rounded;
      case 'Studio':
        return Icons.meeting_room_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  Widget _buildStatsRow(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat(theme, Icons.bed_rounded, '${widget.property.bedrooms}', isDesktop),
        _buildStat(theme, Icons.bathtub_rounded, '${widget.property.bathrooms}', isDesktop),
        _buildStat(
          theme,
          Icons.square_foot_rounded,
          NumberFormat.compact().format(widget.property.area),
          isDesktop,
        ),
      ],
    );
  }

  Widget _buildStat(ThemeData theme, IconData icon, String text, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 10 : 8,
        vertical: isDesktop ? 7 : 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF5B9BD5), size: isDesktop ? 17 : 15),
          SizedBox(width: isDesktop ? 5 : 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 12 : 11,
            ),
          ),
        ],
      ),
    );
  }
}
