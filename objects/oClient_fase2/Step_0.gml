if (interagido) exit;
if (instance_exists(obj_player) && place_meeting(x, y, obj_player)) {
    interagido = true;

    // Stop the player completely
    obj_player.pode_mover = false;
    obj_player.xspd = 0;
    obj_player.yspd = 0;

    // Calculate stars
    if (instance_exists(oInterface)) {
        var _itf = oInterface;
        var _tc  = _itf.tempo_cliente;
        var _lim = _itf.tempo_limite_segundos;

        if      (_tc <= _lim)          { _itf.estrelas_ganhas = 3; }
        else if (_tc <= _lim * 1.0001) { _itf.estrelas_ganhas = 2; }
        else if (_tc <= _lim * 1.2)    { _itf.estrelas_ganhas = 1; }
        else                           { _itf.estrelas_ganhas = 0; }

        _itf.estado_interface = "fim_fase";

        // ── Save best star result for this phase ──
        ini_open("einstein_save.ini");
        var _best = ini_read_real("stars", fase_key, 0);
        if (_itf.estrelas_ganhas > _best) {
            ini_write_real("stars", fase_key, _itf.estrelas_ganhas);
        }
        ini_close();
    }
}