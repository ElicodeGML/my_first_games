/// @description Termine le niveau au contact du joueur.
if (place_meeting(x, y, obj_)) {
	actived = true;
	sprite_index = End__Pressed;
	image_index = 0;
	room_goto_next();
}