/// @description Initialise l'etat et le mouvement du champignon.

state = STATES.IDLE;
move_x = 0;
max_speed = 1.25;
move_dir = choose(-1, 1);

// Le prochain changement d'etat est gere par l'alarme.
alarm[0] = irandom(room_speed * 2);