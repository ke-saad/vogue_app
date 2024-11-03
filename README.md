### Coordonnées de test
Voici les identifiants de deux utilisateurs pour tester l'application :

- **Utilisateur 1 :**
   - Login : `user1@gmail.com`
   - Mot de passe : `123456`

- **Utilisateur 2 :**
   - Login : `user2@gmail.com`
   - Mot de passe : `azerty`

### Observations
1. Lorsque vous modifiez le mot de passe sur l'écran des informations de profil, en cliquant sur le bouton "Valider", il vous sera demandé de saisir le mot de passe actuel. Cela est nécessaire pour une réauthentification via Firebase Auth. Toutefois, si vous ne modifiez pas le mot de passe, vous pouvez mettre à jour les autres informations sans avoir à entrer le mot de passe actuel.

2. La précision du modèle utilisé pour la classification des articles est limitée, ce qui signifie qu'il peut parfois commettre des erreurs lors du processus de classification.
