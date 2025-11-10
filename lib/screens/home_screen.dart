import 'package:flutter/material.dart';
import 'package:real_estate_app/data/mock_properties.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:real_estate_app/widgets/property_card.dart';
import 'package:real_estate_app/widgets/footer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _sortBy = 'Featured';

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Property> _sortProperties(List<Property> properties) {
    final sorted = List<Property>.from(properties);
    switch (_sortBy) {
      case 'Price: Low to High':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Area: Large to Small':
        sorted.sort((a, b) => b.area.compareTo(a.area));
        break;
      case 'Newest':
        break;
      default:
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAnimatedAppBar(isDesktop),
          _buildSearchBar(isDesktop),
          _buildFilterChips(isDesktop),
          _buildSortAndCount(isDesktop),
          _buildPropertyGrid(isDesktop),
          const SliverToBoxAdapter(child: FooterSection()),
        ],
      ),
    );
  }

  Widget _buildAnimatedAppBar(bool isDesktop) {
    final theme = Theme.of(context);
    
    return SliverAppBar(
      expandedHeight: isDesktop ? 220.0 : 160.0,
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: AnimatedBuilder(
          animation: _backgroundAnimationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0A4D8C).withValues(alpha: 0.3),
                    const Color(0xFF5B9BD5).withValues(alpha: 0.15),
                    theme.colorScheme.surface,
                  ],
                  stops: [
                    0.0,
                    _backgroundAnimationController.value,
                    1.0,
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 40.0 : 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _logoAnimationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _logoAnimationController.value * 4 - 2),
                              child: Opacity(
                                opacity: 0.92 + (_logoAnimationController.value * 0.08),
                                child: Column(
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      duration: const Duration(milliseconds: 1200),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      builder: (context, value, child) {
                                        return Opacity(
                                          opacity: value,
                                          child: Transform.scale(
                                            scale: 0.8 + (value * 0.2),
                                            child: Text(
                                              'SerenovaHomes.com',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: isDesktop ? 44 : 30,
                                                letterSpacing: 3,
                                                shadows: [
                                                  Shadow(
                                                    color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: isDesktop ? 12 : 8),
                                    TweenAnimationBuilder<double>(
                                      duration: const Duration(milliseconds: 1600),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      builder: (context, value, child) {
                                        return Opacity(
                                          opacity: value,
                                          child: Transform.translate(
                                            offset: Offset(0, 20 * (1 - value)),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: isDesktop ? 20 : 16,
                                                vertical: isDesktop ? 8 : 6,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
                                                    width: 1,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'Inspired by Tranquil Luxury',
                                                style: TextStyle(
                                                  color: const Color(0xFF5B9BD5).withValues(alpha: 0.9),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: isDesktop ? 15 : 12,
                                                  letterSpacing: 3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDesktop) {
    final theme = Theme.of(context);
    
    return SliverToBoxAdapter(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 900 : double.infinity),
                  padding: EdgeInsets.all(isDesktop ? 32.0 : 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5B9BD5).withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: isDesktop ? 16 : 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search luxury properties...',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: const Color(0xFF5B9BD5),
                          size: isDesktop ? 26 : 24,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: isDesktop ? 18 : 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(bool isDesktop) {
    final theme = Theme.of(context);
    final filters = ['All', 'Apartment', 'Penthouse', 'Villa', 'Studio'];

    return SliverToBoxAdapter(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
                height: isDesktop ? 70 : 60,
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 20),
                margin: EdgeInsets.only(bottom: isDesktop ? 8 : 6),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = _selectedFilter == filter;

                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 600 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, chipValue, child) {
                        return Transform.scale(
                          scale: chipValue,
                          child: Padding(
                            padding: EdgeInsets.only(right: isDesktop ? 14 : 10),
                            child: FilterChip(
                              label: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isDesktop ? 15 : 13,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                              avatar: isSelected ? Icon(
                                _getFilterIcon(filter),
                                color: Colors.white,
                                size: isDesktop ? 18 : 16,
                              ) : null,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              selectedColor: const Color(0xFF5B9BD5),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF5B9BD5)
                                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 20 : 16,
                                vertical: isDesktop ? 12 : 10,
                              ),
                              shadowColor: isSelected 
                                  ? const Color(0xFF5B9BD5).withValues(alpha: 0.3)
                                  : Colors.transparent,
                              elevation: isSelected ? 4 : 0,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortAndCount(bool isDesktop) {
    
    final filteredProperties = MOCK_PROPERTIES.where((property) {
      final matchesSearch = property.title.toLowerCase().contains(_searchQuery) ||
          property.address.toLowerCase().contains(_searchQuery);
      final matchesFilter = _selectedFilter == 'All' || property.type == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 20,
            vertical: isDesktop ? 16 : 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 20 : 16,
                  vertical: isDesktop ? 12 : 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                      const Color(0xFF5B9BD5).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5B9BD5).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.home_work_rounded,
                      color: const Color(0xFF5B9BD5),
                      size: isDesktop ? 20 : 18,
                    ),
                    SizedBox(width: isDesktop ? 10 : 8),
                    Text(
                      'Showing ${filteredProperties.length} ${filteredProperties.length == 1 ? 'property' : 'properties'}',
                      style: TextStyle(
                        color: const Color(0xFF5B9BD5),
                        fontWeight: FontWeight.w600,
                        fontSize: isDesktop ? 14 : 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5B9BD5).withValues(alpha: 0.2),
                      const Color(0xFF5B9BD5).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5B9BD5).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5B9BD5).withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    dropdownColor: const Color(0xFF1A1A1A),
                    icon: Icon(
                      Icons.sort_rounded,
                      color: const Color(0xFF5B9BD5),
                      size: isDesktop ? 20 : 18,
                    ),
                    style: TextStyle(
                      color: const Color(0xFF5B9BD5),
                      fontSize: isDesktop ? 14 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    items: [
                      'Featured',
                      'Price: Low to High',
                      'Price: High to Low',
                      'Area: Large to Small',
                      'Newest',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            value,
                            style: TextStyle(
                              color: _sortBy == value 
                                  ? const Color(0xFF5B9BD5) 
                                  : Colors.white,
                              fontWeight: _sortBy == value 
                                  ? FontWeight.bold 
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _sortBy = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
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

  Widget _buildPropertyGrid(bool isDesktop) {
    var filteredProperties = MOCK_PROPERTIES.where((property) {
      final matchesSearch = property.title.toLowerCase().contains(_searchQuery) ||
          property.address.toLowerCase().contains(_searchQuery);
      final matchesFilter = _selectedFilter == 'All' || property.type == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    filteredProperties = _sortProperties(filteredProperties);

    if (filteredProperties.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: isDesktop ? 100 : 70,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No properties found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: isDesktop ? 24 : 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: isDesktop ? 14 : 13,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 40.0 : 20.0,
        isDesktop ? 32.0 : 20.0,
        isDesktop ? 40.0 : 20.0,
        isDesktop ? 40.0 : 30.0,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 3 : 1,
          mainAxisSpacing: isDesktop ? 48 : 28,
          crossAxisSpacing: isDesktop ? 40 : 0,
          childAspectRatio: isDesktop ? 0.72 : 0.68,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Transform.scale(
                      scale: 0.9 + (value * 0.1),
                      child: PropertyCard(
                        property: filteredProperties[index],
                        isNew: index < 3,
                        isFeatured: index < 2,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          childCount: filteredProperties.length,
        ),
      ),
    );
  }
}
