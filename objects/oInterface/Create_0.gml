// --- EVENTO: Create Interface ---
surf_pausa = -1;

tutorial_intro_ativo  = (room == rm_tutorial);
tutorial_intro_timer  = 0;
tutorial_intro_can_skip = false;

if (tutorial_intro_ativo && instance_exists(obj_player)) {
    obj_player.pode_mover = false;
    obj_player.xspd       = 0;
}

// oInterface Create — replace the deadline block with this
if (!variable_global_exists("deadline_minutos")) {
    global.deadline_minutos = 6;
}

tempo_limite_minutos  = global.deadline_minutos;
tempo_limite_segundos = tempo_limite_minutos * 60;
tempo_volta_completa  = tempo_limite_segundos; // line 26 now works
_deadline_aplicado    = false; // Begin Step will overwrite with correct value

tempo_jogador = 0;
tempo_cliente = 0;
passo_tempo_jogador = 0;
passo_tempo_cliente = 0;
gamma_atual = 1;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

estado_interface = "jogo"; // "jogo" | "game_over" | "fim_fase"
estrelas_ganhas  = 0;

// --- Velocímetro (Canto Inferior Esquerdo) ---
velocimetro_x = 100;
velocimetro_y = _gui_h - 50;
angulo_agulha_atual = 180;

// --- Relógio ---
relogio_x = velocimetro_x + 105;
relogio_y = velocimetro_y;
tempo_volta_completa = tempo_limite_segundos;
raio_do_relogio = 45;

// --- Régua (Canto Inferior Direito) ---
regua_largura  = 340;
regua_x_fim    = _gui_w - 40;
regua_x_inicio = regua_x_fim - regua_largura;
regua_y        = _gui_h - 45; // ← Y correto, usado no Draw GUI

// --- POSIÇÕES NO MAPA ---
// CORREÇÃO: usa o tamanho real da room
if (instance_exists(obj_player)){
x_inicio_corrida     = obj_player.xstart;           // Ajuste se o player não começa em x=0
}

x_fim_corrida        = room_width;  // Fim real da sala
distancia_total_real = x_fim_corrida - x_inicio_corrida;

// --- Shader ---
application_surface_draw_enable(false);
uni_velocity = shader_get_uniform(shd_doppler, "u_velocity");
uni_center   = shader_get_uniform(shd_doppler, "u_center");
uni_aspect   = shader_get_uniform(shd_doppler, "u_aspect");

game_over_lock_timer = -1;   // -1 significa "não inicializado"

// --- TUTORIAL ---
tutorial_ativo = (room == rm_tutorial); // replace rm_tutorial with your room name
tutorial_passo = 0;
tutorial_alpha = 0;
tutorial_debounce = 20; // Frames before accepting input, prevents accidental skip
tutorial_vel_salva    = 0;
tutorial_passo_anterior = -1;
tutorial_sub_passo    = 0;
pausado = false;
pausa_xspd_salvo = 0;
pausa_yspd_salvo = 0;