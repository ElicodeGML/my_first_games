/// @description Génération procédurale pour Room Horizontale (1920x370)
randomize();

var _layer_id = layer_get_id("t_terrain"); //[cite: 1, 3]
var _map_id = layer_tilemap_get_id(_layer_id); //[cite: 1, 3]

// Vos tuiles personnalisées
var TILE_VIDE   = 0; //[cite: 1, 3]
var TILE_HERBE  = 7;  //[cite: 3]
var TILE_SOL    = 10; //[cite: 3]
var TILE_BORDER = 105; //[cite: 3]

var _grid_w = tilemap_get_width(_map_id); //[cite: 1, 3]
var _grid_h = tilemap_get_height(_map_id); //[cite: 1, 3]
var _tile_size = 16; //[cite: 1, 3]

// -------------------------------------------------------------------
// 1. DÉGAGEMENT + BORDURES EXTÉRIEURES
// -------------------------------------------------------------------
for (var _gx = 0; _gx < _grid_w; _gx++) {
    for (var _gy = 0; _gy < _grid_h; _gy++) {
        if (_gx <= 1 || _gx >= _grid_w - 2 || _gy <= 1 || _gy >= _grid_h - 2) {
            tilemap_set(_map_id, TILE_BORDER, _gx, _gy); //[cite: 1, 3]
        } else {
            tilemap_set(_map_id, TILE_VIDE, _gx, _gy); //[cite: 1, 3]
        }
    }
}

// -------------------------------------------------------------------
// 2. RELIEF CONTINU DU SOL (Adapté à 370px de hauteur)
// -------------------------------------------------------------------
var _current_h = _grid_h - 4;

for (var _gx = 2; _gx < _grid_w - 2; _gx++) {
    // Variation douce du relief du sol
    if (irandom(100) < 30) {
        _current_h += choose(-1, 1);
        _current_h = clamp(_current_h, _grid_h - 7, _grid_h - 3); // Garde du sol jouable
    }
    
    // Dessiner le sol jusqu'en bas
    for (var _gy = _current_h; _gy < _grid_h - 2; _gy++) {
        var _tile = (_gy == _current_h) ? TILE_HERBE : TILE_SOL; //[cite: 3]
        tilemap_set(_map_id, _tile, _gx, _gy); //[cite: 3]
    }
}

// -------------------------------------------------------------------
// 3. PLATEFORMES ET ISLANDS SUSPENDUS
// -------------------------------------------------------------------
var _num_islands = 15; // Ajusté pour s'étendre sur les 1920px de largeur

for (var _i = 0; _i < _num_islands; _i++) {
    var _rx = irandom_range(6, _grid_w - 12);
    var _ry = irandom_range(5, _grid_h - 9); // Toujours au-dessus du sol
    var _rw = irandom_range(3, 7);           // Largeur
    var _rh = irandom_range(2, 4);           // Épaisseur

    for (var _x = _rx; _x < _rx + _rw; _x++) {
        for (var _y = _ry; _y < _ry + _rh; _y++) {
            var _tile = (_y == _ry) ? TILE_HERBE : TILE_SOL; //[cite: 3]
            tilemap_set(_map_id, _tile, _x, _y); //[cite: 3]
        }
    }
}

// -------------------------------------------------------------------
// 4. GENERATION DE LA COLLISION AUTOMATIQUE
// -------------------------------------------------------------------
var _col_layer = layer_exists("l_collision") ? "l_collision" : "Instances"; //[cite: 1, 2, 3]

for (var _gx = 0; _gx < _grid_w; _gx++) {
    for (var _gy = 0; _gy < _grid_h; _gy++) {
        var _t = tilemap_get(_map_id, _gx, _gy); //[cite: 1, 3]
        if (_t != TILE_VIDE) { //[cite: 1, 3]
            var _inst = instance_create_layer(_gx * _tile_size, _gy * _tile_size, _col_layer, obj_collision); //[cite: 1, 2, 3]
            _inst.image_xscale = _tile_size / sprite_get_width(_inst.sprite_index); //[cite: 2, 3]
            _inst.image_yscale = _tile_size / sprite_get_height(_inst.sprite_index); //[cite: 2, 3]
        }
    }
}