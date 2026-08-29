/// @description Affiche l'interface et le score.
draw_sprite_ext(spr_gui, 0, 16, 48, 1.5, 1.5, 0, -1, 1);

draw_set_font(Font1);
draw_set_halign(fa_middle);

draw_text(128, 64, score);