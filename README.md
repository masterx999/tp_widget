Q1. Supprimez temporairement le Expanded autour de la Column de HomeHeader. Où se place
l'avatar ? Pourquoi ?
Q2. Pourquoi prenom est-il déclaré final ?
Q3. Quelle différence entre cs.primary et Colors.teal si on change la seedColor du thème ?
REPONSE
Q1 — Expanded : occupe l'espace horizontal restant et repousse l'avatar vers la droite.
Q2 — final : empêche la réaffectation de la propriété prenom.
Q3 — cs.primary : couleur liée au thème ; Colors.teal : couleur fixe.
QUESTIONS
Q4. Placez le DecoratedBox en premier dans la liste children. Que voyez-vous ? Pourquoi ?
Q5. Retirez ClipRRect. Qu'est-ce qui change ?
Q6. Pourquoi le Positioned des textes a-t-il right: 130 ?
REPONSE
Q4 : dans un Stack, l'ordre des enfants détermine leur superposition.
Q5 : ClipRRect découpe le contenu pour conserver les coins arrondis.
Q6 : right: 130 réserve de l'espace au bouton situé en bas à droite.
QUESTIONS
Q7. Pourquoi la Row « note / prix » a-t-elle besoin que la Column soit dans un Expanded pour que
Spacer fonctionne ?
Q8. Combien de lignes faudrait-il ajouter pour afficher une 7e destination ? Dans quel fichier ?
Q7 : Expanded fournit l'espace disponible nécessaire à Spacer() pour pousser le prix vers la droite.

<img width="514" height="584" alt="cap2" src="https://github.com/user-attachments/assets/7ae47c3a-df92-473b-9cfd-7cd441f59825" />
<img width="525" height="697" alt="cap1" src="https://github.com/user-attachments/assets/85d726ff-b927-4766-93af-c121a99035b9" />

Palier 5 — Filtre par catégorie
Q1
La variable change en mémoire, mais Flutter ne reconstruit pas l’écran immédiatement : la puce cochée et la liste affichée peuvent donc rester inchangées jusqu’à une autre reconstruction.
Q2
Parce que la liste filtrée dépend de la catégorie courante. Le getter la dérive de l’état actuel sans devoir conserver une deuxième variable qui pourrait devenir désynchronisée.
Q3
Il n’a pas d’état mutable propre. Il affiche la destination qu’il reçoit en paramètre ; lorsque son parent se reconstruit, Flutter peut reconstruire la bannière avec ses nouvelles données.
Palier 6 — Favoris et clés
Q1
Sans clé, Flutter peut associer l’état d’un enfant à sa position dans la liste. Après un filtre, l’état d’un bouton favori risque alors d’apparaître sur une autre destination. La clé permet à Flutter de reconnaître chaque carte par destination et de garder le favori associé à la bonne.

<img width="478" height="573" alt="Capture d’écran_8-11-2026_152615_localhost" src="https://github.com/user-attachments/assets/a4e8767b-6792-4e13-8190-8113953d53e0" />
<img width="486" height="576" alt="Capture d’écran_8-11-2026_152318_localhost" src="https://github.com/user-attachments/assets/a164c96e-7ba8-4f13-9a9e-d80eedcfb0f0" />
<img width="476" height="572" alt="Capture d’écran_8-11-2026_15329_localhost" src="https://github.com/user-attachments/assets/121f11dc-d493-48cb-a272-1a4342c17bb1" />
