var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _cx = _gw / 2;

// =========================================================
// BACKGROUND — sprite + dim (main and fases share it)
// =========================================================
if (estado_menu == "main" || estado_menu == "fases") {
    draw_sprite_stretched(Sprite24, 0, 0, 0, _gw, _gh);
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(14, 8, 2));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
} else {
    draw_set_color(make_color_rgb(14, 8, 2));
    draw_rectangle(0, 0, _gw, _gh, false);
}

// Stars (dim)
draw_set_color(make_color_rgb(80, 60, 20));
for (var _dx = 0; _dx < _gw; _dx += 40) {
    for (var _dy = 0; _dy < _gh; _dy += 40) {
        draw_point(_dx + 6,  _dy + 6);
        draw_point(_dx + 22, _dy + 18);
        draw_point(_dx + 34, _dy + 30);
    }
}
draw_set_color(make_color_rgb(210, 158, 42));
for (var _dx = 0; _dx < _gw; _dx += 120) {
    for (var _dy = 0; _dy < _gh; _dy += 90) {
        draw_point(_dx + 60, _dy + 45);
    }
}

// Ground line
draw_set_color(make_color_rgb(210, 158, 42));
draw_line_width(0, _gh - 5, _gw, _gh - 5, 3);
draw_set_color(make_color_rgb(118, 76, 10));
draw_line_width(0, _gh - 9, _gw, _gh - 9, 1);

