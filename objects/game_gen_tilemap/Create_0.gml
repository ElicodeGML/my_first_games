/// @description Génération procédurale : Plateformes sur tout le long et FIXE VARIABLE FRUITS
randomize();

var _layer_id = layer_get_id("t_terrain");
var _map_id = layer_tilemap_get_id(_layer_id);

var _grid_w    = tilemap_get_width(_map_id);
var _grid_h    = tilemap_get_height(_map_id);
var _tile_size = 16;

// -------------------------------------------------------------------
// 🛠️ CONFIGURATION DES TUILES COMPLÈTE ET EXACTE
// -------------------------------------------------------------------
var TILE_VIDE         = 0;
var TILE_CONTOUR_UNI  = 23; // Tuile de fond unie pour la marge extérieure

// Bordures métalliques grises (Cadre droit)
var TILE_BORD_HAUT_M  = 133; 
var TILE_BORD_BAS_M   = 89;  
var TILE_BORD_GAUCHE  = 112; 
var TILE_BORD_DROITE  = 110; 

// Vos 4 tuiles d'angles métalliques
var TILE_ANGLE_HAUT_G = 91;  
var TILE_ANGLE_HAUT_D = 92;  
var TILE_ANGLE_BAS_G  = 113; 
var TILE_ANGLE_BAS_D  = 114; 

// Terre / Herbe standard
var TILE_TERRE_HAUT_M = 95;  // Herbe normale centrale
var TILE_TERRE_MID_M  = 117; // Terre beige normale centrale

// Angles d'herbe arrondis supérieurs (Couche 1)
var TILE_HERBE_ARRONDIE_G = 94; 
var TILE_HERBE_ARRONDIE_D = 96; 

// Rebords de terre verticaux pour les flancs du milieu (Couche 2)
var TILE_TERRE_REBORD_G   = 116; 
var TILE_TERRE_REBORD_D   = 118; 

// Dessous de plateformes et angles inférieurs (Couche 3)
var TILE_TERRE_ARRONDIE_BG = 138; 
var TILE_TERRE_PLAFOND_M   = 139; 
var TILE_TERRE_ARRONDIE_BD = 140; 

// Vos jonctions de recoins sous l'herbe haute (Marches)
var TILE_JONCTION_ROUGE_G = 120; 
var TILE_JONCTION_ROUGE_D = 119; 

// -------------------------------------------------------------------
// 🛠️ INITIALISATION DE LA GRILLE 2D (Largeur x Hauteur)
// -------------------------------------------------------------------
var _temp_grid = array_create(_grid_w);
for (var _i = 0; _i < _grid_w; _i++) {
    _temp_grid[_i] = array_create(_grid_h, 0); 
}

// -------------------------------------------------------------------
// 1. RELIEF DU SOL PRINCIPAL
// -------------------------------------------------------------------
var _sol_base_h = floor(_grid_h * 0.8); 
var _current_h = _sol_base_h; 
var _steps_since_change = 0;

for (var _gx = 2; _gx < _grid_w - 2; _gx++) { 
    _steps_since_change++;
    
    if (_steps_since_change >= 4 && irandom(100) < 30) {
        _current_h += choose(-1, 1);
        _current_h = clamp(_current_h, floor(_grid_h * 0.72), floor(_grid_h * 0.82)); 
        _steps_since_change = 0;
    }
    
    var _safe_gy_start = clamp(_current_h, 2, _grid_h - 3);
    for (var _gy = _safe_gy_start; _gy < _grid_h - 2; _gy++) {
        _temp_grid[_gx][_gy] = 1; 
    }
}

// -------------------------------------------------------------------
// 2. CORRECTION : PLATEFORMES SÉPARÉES ET RÉPARTIES SUR TOUT LE LONG
// -------------------------------------------------------------------
var _num_islands = 6; 
// On calcule mathématiquement des tranches de largeur pour étaler les plateformes de gauche à droite
var _section_width = floor((_grid_w - 16) / _num_islands);

