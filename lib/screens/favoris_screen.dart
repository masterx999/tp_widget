import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favoris_model.dart';
import '../widgets/destinations_card.dart';

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoris = context.watch<FavorisModel>().liste;

    if (favoris.isEmpty) {
      return const Center(child: Text('Aucun favori pour le moment'));
    }

    return ListView(
      children: [for (final d in favoris) DestinationCard(destination: d)],
    );
  }
}
