/// @description Collecte le fruit et met a jour le score.
if (is_collected) {
	is_collected = false;
	score ++;
	show_debug_message(score);
	
	image_index = 0;

	sprite_index = spr_Collected;
}