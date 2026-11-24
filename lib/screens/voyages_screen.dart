import 'package:flutter/material.dart';

import '../models/reservation.dart';
import '../services/api_service.dart';

class VoyagesScreen extends StatefulWidget {
  const VoyagesScreen({super.key});

  @override
  State<VoyagesScreen> createState() => _VoyagesScreenState();
}

class _VoyagesScreenState extends State<VoyagesScreen> {
  late Future<List<Reservation>> _futurReservations;

  @override
  void initState() {
    super.initState();
    _futurReservations = ApiService.getReservations();
  }

  Future<void> _recharger() async {
    final futur = ApiService.getReservations();
    setState(() => _futurReservations = futur);
    await futur;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      future: _futurReservations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 56),
                  const SizedBox(height: 16),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _recharger,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        final reservations = snapshot.data ?? [];
        if (reservations.isEmpty) {
          return const Center(child: Text('Aucune réservation pour le moment'));
        }

        return RefreshIndicator(
          onRefresh: _recharger,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final date = reservation.dateDepart;

              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      reservation.destination.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(reservation.destination.nom),
                  subtitle: Text(
                    '${reservation.nom} • ${reservation.voyageurs} voyageur(s)\n'
                    '${date.day.toString().padLeft(2, '0')}/'
                    '${date.month.toString().padLeft(2, '0')}/'
                    '${date.year}',
                  ),
                  trailing: Text(
                    '${reservation.total} DT',
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
