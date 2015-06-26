/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

// Global Lists ////////////////////////////////////////////////

var/global/list/all_species = list()
var/global/list/all_languages = list()
var/global/list/whitelisted_species = list("Human")

/proc/buildSpeciesLists()
	var/datum/language/L
	var/datum/species/S
	for(. in (typesof(/datum/language)-/datum/language))
		L = new .
		all_languages[L.name] = L
	for(. in (typesof(/datum/species)-/datum/species))
		S = new .
		all_species[S.name] = S
		if(S.flags & IS_WHITELISTED) whitelisted_species += S.name
	return

////////////////////////////////////////////////////////////////

/datum/species
	var/name                     // Species name.

	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.
	var/override_icon = null                             // DMI for overriding the icon.  states: [lowertext(species.name)]_[gender][fat?"_fat":""]
	var/eyes = "eyes_s"                                  // Icon for eyes.

	var/primitive                // Lesser form, if any (ie. monkey for humans)
	var/tail                     // Name of tail image in species effects icon file.
	var/language                 // Default racial language, if any.
	var/attack_verb = "punch"    // Empty hand hurt intent verb.
	var/punch_damage = 0		 // Extra empty hand attack damage.
	var/punch_throw_range = 0
	var/punch_throw_speed = 1
	var/mutantrace               // Safeguard due to old code.

	var/breath_type = "oxygen"   // Non-oxygen gas breathed, if any.
	var/survival_gear = /obj/item/weapon/storage/box/survival // For spawnin'.

	var/cold_level_1 = 260  // Cold damage level 1 below this point.
	var/cold_level_2 = 200  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.

	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 2 above this point.

	var/fireloss_mult = 1

	var/darksight = 2
	var/throw_mult = 1 // Default mob throw_mult.

	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.

	var/pressure_resistance = 0 //how much we can take a change in pressure, in kPa

	// This shit is apparently not even wired up.
	var/brute_resist    // Physical damage reduction.
	var/burn_resist     // Burn damage reduction.

	var/brute_mod 		// brute multiplier
	var/burn_mod		// burn multiplier

	var/body_temperature = 310.15

	// For grays
	var/max_hurt_damage = 5 // Max melee damage dealt + 5 if hulk
	var/list/default_mutations = list()
	var/list/default_blocks = list() // Don't touch.
	var/list/default_block_names = list() // Use this instead, using the names from setupgame.dm

	var/flags = 0       // Various specific features.

	var/list/abilities = list()	// For species-derived or admin-given powers

	var/blood_color = "#A10808" //Red.
	var/flesh_color = "#FFC896" //Pink.
	var/base_color      //Used when setting species.
	var/uniform_icons = 'icons/mob/uniform.dmi'
	var/fat_uniform_icons = 'icons/mob/uniform_fat.dmi'
	var/gloves_icons    = 'icons/mob/hands.dmi'
	var/glasses_icons   = 'icons/mob/eyes.dmi'
	var/ears_icons      = 'icons/mob/ears.dmi'
	var/shoes_icons     = 'icons/mob/feet.dmi'
	var/head_icons      = 'icons/mob/head.dmi'
	var/belt_icons      = 'icons/mob/belt.dmi'
	var/wear_suit_icons = 'icons/mob/suit.dmi'
	var/wear_mask_icons = 'icons/mob/mask.dmi'
	var/back_icons      = 'icons/mob/back.dmi'


	//Used in icon caching.
	var/race_key = 0
	var/icon/icon_template

	var/list/has_organ = list(
		"heart" =    /datum/organ/internal/heart,
		"lungs" =    /datum/organ/internal/lungs,
		"liver" =    /datum/organ/internal/liver,
		"kidneys" =  /datum/organ/internal/kidney,
		"brain" =    /datum/organ/internal/brain,
		"appendix" = /datum/organ/internal/appendix,
		"eyes" =     /datum/organ/internal/eyes
		)

	//If we will apply mutant race overlays or not.
	var/has_mutant_race = 1

/datum/species/proc/handle_speech(message, mob/living/carbon/human/H)
	if(H.dna)
		if(length(message) >= 2)
			for(var/datum/dna/gene/gene in dna_genes)
				if(!gene.block)
					continue
				if(gene.is_active(H))
					message = gene.OnSay(H,message)
	return message

