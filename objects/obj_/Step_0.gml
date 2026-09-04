// -----------------------------------------------------------------------------
// Entrees et redemarrage
// -----------------------------------------------------------------------------
input_left  = keyboard_check(vk_left);
input_right = keyboard_check(vk_right);
input_jump  = keyboard_check_pressed(vk_space);

if (state != STATES.HIT) {
	move_dir = input_right - input_left;
}

if (keyboard_check_pressed(ord("R"))) {
	game_restart();
}

if (state == STATES.HIT) {
	var _recoil_step = move_x * 0.2;
	// MODIFICATION : Collision de recul avec la tilemap
	if (!place_meeting(x + _recoil_step, y, tilemap_terrain)) {
		x += _recoil_step;
	} else {
		move_x = 0;
	}
	move_x *= 0.85;
	exit;
}

// -----------------------------------------------------------------------------
// Detection du sol et de la plateforme porteuse
// -----------------------------------------------------------------------------
// MODIFICATION : Détection du sol via la tilemap
touch_floor = place_meeting(x, y + 1, tilemap_terrain);
touch_platform = place_meeting(x, y + 1, obj_platform);

if (touch_platform) {
	platform_id = instance_place(x, y + 1, obj_platform);
	if ((y - 1 < platform_id.y) && platform_id.active) {
		platform_id = noone;
	}
	if (platform_id != noone) {
		if (!platform_id.active) {
			touch_platform = false;
		}
	}
} else {
	platform_id = noone;
}

if ((state == STATES.IDLE || state == STATES.RUN) && !touch_floor && !touch_platform) {
	state = STATES.FALL;
}

// -----------------------------------------------------------------------------
// Saut normal et double saut
// -----------------------------------------------------------------------------
if (input_jump && state != STATES.HIT) {
	if (state == STATES.IDLE || state == STATES.RUN || state == STATES.WALL) {
		state = STATES.JUMP;
		move_y = jump_speed;
	} else if (can_doble_jump) {
		state = STATES.DOUBLEJUMP;
		move_y = jump_speed;
		can_doble_jump = false;
	}
}

if (state != STATES.HIT) {
	move_x = move_dir * move_speed;
}

// -----------------------------------------------------------------------------
// Accrochage au mur
// -----------------------------------------------------------------------------
if (state == STATES.FALL) {
	// MODIFICATION : On s'accroche désormais aux tuiles du terrain directement
	var wall_collision = place_meeting(x + move_x, y, tilemap_terrain);

	if (wall_collision) {
		while (!place_meeting(x + sign(move_x), y, tilemap_terrain)) {
			x += sign(move_x);
		}

		state = STATES.WALL;
		wall_dir = move_dir;
		can_doble_jump = true;
	}
}

// -----------------------------------------------------------------------------
// État accroché au mur
// -----------------------------------------------------------------------------
if (state == STATES.WALL) {
	move_x = 0;
	move_y = 0.5;

	if (touch_floor) {
		state = STATES.IDLE;

		while (!place_meeting(x, y + sign(move_y), tilemap_terrain)) {
			y += sign(move_y);
		}

		move_y = 0;
	}

	if (!place_meeting(x + wall_dir, y, tilemap_terrain)
		|| (move_dir != 0 && move_dir != wall_dir)) {
		state = STATES.FALL;
	}
}

// -----------------------------------------------------------------------------
// Gravité pendant un saut
// -----------------------------------------------------------------------------
if (state == STATES.JUMP || state == STATES.DOUBLEJUMP) {
	move_y += fall_speed;

	if (place_meeting(x, y + move_y, tilemap_terrain)) {
		move_y = 0;
		state = STATES.FALL;
	} else if (move_y >= 0) {
		state = STATES.FALL;
	}
}

// -----------------------------------------------------------------------------
// Chute et atterrissage
// -----------------------------------------------------------------------------
if (state == STATES.FALL) {
	move_y += fall_speed;

	if (place_meeting(x, y + move_y, tilemap_terrain)) {
		move_y = 0;
		state = STATES.IDLE;
		can_doble_jump = true;

		// Replace l'objet juste au-dessus du sol.
		while (!place_meeting(x, y + 1, tilemap_terrain)) {
			y += 1;
		}
	}
	var _pcol = place_meeting(x, y + move_y, obj_platform);
	var _pid  = instance_place(x, y + move_y, obj_platform);

	if (_pcol && (y - 1 >= _pid.y && _pid.active)) {
		move_y = 0;
		state = STATES.IDLE;
		platform_id = _pid;
		can_doble_jump = true;

		// Replace l'objet juste au-dessus du sol.
		while (place_meeting(x, y, _pid)) {
			y -= 1;
		}
		y += 1;
	}
}

// -----------------------------------------------------------------------------
// États horizontaux : course et repos
// -----------------------------------------------------------------------------
if (move_dir != 0 && state == STATES.IDLE) {
	state = STATES.RUN;
} else if (move_dir == 0 && state == STATES.RUN) {
	state = STATES.IDLE;
}

// -----------------------------------------------------------------------------
// Déplacement horizontal et résolution des collisions
// -----------------------------------------------------------------------------
if (place_meeting(x + move_x, y, tilemap_terrain)) {
	var horizontal_direction = sign(move_x);

	while (horizontal_direction != 0
		&& !place_meeting(x + horizontal_direction, y, tilemap_terrain)) {
		x += horizontal_direction;
	}

	move_x = 0;
}

// -----------------------------------------------------------------------------
// Application du déplacement final
// -----------------------------------------------------------------------------
x += move_x;
y += move_y;
