//obj_pause_menu create
// Estado atual: "jogo" | "confirmacao" | "configuracoes"
estado_menu = "jogo";

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

janela_largura = 280;
janela_altura  = 360;
janela_x       = (_gw / 2) - (janela_largura / 2);
janela_y       = (_gh / 2) - (janela_altura / 2);

var _bx  = janela_x + (janela_largura / 2);
var _by  = janela_y + 110;
var _bw  = 220;
var _bh  = 44;
var _gap = 58;

botoes = [
    { label : "> CONTINUE",      acao : "continuar"     },
    { label : "> RESTART LEVEL", acao : "recomecar"     },
    { label : "> SETTINGS",      acao : "configuracoes" },
    { label : "> MAIN MENU",     acao : "menu_principal"}
];

for (var i = 0; i < array_length(botoes); i++) {
    botoes[i].x     = _bx - (_bw / 2);
    botoes[i].y     = _by + (i * _gap);
    botoes[i].w     = _bw;
    botoes[i].h     = _bh;
    botoes[i].hover = false;
}

volume_musica     = audio_group_get_gain(audiogroup_default);
volume_sfx        = 1.0;
confirmacao_acao  = "";
confirmacao_texto = "";
cooldown_input    = 10;