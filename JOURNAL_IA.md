# Journal IA — TP5 Rihla (API REST)

> Brouillon d'aide pour les questions du sujet. Les réponses et explications
> sont proposées par l'IA : relisez-les, vérifiez-les et reformulez la dernière
> colonne avec vos propres mots avant de remettre le journal.

| Question posée à l'IA | Réponse utile | Ce que j'ai compris (à reformuler) |
| --- | --- | --- |
| **Palier 0 —** Quel code renvoie `/destinations/99` ? À quelle famille appartient-il ? | Si aucune destination n'a cet identifiant, json-server renvoie `404 Not Found`. C'est un code HTTP de la famille `4xx`, qui indique une erreur côté requête/ressource demandée. | À compléter avec mes mots : que signifie « ressource introuvable » ? |
| **Palier 0 —** Qui choisit l'identifiant de la réservation créée : moi ou le serveur ? | Le serveur json-server attribue l'identifiant au POST. Le client envoie les champs de réservation, sans `id`, puis lit l'`id` dans la réponse `201 Created`. | À compléter avec mes mots : pourquoi ne pas inventer l'identifiant dans l'application ? |
| **Palier 0 —** Pourquoi le GET n'a-t-il pas de corps contrairement au POST ? | GET demande une représentation d'une ressource; le chemin et les paramètres identifient les données à lire. POST crée une ressource : son corps JSON contient les champs à enregistrer. | À compléter avec mes mots : quel rôle joue le corps JSON du POST ? |
| **Palier 2 —** Pourquoi `fromJson` est-il un constructeur `factory` ? | Il convertit une représentation externe (`Map<String, dynamic>`) en objet `Destination` et peut contrôler ou convertir les valeurs avant de renvoyer l'instance. Le code appelant n'a pas à connaître les détails de conversion. | À compléter avec mes mots : quelles conversions fait `Destination.fromJson` ? |
| **Palier 2 —** Que se passe-t-il si le JSON contient `"prix": "420"` au lieu d'un nombre ? | Le modèle attend une valeur `num` pour `prix`. Une chaîne n'est pas un nombre JSON et le cast échoue : la conversion signale une erreur plutôt que d'inventer une valeur. Il faut corriger les données ou ajouter une conversion explicitement validée. | À compléter avec mes mots : pourquoi un prix texte ne doit-il pas être accepté silencieusement ? |
| **Palier 2 —** Pourquoi `getDestinations` renvoie-t-il `Future<List<Destination>>` ? | Une requête réseau prend du temps et se termine plus tard. Le `Future` représente ce résultat futur; lorsqu'il arrive, il contient la liste convertie. Une `List` immédiate ne peut pas représenter l'attente de la réponse HTTP. | À compléter avec mes mots : que représente le `Future` pendant l'attente du serveur ? |
| **Palier 3 —** Pourquoi déclarer `_futurDestinations` avec `late` ? | La requête est créée une fois dans `initState`, après que l'état existe. `late` permet de déclarer le champ non nullable avant cette initialisation différée; le `Future` est ensuite réutilisé pendant les reconstructions. | À compléter avec mes mots : pourquoi ne pas lancer le GET à chaque `build()` ? |
| **Palier 3 —** Que verrait l'utilisateur sans tester `snapshot.hasError` quand le serveur est arrêté ? | Il ne verrait pas un état d'erreur utile. L'interface pourrait rester bloquée, afficher un état incorrect ou tenter d'utiliser des données absentes. Le contrôle permet d'expliquer la panne et de proposer une nouvelle tentative. | À compléter avec mes mots : quel message et quelle action l'écran d'erreur propose-t-il ? |
| **Palier 3 —** Le changement de catégorie lance-t-il une nouvelle requête ? Pourquoi ? | Non. La liste téléchargée est filtrée localement en mémoire; changer de puce reconstruit l'écran à partir de cette liste et ne rappelle pas l'API. Une nouvelle requête est réservée au rafraîchissement ou à une tentative après erreur. | À compléter avec mes mots : quelle différence entre filtrage local et demande au serveur ? |
| **Palier 4 —** Pourquoi envoyer `destinationId` plutôt que toute la destination ? | La réservation référence la destination par son identifiant. Le serveur peut ainsi relier les deux ressources sans recopier tous les détails de destination dans chaque réservation. L'API peut ensuite inclure la destination avec `_embed`. | À compléter avec mes mots : que représente cette relation entre deux ressources ? |
| **Palier 4 —** Que se passe-t-il si l'en-tête `Content-Type` est oublié ? | Le client n'indique plus que le corps est du JSON. Le serveur ou un autre endpoint peut alors ne pas le décoder comme prévu et la création peut échouer ou produire des données incorrectes. Il faut envoyer `application/json` avec le corps encodé. | À compléter avec mes mots : comment le client signale-t-il le format du corps ? |
| **Palier 4 —** Pourquoi vérifier `mounted` après `await creerReservation` ? | Pendant l'attente réseau, l'écran peut être retiré de l'arbre (navigation retour). Un état retiré ne doit pas afficher de dialogue ou de SnackBar en utilisant son `context`; `mounted` vérifie que l'écran est encore actif. | À compléter avec mes mots : que peut faire l'utilisateur pendant l'attente ? |
| **Palier 5 —** Comment retrouver la destination de chaque réservation ? | La requête `/reservations?_embed=destination` demande à json-server d'inclure l'objet destination lié par `destinationId`. `Reservation.fromJson` convertit cet objet imbriqué avec `Destination.fromJson`. | À compléter avec mes mots : pourquoi le modèle réutilise-t-il le convertisseur de destination ? |
| **Palier 5 —** Pourquoi convertir `dateDepart` avec `DateTime.parse` ? | L'API transporte la date sous forme de chaîne ISO 8601. `DateTime.parse` la convertit en date exploitable par Dart, que l'écran peut afficher au format `jj/mm/aaaa`. | À compléter avec mes mots : quelle est la différence entre la date ISO de l'API et celle affichée ? |
| **Palier 5 —** Pourquoi l'onglet Voyages a-t-il les mêmes états de chargement, erreur et données ? | La liste vient elle aussi du réseau : elle peut être en attente, échouer si le serveur est indisponible, être vide ou contenir des réservations. Le même schéma `FutureBuilder` et le même widget d'erreur rendent chaque état visible et réessayable. | À compléter avec mes mots : que voit-on quand aucune réservation n'existe ? |

## Résumé de l'aide reçue

J'ai demandé de l'aide pour terminer l'application à partir du projet et des
ressources fournies. L'assistant a identifié les paliers REST du sujet, expliqué
les conversions JSON, les requêtes HTTP et les états de chargement, puis aidé à
les intégrer et à vérifier le projet. Les tests utilisent une API simulée; pour
la démonstration, il faut aussi lancer json-server depuis `api/`.

**Ma reformulation personnelle de ce que j'ai appris :** à compléter avant la
remise.
