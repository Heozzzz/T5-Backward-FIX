init()
{
    level thread on_game_start();
}
set_dvars()
{
	SetDvar("player_strafeSpeedScale", 1);
	SetDvar("player_backSpeedScale", 1);
}
on_game_start()
{
	level endon("end_game");
	level waittill("connected",player);
	player thread set_dvars();
}
