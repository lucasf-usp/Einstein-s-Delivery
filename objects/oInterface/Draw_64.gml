// --- EVENTO: Draw GUI Interface ---

#macro COR_PAINEL       make_color_rgb(42, 26, 10)
#macro COR_BORDA_OURO   make_color_rgb(210, 158, 42)
#macro COR_BORDA_ESCURA make_color_rgb(118, 76, 10)
#macro COR_CREME        make_color_rgb(255, 234, 185)
#macro COR_VERDE        make_color_rgb(88, 208, 68)
#macro COR_AQUA         make_color_rgb(68, 198, 218)
#macro COR_AMARELO      make_color_rgb(252, 200, 0)
#macro COR_VERMELHO     make_color_rgb(218, 64, 44)

var formatar_tempo = function(_s) {
    var _m   = floor(_s / 60);
    var _ss  = floor(_s mod 60);
    var _sm  = (_m  < 10) ? "0" + string(_m)  : string(_m);
    var _sss = (_ss < 10) ? "0" + string(_ss) : string(_ss);
    return _sm + ":" + _sss;
};

display_set_gui_size(480, 270);

display_set_gui_size(window_get_width(), window_get_height());

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

// Recalculate HUD positions every frame:
velocimetro_x = 100;
velocimetro_y = _gh - 50;
relogio_x     = velocimetro_x + 105;
relogio_y     = velocimetro_y;
regua_x_fim   = _gw - 40;
regua_x_inicio = regua_x_fim - 340;
regua_y       = _gh - 45;

// =========================================================
// INTRO SCREEN DRAW
// =========================================================
if (tutorial_intro_ativo) {
    var _intro_text =
        "Welcome to a world where light likes to take it slow!\n" +
        "Here, the speed of light is so low that relativistic\n" +
        "phenomena happen while riding your bike.\n" +
        "It's a relativistic riot out there!\n\n" +
        "As Einstein, your mission is to deliver piping-hot\n" +
        "pizzas to the world's brightest minds! These scientists\n" +
        "are busy studying the secrets of the universe,\n" +
        "and they're starving!\n\n" +
        "So let's get moving!";

    // Dark panel — top portion only, player visible below
    draw_set_alpha(0.90);
    draw_set_color(make_color_rgb(10, 6, 2));
    draw_rectangle(0, 0, _gw, _gh * 0.4, false);
    draw_set_alpha(1);

    // Gold border at the bottom of the panel
    draw_set_color(COR_BORDA_OURO);
    draw_line_width(0, _gh * 0.40, _gw, _gh * 0.4, 3);
    draw_set_color(COR_BORDA_ESCURA);
    draw_line_width(0, _gh * 0.40 + 4, _gw, _gh * 0.4 + 4, 1);

    // Title
    draw_set_font(fnt_Pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_cx + 2, 18 + 2, "~ TUTORIAL ~", 1.6, 1.6, 0);
    draw_set_color(COR_BORDA_OURO);
    draw_text_transformed(_cx,     18,     "~ TUTORIAL ~", 1.6, 1.6, 0);

    // Ornament line under title
    draw_set_color(COR_BORDA_ESCURA);
    draw_line_width(_cx - 120, 53, _cx + 120, 53, 1);
    draw_set_color(COR_BORDA_OURO);
    draw_line_width(_cx - 120, 51, _cx + 120, 51, 1);

    // Body text
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_cx + 1, 67 + 1, _intro_text, 0.95, 0.95, 0);
    draw_set_color(COR_CREME);
    draw_text_transformed(_cx,     67,     _intro_text, 0.95, 0.95, 0);

    // Progress bar OR skip prompt
    var _bar_y = _gh * 0.40 - 22;
    if (!tutorial_intro_can_skip) {
        var _progress = tutorial_intro_timer / (game_get_speed(gamespeed_fps) * 15);
        var _bar_w    = 260;
        var _bar_x    = _cx - (_bar_w / 2);

        draw_set_color(make_color_rgb(40, 24, 8));
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + 6, false);
        draw_set_color(COR_BORDA_OURO);
        draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w * _progress), _bar_y + 6, false);
        draw_set_color(COR_BORDA_ESCURA);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + 6, true);

        draw_set_alpha(0.6);
        draw_set_color(make_color_rgb(180, 140, 60));
        draw_set_halign(fa_center);
        draw_text_transformed(_cx, _bar_y - 16, "please wait...", 0.9, 0.9, 0);
        draw_set_alpha(1);
    } else {
        var _pulse = 0.55 + (sin(current_time / 200) * 0.45);
        draw_set_alpha(_pulse);
        draw_set_color(COR_BORDA_OURO);
        draw_set_halign(fa_center);
        draw_text_transformed(_cx, _bar_y, "[ PRESS ANY KEY TO CONTINUE ]", 1.0, 1.0, 0);
        draw_set_alpha(1);
    }

    // Reset draw state
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);
    exit; // Don't draw HUD while intro is showing
}

