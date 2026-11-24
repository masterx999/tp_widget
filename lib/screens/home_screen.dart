import 'package:flutter/material.dart';

import 'package:rihla/widgets/home_header.dart';
import 'package:rihla/widgets/search_box.dart';
import 'package:rihla/widgets/hero_banner.dart';
import 'package:rihla/widgets/destinations_card.dart';
import 'package:rihla/widgets/section_title.dart';

import 'package:rihla/data/destinations.dart';
import 'package:rihla/models/destination.dart';
import 'package:rihla/services/api_service.dart';
import 'package:provider/provider.dart';

import 'package:rihla/providers/favoris_model.dart';
import 'package:rihla/screens/favoris_screen.dart';
import 'package:rihla/screens/voyages_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;

  // TODO 1 : stocker le Future
  late Future<List<Destination>> _futurDestinations;

  @override
  void initState() {
    super.initState();

    // Lancer la requête une seule fois
    _futurDestinations = ApiService.getDestinations();
  }

  // Filtrer les destinations reçues du serveur
  List<Destination> _filtrer(List<Destination> toutes) {
    return _categorie == 'Tout'
        ? toutes
        : toutes.where((d) => d.categorie == _categorie).toList();
  }

  // TODO 2 et 3 : FutureBuilder
  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,

      builder: (context, snapshot) {
        // État 1 : chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // État 2 : erreur
        if (snapshot.hasError) {
          return ErreurReseau(
            message: snapshot.error.toString(),
            onReessayer: _recharger,
          );
        }

        // État 3 : données reçues
        final destinations = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: _recharger,
          child: _construireAccueil(destinations),
        );
      },
    );
  }

  // Construire l'accueil avec les destinations du serveur
  Widget _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),

      children: [
        const HomeHeader(prenom: "Dhaker ben lamine "),

        const SizedBox(height: 20),

        const SearchBox(),

        const SizedBox(height: 20),

        // Éviter destinations.first si la liste est vide
        if (destinations.isNotEmpty)
          HeroBanner(destination: destinations.first),

        const SizedBox(height: 24),

        const SectionTitle(title: 'Catégories'),

        // Catégories
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Row(
            children: [
              for (final c in categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),

                  child: ChoiceChip(
                    label: Text(c),

                    // Catégorie sélectionnée
                    selected: _categorie == c,

                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _categorie = c;
                        });
                      }
                    },
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        const SectionTitle(title: 'Populaires', action: 'Voir tout'),

        const SizedBox(height: 12),

        // Destinations filtrées
        for (final d in filtrees)
          DestinationCard(key: ValueKey(d.id), destination: d),
      ],
    );
  }

  // TODO 5 : rafraîchir les données
  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();

    setState(() {
      _futurDestinations = futur;
    });

    try {
      await futur;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final nombre = context.watch<FavorisModel>().nombre;
    return Scaffold(
      body: SafeArea(
        child: switch (_onglet) {
          0 => _construireExplorer(),
          1 => const FavorisScreen(),
          _ => const VoyagesScreen(),
        },
      ),

      // Navigation conservée
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,

        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },

        destinations: [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),

          NavigationDestination(
            icon: Badge(
              isLabelVisible: nombre > 0,
              label: Text('$nombre'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: nombre > 0,
              label: Text('$nombre'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Favoris',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Réservations',
          ),
        ],
      ),
    );
  }
}

// TODO 4 : Widget ErreurReseau
class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const ErreurReseau({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  @override
  Widget build(BuildContext context) {
    final couleur = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.cloud_off, size: 60, color: couleur.error),

            const SizedBox(height: 16),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 12),

            const Text(
              'Vérifiez que json-server est lancé.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
