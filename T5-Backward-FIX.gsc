init()
{
	level notify("frfix_init");

	flag_init("dvars_set");
	level thread set_dvars();
    level thread on_game_start();
}
set_dvars()
{
	level endon("end_game");
	while (true)
	{
		setdvar("player_strafeSpeedScale", 1);
		setdvar("player_backSpeedScale", 1);
		setdvar("g_speed", 190);				// Only for reset_dvars

		setdvar("con_gameMsgWindow0Filter", "gamenotify obituary");
		setdvar("con_gameMsgWindow0LineCount", 4);
		setdvar("con_gameMsgWindow0MsgTime", 5);
		setdvar("con_gameMsgWindow0FadeInTime", 0.25);
		setdvar("con_gameMsgWindow0FadeOutTime", 0.5);

		setdvar("sv_endGameIfISuck", 0); 		// Prevent host migration
		setdvar("sv_allowAimAssist", 0); 	 	// Removes target assist
		setdvar("sv_patch_zm_weapons", 1);		// Force post dlc1 patch on recoil
		setdvar("sv_cheats", 0);

		if (!flag("dvars_set"))
			flag_set("dvars_set");

		level waittill("reset_dvars");
	}
}
dvar_detector() 
{
	level endon("end_game");

	// Waiting on top so it doesn't trigger before initial dvars are set
	flag_wait("dvars_set");

	red_color = (0.8, 0, 0);
	dvar_definitions = array();
	dvar_definitions["dvar_name"] = array("player_strafeSpeedScale", "player_backSpeedScale", "con_gameMsgWindow0Filter", "sv_cheats", "g_speed");
	dvar_definitions["dvar_values"] = array("1", "1", "gamenotify obituary", "0", "190");
	dvar_definitions["dvar_watermark"] = array("BACKSPEED", "BACKSPEED", "NOPRINT", "CHEATS", "GSPEED");
	dvar_definitions["watermark_color"] = array(red_color, red_color, red_color, red_color, red_color);
	dvar_definitions["is_cheat"] = array(true, true, true, true, true);

	dvar_detections = array();

	while (true) 
	{
		for (i = 0; i < dvar_definitions.size; i++)
		{
			detection_key = "cheat_" + dvar_definitions["dvar_name"][i];

			if (getDvar(dvar_definitions["dvar_name"][i]) != dvar_definitions["dvar_values"][i])
			{
				level notify("reset_dvars");
			}
		}

		wait 0.1;
	}
}
on_game_start()
{
	level endon("end_game");
	level waittill("initial_players_connected");
	level thread dvar_detector();
}
