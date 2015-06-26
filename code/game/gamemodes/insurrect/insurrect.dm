/datum/game_mode/insurrect
	name = "Insurrection"
	config_tag = "insr"
	restricted_jobs = list("Cyborg","Mobile MMI")//They are part of the AI if he is traitor so are they, they use to get double chances
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")//AI", Currently out of the list as malf does not work for shit
	required_players = 0
	required_enemies = 1
	recommended_enemies = 4
	var/traitor_name = "insurrection"

	uplink_welcome = "Nigger Console run run run: "
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

	var/traitors_possible = 4 //hard limit on traitors if scaling is turned off
	var/const/traitor_scaling_coeff = 5.0 //how much does the amount of players get divided by to determine traitors

/datum/game_mode/insurrect/announce()
	world << "<B>The current game mode is - Insurrection!</B>"
	world << "<B>There is an Insurrection going on!</B>"

/datum/game_mode/insurrect/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/possible_traitors = get_players_for_role(ROLE_TRAITOR)

	// stop setup if no possible traitors
	if(!possible_traitors.len)
		return 0

	var/num_insurrectionists = 1

	if(config.traitor_scaling)
		num_insurrectionists = max(1, round((num_players())/(traitor_scaling_coeff)))
	else
		num_insurrectionists = max(1, min(num_players(), traitors_possible))

	for(var/datum/mind/player in possible_traitors)
		for(var/job in restricted_jobs)
			if(player.assigned_role == job)
				possible_traitors -= player

	for(var/j = 0, j < num_insurrectionists, j++)
		if (!possible_traitors.len)
			break
		var/datum/mind/traitor = pick(possible_traitors)
		traitors += traitor
		traitor.special_role = "insurrectionist"
		possible_traitors.Remove(traitor)

	if(!traitors.len)
		return 0
	return 1