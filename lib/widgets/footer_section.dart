import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            const Color(0xFF0A0A0A),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF5B9BD5).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.all(isDesktop ? 60.0 : 40.0),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
          child: Column(
            children: [
              // Logo & Tagline
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_work_rounded,
                        color: const Color(0xFF5B9BD5),
                        size: isDesktop ? 32 : 28,
                      ),
                      SizedBox(width: isDesktop ? 12 : 10),
                      Text(
                        'SerenovaHomes.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 28 : 22,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isDesktop ? 12 : 10),
                  Text(
                    'Inspired by Tranquil Luxury',
                    style: TextStyle(
                      color: const Color(0xFF5B9BD5).withValues(alpha: 0.8),
                      fontSize: isDesktop ? 14 : 12,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isDesktop ? 40 : 32),
              
              // Contact Info
              _buildInfoSection(
                'Contact Us',
                [
                  _buildInfoItem(Icons.email_rounded, 'info@serenovahomes.com', theme),
                  _buildInfoItem(Icons.phone_rounded, '+91 89789 68844', theme),
                  _buildInfoItem(Icons.location_on_rounded, 'Hyderabad, Telangana', theme),
                ],
                theme,
                isDesktop,
              ),
              
              SizedBox(height: isDesktop ? 40 : 32),
              
              // Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF5B9BD5).withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: isDesktop ? 24 : 20),
              
              // Copyright
              Text(
                '© 2025 SerenovaHomes. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: isDesktop ? 13 : 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items, ThemeData theme, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF5B9BD5),
            fontSize: isDesktop ? 16 : 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: isDesktop ? 16 : 12),
        ...items,
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF5B9BD5),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
