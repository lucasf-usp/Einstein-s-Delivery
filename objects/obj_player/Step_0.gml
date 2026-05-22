// ============================================================
//  obj_player STEP EVENT  (complete, corrected order)
// ============================================================

// --- 1. CONTROLES ---
getControls();

if (tela_de_erro) {
    pode_mover = false;
}

// --- 1.5 AGACHAR (sempre, independente de pode_mover) ---
if (place_meeting(x, y + 1, oSolid)) {
    if (down_key) {
        image_yscale = 0.8;
        while (place_meeting(x, y, oSolid)) {
            y -= 0.1;
        }
    } else {
        if (!place_meeting(x, y - 16, oSolid)) {
            image_yscale = 1;
            while (place_meeting(x, y, oSolid)) {
                y -= 0.1;
            }
        }
    }
}

// --- 2. ESTADOS E MOVIMENTO ---
if (pode_mover) {
    
    // B. Lógica de Andar Horizontalmente (Aceleração e Inércia)
    moveDir = right_key - left_key; 
    
    if (moveDir != 0) {
        if (sign(xspd) == moveDir || xspd == 0) {
            var v_sobre_c = abs(xspd) / vel_maxima;
            var fator_relativistico = power(1 - power(v_sobre_c, 2), 1.5);
            fator_relativistico = max(fator_relativistico, 0.02);
            xspd += moveDir * (aceleracao * fator_relativistico);
        } else {
            xspd += moveDir * desaceleracao;
        }
    }

    if (xspd < 0) {
        xspd = 0;
    }

    // C. Verificação da Velocidade da Luz
    if (abs(xspd) >= vel_maxima) {
        tela_de_erro = true;
        xspd = 0;
    }
    
    // D. Lógica de Pulo
    if (jumpKeyPressed && place_meeting(x, y + 1, oSolid)) {
        yspd = jumpspd;
    }
    
    image_alpha = 1; 

} else {
    // --- JOGADOR ESTÁ TRAVADO ---
    if (!tela_de_erro && !chegou && !tutorial_freeze) {
        xspd = 0; 
        yspd = 0; 
        if (current_time mod 100 < 50) {
            image_alpha = 0.2; 
        } else {
            image_alpha = 1;   
        }
    }
}

// --- 3. CHECAGEM DE OBSTÁCULOS (Poça e Galho) ---
if (imune_galho_timer > 0) imune_galho_timer--;

var tocou_poca  = place_meeting(x, y, oPoca);
var tocou_galho = place_meeting(x, y, oGalho) && (image_yscale == 1);

// --- STUN: poça ---
if (tocou_poca && pode_mover && !imune_poca) {
    velocidade_salva = xspd;               // salva o embalo
    pode_mover = false;
    xspd = 0;
    yspd = 0;
    alarm[0] = poca_stun_time;             // tempo configurável (definido no Create)
}

// --- STUN: galho ---
if (tocou_galho && pode_mover && imune_galho_timer == 0) {
    velocidade_salva = xspd;
    pode_mover = false;
    xspd = 0;
    yspd = 0;
    alarm[0] = galho_stun_time;            // tempo configurável
}

// --- IMUNIDADE: remove imunidade a poça quando não estiver sobre ela ---
if (imune_poca && !tocou_poca) {
    imune_poca = false;
}

// --- 4. GRAVIDADE (DEPOIS do stun) ---
if (pode_mover || tela_de_erro || tutorial_freeze) { 
    yspd += grav;
    if (yspd > termVel) { yspd = termVel; }
}

// --- 5. COLISÕES E APLICAÇÃO DO MOVIMENTO ---
var _subPixel = .5;
if (place_meeting(x + xspd, y, oSolid)) {
    var _pixelCheck = _subPixel * sign(xspd);
    while (!place_meeting(x + _pixelCheck, y, oSolid)) {
        x += _pixelCheck;    
    }
    xspd = 0; 
}
x += xspd;

var _subPixelY = .5; 
if (place_meeting(x, y + yspd, oSolid)) {
    var _pixelCheckY = _subPixelY * sign(yspd);
    while (!place_meeting(x, y + _pixelCheckY, oSolid)) {
        y += _pixelCheckY;
    } 
    yspd = 0;
} 
y += yspd;

// --- 6. VELOCIDADE SUAVIZADA PARA O SHADER ---
// Follows xspd up instantly, decays slowly on collision/stun
xspd_shader = lerp(xspd_shader, xspd, 0.15);
