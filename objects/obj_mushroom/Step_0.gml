/// @description Deplace le champignon et le fait rebrousser chemin au bord.

if (state == STATES.RUN) {
	// Calcule le deplacement horizontal.
    move_x = move_dir * max_speed;

    // Verifie le bord avant du champignon.
    var _check_x = (move_dir > 0) ? bbox_right + move_x : bbox_left + move_x;

    var _wall_ahead = place_meeting(x + move_x, y, obj_collision);
    var _ground_ahead = position_meeting(_check_x, bbox_bottom + 2, obj_collision);

    // Sans mur ni sol devant lui, le champignon reste en mouvement.
    if (_wall_ahead || !_ground_ahead) {
        move_x = 0;
        state = STATES.IDLE;
        if (alarm[0] <= 0) {
            alarm[0] = room_speed * 2;
        }
    }

    // Apply horizontal movement
    x += move_x;
}