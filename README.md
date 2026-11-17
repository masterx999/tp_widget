# Rihla

Application Flutter de découverte de destinations en Tunisie. Les destinations
et réservations sont chargées depuis une API REST locale simulée par
`json-server`.

## Fonctionnalités

- Découverte des destinations, filtrage par catégorie et favoris.
- Fiche détaillée, formulaire de réservation et confirmation avec numéro serveur.
- Onglet Voyages avec les réservations enregistrées et rafraîchissement.
- États de chargement, erreur réseau avec nouvelle tentative et liste vide.

Les images des six destinations sont déclarées dans `assets/images/`.

## Démarrer l'API

Prérequis : Node.js 18 ou plus. Dans un terminal, depuis la racine du projet :

```sh
cd api
npx json-server db.json
```

Laissez ce terminal ouvert. L'API est disponible sur `http://localhost:3000`,
avec les ressources `/destinations` et `/reservations`.

## Lancer l'application

Dans un second terminal, depuis la racine du projet :

```sh
flutter pub get
flutter run
```

L'adresse de l'API est configurée pour Chrome/Windows et l'émulateur Android.
Sur un téléphone réel, remplacez l'adresse dans `lib/config/api_config.dart`
par l'adresse IP locale du PC et lancez json-server avec `--host 0.0.0.0`.

## Vérifier le projet

```sh
flutter test
flutter analyze
```
