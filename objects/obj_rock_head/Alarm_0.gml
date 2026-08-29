my_dir ++;

var _nb_dir = array_length(dir);

if (my_dir >= _nb_dir) {
    my_dir = 0;
}

direction = dir[my_dir];

state = STATES.RUN;