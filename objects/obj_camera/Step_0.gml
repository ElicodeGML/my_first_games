/// @description Suivi fluide du personnage, bloque dans les limites de la room

if (!instance_exists(target)) {
    target = instance_find(obj_, 0);
}

if (instance_exists(target)) {
    var _cam_w = camera_get_view_width(cam);
    var _cam_h = camera_get_view_height(cam);

    // Les bornes restent valides meme si la vue est plus grande que la room.
    var _max_x = max(0, room_width - _cam_w);
    var _max_y = max(0, room_height - _cam_h);

    var _wall_y = 320;
    var _wanted_x = clamp(target.x - (_cam_w * 0.5), 0, _max_x);
    var _wanted_y = target.y - (_cam_h * 0.5);

    // En bas, le haut de la vue reste sous le mur.
    if (target.y >= _wall_y) {
        _wanted_y = clamp(_wanted_y, _wall_y, _max_y);
    } else {
        // En haut, la vue reste au-dessus du mur.
        _wanted_y = clamp(_wanted_y, 0, max(0, _wall_y - _cam_h));
    }

    // L'interpolation rend le passage vertical progressif au lieu de le couper.
    var _next_x = lerp(camera_get_view_x(cam), _wanted_x, smoothness);
    var _next_y = lerp(camera_get_view_y(cam), _wanted_y, smoothness);

    camera_set_view_pos(cam, clamp(_next_x, 0, _max_x), clamp(_next_y, 0, _max_y));
}