// =========================================================
// HUD NORMAL (só desenha durante o jogo)
// =========================================================
if (estado_interface == "jogo" && !instance_exists(obj_pause_menu)) {

    // -------------------------------------------------
    // 1. VELOCÍMETRO
    // -------------------------------------------------
    if (instance_exists(obj_player)) {

        var vel_atual = abs(obj_player.xspd);
        var vel_luz   = obj_player.vel_maxima;
        var fracao_c  = vel_atual / vel_luz;
        var txt_vel   = string_format(fracao_c, 1, 2) + "c";

        draw_sprite(spr_velocimetro, 0, velocimetro_x, velocimetro_y);
        draw_sprite_ext(spr_velocimetro_agulha, 0, velocimetro_x, velocimetro_y,
                        1, 1, angulo_agulha_atual, c_white, 1);

        var _vt_x   = velocimetro_x;
        var _vt_y   = velocimetro_y + 8;
        var _vt_w   = 46;
        var _vt_h   = 18;
        var _cor_vel = (fracao_c >= 0.90) ? COR_VERMELHO : COR_AMARELO;

        draw_set_color(COR_PAINEL);
        draw_rectangle(_vt_x - _vt_w/2, _vt_y, _vt_x + _vt_w/2, _vt_y + _vt_h, false);
        draw_set_color(_cor_vel);
        draw_rectangle(_vt_x - _vt_w/2, _vt_y, _vt_x + _vt_w/2, _vt_y + _vt_h, true);

        draw_set_font(fnt_Pixel);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(COR_BORDA_ESCURA);
        draw_text(_vt_x + 1, _vt_y + _vt_h/2 + 1, txt_vel);
        draw_set_color(_cor_vel);
        draw_text(_vt_x,     _vt_y + _vt_h/2,     txt_vel);
    }
	
// =========================================================
// TUTORIAL OVERLAY
// =========================================================
if (tutorial_ativo) {
    var _titulo  = "";
    var _corpo   = "";
    var _dica    = "";
    var _prompt  = "[ PRESS ANY KEY ]";
    var _arrow_x = -1;
    var _arrow_y = -1;

switch (tutorial_passo) {
    case 0:
        _titulo = "CONTROLS";
        _corpo  = "Use ←  →  to run.\nPress  ↑  to jump.\nHold  ↓  to crouch under obstacles.";
        _dica   = "PRESS  →  TO CONTINUE";
        _prompt = "";
    break;
    case 1:
        _titulo = "SPEEDOMETER";
        _corpo  = "This shows your speed as a fraction\nof the speed of light (c).\nIf you reach 1.00c it's GAME OVER.";
        _dica   = "PRESS  →  TO CONTINUE";
        _prompt = "";
        _arrow_x = velocimetro_x;
        _arrow_y = velocimetro_y - 30;
    break;
    case 2:
        _titulo = "THE CLOCK";
        _corpo  = "This clock has three hands.\nEach one tracks a different time.\nRelativity makes them tick differently!";
        _dica   = "";
        _arrow_x = relogio_x;
        _arrow_y = relogio_y - 30;
    break;
    case 3:
        _titulo = "OWN TIME vs CLIENT TIME";
        _corpo  = "Own Time (green): time YOU experience.\nClient Time (blue): time at the destination.\nThe faster you run, the faster tim passes for the client!";
        _dica   = "Keep Client Time below the Deadline.";
        _arrow_x = relogio_x + 58;
        _arrow_y = relogio_y - 36;
    break;
    case 4:
        _titulo = "THE PAUSE MENU";
        _corpo  = "At any time, press  SPACE  to pause.\nFrom there you can:\n- Continue the run\n- Restart the level\n- Change settings\n- Return to the Main Menu";
        _dica   = "";
    break;
    case 5:
        if (tutorial_sub_passo == 0) {
            _titulo = "THE DOPPLER EFFECT";
            _corpo  = "Notice the color shift as you speed up!\nAccelerate toward the speed of light\nto see it at full intensity!";
            _dica   = "  REACH 0.92c TO CONTINUE";
            _prompt = "";
        } else {
            _titulo = "WHAT YOU'RE SEEING";
            _corpo  = "Light ahead bunches up — shifting BLUE.\nLight behind stretches out — shifting RED.\nThis is the Doppler Effect, and it's real!\nWatch the clock hands diverging too.";
            _dica   = "The faster you go, the stronger it gets.";
        }
    break;
    case 6:
    _titulo = "OBSTACLES";
    _corpo  = "PUDDLES slow you down — you'll freeze\nbriefly then regain speed automatically.\n Unless they're on the other side of the road.\nBRANCHES block your path at head height.\nHold  ↓  to crouch under them!";
    _dica   = "Run through an obstacle or press ↑ / ↓";
    _prompt = "";
break;
case 7:
    _titulo = "DELIVER THE PIZZA!";
    _corpo  = "Reach the client (marked on the bar below)\nbefore their time runs out.\nThe sooner you arrive, the more stars you earn.\nGood luck, Einstein!";
    _dica   = "";
    _arrow_x = regua_x_fim;
    _arrow_y = regua_y - 20;
break;

}
    // --- Panel dimensions: top-left ---
    var _pw = 380;
    var _ph = 180;
    var _px = 20;
    var _py = 20;

    // --- Arrow pointing to HUD element ---
if (_arrow_x != -1) {
    var _panel_cx = _px + _pw / 2;
    var _panel_cy = _py + _ph;
    draw_set_alpha(tutorial_alpha * 0.9);
    draw_set_color(COR_BORDA_OURO);

    if (tutorial_passo == 7) {
        // Bent arrow: goes straight down to y=215, then across to the régua end
        var _bend_y = 240;
        draw_line_width(_panel_cx, _panel_cy, _panel_cx, _bend_y, 2);
        draw_line_width(_panel_cx, _bend_y, _arrow_x, _arrow_y, 2);
        var _ang = point_direction(_panel_cx, _bend_y, _arrow_x, _arrow_y);
        var _ax1 = _arrow_x + lengthdir_x(10, _ang + 145);
        var _ay1 = _arrow_y + lengthdir_y(10, _ang + 145);
        var _ax2 = _arrow_x + lengthdir_x(10, _ang - 145);
        var _ay2 = _arrow_y + lengthdir_y(10, _ang - 145);
        draw_triangle(_arrow_x, _arrow_y, _ax1, _ay1, _ax2, _ay2, false);
    } else {
        draw_line_width(_panel_cx, _panel_cy, _arrow_x, _arrow_y, 2);
        var _ang = point_direction(_panel_cx, _panel_cy, _arrow_x, _arrow_y);
        var _ax1 = _arrow_x + lengthdir_x(10, _ang + 145);
        var _ay1 = _arrow_y + lengthdir_y(10, _ang + 145);
        var _ax2 = _arrow_x + lengthdir_x(10, _ang - 145);
        var _ay2 = _arrow_y + lengthdir_y(10, _ang - 145);
        draw_triangle(_arrow_x, _arrow_y, _ax1, _ay1, _ax2, _ay2, false);
    }
    draw_set_alpha(1);
}

    // --- Panel background ---
    draw_set_alpha(tutorial_alpha * 0.93);
    draw_set_color(COR_PAINEL);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_color(COR_BORDA_ESCURA);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);
    draw_set_color(COR_BORDA_OURO);
    draw_rectangle(_px - 2, _py - 2, _px + _pw + 2, _py + _ph + 2, true);
    draw_set_alpha(tutorial_alpha);

    // --- Step counter ---
    draw_set_font(fnt_Pixel);
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(COR_BORDA_ESCURA);
    draw_set_color(COR_BORDA_OURO);
draw_text_transformed(_px + _pw - 7, _py + 7, string(tutorial_passo + 1) + " / 8", 0.7, 0.7, 0);
draw_text_transformed(_px + _pw - 8, _py + 6, string(tutorial_passo + 1) + " / 8", 0.7, 0.7, 0);

    // --- Title ---
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_px + 15 + 1, _py + 14 + 1, _titulo, 1.1, 1.1, 0);
    draw_set_color(COR_BORDA_OURO);
    draw_text_transformed(_px + 15,     _py + 14,     _titulo, 1.1, 1.1, 0);

    // --- Separator ---
    draw_set_color(COR_BORDA_ESCURA);
    draw_line_width(_px + 12, _py + 38, _px + _pw - 12, _py + 38, 1);
    draw_set_color(COR_BORDA_OURO);
    draw_line_width(_px + 12, _py + 40, _px + _pw - 12, _py + 40, 1);

    // --- Body text ---
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_ext(_px + 16, _py + 50, _corpo, 20, _pw - 28);
    draw_set_color(COR_CREME);
    draw_text_ext(_px + 15, _py + 49, _corpo, 20, _pw - 28);

    // --- Hint line ---
    if (_dica != "") {
        draw_set_color(COR_BORDA_ESCURA);
        draw_text_transformed(_px + 16, _py + _ph - 34, _dica, 0.8, 0.8, 0);
        draw_set_color(COR_AMARELO);
        draw_text_transformed(_px + 15, _py + _ph - 35, _dica, 0.8, 0.8, 0);
    }

    // --- Prompt pisca ---
