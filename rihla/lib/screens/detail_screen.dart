import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../models/reservation.dart';
import '../widgets/favorite_button.dart';
import 'reservation_screen.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _voyageurs = 1;

  Future<void> _reserver() async {
    final reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: widget.destination,
          voyageurs: _voyageurs,
        ),
      ),
    );

    // Quitter le formulaire avec la flèche retour renvoie null.
    if (reservation == null) return;
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Réservation confirmée'),
        content: Text(
          '${reservation.nom} a réservé ${reservation.voyageurs} place(s) pour ${reservation.destination.nom} (${reservation.formule}) pour un total de ${reservation.total} DT. Un e-mail de confirmation a été envoyé à ${reservation.email}.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Parfait'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 340,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(destination.image, fit: BoxFit.cover),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: _RoundImageButton(
                      tooltip: 'Retour',
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: _RoundFavoriteButton(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.nom,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              destination.region,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${destination.note}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          label: 'Durée',
                          value: destination.duree,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _InfoTile(
                          label: 'Type',
                          value: destination.categorie,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: _InfoTile(label: 'Groupe', value: '2–4 pers.'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'À propos',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    destination.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Voyageurs',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton.outlined(
                        key: const ValueKey('traveler-decrease'),
                        tooltip: 'Réduire le nombre de voyageurs',
                        onPressed: _voyageurs == 1
                            ? null
                            : () {
                                setState(() {
                                  _voyageurs--;
                                });
                              },
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_voyageurs',
                          key: const ValueKey('traveler-count'),
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton.outlined(
                        key: const ValueKey('traveler-increase'),
                        tooltip: 'Augmenter le nombre de voyageurs',
                        onPressed: () {
                          setState(() {
                            _voyageurs++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${destination.prix * _voyageurs} DT',
                      key: const ValueKey('booking-total'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: _reserver,
                child: const Text('Réserver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundImageButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundImageButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

class _RoundFavoriteButton extends StatelessWidget {
  const _RoundFavoriteButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: const FavoriteButton(),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
