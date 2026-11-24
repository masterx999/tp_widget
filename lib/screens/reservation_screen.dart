
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/destination.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final Destination destination;
  final int voyageurs;

  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // Formulaire et contrôleurs
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  // États du Palier 4
  DateTime? _date;
  String _formule = 'Essentiel';
  bool _conditions = false;

  AutovalidateMode _autoValidation =
      AutovalidateMode.disabled;

  // Calcul du prix par personne
  int get _prixParPersonne =>
      _formule == 'Confort'
          ? (widget.destination.prix * 1.3).round()
          : widget.destination.prix;

  // Calcul du prix total
  int get _total =>
      _prixParPersonne * widget.voyageurs;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();

    super.dispose();
  }

  // Décoration des champs
  InputDecoration _deco(
    String label,
    IconData icone, {
    String? aide,
  }) {
    return InputDecoration(
      labelText: label,
      helperText: aide,
      prefixIcon: Icon(icone),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Validation du nom
  String? _validerNom(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Indiquez votre nom';
    }

    if (v.trim().length < 3) {
      return 'Au moins 3 caractères';
    }

    return null;
  }

  // Validation de l'e-mail
  String? _validerEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Indiquez votre e-mail';
    }

    if (!RegExp(
      r'^[\w.+-]+@[\w-]+\.[\w.]+$',
    ).hasMatch(v.trim())) {
      return 'E-mail invalide (ex. : nom@mail.tn)';
    }

    return null;
  }

  // Validation du téléphone
  String? _validerTel(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Indiquez votre téléphone';
    }

    if (v.trim().length != 8) {
      return '8 chiffres attendus';
    }

    return null;
  }

  // Choisir la date de départ
  Future<void> _choisirDate() async {
    final demain = DateTime.now().add(
      const Duration(days: 1),
    );

    final choix = await showDatePicker(
      context: context,
      initialDate: _date ?? demain,
      firstDate: demain,
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      helpText: 'Date de départ',
    );

    // Si l'utilisateur annule
    if (choix == null) return;

    // Enregistrer la date choisie
    setState(() {
      _date = choix;

      _dateCtrl.text =
          '${choix.day.toString().padLeft(2, '0')}/'
          '${choix.month.toString().padLeft(2, '0')}/'
          '${choix.year}';
    });
  }

  // Valider le formulaire
  void _valider() {
  if (!_formKey.currentState!.validate()) {
    setState(() {
      _autoValidation = AutovalidateMode.onUserInteraction;
    });

    return;
  }

  // TODO 1 : créer la réservation
  final reservation = Reservation(
    destination: widget.destination,
    nom: _nomCtrl.text.trim(),
    email: _emailCtrl.text.trim(),
    telephone: _telCtrl.text.trim(),
    dateDepart: _date!,
    voyageurs: widget.voyageurs,
    formule: _formule,
  );

  // TODO 2 : fermer l'écran et renvoyer la réservation
  Navigator.pop(context, reservation);
}
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver'),
      ),

      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Récapitulatif de la destination
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.destination.image,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.destination.nom,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),

                          const SizedBox(height: 4),

                          const Text('Durée : 3 jours'),

                          Text(
                            'Voyageurs : ${widget.voyageurs}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Votre voyage
              Text(
                'Votre voyage',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 16),

              // Date de départ
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _choisirDate,
                decoration: _deco(
                  'Date de départ',
                  Icons.calendar_month_outlined,
                ),
                validator: (_) =>
                    _date == null
                        ? 'Choisissez une date'
                        : null,
              ),

              const SizedBox(height: 24),

              // Nom complet
              TextFormField(
                controller: _nomCtrl,
                decoration: _deco(
                  'Nom complet',
                  Icons.person_outline,
                ),
                textCapitalization:
                    TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validerNom,
              ),

              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: _emailCtrl,
                decoration: _deco(
                  'E-mail',
                  Icons.email_outlined,
                ),
                keyboardType:
                    TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validerEmail,
              ),

              const SizedBox(height: 16),

              // Téléphone
              TextFormField(
                controller: _telCtrl,
                decoration: _deco(
                  'Téléphone',
                  Icons.phone_outlined,
                  aide: '8 chiffres, sans indicatif',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                textInputAction: TextInputAction.done,
                validator: _validerTel,
              ),

              const SizedBox(height: 24),

              // Choix de la formule
              Text(
                'Choisissez votre formule',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),

              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'Essentiel',
                    label: Text('Essentiel'),
                    icon: Icon(Icons.backpack_outlined),
                  ),

                  ButtonSegment<String>(
                    value: 'Confort',
                    label: Text('Confort +30 %'),
                    icon: Icon(Icons.hotel_outlined),
                  ),
                ],
                selected: {_formule},
                onSelectionChanged: (choix) {
                  setState(() {
                    _formule = choix.first;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Conditions d'annulation
              CheckboxListTile(
                value: _conditions,
                onChanged: (v) {
                  setState(() {
                    _conditions = v ?? false;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "J'accepte les conditions d'annulation",
                ),
                subtitle: const Text(
                  "Annulation gratuite jusqu'à 48 h avant",
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Barre inférieure : prix et confirmation
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                '$_prixParPersonne DT × ${widget.voyageurs}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),

              const SizedBox(height: 4),

              Text(
                '$_total DT',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      _conditions ? _valider : null,
                  icon: const Icon(
                    Icons.check_circle_outline,
                  ),
                  label: const Text('Confirmer'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
