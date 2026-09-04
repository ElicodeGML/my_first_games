# My First Games

Jeu de plateforme 2D développé dans l’environnement GameMaker, inspiré par les mécaniques classiques des jeux de plateforme et conçu comme un projet personnel de découverte et de création.

## Description

Le projet consiste à explorer et à assembler les éléments fondamentaux d’un jeu vidéo : déplacement, sauts, collisions, ennemis, collecte d’objets, système de score et progression dans plusieurs salles. L’objectif principal est de créer une expérience simple, fluide et jouable, tout en testant les mécanismes de base d’un jeu de plateforme.

## Fonctionnalités

- Déplacement latéral avec le clavier
- Saut standard et double saut
- Accroche au mur et gestion de l’état de chute
- Détection de collisions avec le terrain et les plateformes
- Collecte de fruits pour augmenter le score
- Système de checkpoints et de redémarrage
- Ennemis avec réaction au contact
- Génération de collisions à partir de la tilemap
- Interface HUD avec affichage du score

## Contrôles

- Flèches gauche / droite : déplacement
- Espace : saut / double saut
- R : redémarrage du niveau

## Mécaniques du jeu

Le personnage dispose d’un système de mouvement complet avec gestion des états de repos, course, saut, chute, double saut et accroche sur mur. Les collisions sont calculées avec la tilemap et les plateformes porteuses, ce qui permet une progression plus solide et plus fiable dans les niveaux.

La collecte des objets donne un retour immédiat au joueur via le score, et les éléments visuels de l’interface permettent de garder une bonne lisibilité pendant la partie.

Les ennemis ajoutent un niveau de difficulté supplémentaire et le joueur doit gérer les contacts avec prudence. Le jeu met aussi en place une logique de checkpoint pour offrir une meilleure expérience de jeu et une reprise plus naturelle après une erreur.

## Structure du projet

- objects : personnages, ennemis, objets collectables, systèmes de jeu et collisions
- rooms : salles du jeu
- sprites : visuels du personnage, des objets et des éléments environnementaux
- tilesets : éléments de terrain et décors
- scripts : génération procédurale et logique de collisions

## Objectif du projet

Ce projet sert de base de démonstration et de prototype de jeu de plateforme. Il permet de mettre en pratique des notions de programmation de jeux, de gestion des états, de physique simple et de conception de niveaux dans un environnement orienté création de jeux.

## Technologies

- GameMaker
- GML (GameMaker Language)
- Sprites et tilemaps
- Système de collisions et gestion d’états

## Remerciements

Ce projet a été conçu comme un premier pas dans le développement de jeux vidéo, avec un focus sur l’apprentissage de la logique de gameplay, des interactions et de la structure d’un projet de jeu.
