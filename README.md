# rihla

A new Flutter project.

Q1. Supprimez temporairement le Expanded autour de la Column de HomeHeader. Où se place l'avatar ? Pourquoi ?
L’avatar se place juste après la Column, dans la Row. Sans Expanded, la Column prend uniquement la largeur nécessaire à son contenu. L’avatar se retrouve donc plus proche du texte, au lieu d’être poussé vers le bord droit.

Q2. Pourquoi prenom est-il déclaré final ?
prenom est déclaré final parce que sa valeur est reçue lors de la création du widget et ne doit plus être modifiée ensuite. Cela correspond au principe du StatelessWidget, qui affiche des données reçues en paramètres.


Q3. Quelle différence entre cs.primary et Colors.teal si on change la seedColor du thème ?
- cs.primary utilise la couleur principale générée par le thème Material 3. Si on change la seedColor, cette couleur s’adapte automatiquement.
- Colors.teal est une couleur fixe. Elle reste la même même si on change la seedColor.

- Q4. Placez le DecoratedBox en premier dans la liste children. Que voyez-vous ? Pourquoi ?
Le dégradé apparaît derrière les autres éléments, car dans un Stack, le premier enfant est placé au fond et les enfants suivants sont affichés par-dessus.
Le DecoratedBox doit donc être placé après l’image pour assombrir celle-ci et rendre les textes blancs plus lisibles.

Q5. Retirez ClipRRect. Qu'est-ce qui change ?
Les coins de l’image ou de la bannière ne sont plus découpés selon le rayon défini. Les bords deviennent carrés ou peuvent dépasser visuellement des coins arrondis.
ClipRRect sert à découper le contenu en respectant les coins arrondis.

Q6. Pourquoi le Positioned des textes a-t-il right: 130 ?
La propriété right: 130 réserve un espace de 130 pixels logiques entre le bord droit du parent et le texte. Cela permet de contrôler sa position horizontale, notamment pour éviter qu’il ne chevauche un autre élément placé à droite.

Execution du travail :


<img width="1919" height="1079" alt="Capture d&#39;écran 2026-10-14 193539" src="https://github.com/user-attachments/assets/ad2b3f73-9735-4931-b20c-8bcf19a1b5bc" />

Execution du palier 5: 


<img width="1917" height="1078" alt="Capture d&#39;écran 2026-10-20 102456" src="https://github.com/user-attachments/assets/aed214eb-52ef-4755-af7b-05c3d4a929cc" />
<img width="1917" height="1078" alt="Capture d&#39;écran 2026-10-20 094908" src="https://github.com/user-attachments/assets/470adb75-0822-4fc0-b571-c3c5f777ce73" />
<img width="1917" height="1067" alt="Capture d&#39;écran 2026-10-20 094900" src="https://github.com/user-attachments/assets/b9332c52-158b-441c-b62d-5682ee3281fa" />


Execution du palier 6:


<img width="1917" height="1078" alt="Capture d&#39;écran 2026-10-20 102505" src="https://github.com/user-attachments/assets/b1249fac-0c1b-4644-b28f-7fec635de3da" />


Execution du palier 7:

<img width="1912" height="1078" alt="Capture d&#39;écran 2026-10-20 104207" src="https://github.com/user-attachments/assets/022f4f7f-e708-44d3-85e6-4b9dc1eb1a8b" />
<img width="1917" height="1078" alt="Capture d&#39;écran 2026-10-20 104202" src="https://github.com/user-attachments/assets/beadaf76-5a56-42ae-9fc7-b9b7bb368594" />




Execution du Devoir : 

<img width="943" height="1078" alt="image" src="https://github.com/user-attachments/assets/7f6b9d1a-3270-4ab7-b807-ff85cf46ac3c" />

