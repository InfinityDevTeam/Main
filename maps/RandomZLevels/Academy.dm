//overmap stuff
/obj/effect/mapinfo/sector/academy
	name = "Cultist Academy"
	shipname = "Cultist Academy"
	obj_type = /obj/effect/map/sector/academy
	mapx = 6
	mapy = 66
	landing_area = /area/awaymission/academy/incoming

/obj/effect/map/sector/academy
	name = "Cultist Academy"
	desc = "A dark place full of ancient dark arts. You can barely bring yourself to look at it on the helm display."
	icon = 'icons/obj/cult.dmi'
	icon_state = "pylon"


//Academy Areas

/area/awaymission/academy
	name = "\improper Academy Asteroids"
	icon_state = "away"

/area/awaymission/academy/headmaster
	name = "\improper Academy Fore Block"
	icon_state = "away1"

/area/awaymission/academy/classrooms
	name = "\improper Academy Classroom Block"
	icon_state = "away2"

/area/awaymission/academy/academyaft
	name = "\improper Academy Ship Aft Block"
	icon_state = "away3"

/area/awaymission/academy/academygate
	name = "\improper Academy Gateway"
	icon_state = "away4"

/area/awaymission/academy/incoming
	name = "\improper Academy Shuttle Dock"
	icon_state = "shuttle"

//Academy Items

/obj/machinery/singularity/academy
	dissipate = 0
	move_self = 0
	grav_pull = 1

/obj/machinery/singularity/academy/admin_investigate_setup()
	return

/obj/machinery/singularity/academy/process()
	eat()
	if(prob(1))
		mezzer()


/obj/item/clothing/glasses/meson/truesight
	name = "The Lens of Truesight"
	desc = "I can see forever!"
	icon_state = "monocle"
	item_state = "headset"