import 'package:flutter/material.dart';

import '../models/reservation.dart';
import '../services/api_service.dart';
import '../widgets/network_error.dart';

class MesReservationsScreen extends StatefulWidget {
  const MesReservationsScreen({super.key, required this.apiService});

  final ApiService apiService;

  @override
  State<MesReservationsScreen> createState() => _MesReservationsScreenState();
}

class _MesReservationsScreenState extends State<MesReservationsScreen> {
  late Future<List<Reservation>> _futurReservations;

  @override
  void initState() {
    super.initState();
    _futurReservations = widget.apiService.getReservations();
  }

  Future<void> _recharger() {
    final futur = widget.apiService.getReservations();
    setState(() {
      _futurReservations = futur;
    });
    return futur.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        // FutureBuilder displays the failure while the refresh indicator stops.
      },
    );
  }

  String _dateFormatee(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';

  Widget _construireCarte(Reservation reservation) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                reservation.destination.image,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reservation.destination.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Départ : ${_dateFormatee(reservation.dateDepart)}'),
                  Text(
                    '${reservation.voyageurs} voyageurs · ${reservation.formule}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${reservation.total} DT',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes voyages')),
      body: FutureBuilder<List<Reservation>>(
        future: _futurReservations,
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

          final reservations = snapshot.data ?? const <Reservation>[];
          if (reservations.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recharger,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 220),
                  Center(child: Text('Aucune réservation pour le moment')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: reservations.length,
              itemBuilder: (context, index) =>
                  _construireCarte(reservations[index]),
            ),
          );
        },
      ),
    );
  }
}
