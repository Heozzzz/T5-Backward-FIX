init()
{
    level thread on_game_start();
	level thread set_dvars();
}
set_dvars()
{
	dvar_definitions = array();
	dvar_definitions["dvar_name"] = array("player_strafeSpeedScale", "player_backSpeedScale","cg_fov");
	dvar_definitions["dvar_values"] = array(1, 1, 90);
	while (true) 
	{
		for (i = 0; i < dvar_definitions["dvar_name"].size; i++)
		{
			if (GetDvarInt(dvar_definitions["dvar_name"][i]) != dvar_definitions["dvar_values"][i])
			{
				SetDvar("sv_cheats",1);
				SetDvar(dvar_definitions["dvar_name"][i], dvar_definitions["dvar_values"][i]);
				SetDvar("sv_cheats",0);
			}
		}
		wait 0.1;
	}
}
on_game_start()
{
	level endon("end_game");
	level waittill("connected",player);
	player thread set_dvars();
}