// =========================================================
// TITLE  (+40% scale: 2.5 → 3.5)
// =========================================================
draw_set_font(fnt_Pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _ty = _gh * 0.18;   // moved up slightly to give room below

draw_set_color(make_color_rgb(80, 50, 0));
draw_text_transformed(_cx + 3, _ty + 3, "EINSTEIN'S DELIVERY", 3.5, 3.5, 0);
draw_set_color(make_color_rgb(210, 158, 42));
draw_text_transformed(_cx,     _ty,     "EINSTEIN'S DELIVERY", 3.5, 3.5, 0);

draw_set_color(make_color_rgb(180, 148, 90));
draw_text_transformed(_cx, _ty + 66, "A special relativity game!", 1.19, 1.19, 0);

// Ornament
var _ly = _ty + 96;
draw_set_color(make_color_rgb(118, 76, 10));
draw_line_width(_cx - 160, _ly,     _cx + 160, _ly,     1);
draw_set_color(make_color_rgb(210, 158, 42));
draw_line_width(_cx - 160, _ly - 2, _cx + 160, _ly - 2, 1);
var _ds = 6;
draw_set_color(make_color_rgb(210, 158, 42));
draw_triangle(_cx, _ly - _ds, _cx + _ds, _ly, _cx, _ly + _ds, false);
draw_triangle(_cx, _ly - _ds, _cx - _ds, _ly, _cx, _ly + _ds, false);

// =========================================================
// MAIN MENU
// =========================================================
if (estado_menu == "main") {

    for (var i = 0; i < array_length(botoes); i++) {
        var _b  = botoes[i];
        var _bx = _b.x; var _by = _b.y;
        var _bw = _b.w; var _bh = _b.h;

        if (_b.hover) {
            draw_set_color(make_color_rgb(210, 158, 42));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
            draw_set_color(make_color_rgb(14, 8, 2));
            draw_rectangle(_bx + 3, _by + 3, _bx + _bw - 3, _by + _bh - 3, false);
            draw_set_color(make_color_rgb(210, 158, 42));
            draw_rectangle(_bx + 3, _by + 3, _bx + _bw - 3, _by + _bh - 3, true);
        } else {
            draw_set_alpha(0.82);
            draw_set_color(make_color_rgb(28, 16, 6));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(118, 76, 10));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
        }

        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        // Shadow
        draw_set_color(make_color_rgb(118, 76, 10));
        draw_text_transformed(_bx + (_bw/2) + 1, _by + (_bh/2) + 1, _b.label, 1.4, 1.4, 0);
        // Label
        draw_set_color(_b.hover ? make_color_rgb(14, 8, 2) : make_color_rgb(255, 234, 185));
        draw_text_transformed(_bx + (_bw/2), _by + (_bh/2), _b.label, 1.4, 1.4, 0);
    }

    // Footer strip
    draw_set_alpha(0.7);
    draw_set_color(make_color_rgb(10, 6, 0));
    draw_rectangle(0, _gh - 32, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(make_color_rgb(210, 168, 60));
    draw_text_transformed(_cx, _gh - 8, "EINSTEIN'S DELIVERY  |  v1.0  |  good luck! :)", 1.1, 1.1, 0);
}

// =========================================================
// PHASES SUBMENU
// =========================================================
else if (estado_menu == "fases") {

    // Header
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_text_transformed(_cx, _ly + 28, "SELECT PHASE", 1.68, 1.68, 0);

    for (var i = 0; i < array_length(botoes_fases); i++) {
        var _b  = botoes_fases[i];
        var _bx = _b.x; var _by = _b.y;
        var _bw = _b.w; var _bh = _b.h;

        if (_b.hover) {
            draw_set_color(make_color_rgb(210, 158, 42));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
            draw_set_color(make_color_rgb(14, 8, 2));
            draw_rectangle(_bx + 3, _by + 3, _bx + _bw - 3, _by + _bh - 3, false);
            draw_set_color(make_color_rgb(210, 158, 42));
            draw_rectangle(_bx + 3, _by + 3, _bx + _bw - 3, _by + _bh - 3, true);
        } else {
            draw_set_alpha(0.82);
            draw_set_color(make_color_rgb(28, 16, 6));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(118, 76, 10));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
        }

        // ── Button label (left-aligned with padding) ──
        draw_set_halign(fa_left); draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(118, 76, 10));
        draw_text_transformed(_bx + 20 + 1, _by + (_bh/2) + 1, _b.label, 1.4, 1.4, 0);
        draw_set_color(_b.hover ? make_color_rgb(14, 8, 2) : make_color_rgb(255, 234, 185));
        draw_text_transformed(_bx + 20,     _by + (_bh/2),     _b.label, 1.4, 1.4, 0);
		
		// ── Stars (3 sprites, right side of button) ──
var _star_count = estrelas_fases[i];
var _star_gap   = 28;
var _star_start = _bx + _bw - 45 - (_star_gap * 2);
var _star_cy    = _by + (_bh / 2) - 20;

for (var s = 0; s < 3; s++) {
    var _sx  = _star_start + (s * _star_gap);
    var _spr = (s < _star_count) ? spr_EstrelaCheia : spr_EstrelaVazia;
    draw_sprite_ext(
        _spr,
        0,          // frame
        _sx,        // x
        _star_cy,   // y
        0.6,        // xscale
        0.6,        // yscale
        0,          // rotation
        c_white,
        1           // alpha
    );
}

    // Back button
    var _last_y = botoes_fases[array_length(botoes_fases) - 1].y;
    var _vw     = 208;
    var _vh     = 52;
    var _vx     = _cx - (_vw / 2);
    var _vy     = _last_y + 73;
    var _vhover = point_in_rectangle(_mx, _my, _vx, _vy, _vx + _vw, _vy + _vh);

    draw_set_alpha(0.82);
    draw_set_color(_vhover ? make_color_rgb(210, 158, 42) : make_color_rgb(28, 16, 6));
    draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
    draw_set_alpha(1);
    draw_set_color(_vhover ? make_color_rgb(210, 158, 42) : make_color_rgb(118, 76, 10));
    draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, true);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(118, 76, 10));
    draw_text_transformed(_vx + (_vw/2) + 1, _vy + (_vh/2) + 1, "< Back", 1.4, 1.4, 0);
    draw_set_color(_vhover ? make_color_rgb(42, 26, 10) : make_color_rgb(255, 234, 185));
    draw_text_transformed(_vx + (_vw/2), _vy + (_vh/2), "< Back", 1.4, 1.4, 0);
}
}

