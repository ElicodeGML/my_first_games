/// @description Affiche le rocher.
if (sprite_index != Blink && sprite_index != Idle ) {
	if (image_index > image_number - 1 ) {
		alarm[1] = room_speed / 2;
		sprite_index = Idle;
	}
}

if (sprite_index == Blink) {
	if (image_index > image_number - 1 ) {
		alarm[0] = room_speed;
		sprite_index = Idle;
	}
}
draw_self();