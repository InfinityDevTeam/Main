/obj/item/weapon/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .38 rounds."
	icon_state = "silenced_pistol"
	item_state = null
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/guninhands_left.dmi', "right_hand" = 'icons/mob/in-hand/right/guninhands_right.dmi')
	w_class = 3.0
	max_shells = 7
	caliber = list("subsonic"  = 1)
	silenced = 1
	origin_tech = "combat=2;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/c38"
	mag_type = "/obj/item/ammo_storage/magazine/subsonic"
	load_method = 2

/obj/item/weapon/gun/projectile/silenced/update_icon()
	..()
	if(stored_magazine)
		icon_state = "silenced_pistol_full"
	else
		icon_state = "silenced_pistol"
	return


/obj/item/weapon/gun/projectile/magnum
	name = "M6G Magnum"
	desc = "The standard UNSC Handgun"
	icon_state = "magnum"
	item_state = "magnum"
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/guninhands_left.dmi', "right_hand" = 'icons/mob/in-hand/right/guninhands_right.dmi')
	w_class = 3.0
	max_shells = 8
	caliber = list("12.7"  = 1)
	origin_tech = "combat=2;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/12.7"
	mag_type = "/obj/item/ammo_storage/magazine/magnum_clip"
	load_method = 2

/obj/item/weapon/gun/projectile/magnum/update_icon()
	..()
	if(stored_magazine)
		icon_state = "magnum_full"
	else
		icon_state = "magnum"
	return


/obj/item/weapon/gun/projectile/socom
	name = "M6C/SOCOM"
	desc = "The Handgun used by the UNSC special operations unit."
	icon_state = "socom"
	item_state = "socom"
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/guninhands_left.dmi', "right_hand" = 'icons/mob/in-hand/right/guninhands_right.dmi')
	w_class = 3.0
	max_shells = 12
	caliber = list("12.7"  = 1)
	origin_tech = "combat=2;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/12.7"
	mag_type = "/obj/item/ammo_storage/magazine/socom_clip"
	load_method = 2


/obj/item/weapon/gun/projectile/socom/update_icon()
	..()
	if(stored_magazine)
		icon_state = "socom_full"
	else
		icon_state = "socom"
	return


/obj/item/weapon/gun/projectile/deagle
	name = "desert eagle"
	desc = "A robust handgun that uses .50 AE ammo"
	icon_state = "deagle"
	item_state = null
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/guninhands_left.dmi', "right_hand" = 'icons/mob/in-hand/right/guninhands_right.dmi')
	force = 14.0
	max_shells = 7
	caliber = list(".50" = 1)
	ammo_type ="/obj/item/ammo_casing/a50"
	mag_type = "/obj/item/ammo_storage/magazine/a50"
	load_method = 2

	gun_flags = AUTOMAGDROP | EMPTYCASINGS

/obj/item/weapon/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"


/obj/item/weapon/gun/projectile/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"



/obj/item/weapon/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon_state = "gyropistol"
	item_state = null
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/guninhands_left.dmi', "right_hand" = 'icons/mob/in-hand/right/guninhands_right.dmi')
	max_shells = 8
	caliber = list("75" = 1)
	fire_sound = 'sound/weapons/elecfire.ogg'
	origin_tech = "combat=3"
	ammo_type = "/obj/item/ammo_casing/a75"
	mag_type = "/obj/item/ammo_storage/magazine/a75"
	load_method = 2

	gun_flags = AUTOMAGDROP | EMPTYCASINGS

	update_icon()
		..()
		if(stored_magazine)
			icon_state = "gyropistolloaded"
		else
			icon_state = "gyropistol"
		return

/obj/item/weapon/gun/projectile/pistol
	name = "\improper Stechtkin pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	w_class = 2
	max_shells = 8
	caliber = list("9mm" = 1)
	silenced = 0
	origin_tech = "combat=2;materials=2;syndicate=2"
	ammo_type = "/obj/item/ammo_casing/c9mm"
	mag_type = "/obj/item/ammo_storage/magazine/mc9mm"
	load_method = 2

	gun_flags = AUTOMAGDROP | EMPTYCASINGS | SILENCECOMP

/obj/item/weapon/gun/projectile/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][silenced ? "-silencer" : ""][chambered ? "" : "-e"]"
	return


