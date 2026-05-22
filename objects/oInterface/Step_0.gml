// Make the game world fill the window, same as display_set_gui_size does for GUI
view_wport[0] = window_get_width();
view_hport[0] = window_get_height();

// Fullscreen
if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}
	
// =========================================================
// INTRO SCREEN (runs before tutorial steps)
// =========================================================
if (tutorial_intro_ativo) {
    
    // ADD THIS: Force player to be visible/not blink during intro
    if (instance_exists(obj_player)) {
        obj_player.image_alpha = 1;
    }
}
	
if (tutorial_intro_ativo) {
    tutorial_intro_timer++;
    if (tutorial_intro_timer >= game_get_speed(gamespeed_fps) * 15) {
        tutorial_intro_can_skip = true;
    }
    if (tutorial_intro_can_skip) {
        if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any)) {
            tutorial_intro_ativo = false;
            // Unfreeze into tutorial step 0 (which will re-freeze with its own logic)
            if (instance_exists(obj_player)) {
                obj_player.pode_mover = false;
                obj_player.tutorial_freeze = true;
            }
        }
    }
    exit; // Block ALL other logic while intro is showing
}
	if (!_deadline_aplicado) {
    _deadline_aplicado     = true;
    tempo_limite_minutos   = global.deadline_minutos;
    tempo_limite_segundos  = tempo_limite_minutos * 60;
    tempo_volta_completa   = tempo_limite_segundos;
}

// =========================================================
// TELAS DE GAME OVER / FIM DE FASE — input para sair
// =========================================================
if (estado_interface == "game_over" || estado_interface == "fim_fase") {

    // --- Inicializa o timer na primeira frame em que essa tela aparece ---
    if (game_over_lock_timer == -1) {
        game_over_lock_timer = game_get_speed(gamespeed_fps) * 1.5;   // 1.5 segundos
    }

    // --- Faz a contagem regressiva ---
    if (game_over_lock_timer > 0) {
        game_over_lock_timer--;
        exit;   // sai sem processar input
    }

    // --- Só depois de 1.5s o jogador pode sair ---
    if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any)) {
        instance_activate_all();
        room_goto(rm_menu_principal); // ⚠️ troque pelo nome da sua room de menu
    }
    exit; // congela o resto da lógica enquanto a tela estiver ativa
}

// =========================================================
// PAUSA
// =========================================================
// Detect when pause menu closes
if (pausado && !instance_exists(obj_pause_menu)) {
    pausado = false;
    application_surface_draw_enable(false);
    
    // Restore player velocity
    if (instance_exists(obj_player)) {
        obj_player.xspd  = pausa_xspd_salvo;
        obj_player.yspd  = pausa_yspd_salvo;
        obj_player.pode_mover = true;
    }
}

