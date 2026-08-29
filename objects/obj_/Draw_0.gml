/// @description Selectionne le sprite et dessine le joueur.

// Apparence correspondant a l'etat courant.
switch (state) {
	case STATES.IDLE : sprite_index = spr_Idle; break;
	case STATES.RUN : sprite_index = spr_Run; break;
	case STATES.FALL : sprite_index = spr_Fall; break;
	case STATES.JUMP : sprite_index = spr_Jump; break;
	case STATES.DOUBLEJUMP : sprite_index = spr_Double_Jump; break;
	case STATES.WALL : sprite_index = spr_Wall_Jump; break;
	case STATES.HIT : sprite_index = spr_Hit; break;
}

// Orientation horizontale, sauf pendant l'accrochage au mur.
if (move_dir != 0 && state != STATES.WALL) {
	image_xscale = move_dir;
}

// Animation de degats puis disparition progressive.
if (state == STATES.HIT) {
	if (!animation_ended) {
		if (image_index >= image_number - 1) animation_ended = true;
	} else {
		image_speed = 0;
		image_alpha -= 0.05;
	}
	image_angle -= 0.5 * move_dir;
}


// Le sprite du mur regarde dans la direction du mur.
if (state == STATES.WALL) {
	image_xscale = wall_dir;
}


draw_self();