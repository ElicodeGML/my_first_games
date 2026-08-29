/// @description Gere la collision du joueur avec un champignon.

// Le joueur peut rebondir sur le champignon en tombant ou depuis un mur.
if ((state == STATES.FALL || state == STATES.WALL) && other.state != STATES.HIT) {
	state = STATES.JUMP;
	move_y = jump_speed;
	can_doble_jump = true;
	
	// Le champignon passe en animation de mort.
	other.state = STATES.HIT;
	other.move_x = 0;
	other.move_y = 0;
	other.animation_ended = false;
	other.image_index = 0;

// Une collision laterale blesse le joueur.
} else if (state != STATES.HIT && other.state != STATES.HIT) {
	
	state = STATES.HIT;
	image_index = 0;
	can_doble_jump = false;
	animation_ended = false;
	
	// Le recul eloigne le joueur du champignon.
	if (other.x < x) move_dir = 1;
	else move_dir = -1;

	move_x = move_dir * move_speed * 1.5;
	image_alpha = 1;
	image_angle = 0;
	
		
}