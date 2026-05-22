// --- CÂMERA SEGUINDO O PLAYER (SÓ NO EIXO X) ---
var _cam = view_camera[0];
var _cam_w = camera_get_view_width(_cam);

// Calcula o alvo X (centralizado no jogador)
var _alvo_x = x - (_cam_w / 2);

// Pega a posição atual da câmera
var _atual_x = camera_get_view_x(_cam);
var _atual_y = camera_get_view_y(_cam); // Vamos manter o Y atual intacto!

// Move a câmera suavemente SÓ no X. O _atual_y é passado direto, sem suavização.
camera_set_view_pos(_cam, lerp(_atual_x, _alvo_x, 0.20), _atual_y);

// Pega a posição X (horizontal) atual da câmera
var _cam_x = camera_get_view_x(view_camera[0]);

// Move a camada de trás (prédios azuis) para acompanhar a câmera, 
// mas com uma pequena diferença para parecer distante.
// O valor 0.8 significa que ela segue a câmera a 80% da velocidade.
layer_x("Fundo_Predios", _cam_x * 0.8);

// Move a camada da frente (casinhas).
// O valor 0.5 faz com que ela pareça mais próxima do jogador do que os prédios.
layer_x("Frente_Casas", _cam_x * 0.6);
layer_x("Background_Sidewalk", _cam_x * 0.6);