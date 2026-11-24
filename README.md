<img width="485" height="644" alt="image" src="https://github.com/user-attachments/assets/7794e814-f74f-4143-9c6d-de4624605fb1" />
<img width="494" height="611" alt="image" src="https://github.com/user-attachments/assets/f732347d-a9f7-4712-acca-06d0faa7cfbd" />
<img width="492" height="602" alt="image" src="https://github.com/user-attachments/assets/dc7e4b0f-1844-40bc-8f40-509218aa6cc7" />
<img width="485" height="577" alt="image" src="https://github.com/user-attachments/assets/5dfb93cf-22e6-4127-8e11-f15750e33709" />
REPONSES DU TP RIHLА

PALIER 1-3 - WIDGETS ET ETAT

Q1. Après suppression temporaire de Expanded autour de la Column de HomeHeader,
où se place l'avatar ?
L'avatar se place juste après la Column, donc plus près du texte. Sans Expanded,
la Column prend seulement la largeur nécessaire à son contenu.

Q2. Pourquoi prenom est-il déclaré final ?
prenom est fourni au widget lors de sa construction et ne doit pas être modifié.
final empêche toute nouvelle affectation.

Q3. Quelle différence entre cs.primary et Colors.teal si la seedColor change ?
cs.primary est une couleur du thème Material 3 générée à partir de seedColor.
Elle change avec le thème. Colors.teal est une couleur fixe.

Q4. Que voit-on si DecoratedBox est placé en premier dans children ?
Le dégradé apparaît derrière les autres enfants. Dans un Stack, les premiers
enfants sont au fond et les suivants sont dessinés par-dessus.

Q5. Que change le retrait de ClipRRect ?
Le contenu n'est plus découpé selon les coins arrondis. Les bords deviennent
plus carrés ou peuvent dépasser visuellement les limites arrondies.

Q6. Pourquoi Positioned des textes utilise-t-il right: 130 ?
right: 130 réserve de l'espace horizontal à droite pour éviter que les textes
chevauchent le bouton situé en bas à droite.

Q7. Pourquoi la Row « note / prix » nécessite-t-elle une Column dans Expanded ?
Expanded donne à la Column tout l'espace horizontal disponible. Spacer peut
alors pousser le prix vers la droite.

Q8. Combien de lignes faut-il ajouter pour une 7e destination ? Dans quel fichier ?
Il faut ajouter un objet Destination dans la liste du fichier
lib/data/destinations.dart, puis éventuellement dans api/db.json pour l'API.

PALIER 5 - FILTRE PAR CATEGORIE

Q1. Que se passe-t-il si setState n'est pas utilisé ?
La variable change en mémoire, mais l'interface n'est pas reconstruite
immédiatement. La puce sélectionnée et la liste peuvent rester inchangées.

Q2. Pourquoi définir _filtrer comme getter ou méthode plutôt que créer une liste ?
Le résultat dépend directement de la catégorie courante. Il est recalculé lors
du build, ce qui évite une seconde liste susceptible d'être désynchronisée.

Q3. Pourquoi les cartes sont-elles des StatelessWidget ?
Elles affichent les données reçues dans leurs paramètres. Le parent reconstruit
les widgets lorsque ces données changent; elles n'ont pas besoin d'état mutable.

PALIER 6 - FAVORIS ET CLES

Q1. Pourquoi une clé est-elle nécessaire ?
Sans clé, Flutter peut associer l'état d'un enfant à sa position. Après un
filtrage, l'état favori risque d'être affiché sur une mauvaise destination.
Une ValueKey unique permet à Flutter de suivre chaque carte par son identifiant.

TP5 - API REST

PALIER 0 - REQUETES HTTP

Q1. Quel code renvoie /destinations/99 si la destination n'existe pas ?
404 Not Found, un code de la famille 4xx indiquant une ressource ou une requête
incorrecte.

Q2. Qui choisit l'identifiant de la réservation ?
Le serveur attribue l'identifiant lors du POST. Le client envoie les autres
champs, puis reçoit l'identifiant avec une réponse 201 Created.

Q3. Pourquoi le GET n'a-t-il pas de corps alors que le POST en a un ?
Le GET demande une lecture et utilise généralement l'URL et ses paramètres.
Le POST contient dans son corps JSON les champs nécessaires à la création.

PALIER 2 - MODELE ET JSON

Q1. Pourquoi fromJson est-il un constructeur factory ?
Il convertit une Map<String, dynamic> externe en objet Destination. Il peut
valider ou convertir les valeurs avant de créer et retourner l'instance.

Q2. Que se passe-t-il si le JSON contient "prix": "420" ?
La propriété attend un nombre. La chaîne provoque une erreur de conversion
dans la conversion par cast. Il faut corriger les données ou convertir et
valider explicitement la chaîne.

Q3. Pourquoi getDestinations retourne-t-il Future<List<Destination>> ?
La requête réseau est asynchrone. Future représente le résultat disponible
plus tard, après réception et conversion de la réponse.

PALIER 3 - CHARGEMENT

Q1. Pourquoi _futurDestinations est-il déclaré late ?
Il est initialisé dans initState, après la création de State, puis reutilisé
dans les reconstructions sans lancer une nouvelle requête à chaque build.

Q2. Que verrait l'utilisateur si snapshot.hasError n'était pas testé ?
L'échec réseau serait mal présenté. L'écran pourrait rester bloqué ou tenter
d'utiliser des données absentes au lieu d'afficher l'erreur.

Q3. Le changement de catégorie lance-t-il une nouvelle requête ?
Non. Le filtre travaille en mémoire sur la liste déjà téléchargée.

PALIER 4 - CREATION D'UNE RESERVATION

Q1. Pourquoi envoyer destinationId plutôt que toute la destination ?
La réservation référence la destination par son identifiant. Le serveur évite
ainsi de dupliquer tous les détails dans chaque réservation.

Q2. Que se passe-t-il si Content-Type est oublié ?
Le serveur peut ne pas reconnaître le format JSON du corps et rejeter ou
mal interpréter la requête. Content-Type: application/json l'informe du format.

Q3. Pourquoi vérifier mounted après await ?
L'utilisateur peut avoir quitté l'écran pendant la requête. mounted vérifie
que le State est toujours actif avant d'utiliser context.

PALIER 5 - AFFICHAGE DES RESERVATIONS

Q1. Comment retrouver la destination de chaque réservation ?
La requête /reservations?_expand=destination demande à json-server d'inclure
l'objet destination lié. Reservation.fromJson convertit cet objet imbriqué.

Q2. Pourquoi convertir dateDepart avec DateTime.parse ?
L'API fournit une chaîne ISO 8601. DateTime.parse la transforme en objet
DateTime utilisable pour calculer ou afficher une date lisible.

Q3. Pourquoi l'onglet Voyages gère-t-il chargement, erreur et données ?
Les réservations proviennent du réseau. La requête peut être en attente,
échouer, être vide ou contenir des données. Chaque état nécessite une réponse
adaptée à l'utilisateur.

