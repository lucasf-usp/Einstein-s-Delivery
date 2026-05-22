estado_menu = "main";
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _cx  = _gw / 2;
var _bw  = 338;   // 260 * 1.3
var _bh  = 60;    // 46  * 1.3
var _by0 = _gh * 0.44;
var _gap = 78;    // 60  * 1.3

botoes = [
    { label : "> PHASES",    acao : "fases"   },
    { label : "> SETTINGS",  acao : "configs" },
    { label : "> QUIT GAME", acao : "sair"    }
];
for (var i = 0; i < array_length(botoes); i++) {
    botoes[i].x     = _cx - (_bw / 2);
    botoes[i].y     = _by0 + (i * _gap);
    botoes[i].w     = _bw;
    botoes[i].h     = _bh;
    botoes[i].hover = false;
}

var _bw_f  = 338;
var _bh_f  = 60;
var _by0_f = _gh * 0.42;
var _gap_f = 73;   // 56 * 1.3

botoes_fases = [
    { label : "> TUTORIAL", acao : "tutorial" },
    { label : "> PHASE 1",  acao : "fase1"    },
    { label : "> PHASE 2",  acao : "fase2"    },
    { label : "> PHASE 3",  acao : "fase3"    }
];
for (var i = 0; i < array_length(botoes_fases); i++) {
    botoes_fases[i].x     = _cx - (_bw_f / 2);
    botoes_fases[i].y     = _by0_f + (i * _gap_f);
    botoes_fases[i].w     = _bw_f;
    botoes_fases[i].h     = _bh_f;
    botoes_fases[i].hover = false;
}

// ── Load best star results from save file ──
ini_open("einstein_save.ini");
estrelas_fases = [
    ini_read_real("stars", "tutorial", 0),
    ini_read_real("stars", "fase1",    0),
    ini_read_real("stars", "fase2",    0),
    ini_read_real("stars", "fase3",    0)
];
ini_close();

configs_largura = 320;
configs_altura  = 300;
configs_x       = (_gw / 2) - (configs_largura / 2);
configs_y       = (_gh / 2) - (configs_altura / 2);

volume_musica = audio_group_get_gain(audiogroup_default);
volume_sfx    = 1.0;
cursor_timer  = 0;