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