// =========================================================
// SETTINGS
// =========================================================
else if (estado_menu == "configuracoes") {

    var _jy = _gh * 0.28;
    var _jh = _gh * 0.68;
    var _sw  = 200;
    var _sh  = 10;
    var _sx2 = _cx - (_sw / 2);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _sy_m = _jy + 148;
    draw_set_color(make_color_rgb(255, 234, 185));
    draw_text_transformed(_cx, _sy_m - 26, "MUSIC VOLUME", 1.4, 1.4, 0);

    draw_set_color(make_color_rgb(20, 60, 20));
    draw_rectangle(_sx2, _sy_m - _sh/2, _sx2 + _sw, _sy_m + _sh/2, false);
    draw_set_color(make_color_rgb(78, 178, 58));
    draw_rectangle(_sx2, _sy_m - _sh/2, _sx2 + (volume_musica * _sw), _sy_m + _sh/2, false);
    draw_set_color(make_color_rgb(30, 100, 30));
    draw_rectangle(_sx2, _sy_m - _sh/2, _sx2 + _sw, _sy_m + _sh/2, true);
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_sx2 - 1, _sy_m - _sh/2 - 1, _sx2 + _sw + 1, _sy_m + _sh/2 + 1, true);
    var _hx_m = _sx2 + (volume_musica * _sw) - 7;
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_hx_m, _sy_m - 9, _hx_m + 14, _sy_m + 9, false);
    draw_set_color(make_color_rgb(118, 76, 10));
    draw_rectangle(_hx_m, _sy_m - 9, _hx_m + 14, _sy_m + 9, true);
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_text_transformed(_cx, _sy_m + 26, string(round(volume_musica * 100)) + "%", 1.4, 1.4, 0);

    var _sy_s = _jy + 238;
    draw_set_color(make_color_rgb(255, 234, 185));
    draw_text_transformed(_cx, _sy_s - 26, "SFX VOLUME", 1.4, 1.4, 0);

    draw_set_color(make_color_rgb(20, 60, 20));
    draw_rectangle(_sx2, _sy_s - _sh/2, _sx2 + _sw, _sy_s + _sh/2, false);
    draw_set_color(make_color_rgb(78, 178, 58));
    draw_rectangle(_sx2, _sy_s - _sh/2, _sx2 + (volume_sfx * _sw), _sy_s + _sh/2, false);
    draw_set_color(make_color_rgb(30, 100, 30));
    draw_rectangle(_sx2, _sy_s - _sh/2, _sx2 + _sw, _sy_s + _sh/2, true);
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_sx2 - 1, _sy_s - _sh/2 - 1, _sx2 + _sw + 1, _sy_s + _sh/2 + 1, true);
    var _hx_s = _sx2 + (volume_sfx * _sw) - 7;
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_rectangle(_hx_s, _sy_s - 9, _hx_s + 14, _sy_s + 9, false);
    draw_set_color(make_color_rgb(118, 76, 10));
    draw_rectangle(_hx_s, _sy_s - 9, _hx_s + 14, _sy_s + 9, true);
    draw_set_color(make_color_rgb(210, 158, 42));
    draw_text_transformed(_cx, _sy_s + 26, string(round(volume_sfx * 100)) + "%", 1.4, 1.4, 0);

    var _vx     = _cx - 80;
    var _vy     = _jy + _jh - 62;
    var _vhover = point_in_rectangle(_mx, _my, _vx, _vy, _vx + 160, _vy + 40);
    draw_set_color(_vhover ? make_color_rgb(210, 158, 42) : make_color_rgb(28, 16, 6));
    draw_rectangle(_vx, _vy, _vx + 160, _vy + 40, false);
    draw_set_color(_vhover ? make_color_rgb(210, 158, 42) : make_color_rgb(118, 76, 10));
    draw_rectangle(_vx, _vy, _vx + 160, _vy + 40, true);
    draw_set_color(make_color_rgb(118, 76, 10));
    draw_text_transformed(_vx + 81, _vy + 21, "< Back", 1.4, 1.4, 0);
    draw_set_color(_vhover ? make_color_rgb(42, 26, 10) : make_color_rgb(255, 234, 185));
    draw_text_transformed(_vx + 80, _vy + 20, "< Back", 1.4, 1.4, 0);
	
	// Reset Progress button
var _rx     = _cx - 100;
var _ry     = _jy + _jh - 118; // above the Back button
var _rw     = 200;
var _rh     = 40;
var _rhover = point_in_rectangle(_mx, _my, _rx, _ry, _rx + _rw, _ry + _rh);

draw_set_color(_rhover ? make_color_rgb(218, 64, 44) : make_color_rgb(28, 16, 6));
draw_rectangle(_rx, _ry, _rx + _rw, _ry + _rh, false);
draw_set_color(_rhover ? make_color_rgb(218, 64, 44) : make_color_rgb(140, 20, 10));
draw_rectangle(_rx, _ry, _rx + _rw, _ry + _rh, true);
draw_set_color(make_color_rgb(80, 10, 5));
draw_text_transformed(_rx + (_rw/2) + 1, _ry + (_rh/2) + 1, "RESET PROGRESS", 1.1, 1.1, 0);
draw_set_color(make_color_rgb(255, 234, 185));
draw_text_transformed(_rx + (_rw/2), _ry + (_rh/2), "RESET PROGRESS", 1.1, 1.1, 0);
}

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);