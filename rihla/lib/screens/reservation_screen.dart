import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/destination.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  DateTime? _date;
  String _formule = 'Essentiel';
  bool _conditions = false;
  AutovalidateMode _autoValidation = AutovalidateMode.disabled;

  int get _prixParPersonne => _formule == 'Confort'
      ? (widget.destination.prix * 1.3).round()
      : widget.destination.prix;

  int get _total => _prixParPersonne * widget.voyageurs;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  InputDecoration _deco(String label, IconData icon, {String? aide}) {
    return InputDecoration(
      labelText: label,
      helperText: aide,
      prefixIcon: Icon(icon),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? _validerNom(String? value) {
    if (value == null || value.trim().isEmpty) return 'Indiquez votre nom';
    if (value.trim().length < 3) return 'Au moins 3 caractères';
    return null;
  }

  String? _validerEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Indiquez votre e-mail';
    }
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(value.trim())) {
      return 'E-mail invalide (ex. : nom@mail.tn)';
    }
    return null;
  }

  String? _validerTel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Indiquez votre téléphone';
    }
    if (value.trim().length != 8) return '8 chiffres attendus';
    return null;
  }

  void _valider() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidation = AutovalidateMode.onUserInteraction);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulaire valide')),
    );
  }

  Future<void> _choisirDate() async {
    final demain = DateTime.now().add(const Duration(days: 1));
    final choisie = await showDatePicker(
      context: context,
      initialDate: _date ?? demain,
      firstDate: demain,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Date de départ',
    );

    if (choisie == null) return;

    setState(() {
      _date = choisie;
      _dateCtrl.text =
          '${choisie.day.toString().padLeft(2, '0')}/${choisie.month.toString().padLeft(2, '0')}/${choisie.year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Réserver')),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.destination.nom,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.destination.duree,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.voyageurs} voyageurs',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Votre voyage',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Le champ reste en lecture seule pour forcer le choix au calendrier.
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _choisirDate,
                decoration: _deco(
                  'Date de départ',
                  Icons.calendar_month_outlined,
                ),
                validator: (_) =>
                    _date == null ? 'Choisissez une date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomCtrl,
                decoration: _deco('Nom complet', Icons.person_outline),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validerNom,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: _deco('E-mail', Icons.mail_outline),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validerEmail,
              ),
              const SizedBox(height: 16),
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
                validator: _validerTel,
              ),
              const SizedBox(height: 24),
              Text(
                'Formule',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Essentiel',
                    label: Text('Essentiel'),
                    icon: Icon(Icons.backpack_outlined),
                  ),
                  ButtonSegment(
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
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _conditions,
                onChanged: (value) {
                  setState(() {
                    _conditions = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text("J'accepte les conditions d'annulation"),
                subtitle: const Text("Annulation gratuite jusqu'à 48 h avant"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_prixParPersonne DT × ${widget.voyageurs}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_total DT',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _conditions ? _valider : null,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirmer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
