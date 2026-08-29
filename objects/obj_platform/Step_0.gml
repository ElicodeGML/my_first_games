/// @description Deplace la plateforme et gere le joueur qui la chevauche.

if (state == STATES.RUN) {
	if (place_meeting(x, y + move_speed * vertical_dir, obj_platform_col)) {
		state = STATES.IDLE;
		alarm[0] = room_speed;
		return;
	}
	
	y += move_speed * vertical_dir;
	with (obj_) {
		if (state != STATES.WALL && platform_id == other.id) {
			y += other.move_speed * other.vertical_dir;
		}
	}
}

if (obj_.platform_id == id && keyboard_check_pressed(vk_down) && active) {
	active = false;
	obj_.y++;
	obj_.state = STATES.FALL;
}

if (!active && !place_meeting(x, y, obj_)) {
	active = true;
}