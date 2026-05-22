// --- EVENTO: Draw GUI obj_pause_menu ---
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _jx = janela_x;
var _jy = janela_y;
var _jw = janela_largura;
var _jh = janela_altura;
var _cx = _jx + (_jw / 2);

draw_set_alpha(1);
draw_set_color(c_white);

// Overlay escurecido
draw_set_alpha(0.68);
draw_set_color(make_color_rgb(20, 10, 0));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// =========================================================
// PAINEL principal (borda dupla dourada)
// =========================================================
draw_set_color(make_color_rgb(42, 26, 10));
draw_rectangle(_jx, _jy, _jx + _jw, _jy + _jh, false);
draw_set_color(make_color_rgb(118, 76, 10));
draw_rectangle(_jx,     _jy,     _jx + _jw,     _jy + _jh,     true);
draw_set_color(make_color_rgb(210, 158, 42));
draw_rectangle(_jx - 2, _jy - 2, _jx + _jw + 2, _jy + _jh + 2, true);

// Separador decorativo abaixo do título
draw_set_color(make_color_rgb(118, 76, 10));
draw_line_width(_jx + 14, _jy + 70, _jx + _jw - 14, _jy + 70, 1);
draw_set_color(make_color_rgb(210, 158, 42));
draw_line_width(_jx + 14, _jy + 72, _jx + _jw - 14, _jy + 72, 1);

// Cantos decorativos
var _cm = 6;
draw_set_color(make_color_rgb(210, 158, 42));
draw_rectangle(_jx + 4,              _jy + 4,              _jx + 4 + _cm,        _jy + 4 + _cm,        false);
draw_rectangle(_jx + _jw - 4 - _cm, _jy + 4,              _jx + _jw - 4,        _jy + 4 + _cm,        false);
draw_rectangle(_jx + 4,              _jy + _jh - 4 - _cm, _jx + 4 + _cm,        _jy + _jh - 4,        false);
draw_rectangle(_jx + _jw - 4 - _cm, _jy + _jh - 4 - _cm, _jx + _jw - 4,        _jy + _jh - 4,        false);

// =========================================================
// TÍTULO com sombra
// =========================================================
draw_set_font(fnt_Pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(make_color_rgb(118, 76, 10));
draw_text(_cx + 2, _jy + 38 + 2, "~ PAUSED ~");
draw_set_color(make_color_rgb(255, 234, 185));
draw_text(_cx,     _jy + 38,     "~ PAUSED ~");

// =========================================================
// MENU PRINCIPAL DE PAUSA
// =========================================================
if (estado_menu == "jogo") {

    for (var i = 0; i < array_length(botoes); i++) {
        var _b  = botoes[i];
        var _bx = _b.x;
        var _by = _b.y;
        var _bw = _b.w;
        var _bh = _b.h;

        if (_b.hover) {
            draw_set_color(make_color_rgb(210, 158, 42));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
            draw_set_color(make_color_rgb(42, 26, 10));
            draw_rectangle(_bx + 3, _by + 3, _bx + _bw - 3, _by + _bh - 3, false);
            draw_set_color(make_color_rgb(210, 158, 42));
            draw_rectangle(_bx + 3, _by + 3, _bx + _bw - 3, _by + _bh - 3, true);
        } else {
            draw_set_color(make_color_rgb(28, 16, 6));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
            draw_set_color(make_color_rgb(118, 76, 10));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
        }

        draw_set_color(make_color_rgb(118, 76, 10));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_bx + (_bw/2) + 1, _by + (_bh/2) + 1, _b.label);

        draw_set_color(_b.hover ? make_color_rgb(42, 26, 10) : make_color_rgb(255, 234, 185));
        draw_text(_bx + (_bw/2), _by + (_bh/2), _b.label);
    }

    draw_set_color(make_color_rgb(140, 100, 40));
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text(_cx, _jy + _jh - 10, "[ESC] return");
}

// =========================================================
// CONFIRMAÇÃO
// =========================================================
else if (estado_menu == "confirmacao") {

    var _ico_y = _jy + 120;
    var _ico_s = 14;
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_triangle(_cx, _ico_y - _ico_s, _cx + _ico_s, _ico_y, _cx, _ico_y + _ico_s, false);
    draw_triangle(_cx, _ico_y - _ico_s, _cx - _ico_s, _ico_y, _cx, _ico_y + _ico_s, false);
    draw_set_color(make_color_rgb(42, 26, 10));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_cx, _ico_y, "!");

    draw_set_color(make_color_rgb(255, 234, 185));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_ext(_cx, _jy + 190, confirmacao_texto, 28, _jw - 40);

    var _bw2 = 108;
    var _bh2 = 40;
    var _by2 = _jy + _jh - 62;

    // Botão YES
    var _sx     = _cx - _bw2 - 8;
    var _shover = point_in_rectangle(_mx, _my, _sx, _by2, _sx + _bw2, _by2 + _bh2);
    draw_set_color(_shover ? make_color_rgb(210, 64, 44) : make_color_rgb(28, 16, 6));
    draw_rectangle(_sx, _by2, _sx + _bw2, _by2 + _bh2, false);
    draw_set_color(make_color_rgb(210, 64, 44));
    draw_rectangle(_sx, _by2, _sx + _bw2, _by2 + _bh2, true);
    draw_set_color(make_color_rgb(100, 20, 10));
    draw_text(_sx + (_bw2/2) + 1, _by2 + (_bh2/2) + 1, "Yes :(");
    draw_set_color(c_white);
    draw_text(_sx + (_bw2/2),     _by2 + (_bh2/2),     "Yes :(");

    // Botão NO
    var _nx     = _cx + 8;
    var _nhover = point_in_rectangle(_mx, _my, _nx, _by2, _nx + _bw2, _by2 + _bh2);
    draw_set_color(_nhover ? make_color_rgb(68, 168, 48) : make_color_rgb(28, 16, 6));
    draw_rectangle(_nx, _by2, _nx + _bw2, _by2 + _bh2, false);
    draw_set_color(make_color_rgb(68, 168, 48));
    draw_rectangle(_nx, _by2, _nx + _bw2, _by2 + _bh2, true);
    draw_set_color(make_color_rgb(10, 60, 10));
    draw_text(_nx + (_bw2/2) + 1, _by2 + (_bh2/2) + 1, "No! :)");
    draw_set_color(c_white);
    draw_text(_nx + (_bw2/2),     _by2 + (_bh2/2),     "No! :)");
}

