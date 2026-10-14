
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icône de recherche
          Icon(
            Icons.search,
            color: cs.onSurfaceVariant,
          ),

          const SizedBox(width: 12),

          // Texte de recherche
          const Expanded(
            child: Text('Rechercher une destination'),
          ),

          // Icône de filtres
          Icon(
            Icons.tune,
            color: cs.primary,
          ),
        ],
      ),
    );
  }
}