if (keyboard_check_pressed(vk_space) && !instance_exists(obj_pause_menu) && estado_interface == "jogo") {
    if (!surface_exists(surf_pausa)) {
        surf_pausa = surface_create(
            surface_get_width(application_surface),
            surface_get_height(application_surface)
        );
    }
    surface_copy(surf_pausa, 0, 0, application_surface);
    pausado = true;
    
    // Save and freeze player velocity
    if (instance_exists(obj_player)) {
        pausa_xspd_salvo = obj_player.xspd;
        pausa_yspd_salvo = obj_player.yspd;
        obj_player.xspd  = 0;
        obj_player.yspd  = 0;
        obj_player.pode_mover = false;
    }
    
    instance_create_layer(0, 0, "Instances", obj_pause_menu);
}
// =========================================================
// LÓGICA PRINCIPAL (só roda se o jogador existe e não bateu em "c")
// =========================================================
// =========================================================
// TUTORIAL: Avanço de Passos
// =========================================================
if (tutorial_ativo && estado_interface == "jogo") {
    tutorial_alpha = min(tutorial_alpha + 0.06, 1);
    if (tutorial_debounce > 0) tutorial_debounce--;

    if (tutorial_passo != tutorial_passo_anterior) {
        tutorial_passo_anterior = tutorial_passo;
        tutorial_sub_passo = 0;
        if (instance_exists(obj_player)) {
            if (tutorial_passo == 5) {
                obj_player.pode_mover      = true;
                obj_player.xspd            = tutorial_vel_salva;
                obj_player.tutorial_freeze = false;
            } else if (tutorial_passo == 6) {
                tutorial_vel_salva         = obj_player.xspd;
                obj_player.xspd            = obj_player.vel_maxima * 0.3;
                obj_player.image_yscale    = 1;
                obj_player.pode_mover      = true;
                obj_player.tutorial_freeze = false;
            } else {
                tutorial_vel_salva         = obj_player.xspd;
                obj_player.pode_mover      = false;
                obj_player.tutorial_freeze = true;
            }
        }
    }

    var _advance = false;

    switch (tutorial_passo) {
        case 0:
            if (keyboard_check_pressed(vk_right) && tutorial_debounce == 0) _advance = true;
        break;
        case 1:
            if (keyboard_check_pressed(vk_right) && tutorial_debounce == 0) _advance = true;
        break;
        case 2:
            if (keyboard_check_pressed(vk_anykey) && tutorial_debounce == 0) _advance = true;
        break;
        case 3:
            if (keyboard_check_pressed(vk_anykey) && tutorial_debounce == 0) _advance = true;
        break;
        case 4:
            if (keyboard_check_pressed(vk_anykey) && tutorial_debounce == 0) _advance = true;
        break;
        case 5:
            if (instance_exists(obj_player)) {
                var _frac = abs(obj_player.xspd) / obj_player.vel_maxima;
                if (_frac >= 0.92) tutorial_sub_passo = 1;
                if (tutorial_sub_passo == 1 && keyboard_check_pressed(vk_anykey) && tutorial_debounce == 0)
                    _advance = true;
            }
        break;
        case 6:
            if (instance_exists(obj_player)) {
                if (!obj_player.pode_mover && !obj_player.tutorial_freeze && !obj_player.tela_de_erro)
                    _advance = true;
                if (keyboard_check_pressed(vk_up) && tutorial_debounce == 0)
                    _advance = true;
                if (keyboard_check_pressed(vk_down) && tutorial_debounce == 0)
                    _advance = true;
            }
        break;
        case 7:
            if (keyboard_check_pressed(vk_anykey) && tutorial_debounce == 0) _advance = true;
        break;
    }

    if (_advance) {
        if (instance_exists(obj_player)) {
            if (tutorial_passo == 6) {
                tutorial_vel_salva = obj_player.xspd;
            }
            obj_player.xspd            = tutorial_vel_salva;
            obj_player.pode_mover      = true;
            obj_player.tutorial_freeze = false;
            obj_player.image_yscale    = 1;
        }
        tutorial_passo++;
        tutorial_debounce  = 20;
        tutorial_alpha     = 0;
        tutorial_sub_passo = 0;
        if (tutorial_passo > 7) tutorial_ativo = false;
    }
}

    // --- GAME OVER: jogador atingiu a velocidade da luz ---
if (instance_exists(obj_player) && obj_player.tela_de_erro && estado_interface == "jogo") {
    estado_interface = "game_over";
    exit;
}

if (instance_exists(obj_player) && !obj_player.tela_de_erro) {
    var v = abs(obj_player.xspd);
    var c = obj_player.vel_maxima;
    if (v >= c) { v = c - 0.01; }
    var v_sobre_c = v / c;
    gamma_atual = 1 / sqrt(1 - power(v_sobre_c, 2));

    // Only tick time when not paused
    if (!pausado) {
        var tempo_frame      = delta_time / 100000;
        passo_tempo_jogador  = tempo_frame;
        passo_tempo_cliente  = tempo_frame * gamma_atual;
        tempo_jogador += passo_tempo_jogador;
        tempo_cliente += passo_tempo_cliente;
    }

    var angulo_alvo = lerp(90, -90, v_sobre_c);
    angulo_agulha_atual = lerp(angulo_agulha_atual, angulo_alvo, 0.1);
}