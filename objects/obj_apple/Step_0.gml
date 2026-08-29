/// @description Detruit le fruit apres son animation de collecte.
if (image_index >= image_number - 1 && !is_collected) {
	instance_destroy();
}