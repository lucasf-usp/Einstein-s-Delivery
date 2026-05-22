// --- Alarm[0] : recuperação após poça ou galho ---

// 1. Devolve o controle e o embalo que o jogador tinha
pode_mover = true;
xspd = velocidade_salva;   // ← O MOMENTO EXATO É PRESERVADO

// 2. Torna o jogador imune para que ele possa sair do obstáculo
imune_poca = true;
imune_galho = true;

// 3. Define o tempo de imunidade contra galhos (agora configurável)
imune_galho_timer = galho_immune_time;   // 180 frames (3s) ou o valor que desejar

// 4. Garante que o jogador esteja totalmente visível
image_alpha = 1;