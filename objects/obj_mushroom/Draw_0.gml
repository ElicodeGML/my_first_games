/// @description Affiche le champignon selon son etat.

switch (state) {
	case STATES.IDLE : sprite_index = Mushroom_Idle; break;
	case STATES.RUN : sprite_index = Mushroom_Run; break;
	case STATES.HIT : sprite_index = Mushroom_Die; break;
}

if (state == STATES.HIT) {
	if (image_index > image_number - 1) {
		instance_destroy();
	}
}	

if (move_dir != 0) {
	image_xscale = -move_dir;
}

draw_self();