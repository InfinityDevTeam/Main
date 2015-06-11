//Tiny Tanks!  ~Nexendia

/obj/mecha/combat/tank
	desc = "A small Tank used by /NT/ Mercenaries or by a really bored Roboticist."
	name = "\improper tank"
	icon_state = "tank"
	icon = 'icons/obj/tanks.dmi'
	alpha = 255
	opacity = 0
	step_in = 2
	dir_in = 1 //Facing North.
	health = 200
	deflect_chance = 15
	damage_absorption = list("brute"=0.6,"bomb"=0.2)
	max_temperature = 15000
	wreckage = null
	operation_req_access = list()
	add_req_access = 0
	internal_damage_threshold = 25
	max_equip = 2
	step_energy_drain = 3


/obj/mecha/combat/tank/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	ME.attach(src)
	return

/obj/mecha/combat/tank/synditank/add_cell(var/obj/item/weapon/stock_parts/cell/C=null)
	if(cell)
		forceMove(src)
		return
	cell = new(src)
	cell.charge = 20000
	cell.maxcharge = 20000



/obj/mecha/combat/tank/mimetank
	desc = "A silent, fast, and nigh-invisible miming tank. Popular among mimes."
	name = "\improper tank"
	icon_state = "tank"
	icon = 'icons/obj/tanks.dmi'
	alpha = 40
	opacity = 0
	step_in = 2
	dir_in = 1 //Facing North.
	health = 200
	deflect_chance = 15
	damage_absorption = list("brute"=0.6,"bomb"=0.2)
	max_temperature = 15000
	wreckage = null
	operation_req_access = list(access_theatre)
	add_req_access = 0
	internal_damage_threshold = 25
	max_equip = 2
	step_energy_drain = 3

/obj/mecha/combat/tank/mimetank/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/rcd //Hue hue hue walls!!! get it?  Mimes make walls and the tank makes walls!!   HUEHUEHUE
	ME.attach(src)
	return


/obj/mecha/combat/tank/clowntank
	desc = "A loud, clumsy, and nigh-unhonkable clowning tank. Popular among Clowns."
	name = "\improper clown tank"
	icon_state = "tank"
	icon = 'icons/obj/tanks.dmi'
	alpha = 255
	opacity = 0
	step_in = 2
	dir_in = 1 //Facing North.
	health = 200
	deflect_chance = 15
	damage_absorption = list("brute"=0.6,"bomb"=0.2)
	max_temperature = 15000
	wreckage = null
	operation_req_access = list(access_theatre)
	add_req_access = 0
	internal_damage_threshold = 25
	max_equip = 2
	step_energy_drain = 3


/obj/mecha/combat/tank/clowntank/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/honker
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/tank
	ME.attach(src)
	return

/obj/mecha/combat/tank/synditank
	desc = "A highly dangerous Tank designed for boarding operations onto other Stations!."
	name = "\improper syndi tank"
	icon_state = "tankred"
	icon = 'icons/obj/tanks.dmi'
	alpha = 255
	opacity = 0   //No fucking opacity :I That shit is annoying seeing as this thing is fucking TINY  ~Nexendia
	step_in = 2
	dir_in = 1 //Facing North.
	health = 400
	deflect_chance = 20
	damage_absorption = list("brute"=0.5,"fire"=1.1,"bullet"=0.65,"laser"=0.85,"energy"=0.9,"bomb"=0.8)
	max_temperature = 15000
	wreckage = null
	operation_req_access = list()
	add_req_access = 0
	internal_damage_threshold = 30
	max_equip = 3
	step_energy_drain = 3

/obj/mecha/combat/tank/synditank/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/tank/syndi
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	ME.attach(src)
	return

/obj/mecha/combat/tank/synditank/add_cell(var/obj/item/weapon/stock_parts/cell/C=null)
	if(cell)
		forceMove(src)
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000



/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/tank
	name = "\improper 30mm Tank AutoCannon"
	desc = "A light AutoCannon for Tanks."
	icon_state = "mecha_carbine" //Just a temp sprite for now..  Nien bby please make me one
	equip_cooldown = 18
	projectile = /obj/item/projectile/bullet/tank
	projectiles = 10
	projectile_energy_cost = 50

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/tank/syndi
	equip_cooldown = 12
	projectile = /obj/item/projectile/bullet/synditank


/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse/tank
	equip_cooldown = 2
	name = "eZ-13 MK2 heavy Tank Cannon"
	desc = "A weapon for the Weeaboo Mobile."
	energy_drain = 60


/*
	Everything clown related needs a HONKER!! and a Banana Mortar!!  ~Nexendia
*/

/obj/item/mecha_parts/mecha_equipment/weapon/honker/tank
	energy_drain = 300

/obj/item/mecha_parts/mecha_equipment/weapon/honker/tank/can_attach(obj/mecha/combat/tank/M as obj)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/tank
	projectile_energy_cost = 145

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/tank/can_attach(obj/mecha/combat/tank/M as obj)
	if(..())
		if(istype(M))
			return 1
	return 0

/*
	Hoooooooooooooooooooooooooooooooonk!
*/




// Testing Tank:

/obj/mecha/combat/tank/ninja
	desc = "Codertank!!!!!!! RUN"
	name = "\improper codertank"
	icon_state = "tankwhite"
	icon = 'icons/obj/tanks.dmi'
	alpha = 255
	opacity = 0
	var/colour = "#00FFE9"
	step_in = 2
	dir_in = 1 //Facing North.
	health = 200
	deflect_chance = 15
	damage_absorption = list("brute"=0.6,"bomb"=0.2)
	max_temperature = 15000
	wreckage = null
	operation_req_access = list()
	add_req_access = 0
	internal_damage_threshold = 25
	max_equip = 2
	step_energy_drain = 3


/obj/mecha/combat/tank/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	ME.attach(src)
	return

/obj/mecha/combat/tank/synditank/add_cell(var/obj/item/weapon/stock_parts/cell/C=null)
	if(cell)
		forceMove(src)
		return
	cell = new(src)
	cell.charge = 20000
	cell.maxcharge = 20000