for (var _i = 0; _i < _num_islands; _i++) {
    var _rw = irandom_range(8, 13); 
    
    // On force chaque plateforme à naître dans sa propre zone de gauche à droite
    var _min_x = 4 + (_i * _section_width);
    var _max_x = _min_x + _section_width - _rw - 2;
    var _rx = irandom_range(_min_x, max(_min_x + 1, _max_x));
    
    var _min_spawn_h = 4;
    var _max_spawn_h = min(_grid_h - 7, floor(_grid_h * 0.6)); 
    var _ry = irandom_range(_min_spawn_h, _max_spawn_h); 

    var _conflit = false;
    for (var _cx = _rx - 2; _cx < _rx + _rw + 2; _cx++) {
        for (var _cy = _ry - 3; _cy < _ry + 4; _cy++) {
            if (_cx < 0 || _cx >= _grid_w || _cy < 0 || _cy >= _grid_h) continue;
            if (_temp_grid[_cx][_cy] != 0) { _conflit = true; }
        }
    }

    if (!_conflit) {
        var _island_h = _ry;
        var _sub_step = 0;
        
        for (var _x = _rx; _x < _rx + _rw; _x++) {
            _sub_step++;
            if (_sub_step >= 4 && irandom(100) < 25 && _x < _rx + _rw - 2) {
                _island_h += choose(-1, 1);
                _sub_step = 0;
            }
            
            _island_h = clamp(_island_h, 4, _grid_h - 6); 
            
            if (_x >= 0 && _x < _grid_w && _island_h >= 0 && _island_h + 2 < _grid_h) {
                _temp_grid[_x][_island_h] = 2;     
                _temp_grid[_x][_island_h + 1] = 2; 
                _temp_grid[_x][_island_h + 2] = 2; 
            }
        }
    }
}

// -------------------------------------------------------------------
// 3. TRANSFERT ET HABILLAGE CHIRURGICAL GLOBAL
// -------------------------------------------------------------------
for (var _gx = 0; _gx < _grid_w; _gx++) {
    for (var _gy = 0; _grid_h > _gy; _gy++) {
        
        var _is_edge_vide = (_gx == 0 || _gx == _grid_w - 1 || _gy == 0 || _gy == _grid_h - 1);
        if (_is_edge_vide) {
            tilemap_set(_map_id, TILE_CONTOUR_UNI, _gx, _gy);
            continue;
        }

        var _is_border_left   = (_gx == 1); 
        var _is_border_right  = (_gx == _grid_w - 2);
        var _is_border_top    = (_gy == 1);
        var _is_border_bottom = (_grid_h - 2 == _gy);

        if (_is_border_top && _is_border_left)   { tilemap_set(_map_id, TILE_ANGLE_HAUT_G, _gx, _gy); continue; }
        if (_is_border_top && _is_border_right)  { tilemap_set(_map_id, TILE_ANGLE_HAUT_D, _gx, _gy); continue; }
        if (_is_border_bottom && _is_border_left)  { tilemap_set(_map_id, TILE_ANGLE_BAS_G, _gx, _gy); continue; }
        if (_is_border_bottom && _is_border_right) { tilemap_set(_map_id, TILE_ANGLE_BAS_D, _gx, _gy); continue; }

        if (_is_border_top)    { tilemap_set(_map_id, TILE_BORD_HAUT_M, _gx, _gy); continue; }
        if (_is_border_bottom) { tilemap_set(_map_id, TILE_BORD_BAS_M, _gx, _gy); continue; }
        if (_is_border_left)   { tilemap_set(_map_id, TILE_BORD_GAUCHE, _gx, _gy); continue; }
        if (_is_border_right)  { tilemap_set(_map_id, TILE_BORD_DROITE, _gx, _gy); continue; }

        var _type = _temp_grid[_gx][_gy];

        if (_type > 0) {
            var _vide_au_dessus = (_temp_grid[_gx][_gy - 1] == 0);
            var _vide_en_bas    = (_temp_grid[_gx][_gy + 1] == 0);
            var _vide_a_gauche  = (_temp_grid[_gx - 1][_gy] == 0);
            var _vide_a_droite  = (_temp_grid[_gx + 1][_gy] == 0);

            var _target_tile = TILE_TERRE_MID_M; 

            if (_vide_au_dessus) {
                if (_vide_a_gauche) {
                    _target_tile = TILE_HERBE_ARRONDIE_G; 
                } else if (_vide_a_droite) {
                    _target_tile = TILE_HERBE_ARRONDIE_D; 
                } else {
                    _target_tile = TILE_TERRE_HAUT_M;     
                }
            } 
            else {
                var _tuile_du_dessus_est_herbe = (_temp_grid[_gx][_gy - 1] > 0 && _temp_grid[_gx][_gy - 2] == 0);
                
                if (_tuile_du_dessus_est_herbe && !_vide_a_gauche && _temp_grid[_gx - 1][_gy - 1] == 0) {
                    _target_tile = TILE_JONCTION_ROUGE_G; 
                }
                else if (_tuile_du_dessus_est_herbe && !_vide_a_droite && _temp_grid[_gx + 1][_gy - 1] == 0) {
                    _target_tile = TILE_JONCTION_ROUGE_D; 
                }
                else if (_vide_en_bas && _type == 2) {
                    if (_vide_a_gauche) {
                        _target_tile = TILE_TERRE_ARRONDIE_BG; 
                    } else if (_vide_a_droite) {
                        _target_tile = TILE_TERRE_ARRONDIE_BD; 
                    } else {
                        _target_tile = TILE_TERRE_PLAFOND_M;   
                    }
                }
                else if (_vide_a_gauche) {
                    _target_tile = TILE_TERRE_REBORD_G; 
                }
                else if (_vide_a_droite) {
                    _target_tile = TILE_TERRE_REBORD_D; 
                }
            }

            tilemap_set(_map_id, _target_tile, _gx, _gy);
        } else {
            tilemap_set(_map_id, TILE_VIDE, _gx, _gy);
        }
    }
}

