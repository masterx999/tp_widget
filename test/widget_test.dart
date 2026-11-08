import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rihla/data/destinations.dart';
import 'package:rihla/main.dart';
import 'package:rihla/screens/detail_screen.dart';
import 'package:rihla/widgets/destination_card.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('home filters destinations by category', (tester) async {
    tester.view.physicalSize = const Size(400, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const RihlaApp());

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

    await tester.pumpWidget(const RihlaApp());

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

    await tester.pumpWidget(const RihlaApp());

    final tozeurCard = find.byKey(const ValueKey('Tozeur'));
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
        of: find.byKey(const ValueKey('Tozeur')),
        matching: find.byTooltip('Retirer des favoris'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tout'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('Tozeur')),
        matching: find.byTooltip('Retirer des favoris'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('bottom navigation switches tabs', (tester) async {
    await tester.pumpWidget(const RihlaApp());

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
      MaterialApp(home: DetailScreen(destination: destinations[1])),
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

    await tester.pumpWidget(const RihlaApp());
    await tester.tap(find.text('Djerba'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailScreen), findsOneWidget);
    expect(find.text(destinations[1].description), findsOneWidget);
    expect(find.text('420 DT'), findsOneWidget);
  });
}
