
import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';
import '../widgets/favourite_button.dart';
import 'reservation_screen.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({
    super.key,
    required this.destination,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _voyageurs = 1;

  // Réserver et envoyer les données au serveur
  Future<void> _reserver() async {

    // Ouvrir ReservationScreen et attendre le résultat
    final reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: widget.destination,
          voyageurs: _voyageurs,
        ),
      ),
    );

    // Vérifier si une réservation a été renvoyée
    if (reservation == null) return;

    // Vérifier que l'écran existe toujours
    if (!mounted) return;

    // Envoyer la réservation au serveur
    final String id;

    try {
      id = await ApiService.creerReservation(reservation);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Envoi impossible : json-server est-il lancé ?',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (!mounted) return;

    // Afficher la confirmation
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),

        title: const Text('Réservation confirmée'),

        content: Text(
          'N° de réservation : $id\n'
          'Nom : ${reservation.nom}\n'
          'Destination : ${reservation.destination.nom}\n'
          'Voyageurs : ${reservation.voyageurs}\n'
          'Formule : ${reservation.formule}\n'
          'Total : ${reservation.total} DT\n'
          'E-mail : ${reservation.email}',
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final destination = widget.destination;
    final total = destination.prix * _voyageurs;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. Grande image avec les boutons Retour et Favori
            SizedBox(
              height: 340,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image de la destination
                  Hero(
                    tag: 'image-${widget.destination.nom}',
                    child: Image.asset(
                      widget.destination.image,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Dégradé
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black38,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Bouton Retour
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black,
                        tooltip: 'Retour',
                      ),
                    ),
                  ),

                  // Bouton Favori
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FavoriteButton(destination: destination),
                  ),
                ],
              ),
            ),

            // 2. Informations et description
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom, région et note
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination.nom,
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: cs.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      destination.region,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Badge de note
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${destination.note}',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 3. Trois tuiles
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.schedule,
                            title: 'Durée',
                            value: '3 jours',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.category_outlined,
                            title: 'Type',
                            value: destination.categorie,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.groups_outlined,
                            title: 'Groupe',
                            value: '2-6 pers.',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // 4. Section À propos
                    Text(
                      'À propos',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      destination.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 5. Sélecteur de voyageurs
                    Text(
                      'Nombre de voyageurs',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: cs.primary,
                          size: 28,
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text('Voyageurs'),
                        ),

                        // Bouton moins
                        IconButton.outlined(
                          onPressed: _voyageurs > 1
                              ? () {
                                  setState(() {
                                    _voyageurs--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove),
                          tooltip: 'Retirer un voyageur',
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Text(
                            '$_voyageurs',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Bouton plus
                        IconButton.outlined(
                          onPressed: () {
                            setState(() {
                              _voyageurs++;
                            });
                          },
                          icon: const Icon(Icons.add),
                          tooltip: 'Ajouter un voyageur',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 6. Barre de réservation en bas
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Prix total
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prix total',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${total.toStringAsFixed(0)} DT',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    Text(
                      'Pour $_voyageurs voyageur(s)',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Bouton Réserver
              Expanded(
                child: FilledButton(
                  onPressed: _reserver,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Réserver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget réutilisable pour les trois caractéristiques
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: cs.primary,
            size: 26,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
