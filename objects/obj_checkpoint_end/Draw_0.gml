/// @description Affiche le drapeau au-dessus du joueur.
depth = obj_.depth - 1;

if (sprite_index == End__Pressed && image_index > image_number - 1) {
	sprite_index = End__Idle;
	image_index = 0;
}

draw_self();