// =========================================================
// CONFIGURAÇÕES  — sliders expandidos inline (sem função local)
// =========================================================
else if (estado_menu == "configuracoes") {

    var _sw  = 200;
    var _sh  = 10;
    var _sx2 = _cx - (_sw / 2);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // --------------------------------------------------
    // MUSIC VOLUME
    // --------------------------------------------------
    var _sy_m = _jy + 148;

    draw_set_color(make_color_rgb(255, 234, 185));
    draw_text(_cx, _sy_m - 26, "MUSIC VOLUME");

    // Track fundo
    draw_set_color(make_color_rgb(20, 60, 20));
    draw_rectangle(_sx2, _sy_m - _sh/2, _sx2 + _sw, _sy_m + _sh/2, false);
    // Preenchimento
    draw_set_color(make_color_rgb(78, 178, 58));
    draw_rectangle(_sx2, _sy_m - _sh/2, _sx2 + (volume_musica * _sw), _sy_m + _sh/2, false);
    // Borda interna
    draw_set_color(make_color_rgb(30, 100, 30));
    draw_rectangle(_sx2, _sy_m - _sh/2, _sx2 + _sw, _sy_m + _sh/2, true);
    // Borda externa dourada
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_sx2 - 1, _sy_m - _sh/2 - 1, _sx2 + _sw + 1, _sy_m + _sh/2 + 1, true);

    // Handle dourado
    var _hx_m = _sx2 + (volume_musica * _sw) - 7;
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_hx_m, _sy_m - 9, _hx_m + 14, _sy_m + 9, false);
    draw_set_color(make_color_rgb(118, 76, 10));
    draw_rectangle(_hx_m, _sy_m - 9, _hx_m + 14, _sy_m + 9, true);

    // Percentagem
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_text(_cx, _sy_m + 22, string(round(volume_musica * 100)) + "%");

    // --------------------------------------------------
    // SFX VOLUME
    // --------------------------------------------------
    var _sy_s = _jy + 238;

    draw_set_color(make_color_rgb(255, 234, 185));
    draw_text(_cx, _sy_s - 26, "SFX VOLUME");

    // Track fundo
    draw_set_color(make_color_rgb(20, 60, 20));
    draw_rectangle(_sx2, _sy_s - _sh/2, _sx2 + _sw, _sy_s + _sh/2, false);
    // Preenchimento
    draw_set_color(make_color_rgb(78, 178, 58));
    draw_rectangle(_sx2, _sy_s - _sh/2, _sx2 + (volume_sfx * _sw), _sy_s + _sh/2, false);
    // Borda interna
    draw_set_color(make_color_rgb(30, 100, 30));
    draw_rectangle(_sx2, _sy_s - _sh/2, _sx2 + _sw, _sy_s + _sh/2, true);
    // Borda externa dourada
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_sx2 - 1, _sy_s - _sh/2 - 1, _sx2 + _sw + 1, _sy_s + _sh/2 + 1, true);

    // Handle dourado
    var _hx_s = _sx2 + (volume_sfx * _sw) - 7;
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_hx_s, _sy_s - 9, _hx_s + 14, _sy_s + 9, false);
    draw_set_color(make_color_rgb(118, 76, 10));
    draw_rectangle(_hx_s, _sy_s - 9, _hx_s + 14, _sy_s + 9, true);

    // Percentagem
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_text(_cx, _sy_s + 22, string(round(volume_sfx * 100)) + "%");

    // --------------------------------------------------
    // Botão BACK
    // --------------------------------------------------
    var _vx     = _cx - 80;
    var _vy     = _jy + _jh - 62;
    var _vhover = point_in_rectangle(_mx, _my, _vx, _vy, _vx + 160, _vy + 40);

    draw_set_color(_vhover ? make_color_rgb(210, 158, 42) : make_color_rgb(28, 16, 6));
    draw_rectangle(_vx, _vy, _vx + 160, _vy + 40, false);
    draw_set_color(_vhover ? make_color_rgb(210, 158, 42) : make_color_rgb(118, 76, 10));
    draw_rectangle(_vx, _vy, _vx + 160, _vy + 40, true);

    draw_set_color(make_color_rgb(118, 76, 10));
    draw_text(_vx + 81, _vy + 21, "< Back");
    draw_set_color(_vhover ? make_color_rgb(42, 26, 10) : make_color_rgb(255, 234, 185));
    draw_text(_vx + 80, _vy + 20, "< Back");
}

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);