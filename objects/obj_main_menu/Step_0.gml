var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
cursor_timer++;

// ⚠️ Call this when a phase is completed.
// _fase_key : "tutorial" | "fase1" | "fase2" | "fase3"
// _stars_earned : integer 1–3

if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}

if (estado_menu == "main") {
    for (var i = 0; i < array_length(botoes); i++) {
        var _b = botoes[i];
        _b.hover = point_in_rectangle(_mx, _my, _b.x, _b.y, _b.x + _b.w, _b.y + _b.h);
        if (_b.hover && mouse_check_button_pressed(mb_left)) {
            switch (_b.acao) {
                case "fases":   estado_menu = "fases";         break;
                case "configs": estado_menu = "configuracoes"; break;
                case "sair":    game_end();                    break;
            }
        }
    }
}

else if (estado_menu == "fases") {
    for (var i = 0; i < array_length(botoes_fases); i++) {
        var _b = botoes_fases[i];
        _b.hover = point_in_rectangle(_mx, _my, _b.x, _b.y, _b.x + _b.w, _b.y + _b.h);
        if (_b.hover && mouse_check_button_pressed(mb_left)) {
            switch (_b.acao) {
                case "tutorial": room_goto(rm_tutorial); break;
                case "fase1":    room_goto(rm_level_1);  break;
                case "fase2":    room_goto(rm_level_2);  break;
                case "fase3":    room_goto(rm_level_3);  break;
            }
        }
    }

    // Back button — MUST use identical coords as Draw GUI
    var _last_y = botoes_fases[array_length(botoes_fases) - 1].y;
    var _vw     = 208;   // 160 * 1.3
    var _vh     = 52;    // 40  * 1.3
    var _vx     = display_get_gui_width() / 2 - (_vw / 2);
    var _vy     = _last_y + 73;   // same gap_f used in Create
    if (point_in_rectangle(_mx, _my, _vx, _vy, _vx + _vw, _vy + _vh)
        && mouse_check_button_pressed(mb_left)) {
        estado_menu = "main";
    }
    if (keyboard_check_pressed(vk_escape)) {
        estado_menu = "main";
    }
}

else if (estado_menu == "configuracoes") {
    var _jy      = display_get_gui_height() * 0.28;
    var _jh      = display_get_gui_height() * 0.68;
    var _cx      = display_get_gui_width() / 2;
    var _sw      = 200;
    var _sx2     = _cx - (_sw / 2);
    var _sy_m    = _jy + 148;
    var _sy_s    = _jy + 238;
	
	var _rx = _cx - 100;
var _ry = _jy + _jh - 118;
var _rw = 200;
var _rh = 40;
if (point_in_rectangle(_mx, _my, _rx, _ry, _rx + _rw, _ry + _rh)
    && mouse_check_button_pressed(mb_left)) {
    ini_open("einstein_save.ini");
    ini_write_real("stars", "tutorial", 0);
    ini_write_real("stars", "fase1",    0);
    ini_write_real("stars", "fase2",    0);
    ini_write_real("stars", "fase3",    0);
    ini_close();
    // Reload stars so the phase select screen updates immediately
    estrelas_fases = [0, 0, 0, 0];
}

    if (point_in_rectangle(_mx, _my, _sx2, _sy_m - 12, _sx2 + _sw, _sy_m + 12)
        && mouse_check_button(mb_left)) {
        volume_musica = clamp((_mx - _sx2) / _sw, 0, 1);
        audio_group_set_gain(audiogroup_default, volume_musica, 0);
    }
    if (point_in_rectangle(_mx, _my, _sx2, _sy_s - 12, _sx2 + _sw, _sy_s + 12)
        && mouse_check_button(mb_left)) {
        volume_sfx = clamp((_mx - _sx2) / _sw, 0, 1);
    }

    var _vx = _cx - 80;
    var _vy = _jy + _jh - 62;
    if (point_in_rectangle(_mx, _my, _vx, _vy, _vx + 160, _vy + 40)
        && mouse_check_button_pressed(mb_left)) {
        estado_menu = "main";
    }
    if (keyboard_check_pressed(vk_escape)) {
        estado_menu = "main";
    }
}