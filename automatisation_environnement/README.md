#Projet 1 : Script d'Automatisation d'Environnement (Piscine ETNA)

Ce projet fournit un script de déploiement modulaire, robuste et **entièrement non interactif** permettant d'installer et de configurer automatiquement un environnement de développement complet sur une machine **Debian vierge**.Normalement, il est utilisable par tout étudiant de l'ETNA.

##Fonctionnalités

Le script orchestre plusieurs sous-scripts pour automatiser les tâches suivantes :
*   **Mise à jour système** : Actualisation automatique des dépôts et mise à niveau des paquets existants.
*   **Gestion intelligente des paquets** : Vérification des paquets déjà installés pour ne télécharger que le strict nécessaire (`git`, `curl`, `wget`, `zsh`, `vim`).
*   **Configuration de Git** : Paramétrage global automatique de l'identité utilisateur, de la branche par défaut et de l'éditeur.
*   **Sécurisation SSH** : Vérification de l'accès auprès de GitLab ETNA, génération d'une paire de clés Ed25519 (sans passphrase) et configuration de l'agent SSH si nécessaire.
*   **Personnalisation de Vim** : Configuration non interactive des options ergonomiques essentielles (`set number`, `set mouse=a`).
*   **Environnement Zsh (Oh My Zsh)** : Installation automatisée sans interruption de session, ajout de plugins de productivité (`syntax-highlighting`, `autosuggestions`), configuration du thème graphique `bira` et injection d'alias personnalisés.

---

##Architecture du Projet

```text
.
├── setup.sh                  # Script principal (Orchestrateur)
├── README.md                 # Documentation du projet
├── logs/                     # Traces d'exécution (généré automatiquement)
│   ├── a_installer.txt       # Liste brute des paquets manquants
│   ├── déja_installé.txt     # Liste brute des paquets déjà présents
│   ├── installé.txt          # Liste brute des paquets installés par le script
│   └── logs.txt              # Rapport complet et chronologique de la console (Nouveauté)
└── sous_script/              # Scripts modulaires spécialisés
    ├── git_config.sh
    ├── installed.sh
    ├── installer.sh
    ├── oh_my_zsh.sh
    ├── ssh.sh
    ├── update.sh
    └── vim.sh
```

---

## Utilisation

### Prérequis
Le script doit impérativement être exécuté avec les privilèges d'administrateur (**`sudo`**) afin de pouvoir installer les paquets système et modifier les configurations des espaces utilisateurs.

### Exécution
Pour lancer l'installation complète, exécutez la commande suivante à la racine du projet :

```bash
sudo ./setup.sh
```

---

## Propriétés Techniques Clés

*   **Idempotence** : Le script peut être exécuté plusieurs fois d'affilée sans aucune erreur. Les fichiers de configuration (`.vimrc`, `.zshrc`) et les configurations Git ou SSH sont protégés contre la duplication de lignes et l'écrasement de données.
*   **Zéro Interaction** : Conçu pour les déploiements automatisés. Les commandes interactives par défaut (`apt`, `ssh-keygen`, Oh My Zsh) ont été configurées avec des drapeaux spécifiques (`--unattended`, `-y`, `-N ""`) pour interdire tout blocage humain.
*   **Journalisation centralisée (`tee -a`)** : Toutes les étapes du déploiement sont affichées en temps réel à l'écran et simultanément sauvegardées de manière chronologique dans le fichier **`logs/logs.txt`** pour faciliter le débogage post-installation.
*   **Sécurité des flux (`pipefail`)** : Le script utilise l'option `set -o pipefail`. Cela garantit que si un sous-script échoue au milieu d'un tube de commande (`| tee`), l'erreur n'est pas masquée et le script principal interrompt immédiatement son exécution pour éviter un déploiement corrompu.
*   **Gestion fine des droits** : Bien que lancé en `root`, le script identifie l'utilisateur initial à l'origine du `sudo` via la variable `$SUDO_USER` pour s'assurer que les fichiers de configuration de l'espace utilisateur conservent les bonnes permissions d'accès.
