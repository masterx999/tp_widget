<img width="525" height="697" alt="cap1" src="https://github.com/user-attachments/assets/a918bf0c-0ca4-439c-ab7d-ff92a857c6a1" />Questions de compréhension (réponses en commentaire dans le code) 
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


