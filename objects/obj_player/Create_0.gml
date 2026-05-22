// Moving
moveDir = 0;
xspd = 0;  
yspd = 0;

// -- NOVA MECÂNICA: Velocidade da Luz --
vel_maxima = 11.5; // O seu limite "c"
aceleracao = 0.07; // O quão rápido ele ganha velocidade
desaceleracao = 0.05; // O quão rápido ele freia ao soltar os botões
tela_de_erro = false; // Controle de estado do erro
velocidade_salva = 0;
xspd_shader = 0;

// Jumping
grav = .39;
termVel = 4.5; 
jumpspd = -7.5; 

// Controles de Estado
pode_mover = true; 
imune_poca = false;
imune_galho = false;
imune_galho_timer = 0;
chegou = false;
tutorial_freeze = false;

// --- DURATION OF STUN (in frames) ---
poca_stun_time  = 30;    // how long the player is stuck after hitting a puddle
galho_stun_time = 30;    // how long the player is stuck after hitting a branch

// (Optional) immunity duration after recovery
galho_immune_time = 30; // how long the player is immune to branches after stun