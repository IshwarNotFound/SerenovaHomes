import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.05),
            ],
          ),
        ),
        // FIX OVERFLOW: Use flexible padding and sized containers
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // IMPORTANT: Don't force size
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