if (_prompt != "" && (current_time mod 800) < 500) {
    draw_set_halign(fa_left);
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_px + 16 + 1, _py + _ph - 16 + 1, _prompt, 0.75, 0.75, 0);
    draw_set_color(make_color_rgb(180, 148, 80));
    draw_text_transformed(_px + 16,     _py + _ph - 16,     _prompt, 0.75, 0.75, 0);
}

    draw_set_alpha(1);
}

    // -------------------------------------------------
    // 2. RELÓGIO + TEXTOS
    // -------------------------------------------------
    var str_prazo   = formatar_tempo(tempo_limite_segundos);
    var str_jogador = formatar_tempo(tempo_jogador);
    var str_cliente = formatar_tempo(tempo_cliente);

    var cor_cliente = COR_AQUA;
    if      (tempo_cliente >= tempo_limite_segundos)         { cor_cliente = COR_VERMELHO; }
    else if (tempo_cliente >= tempo_limite_segundos * 0.8)   { cor_cliente = COR_AMARELO;  }

    draw_sprite(spr_relogio_fundo, 0, relogio_x, relogio_y);

    var ang_prazo   = -((tempo_limite_segundos / tempo_volta_completa) * 360);
    var ang_jogador = -((tempo_jogador         / tempo_volta_completa) * 360);
    var ang_cliente = -((tempo_cliente         / tempo_volta_completa) * 360);

    draw_sprite_ext(spr_ponteiro_prazo,   0, relogio_x, relogio_y, 1, 1, ang_prazo,   COR_CREME,   0.5);
    draw_sprite_ext(spr_ponteiro_jogador, 0, relogio_x, relogio_y, 1, 1, ang_jogador, COR_VERDE,   1  );
    draw_sprite_ext(spr_ponteiro_cliente, 0, relogio_x, relogio_y, 1, 1, ang_cliente, cor_cliente, 1  );

    draw_set_font(fnt_Pixel);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    var tx  = relogio_x + 56;
    var ty  = relogio_y - 28;
    var tlh = 22;

    draw_set_color(COR_BORDA_ESCURA);
    draw_text(tx + 1, ty + 1,         "Deadline: "  + str_prazo);
    draw_set_color(COR_CREME);
    draw_text(tx,     ty,              "Deadline: "  + str_prazo);

    draw_set_color(COR_BORDA_ESCURA);
    draw_text(tx + 1, ty + tlh + 1,   "Own time: "  + str_jogador);
    draw_set_color(COR_VERDE);
    draw_text(tx,     ty + tlh,        "Own time: "  + str_jogador);

    draw_set_color(COR_BORDA_ESCURA);
    draw_text(tx + 1, ty + tlh*2 + 1, "Client time: " + str_cliente);
    draw_set_color(cor_cliente);
    draw_text(tx,     ty + tlh*2,     "Client time: " + str_cliente);

    // -------------------------------------------------
    // 3. RÉGUA DE PROGRESSO
    // -------------------------------------------------
    var _r_y   = regua_y;
    var _r_h   = 14;
    var _r_ini = regua_x_inicio;
    var _r_fim = regua_x_fim;
    var _r_w   = _r_fim - _r_ini;

    draw_set_color(make_color_rgb(20, 60, 20));
    draw_rectangle(_r_ini, _r_y - _r_h/2, _r_fim, _r_y + _r_h/2, false);

    var _pos_player = _r_ini;
    if (distancia_total_real > 0 && instance_exists(obj_player)) {
        var _dist_andada = clamp(obj_player.x - x_inicio_corrida, 0, distancia_total_real);
        var _progresso   = _dist_andada / distancia_total_real;
        _pos_player      = _r_ini + (_progresso * _r_w);

        draw_set_color(make_color_rgb(78, 196, 58));
        draw_rectangle(_r_ini, _r_y - _r_h/2, _pos_player, _r_y + _r_h/2, false);
    }

    draw_set_color(make_color_rgb(30, 100, 30));
    var _num_ticks = 10;
    for (var _t = 1; _t < _num_ticks; _t++) {
        var _tx2 = _r_ini + (_r_w * _t / _num_ticks);
        var _th  = (_t mod 5 == 0) ? _r_h : _r_h / 2;
        draw_line_width(_tx2, _r_y - _th/2, _tx2, _r_y + _th/2, 1);
    }

    draw_set_color(make_color_rgb(30, 100, 30));
    draw_rectangle(_r_ini,     _r_y - _r_h/2,     _r_fim,     _r_y + _r_h/2,     true);
    draw_set_color(make_color_rgb(88, 208, 68));
    draw_rectangle(_r_ini - 1, _r_y - _r_h/2 - 1, _r_fim + 1, _r_y + _r_h/2 + 1, true);

    draw_set_color(COR_BORDA_OURO);
    draw_rectangle(_r_fim - 5, _r_y - 9, _r_fim + 5, _r_y + 9, false);
    draw_set_color(COR_BORDA_ESCURA);
    draw_rectangle(_r_fim - 5, _r_y - 9, _r_fim + 5, _r_y + 9, true);

    draw_set_color(COR_VERMELHO);
    draw_rectangle(_pos_player - 5, _r_y - 9, _pos_player + 5, _r_y + 9, false);
    draw_set_color(make_color_rgb(140, 20, 10));
    draw_rectangle(_pos_player - 5, _r_y - 9, _pos_player + 5, _r_y + 9, true);

    draw_set_font(fnt_Pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_r_fim + 1,      _r_y - 13 + 1, "Client",   0.75, 0.75, 0);
    draw_set_color(COR_BORDA_OURO);
    draw_text_transformed(_r_fim,          _r_y - 13,     "Client",   0.75, 0.75, 0);

    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_pos_player + 1, _r_y - 13 + 1, "Einstein", 0.75, 0.75, 0);
    draw_set_color(COR_VERMELHO);
    draw_text_transformed(_pos_player,     _r_y - 13,     "Einstein", 0.75, 0.75, 0);
}

