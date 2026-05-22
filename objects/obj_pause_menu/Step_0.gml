// obj_pause_menu step
if (cooldown_input > 0) {
    cooldown_input--;
    exit;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// ESC ou P fecha o menu
if (keyboard_check_pressed(vk_escape)) {
    instance_activate_all();
    instance_destroy();
    exit;
}

// =========================================================
// MENU PRINCIPAL DE PAUSA
// =========================================================
if (estado_menu == "jogo") {

    for (var i = 0; i < array_length(botoes); i++) {
        var _b = botoes[i];
        _b.hover = point_in_rectangle(_mx, _my, _b.x, _b.y, _b.x + _b.w, _b.y + _b.h);

        if (_b.hover && mouse_check_button_pressed(mb_left)) {
            switch (_b.acao) {

case "continuar":
    instance_activate_all();          // 1. Wake up ALL instances
    with (oPoca) {                    // 2. Now the loop CAN see them
        visible     = true;
        image_alpha = 1;
    }
    instance_destroy();               // 3. Remove the pause menu
    break;

                case "recomecar":
                    estado_menu       = "confirmacao";
                    confirmacao_acao  = "recomecar";
                    confirmacao_texto = "RESTART THE LEVEL?\nALL PROGRESS WILL BE LOST.";
                break;

                case "configuracoes":
                    estado_menu = "configuracoes";
                break;

                case "menu_principal":
                    estado_menu       = "confirmacao";
                    confirmacao_acao  = "menu_principal";
                    confirmacao_texto = "RETURN TO MAIN MENU?\nALL PROGRESS WILL BE LOST.";
                break;
            }
        }
    }
}

// =========================================================
// CONFIRMAÇÃO
// =========================================================
else if (estado_menu == "confirmacao") {

    var _jw  = janela_largura;
    var _bw2 = 110;
    var _bh2 = 40;
    var _by2 = janela_y + janela_altura - 65;

    var _sim_x     = janela_x + (_jw / 2) - _bw2 - 8;
    var _sim_hover = point_in_rectangle(_mx, _my, _sim_x, _by2, _sim_x + _bw2, _by2 + _bh2);

    var _nao_x     = janela_x + (_jw / 2) + 8;
    var _nao_hover = point_in_rectangle(_mx, _my, _nao_x, _by2, _nao_x + _bw2, _by2 + _bh2);

    if (mouse_check_button_pressed(mb_left)) {

        if (_sim_hover) {
            if (confirmacao_acao == "recomecar") {
                instance_activate_all();
                room_restart();
            }
            else if (confirmacao_acao == "menu_principal") {
                instance_activate_all();
                room_goto(rm_menu_principal); // ⚠️ Troque pelo nome da sua room de menu
            }
        }

        if (_nao_hover) {
            estado_menu = "jogo";
        }
    }
}

// =========================================================
// CONFIGURAÇÕES
// =========================================================
else if (estado_menu == "configuracoes") {

    var _slider_w   = 200;
    var _slider_x   = janela_x + (janela_largura / 2) - (_slider_w / 2);
    var _slider_y_m = janela_y + 160;
    var _slider_y_s = janela_y + 240;

    if (point_in_rectangle(_mx, _my, _slider_x, _slider_y_m - 12, _slider_x + _slider_w, _slider_y_m + 12)
        && mouse_check_button(mb_left)) {
        volume_musica = clamp((_mx - _slider_x) / _slider_w, 0, 1);
        audio_group_set_gain(audiogroup_default, volume_musica, 0);
    }

    if (point_in_rectangle(_mx, _my, _slider_x, _slider_y_s - 12, _slider_x + _slider_w, _slider_y_s + 12)
        && mouse_check_button(mb_left)) {
        volume_sfx = clamp((_mx - _slider_x) / _slider_w, 0, 1);
        // audio_group_set_gain(audiogroup_sfx, volume_sfx, 0); // ← Descomente se tiver grupo SFX
    }

    var _vx = janela_x + (janela_largura / 2) - 80;
    var _vy = janela_y + janela_altura - 65;
    if (point_in_rectangle(_mx, _my, _vx, _vy, _vx + 160, _vy + 40)
        && mouse_check_button_pressed(mb_left)) {
        estado_menu = "jogo";
    }
}