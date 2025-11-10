import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/providers/favorites_provider.dart';
import 'package:real_estate_app/screens/inquiry_form_screen.dart';

class DetailsScreen extends StatefulWidget {
  final Property property;

  const DetailsScreen({super.key, required this.property});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final priceFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // App Bar
          Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF5B9BD5).withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF5B9BD5)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  Consumer<FavoritesProvider>(
                    builder: (context, provider, child) {
                      final isFavorite = provider.isFavorite(widget.property);
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF5B9BD5).withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFavorite ? const Color(0xFF5B9BD5) : Colors.white,
                          ),
                          onPressed: () => provider.toggleFavorite(widget.property),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Main Content - Fills remaining space perfectly
          Expanded(
            child: FadeTransition(
              opacity: _animationController,
              child: isDesktop ? _buildDesktopLayout(theme, priceFormat) : _buildMobileLayout(theme, priceFormat),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme, NumberFormat priceFormat) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEFT: Image (50%)
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Hero(
                tag: 'property_image_${widget.property.id}',
                child: Image.network(
                  widget.property.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 40),
          
          // RIGHT: Compact Details (50%)
          Expanded(
            flex: 5,
            child: _buildCompactDetailsContent(theme, priceFormat),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme, NumberFormat priceFormat) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Hero(
            tag: 'property_image_${widget.property.id}',
            child: Image.network(
              widget.property.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildCompactDetailsContent(theme, priceFormat),
          ),
        ],
      ),
    );
  }

  // ✅ COMPACT VERSION - Fits perfectly without scroll
  Widget _buildCompactDetailsContent(ThemeData theme, NumberFormat priceFormat) {
    
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price + Title Row (Compact)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B9BD5), Color(0xFF4A8BC2)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    priceFormat.format(widget.property.price),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    widget.property.type,
                    style: const TextStyle(
                      color: Color(0xFF5B9BD5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              widget.property.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 10),
            
            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF5B9BD5),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.property.address,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Stats Row (Compact)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCompactStat(Icons.bed_rounded, '${widget.property.bedrooms}', 'Bedrooms'),
                  _buildCompactDivider(),
                  _buildCompactStat(Icons.bathtub_rounded, '${widget.property.bathrooms}', 'Bathrooms'),
                  _buildCompactDivider(),
                  _buildCompactStat(Icons.square_foot_rounded, '${widget.property.area.toInt()}', 'Sq.Ft'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Property Highlights (Compact)
            const Text(
              'Property Highlights',
              style: TextStyle(
                color: Color(0xFF5B9BD5),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCompactChip('Parking', Icons.local_parking_rounded),
                _buildCompactChip('Security', Icons.security_rounded),
                _buildCompactChip('Pool', Icons.pool_rounded),
                _buildCompactChip('Garden', Icons.local_florist_rounded),
                _buildCompactChip('Gym', Icons.fitness_center_rounded),
                _buildCompactChip('Backup', Icons.power_rounded),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Description (Compact)
            const Text(
              'About Property',
              style: TextStyle(
                color: Color(0xFF5B9BD5),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            Text(
              widget.property.description,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        
        // Bottom Buttons
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: () => _showScheduleDialog(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5B9BD5), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_rounded, color: Color(0xFF5B9BD5), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Schedule Visit',
                        style: TextStyle(
                          color: Color(0xFF5B9BD5),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InquiryFormScreen(property: widget.property),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B9BD5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Inquire Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF5B9BD5), size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactDivider() {
    return Container(
      height: 50,
      width: 1,
      color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
    );
  }

  Widget _buildCompactChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF5B9BD5).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF5B9BD5), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF5B9BD5),
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Schedule a Visit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Our team will contact you within 24 hours to schedule your property visit.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9BD5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Got it!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