// =========================================================
// TELA DE GAME OVER
// =========================================================
else if (estado_interface == "game_over") {

    // Overlay escuro
    draw_set_alpha(0.82);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // Painel central
    var _pw = 520;
    var _ph = 220;
    var _px = _cx - _pw / 2;
    var _py = _cy - _ph / 2;

    draw_set_color(make_color_rgb(28, 6, 4));
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_color(COR_VERMELHO);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);
    draw_set_color(make_color_rgb(140, 20, 10));
    draw_rectangle(_px + 3, _py + 3, _px + _pw - 3, _py + _ph - 3, true);

    draw_set_font(fnt_Pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Título
    draw_set_color(make_color_rgb(140, 20, 10));
    draw_text_transformed(_cx + 2, _py + 52 + 2, "GAME OVER", 2.2, 2.2, 0);
    draw_set_color(COR_VERMELHO);
    draw_text_transformed(_cx,     _py + 52,     "GAME OVER", 2.2, 2.2, 0);

    // Separador
    draw_set_color(make_color_rgb(140, 20, 10));
    draw_line_width(_px + 20, _py + 88, _px + _pw - 20, _py + 88, 1);
    draw_set_color(COR_VERMELHO);
    draw_line_width(_px + 20, _py + 90, _px + _pw - 20, _py + 90, 1);

    // Mensagem
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_ext(_cx + 1, _cy + 28 + 1,
        "Einstein, you have mass," + chr(10) + "you cannot reach the speed of light!",
        24, _pw - 40);
    draw_set_color(COR_CREME);
    draw_text_ext(_cx,     _cy + 28,
        "Einstein, you have mass," + chr(10) + "you cannot reach the speed of light!",
        24, _pw - 40);

    // Prompt pisca
    if ((current_time mod 800) < 400) {
        draw_set_color(make_color_rgb(180, 80, 60));
        draw_text_transformed(_cx, _py + _ph - 22, "[ PRESS ANY KEY TO RETURN ]", 0.75, 0.75, 0);
    }
}

