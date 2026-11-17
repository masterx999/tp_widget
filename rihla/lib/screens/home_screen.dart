import 'package:flutter/material.dart';

import '../data/destinations.dart';
import '../models/destination.dart';
import 'mes_reservations_screen.dart';
import '../services/api_service.dart';
import '../widgets/destination_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/network_error.dart';
import '../widgets/search_box.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.apiService});

  final ApiService apiService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;
  late Future<List<Destination>> _futurDestinations;

  @override
  void initState() {
    super.initState();
    _futurDestinations = widget.apiService.getDestinations();
  }

  List<Destination> _filtrer(List<Destination> toutes) {
    if (_categorie == 'Tout') return toutes;
    return toutes
        .where((destination) => destination.categorie == _categorie)
        .toList();
  }

  Future<void> _recharger() {
    final futur = widget.apiService.getDestinations();
    setState(() {
      _futurDestinations = futur;
    });
    return futur.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        // FutureBuilder displays the failure while the refresh indicator stops.
      },
    );
  }

  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return NetworkError(
            message: snapshot.error.toString(),
            onRetry: _recharger,
          );
        }

        final destinations = snapshot.data ?? const <Destination>[];
        return RefreshIndicator(
          onRefresh: _recharger,
          child: destinations.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 180),
                    Center(child: Text('Aucune destination disponible.')),
                  ],
                )
              : _construireAccueil(destinations),
        );
      },
    );
  }

  Widget _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        const HomeHeader(prenom: 'Rayen'),
        const SizedBox(height: 20),
        const SearchBox(),
        const SizedBox(height: 20),
        if (destinations.isNotEmpty) ...[
          HeroBanner(
            destination: destinations.first,
            apiService: widget.apiService,
          ),
          const SizedBox(height: 24),
        ],
        const SectionTitle(title: 'Catégories'),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final categorie in categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(categorie),
                    selected: _categorie == categorie,
                    onSelected: (_) {
                      setState(() {
                        _categorie = categorie;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle(title: 'Populaires', action: 'Voir tout'),
        const SizedBox(height: 12),
        for (final destination in filtrees)
          DestinationCard(
            key: ValueKey(destination.id),
            destination: destination,
            apiService: widget.apiService,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: switch (_onglet) {
          0 => _construireExplorer(),
          1 => const Center(child: Text('Bientôt disponible')),
          _ => MesReservationsScreen(apiService: widget.apiService),
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage),
            label: 'Voyages',
          ),
        ],
      ),
    );
  }
}
