/// @description Alterne entre repos et deplacement.
if (state != STATES.HIT) {
state = STATES.RUN;
move_dir = -move_dir;
}