// =========================================================
// TELA DE FIM DE FASE
// =========================================================
else if (estado_interface == "fim_fase") {

    // Overlay escuro
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(14, 8, 2));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // Painel central
    var _pw = 480;
    var _ph = 380;
    var _px = _cx - _pw / 2;
    var _py = _cy - _ph / 2;

    draw_set_color(COR_PAINEL);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_color(COR_BORDA_ESCURA);
    draw_rectangle(_px,     _py,     _px + _pw,     _py + _ph,     true);
    draw_set_color(COR_BORDA_OURO);
    draw_rectangle(_px - 2, _py - 2, _px + _pw + 2, _py + _ph + 2, true);

    draw_set_font(fnt_Pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Título
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_cx + 2, _py + 38 + 2, "DELIVERY COMPLETE!", 1.6, 1.6, 0);
    draw_set_color(COR_BORDA_OURO);
    draw_text_transformed(_cx,     _py + 38,     "DELIVERY COMPLETE!", 1.6, 1.6, 0);

    // Separador
    draw_set_color(COR_BORDA_ESCURA);
    draw_line_width(_px + 20, _py + 66, _px + _pw - 20, _py + 66, 1);
    draw_set_color(COR_BORDA_OURO);
    draw_line_width(_px + 20, _py + 68, _px + _pw - 20, _py + 68, 1);

    // --- Sprite do jogador (lado esquerdo) ---
 // --- Sprites e Tabela ---
    var _ty  = _py + 140;
    var _tlh = 30;
    var _mid_y = _ty + _tlh; // Vertical center of the time text block

    // Player on the left, aligned with time text
    draw_sprite(spr_PlayerFinal, 0, _px + _pw - 430, _mid_y - 50);

    // Client on the right, aligned with time text
    draw_sprite(spr_Client, 0, _px + _pw - 180, _mid_y - 50);

    // Time text in the center
    var _tx = _cx - 60;
    draw_set_halign(fa_left);
    draw_set_color(COR_BORDA_ESCURA);
    draw_text(_tx + 1, _ty + 1,          "Deadline:    " + formatar_tempo(tempo_limite_segundos));
    draw_set_color(COR_CREME);
    draw_text(_tx,     _ty,              "Deadline:    " + formatar_tempo(tempo_limite_segundos));

    draw_set_color(COR_BORDA_ESCURA);
    draw_text(_tx + 1, _ty + _tlh + 1,   "Own time:   " + formatar_tempo(tempo_jogador));
    draw_set_color(COR_VERDE);
    draw_text(_tx,     _ty + _tlh,        "Own time:   " + formatar_tempo(tempo_jogador));

    var _cor_cli_fim = COR_AQUA;
    if      (tempo_cliente >= tempo_limite_segundos)       { _cor_cli_fim = COR_VERMELHO; }
    else if (tempo_cliente >= tempo_limite_segundos * 0.8) { _cor_cli_fim = COR_AMARELO;  }
    draw_set_color(COR_BORDA_ESCURA);
    draw_text(_tx + 1, _ty + _tlh*2 + 1, "Client time: " + formatar_tempo(tempo_cliente));
    draw_set_color(_cor_cli_fim);
    draw_text(_tx,     _ty + _tlh*2,     "Client time: " + formatar_tempo(tempo_cliente));

    // --- Estrelas (centro, acima da linha) ---
    var _stars_y  = _py + _ph - 130;
    var _star_gap = 60;
    var _stars_x0 = _cx - _star_gap - 25;

    draw_set_halign(fa_center);
    for (var _i = 0; _i < 3; _i++) {
        var _sx = _stars_x0 + (_i * _star_gap);
        if (_i < estrelas_ganhas) {
            draw_sprite(spr_EstrelaCheia, 0, _sx, _stars_y);
        } else {
            draw_sprite(spr_EstrelaVazia, 0, _sx, _stars_y);
        }
    }

    // --- Linha separadora abaixo das estrelas ---
    var _sep_y = _py + _ph - 68;
    draw_set_color(COR_BORDA_ESCURA);
    draw_line_width(_px + 20, _sep_y,     _px + _pw - 20, _sep_y,     1);
    draw_set_color(COR_BORDA_OURO);
    draw_line_width(_px + 20, _sep_y + 2, _px + _pw - 20, _sep_y + 2, 1);

    // Mensagem
    var _msg = "";
    switch (estrelas_ganhas) {
        case 3: _msg = "Perfect delivery!";             break;
        case 2: _msg = "Well done!";                    break;
        case 1: _msg = "Just in time...";               break;
        case 0: _msg = "Too late. The pizza is cold.";  break;
    }
    draw_set_color(COR_BORDA_ESCURA);
    draw_text_transformed(_cx + 1, _sep_y + 18 + 1, _msg, 0.85, 0.85, 0);
    draw_set_color(COR_CREME);
    draw_text_transformed(_cx,     _sep_y + 18,     _msg, 0.85, 0.85, 0);

    // Prompt pisca
    if ((current_time mod 800) < 400) {
        draw_set_color(COR_BORDA_ESCURA);
        draw_text_transformed(_cx, _py + _ph - 14, "[ PRESS ANY KEY TO RETURN ]", 0.75, 0.75, 0);
        draw_set_color(make_color_rgb(180, 148, 80));
        draw_text_transformed(_cx - 1, _py + _ph - 15, "[ PRESS ANY KEY TO RETURN ]", 0.75, 0.75, 0);
    }
}
// =========================================================
// RESET
// =========================================================
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_alpha(1);