/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs.

	//This is a basic humanoid limb setup.
	H.organs = list()
	H.organs_by_name["chest"] = new/datum/organ/external/chest()
	H.organs_by_name["groin"] = new/datum/organ/external/groin(H.organs_by_name["chest"])
	H.organs_by_name["head"] = new/datum/organ/external/head(H.organs_by_name["chest"])
	H.organs_by_name["l_arm"] = new/datum/organ/external/l_arm(H.organs_by_name["chest"])
	H.organs_by_name["r_arm"] = new/datum/organ/external/r_arm(H.organs_by_name["chest"])
	H.organs_by_name["r_leg"] = new/datum/organ/external/r_leg(H.organs_by_name["groin"])
	H.organs_by_name["l_leg"] = new/datum/organ/external/l_leg(H.organs_by_name["groin"])
	H.organs_by_name["l_hand"] = new/datum/organ/external/l_hand(H.organs_by_name["l_arm"])
	H.organs_by_name["r_hand"] = new/datum/organ/external/r_hand(H.organs_by_name["r_arm"])
	H.organs_by_name["l_foot"] = new/datum/organ/external/l_foot(H.organs_by_name["l_leg"])
	H.organs_by_name["r_foot"] = new/datum/organ/external/r_foot(H.organs_by_name["r_leg"])

	H.internal_organs = list()
	for(var/organ in has_organ)
		var/organ_type = has_organ[organ]
		H.internal_organs_by_name[organ] = new organ_type(H)

	for(var/name in H.organs_by_name)
		H.organs += H.organs_by_name[name]

	for(var/datum/organ/external/O in H.organs)
		O.owner = H

	if(flags & IS_SYNTHETIC)
		for(var/datum/organ/external/E in H.organs)
			if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED) continue
			E.status |= ORGAN_ROBOT
		for(var/datum/organ/internal/I in H.internal_organs)
			I.mechanize()

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	return

