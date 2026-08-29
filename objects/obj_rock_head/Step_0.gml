if (state == STATES.RUN) {
    speed = move_speed;

    var _lx = lengthdir_x(speed, direction);
    var _ly = lengthdir_y(speed, direction);

    // 1. DÉTECTION ET POUSSÉE DU JOUEUR
    if (place_meeting(x + _lx, y + _ly, obj_)) {
        
        // On déplace le joueur d'abord
        obj_.x += _lx;
        obj_.y += _ly;

        // ON VÉRIFIE SI LE JOUEUR EST COINCÉ DANS UN VRAI MUR
        // (En excluant l'instance du rocher)
        var _is_stuck = false;
        
        with (obj_) {
            // Test de collision avec obj_collision en ignorant le rocher actuel (other)
            var _col = instance_place(x, y, obj_collision);
            if (_col != noone && _col != other.id) {
                _is_stuck = true;
            }
        }

        // Si coincé contre un mur -> HIT
        if (_is_stuck) {
            with (obj_) {
                state = STATES.HIT;
                image_index = 0;
                can_doble_jump = false;
            }
        }
    }

    // 2. ARRÊT DU ROCHER CONTRE LES MURS
    if (place_meeting(x + _lx, y + _ly, obj_collision)) {
        speed = 0;
        state = STATES.IDLE;
        alarm[0] = room_speed;
        image_index = 0;

        switch (direction) {
            case 0:   sprite_index = Right_Hit;  break;
            case 90:  sprite_index = Top_Hit;    break;
            case 180: sprite_index = Left_Hit;   break;
            case 270: sprite_index = Bottom_Hit; break;
        }

        while (!place_meeting(x + sign(_lx), y + sign(_ly), obj_collision)) {
            x += sign(_lx);
            y += sign(_ly);
        }
    }
}