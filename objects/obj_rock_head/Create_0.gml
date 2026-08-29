/// @description Initialise la direction et la vitesse du rocher.

state = STATES.IDLE;

// Le rocher choisit une direction verticale au debut de la room.
dir = [180, 0, 90, 270];
my_dir = 0;

speed = 0;
move_speed = 5;

alarm[0] = room_speed;