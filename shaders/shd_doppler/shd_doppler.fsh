// --- shd_doppler.fsh ---
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_velocity;
uniform vec2 u_center;  // RESTAURADO: Posição do player na tela (0.0 a 1.0)
uniform float u_aspect; // RESTAURADO: Proporção da tela (Largura / Altura)

void main() {
    // 1. Pega a cor original do pixel do jogo
    vec4 base_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    // 2. Parâmetros de Movimento e Gatilhos
    float speed = abs(u_velocity);
    float dir = sign(u_velocity);
    
    // Gatilho Universal para Cores e Escurecimento Gama (Começa em 0.85c)
    float high_speed_factor = smoothstep(0.45, 0.999, speed);
    
    // 3. QUEDA QUADRÁTICA DE BRILHO GLOBAL
    float gamma_drop = 1.0 - (speed * speed);
    float current_brightness = mix(1.0, gamma_drop, high_speed_factor);
    vec3 game_color = base_color.rgb * current_brightness;
    
    // 4. EFEITO DOPPLER (Começa em 0.85c)
    vec3 color_purple = vec3(0.4, 0.0, 0.8);
    vec3 color_red = vec3(1.0, 0.1, 0.0);
    
    float gradient = v_vTexcoord.x;
    if (dir < 0.0) {
        gradient = 1.0 - gradient;
    }
    
    // Mescla o roxo e vermelho e adiciona por cima (limite 60% opacidade)
    vec3 doppler_hue = mix(color_red, color_purple, gradient);
    vec3 final_color = mix(game_color, doppler_hue, high_speed_factor * 0.6);
    
    // 5. VINHETA AGRESSIVA, SUAVE E CENTRALIZADA NO PLAYER (Começa em 0.95c)
    float vignette_strength = smoothstep(0.6, 0.999, speed);
    
    // CORREÇÃO: Calcula a distância do pixel até o player, corrigindo a proporção da tela
    vec2 dir_to_center = v_vTexcoord - u_center;
    dir_to_center.x *= u_aspect;
    float dist = length(dir_to_center); 
    
    // A MÁGICA DO DEGRADÊ:
    // Em 0.95c: safe_zone é 0.4 e dark_edge é 0.8
    // Em 0.999c: safe_zone é -0.1 e dark_edge é 0.1
    float safe_zone = mix(0.4, -0.1, vignette_strength);
    float dark_edge = mix(0.8, 0.1, vignette_strength);
    
    // O degradê da vinheta: suave entre o centro e a borda preta
    float blackout_shape = smoothstep(safe_zone, dark_edge, dist);
    
    // Multiplica pela força para que o degradê e a escuridão geral cresçam juntos
    float blackout = blackout_shape * vignette_strength;
    
    final_color *= (1.0 - blackout);
    
    // 6. Saída para a tela
    gl_FragColor = vec4(final_color, base_color.a);
}