/// @description Initialise la camera et sa cible.
cam = view_camera[0];
target = instance_find(obj_, 0);

// Une petite valeur rend le suivi plus doux.
smoothness = 0.08;