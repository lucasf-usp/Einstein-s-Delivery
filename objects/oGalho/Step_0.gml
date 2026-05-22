var _cam_x = camera_get_view_x(view_camera[0]);
var _fator_parallax = 0.6;
x = x_inicial + (_cam_x * _fator_parallax);// hitbox moves with the visual