// -------------------------------------------------------------------
// 4. PLACEMENT JOUEUR
// -------------------------------------------------------------------
if (object_exists(obj_)) {
    var _spawn_player_x = 5 * _tile_size + 8; 
    var _spawn_player_y = 4 * _tile_size; 
    if (instance_exists(obj_)) {
        with (obj_) { x = _spawn_player_x; y = _spawn_player_y; }
    } else {
        instance_create_layer(_spawn_player_x, _spawn_player_y, "Instances", obj_);
    }
}

// -------------------------------------------------------------------
// 5. APPARITION FORCEE DES ENNEMIS ET CORRECTION DE LA VARIABLE DES FRUITS
// -------------------------------------------------------------------
var _cooldown_fruits = 0; 

for (var _gx = 3; _gx < _grid_w - 6; _gx++) { 
    for (var _gy = 2; _gy < _grid_h - 2; _gy++) {
        
        var _tile = tilemap_get(_map_id, _gx, _gy);
        var _type = _temp_grid[_gx][_gy];
        
        if (_tile == TILE_TERRE_HAUT_M || _tile == TILE_HERBE_ARRONDIE_G || _tile == TILE_HERBE_ARRONDIE_D) {
            
            var _spawn_x = (_gx * _tile_size) + (_tile_size / 2);
            var _spawn_y = (_gy * _tile_size); 

            var _case_occupee_par_monstre = false;

            // --- 1. ENNEMI UNIQUE ---
            var _champignon_deja_present = false;
            if (object_exists(obj_mushroom)) {
                _champignon_deja_present = collision_rectangle(_spawn_x - (6 * _tile_size), _spawn_y - 32, _spawn_x + (6 * _tile_size), _spawn_y + 16, obj_mushroom, false, true);
            }

            if (!_champignon_deja_present && irandom(100) < 4) {
                if (object_exists(obj_mushroom)) {
                    instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_mushroom);
                    _cooldown_fruits = 4; 
                    _case_occupee_par_monstre = true;
                }
            }

            // --- 2. MULTI-SPAWN FRUITS (CORRIGÉ ET SYNCHRONISÉ) ---
            if (!_case_occupee_par_monstre) {
                if (_cooldown_fruits > 0) {
                    _cooldown_fruits--;}else {
                        var _chance_spawn = (_type == 2) ? 25 : 15;
                        if (irandom(100) < _chance_spawn) {
                            var _fruit_choisi = noone;
                            var _pick = irandom(4);
                            switch (_pick) {
                                case 0: if (object_exists(obj_apple)) _fruit_choisi = obj_apple; break;
                                case 1: if (object_exists(obj_bananas)) _fruit_choisi = obj_bananas; break;
                                case 2: if (object_exists(obj_pineapple)) _fruit_choisi = obj_pineapple; break;
                                case 3: if (object_exists(obj_strawberry)) _fruit_choisi = obj_strawberry; break;
                                case 4: if (object_exists(obj_cherries)) _fruit_choisi = obj_cherries; break;
                            }
                            // CORRECTION CRITIQUE : Le script transmet la valeur à la variable de spawn finale
                            var _fruit_unique = _fruit_choisi;
                            if (_fruit_unique != noone) {
                                var _taille_rangee = irandom_range(2, 3);
                                var _rangee_valide = true;
                                for (var _k = 0; _k < _taille_rangee; _k++) {
                                    var _target_gx = _gx + _k;
                                    var _target_gy = _gy;
                                    var _check_tile = tilemap_get(_map_id, _target_gx, _target_gy);
                                    if (_check_tile != TILE_TERRE_HAUT_M && _check_tile != TILE_TERRE_HAUT_M && _check_tile != TILE_HERBE_ARRONDIE_G && _check_tile != TILE_HERBE_ARRONDIE_D) {
                                        _rangee_valide = false;
                                    }
                                    if (_temp_grid[_target_gx][_target_gy - 1] != 0 || _temp_grid[_target_gx + 1][_target_gy - 1] != 0) {
                                        _rangee_valide = false;
                                    }
                                }
                                if (_rangee_valide) {
                                    for (var _f = 0; _f < _taille_rangee; _f++) {
                                        var _fx = _spawn_x + (_f * 20);
                                        instance_create_layer(_fx, _spawn_y - 14, "Instances", _fruit_unique); // Utilise la bonne variable !
                                    }
                                    _cooldown_fruits = _taille_rangee + 4;
                                }
                            }
                        }
                    }
                }
            }
        }
}