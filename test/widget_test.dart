import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rihla/main.dart';
import 'package:rihla/models/destination.dart';
import 'package:rihla/screens/detail_screen.dart';
import 'package:rihla/services/api_service.dart';
import 'package:rihla/widgets/destination_card.dart';

const testDestinations = [
  Destination(
    id: '1',
    nom: 'Sidi Bou Saïd',
    region: 'Tunis',
    categorie: 'Patrimoine',
    image: 'assets/images/sidi_bou_said.png',
    note: 4.9,
    prix: 180,
    duree: '1 jour',
    description: 'Village blanc au-dessus du golfe de Tunis.',
  ),
  Destination(
    id: '2',
    nom: 'Djerba',
    region: 'Médenine',
    categorie: 'Plage',
    image: 'assets/images/djerba.png',
    note: 4.8,
    prix: 420,
    duree: '4 jours',
    description: 'Plages de sable fin et eaux turquoise.',
  ),
  Destination(
    id: '3',
    nom: 'Tozeur',
    region: 'Tozeur',
    categorie: 'Désert',
    image: 'assets/images/tozeur.png',
    note: 4.7,
    prix: 350,
    duree: '3 jours',
    description: 'Porte du Sahara et palmeraie.',
  ),
  Destination(
    id: '4',
    nom: 'El Jem',
    region: 'Mahdia',
    categorie: 'Patrimoine',
    image: 'assets/images/el_jem.png',
    note: 4.8,
    prix: 120,
    duree: '1 jour',
    description: 'Amphithéâtre romain inscrit à l’UNESCO.',
  ),
  Destination(
    id: '5',
    nom: 'Douz',
    region: 'Kébili',
    categorie: 'Désert',
    image: 'assets/images/douz.png',
    note: 4.6,
    prix: 390,
    duree: '3 jours',
    description: 'Dunes et nuit sous tente.',
  ),
  Destination(
    id: '6',
    nom: 'Hammamet',
    region: 'Nabeul',
    categorie: 'Plage',
    image: 'assets/images/hammamet.png',
    note: 4.5,
    prix: 260,
    duree: '2 jours',
    description: 'Médina fortifiée au bord de la mer.',
  ),
];

Map<String, dynamic> _destinationToJson(Destination destination) => {
  'id': destination.id,
  'nom': destination.nom,
  'region': destination.region,
  'categorie': destination.categorie,
  'image': destination.image,
  'note': destination.note,
  'prix': destination.prix,
  'duree': destination.duree,
  'description': destination.description,
};

ApiService _createApiService() {
  return ApiService(
    client: MockClient((request) async {
      if (request.method == 'GET' && request.url.path == '/destinations') {
        return http.Response(
          jsonEncode(testDestinations.map(_destinationToJson).toList()),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
      if (request.method == 'GET' && request.url.path == '/reservations') {
        return http.Response('[]', 200);
      }
      return http.Response('Not found', 404);
    }),
  );
}

void main() {
  late ApiService apiService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    apiService = _createApiService();
  });

  tearDown(() {
    apiService.close();
  });

  testWidgets('home filters destinations by category', (tester) async {
    tester.view.physicalSize = const Size(400, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(RihlaApp(apiService: apiService));
    await tester.pumpAndSettle();

    expect(find.text('Ahlan, Rayen 👋'), findsOneWidget);
    expect(find.text('Populaires'), findsOneWidget);
    expect(find.byType(DestinationCard), findsNWidgets(6));

    await tester.tap(find.widgetWithText(ChoiceChip, 'Désert'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ChoiceChip, 'Désert'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Désert'))
          .selected,
      isTrue,
    );
    expect(find.byType(DestinationCard), findsNWidgets(2));
    expect(find.text('Tozeur'), findsWidgets);
    expect(find.text('Douz'), findsWidgets);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tout'));
    await tester.pumpAndSettle();
    expect(find.byType(DestinationCard), findsNWidgets(6));
  });

  testWidgets('favorite button toggles and shows feedback', (tester) async {
    tester.view.physicalSize = const Size(400, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(RihlaApp(apiService: apiService));
    await tester.pumpAndSettle();

    final favoriteButton = find.byTooltip('Ajouter aux favoris').first;
    await tester.tap(favoriteButton);
    await tester.pump();

    expect(find.byTooltip('Retirer des favoris').first, findsOneWidget);
    expect(find.text('Ajouté aux favoris'), findsOneWidget);

    await tester.tap(find.byTooltip('Retirer des favoris').first);
    await tester.pump();
    expect(find.text('Retiré des favoris'), findsOneWidget);
    expect(find.byTooltip('Ajouter aux favoris').first, findsOneWidget);
  });

  testWidgets('favorite stays with its destination when filtering', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(RihlaApp(apiService: apiService));
    await tester.pumpAndSettle();

    final tozeurCard = find.byKey(const ValueKey('3'));
    await tester.tap(
      find.descendant(
        of: tozeurCard,
        matching: find.byTooltip('Ajouter aux favoris'),
      ),
    );
    await tester.pump();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Désert'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('3')),
        matching: find.byTooltip('Retirer des favoris'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tout'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('3')),
        matching: find.byTooltip('Retirer des favoris'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('bottom navigation switches tabs', (tester) async {
    await tester.pumpWidget(RihlaApp(apiService: apiService));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favoris'));
    await tester.pumpAndSettle();
    expect(find.text('Bientôt disponible'), findsOneWidget);

    await tester.tap(find.text('Explorer'));
    await tester.pumpAndSettle();
    expect(find.text('Ahlan, Rayen 👋'), findsOneWidget);
  });

  testWidgets('detail screen updates traveler count and total', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: DetailScreen(
          destination: testDestinations[1],
          apiService: apiService,
        ),
      ),
    );

    expect(find.text('Djerba'), findsOneWidget);
    expect(find.text('420 DT'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(find.byKey(const ValueKey('traveler-decrease')))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('traveler-increase')));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('840 DT'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('traveler-decrease')));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('420 DT'), findsOneWidget);
  });

  testWidgets('destination card opens its detail screen', (tester) async {
    tester.view.physicalSize = const Size(400, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(RihlaApp(apiService: apiService));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Djerba'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailScreen), findsOneWidget);
    expect(find.text(testDestinations[1].description), findsOneWidget);
    expect(find.text('420 DT'), findsOneWidget);
  });
}