/datum/species/proc/handle_breath(var/datum/gas_mixture/breath, var/mob/living/carbon/human/H)
	var/safe_oxygen_min = 16 // Minimum safe partial pressure of O2, in kPa
	//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
	var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
	var/safe_toxins_max = 0.5
	var/safe_toxins_mask = 5
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/oxygen_used = 0
	var/nitrogen_used = 0
	var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME
	var/vox_oxygen_max = 1 // For vox.

	//Partial pressure of the O2 in our breath
	var/O2_pp = (breath.oxygen/breath.total_moles())*breath_pressure
	// Same, but for the toxins
	var/Toxins_pp = (breath.toxins/breath.total_moles())*breath_pressure
	// And CO2, lets say a PP of more than 10 will be bad (It's a little less really, but eh, being passed out all round aint no fun)
	var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*breath_pressure // Tweaking to fit the hacky bullshit I've done with atmo -- TLE
	// Nitrogen, for Vox.
	var/Nitrogen_pp = (breath.nitrogen/breath.total_moles())*breath_pressure

	// TODO: Split up into Voxs' own proc.
	if(O2_pp < safe_oxygen_min && name != "Vox") 	// Too little oxygen
		if(prob(20))
			spawn(0)
				H.emote("gasp")
		if(O2_pp > 0)
			var/ratio = safe_oxygen_min/O2_pp
			H.adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
			H.failed_last_breath = 1
			oxygen_used = breath.oxygen*ratio/6
		else
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			H.failed_last_breath = 1
		H.oxygen_alert = max(H.oxygen_alert, 1)
	else if(Nitrogen_pp < safe_oxygen_min && name == "Vox")  //Vox breathe nitrogen, not oxygen.

		if(prob(20))
			spawn(0) H.emote("gasp")
		if(Nitrogen_pp > 0)
			var/ratio = safe_oxygen_min/Nitrogen_pp
			H.adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS))
			H.failed_last_breath = 1
			nitrogen_used = breath.nitrogen*ratio/6
		else
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			H.failed_last_breath = 1
		H.oxygen_alert = max(H.oxygen_alert, 1)

	else								// We're in safe limits
		H.failed_last_breath = 0
		H.adjustOxyLoss(-5)
		oxygen_used = breath.oxygen/6
		H.oxygen_alert = 0

	breath.oxygen -= oxygen_used
	breath.nitrogen -= nitrogen_used
	breath.carbon_dioxide += oxygen_used

	//CO2 does not affect failed_last_breath. So if there was enough oxygen in the air but too much co2, this will hurt you, but only once per 4 ticks, instead of once per tick.
	if(CO2_pp > safe_co2_max)
		if(!H.co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
			H.co2overloadtime = world.time
		else if(world.time - H.co2overloadtime > 120)
			H.Paralyse(3)
			H.adjustOxyLoss(3) // Lets hurt em a little, let them know we mean business
			if(world.time - H.co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
				H.adjustOxyLoss(8)
		if(prob(20)) // Lets give them some chance to know somethings not right though I guess.
			spawn(0) H.emote("cough")

	else
		H.co2overloadtime = 0

	if(Toxins_pp > safe_toxins_max) // Too much toxins
		var/ratio = (breath.toxins/safe_toxins_max) * 10
		//adjustToxLoss(Clamp(ratio, MIN_PLASMA_DAMAGE, MAX_PLASMA_DAMAGE))	//Limit amount of damage toxin exposure can do per second
		if(H.wear_mask)
			if(H.wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT)
				if(breath.toxins > safe_toxins_mask)
					ratio = (breath.toxins/safe_toxins_mask) * 10
				else
					ratio = 0
		if(ratio)
			if(H.reagents)
				H.reagents.add_reagent("plasma", Clamp(ratio, MIN_PLASMA_DAMAGE, MAX_PLASMA_DAMAGE))
			H.toxins_alert = max(H.toxins_alert, 1)
	else if(O2_pp > vox_oxygen_max && name == "Vox") //Oxygen is toxic to vox.
		var/ratio = (breath.oxygen/vox_oxygen_max) * 1000
		H.adjustToxLoss(Clamp(ratio, MIN_PLASMA_DAMAGE, MAX_PLASMA_DAMAGE))
		H.toxins_alert = max(H.toxins_alert, 1)
	else
		H.toxins_alert = 0

	if(breath.trace_gases.len)	// If there's some other shit in the air lets deal with it here.
		for(var/datum/gas/sleeping_agent/SA in breath.trace_gases)
			var/SA_pp = (SA.moles/breath.total_moles())*breath_pressure
			if(SA_pp > SA_para_min) // Enough to make us paralysed for a bit
				H.Paralyse(3) // 3 gives them one second to wake up and run away a bit!
				if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
					H.sleeping = min(H.sleeping+2, 10)
			else if(SA_pp > 0.15)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
				if(prob(20))
					spawn(0) H.emote(pick("giggle", "laugh"))
			SA.moles = 0

	if( (abs(310.15 - breath.temperature) > 50) && !(M_RESIST_HEAT in H.mutations)) // Hot air hurts :(
		if(H.status_flags & GODMODE)	return 1	//godmode
		if(breath.temperature < cold_level_1)
			if(prob(20))
				H << "\red You feel your face freezing and an icicle forming in your lungs!"
		else if(breath.temperature > heat_level_1)
			if(prob(20))
				if(H.dna.mutantrace == "slime")
					H << "\red You feel supercharged by the extreme heat!"
				else
					H << "\red You feel your face burning and a searing heat in your lungs!"

		if(H.dna.mutantrace == "slime")
			if(breath.temperature < cold_level_1)
				H.adjustToxLoss(round(cold_level_1 - breath.temperature))
				H.fire_alert = max(H.fire_alert, 1)

		if(H.dna.mutantrace != "slime")
			switch(breath.temperature)
				if(-INFINITY to cold_level_3)
					H.apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Cold")
					H.fire_alert = max(H.fire_alert, 1)

				if(cold_level_3 to cold_level_2)
					H.apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Cold")
					H.fire_alert = max(H.fire_alert, 1)

				if(cold_level_2 to cold_level_1)
					H.apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Cold")
					H.fire_alert = max(H.fire_alert, 1)

				if(heat_level_1 to heat_level_2)
					H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Heat")
					H.fire_alert = max(H.fire_alert, 2)

				if(heat_level_2 to heat_level_3)
					H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Heat")
					H.fire_alert = max(H.fire_alert, 2)

				if(heat_level_3 to INFINITY)
					H.apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Heat")
					H.fire_alert = max(H.fire_alert, 2)
	return 1

// Used for species-specific names (Vox, etc)
/datum/species/proc/makeName(var/gender,var/mob/living/carbon/C=null)
	if(gender==FEMALE)	return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
	else				return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	/*
	if(flags & IS_SYNTHETIC)
		//H.Jitter(200) //S-s-s-s-sytem f-f-ai-i-i-i-i-lure-ure-ure-ure
		H.h_style = ""
		spawn(100)
			//H.is_jittery = 0
			//H.jitteriness = 0
			H.update_hair()
	*/
	return

/datum/species/proc/equip(var/mob/living/carbon/human/H)

/datum/species/human
	name = "Human"
	language = "Sol Common"
	primitive = /mob/living/carbon/monkey

	flags = HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | CAN_BE_FAT

//BEGIN DELETING ALL THESE FUCKING SHIT RACES, WE DONT NEED CATS ABOAURD OUR SHIP.

//SAY GOODDBYE TO CATS AND LIZARDS AND ALL THE OTHER BULLSHIT.