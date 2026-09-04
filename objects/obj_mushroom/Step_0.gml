// Événement STEP de obj_mushroom
if (state == STATES.RUN) {
    move_x = move_dir * max_speed;

    var _check_x = (move_dir > 0) ? bbox_right + move_x : bbox_left + move_x;

    // Récupère l'ID technique de la tilemap pour les collisions
    var _tilemap = layer_tilemap_get_id("t_terrain");

    // MODIFICATION : Utilise la tilemap à la place de obj_collision
    var _wall_ahead = place_meeting(x + move_x, y, _tilemap);
    var _ground_ahead = tilemap_get_at_pixel(_tilemap, _check_x, bbox_bottom + 2) > 0;

    if (_wall_ahead || !_ground_ahead) {
        move_x = 0;
        state = STATES.IDLE;
        if (alarm[0] <= 0) {
            alarm[0] = room_speed * 2;
        }
    }

    x += move_x;
}
