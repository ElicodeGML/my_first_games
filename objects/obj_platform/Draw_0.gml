/// @description Affiche le sprite correspondant a l'etat de la plateforme.

switch (state) {
	case STATES.IDLE : sprite_index = Brown_Off; break;
	case STATES.RUN : sprite_index = Brown_On__32x8_; break;
}

draw_self();