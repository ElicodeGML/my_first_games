/// @description Initialise le mouvement vertical de la plateforme.
randomise();
state = STATES.RUN;
vertical_dir = choose(-1, 1);
move_speed = 1.5;

active = true;