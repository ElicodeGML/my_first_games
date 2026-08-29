/// @description Genere les collisions de terrain et les murs d'accroche.
function scr_generate_collisions() {
    var _tilemap = layer_tilemap_get_id("t_terrain");
    if (_tilemap == -1) {
        show_debug_message("scr_generate_collisions : couche 't_terrain' introuvable.");
        return;
    }

    var _tile_w = tilemap_get_tile_width(_tilemap);
    var _tile_h = tilemap_get_tile_height(_tilemap);
    if (_tile_w <= 0 || _tile_h <= 0) {
        show_debug_message("scr_generate_collisions : taille des tuiles invalide.");
        return;
    }

    var _collision_layer = layer_get_id("l_collision");
    if (_collision_layer == -1) {
        _collision_layer = layer_get_id("i_collision");
    }

    if (_collision_layer == -1) {
        show_debug_message("scr_generate_collisions : couche de collision introuvable.");
        return;
    }

    var _cols = ceil(room_width / _tile_w);
    var _rows = ceil(room_height / _tile_h);
    // Evite de creer plusieurs collisions pour une meme tuile de bord.
    var _visited = ds_map_create();

    for (var _ty = 0; _ty < _rows; _ty++) {
        for (var _tx = 0; _tx < _cols; _tx++) {
            var _px = _tx * _tile_w;
            var _py = _ty * _tile_h;
            var _cell = tilemap_get_at_pixel(_tilemap, _px, _py);

            if (_cell > 0) {
                var _key = string(_tx) + "," + string(_ty);
                if (ds_map_exists(_visited, _key)) {
                    continue;
                }

                var _solid_left = false;
                var _solid_right = false;
                var _solid_up = false;
                var _solid_down = false;

                if (_tx - 1 >= 0) {
                    _solid_left = (tilemap_get_at_pixel(_tilemap, (_tx - 1) * _tile_w, _py) > 0);
                }
                if (_tx + 1 < _cols) {
                    _solid_right = (tilemap_get_at_pixel(_tilemap, (_tx + 1) * _tile_w, _py) > 0);
                }
                if (_ty - 1 >= 0) {
                    _solid_up = (tilemap_get_at_pixel(_tilemap, _px, (_ty - 1) * _tile_h) > 0);
                }
                if (_ty + 1 < _rows) {
                    _solid_down = (tilemap_get_at_pixel(_tilemap, _px, (_ty + 1) * _tile_h) > 0);
                }

                if (!_solid_left || !_solid_right || !_solid_up || !_solid_down) {
                    ds_map_add(_visited, _key, true);

                    var _inst = instance_create_layer(_px, _py, _collision_layer, obj_collision);
                    _inst.image_xscale = _tile_w / sprite_get_width(_inst.sprite_index);
                    _inst.image_yscale = _tile_h / sprite_get_height(_inst.sprite_index);
                }
            }
        }
    }

    ds_map_destroy(_visited);
}

scr_generate_collisions();
