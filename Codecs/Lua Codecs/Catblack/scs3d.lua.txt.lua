-- deck indicators

add_control("deck_a", 1, "note", 0x71)
add_control("deck_b", 1, "note", 0x72)

-- outer 4 buttons

add_control("btn1", 1, "note", 44)
add_control("btn2", 1, "note", 46)
add_control("btn3", 1, "note", 48)
add_control("btn4", 1, "note", 50)

-- transport and layer buttons

add_control("play", 1, "note", 109)
add_control("cue", 1, "note", 110)
add_control("sync", 1, "note", 111)
add_control("tap", 1, "note", 112)
add_control("fx", 1, "note", 32)
add_control("loop", 1, "note", 34)
add_control("vinyl", 1, "note", 36)
add_control("eq", 1, "note", 38)
add_control("trig", 1, "note", 40)
add_control("deck", 1, "note", 42)

-- button mode (2nd col is emulated from fader5)

add_grid_control(0, 0, 1, "note", 72);
add_grid_control(1, 0, 1, "note", 74);
add_grid_control(2, 0, 1, "note", 76);
add_grid_control(3, 0, 1, "note", 78);

add_grid_control(0, 2, 1, "note", 79);
add_grid_control(1, 2, 1, "note", 81);
add_grid_control(2, 2, 1, "note", 83);
add_grid_control(3, 2, 1, "note", 85);

-- top left fader "gain"

add_control("fader1_press", 1, "note", 7);
add_control("fader1", 1, "cc", 7);
add_control("fader1_relative", 1, "cc", 8);

-- top right fader "pitch"

add_control("fader2_press", 1, "note", 3);
add_control("fader2", 1, "cc", 3);
add_control("fader2_relative", 1, "cc", 4);

-- circular fader

add_control("fader3_press", 1, "note", 98);
add_control("fader3", 1, "cc", 98);
add_control("fader3_relative", 1, "cc", 99);

-- central bottom fader

add_control("fader5_press", 1, "note", 1);
add_control("fader5", 1, "cc", 1);
add_control("fader5_relative", 1, "cc", 2);

-- left bottom fader

add_control("fader4_press", 1, "note", 12);
add_control("fader4", 1, "cc", 12);
add_control("fader4_relative", 1, "cc", 13);

-- right bottom fader

add_control("fader6_press", 1, "note", 14);
add_control("fader6", 1, "cc", 14);
add_control("fader6_relative", 1, "cc", 15);

-- inverted led feedback

add_control("fader1_inverted", 1, "cc", 0x17);
add_control("fader2_inverted", 1, "cc", 0x13);
add_control("fader3_inverted", 1, "cc", 0x72);
add_control("fader4_inverted", 1, "cc", 0x1C);
add_control("fader5_inverted", 1, "cc", 0x11);
add_control("fader6_inverted", 1, "cc", 0x1E);



