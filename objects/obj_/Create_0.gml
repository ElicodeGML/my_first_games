/// @description Initialise l'etat et les parametres de mouvement du joueur.

// Etat courant et informations de collision.
state = STATES.IDLE;
touch_floor = false;
touch_platform = false;
wall_dir = 0;

// Mouvement horizontal.
move_speed = 3.5;
move_dir = 0;
move_x = 0;
image_alpha = 1;
image_angle = 0;

// Mouvement vertical.
jump_speed = -8;
fall_speed = 0.5;
move_y = 0;
can_doble_jump = true;
animation_ended = false;

// Plateforme actuellement porteuse.
platform_id = noone;

// On stocke l'ID technique de votre calque de tuiles existant
tilemap_terrain = layer_tilemap_get_id("t_terrain");
