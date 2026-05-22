// --- EVENTO: Post-Draw Interface ---

var _vel_atual = 0;
var _vel_max = 18; // Valor padrão de segurança
var _px = 0.5; // Posição padrão (meio da tela) caso o player não exista
var _py = 0.5;

// Busca os dados da câmera para calcular a proporção e posição
var _cam = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);
var _win_w = window_get_width();
var _win_h = window_get_height();

// 1. Calcula a proporção da tela (ex: 16/9 = 1.77)
var _aspect = _win_w / _win_h;

if (instance_exists(obj_player)) {
	_vel_atual = obj_player.xspd_shader;
    _vel_max = obj_player.vel_maxima;
    
    // --- CENTRO DO PLAYER ---
    // Calcula o meio exato da caixa de colisão. 
    // Assim o shader foca no meio do corpo, e se ajusta automaticamente ao agachar!
    var _centro_x = (obj_player.bbox_left + obj_player.bbox_right) / 2;
    var _centro_y = (obj_player.bbox_top + obj_player.bbox_bottom) / 2;
    
    // 2. Transforma a posição calculada para posição da tela (0.0 a 1.0)
    _px = clamp((_centro_x - _cam_x) / _cam_w, 0.0, 1.0);
    _py = clamp((_centro_y - _cam_y) / _cam_h, 0.0, 1.0);
}

// Normaliza a velocidade (0.0 a 1.0)
var _vel_normalizada = clamp(abs(_vel_atual) / _vel_max, 0.0, 1.0);

// Smooth remap: below 0.5c the effect fades toward zero, above it grows
var _threshold = 0.5;
var _efeito = clamp((_vel_normalizada - _threshold) / (1.0 - _threshold), 0.0, 1.0);

// Preserve direction sign for the shader
_vel_normalizada = _efeito * sign(_vel_atual);

// --- Renderizando o Shader ---
shader_set(shd_doppler);

// Envia os dados atualizados
shader_set_uniform_f(uni_velocity, _vel_normalizada);
shader_set_uniform_f(uni_center, _px, _py);
shader_set_uniform_f(uni_aspect, _aspect);

// Estica a surface para o tamanho da janela
var _win_w = window_get_width();
var _win_h = window_get_height();
draw_surface_stretched(application_surface, 0, 0, _win_w, _win_h);

shader_reset();