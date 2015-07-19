/datum/ship_engine/electric
	name = "electrical engine"

	get_status()
		..()
		var/obj/machinery/power/engine/electric/E = engine
		return "Power Level: [E.avail()] watts."

	get_thrust()
		..()
		var/obj/machinery/power/engine/electric/E = engine
		if(!is_on())
			return 0
		var/powered_coef = E.avail()/E.effective_power
		return round(E.thrust_limit * E.nominal_thrust * powered_coef)

	burn()
		..()
		var/obj/machinery/power/engine/electric/E = engine
		E.burn()

	set_thrust_limit(var/newlimit)
		..()
		var/obj/machinery/power/engine/electric/E = engine
		E.thrust_limit = newlimit

	get_thrust_limit()
		..()
		var/obj/machinery/power/engine/electric/E = engine
		return E.thrust_limit

	is_on()
		..()
		var/obj/machinery/power/engine/electric/E = engine
		return E.on

	toggle()
		..()
		var/obj/machinery/power/engine/electric/E = engine
		E.on = !E.on


/obj/machinery/power/engine/electric
	name = "Electric Engine Nozzle"
	desc = "Moves the ship, stay clear"
	icon = 'icons/obj/engine2.dmi'
	icon_state = "Still_Off"
	var/on = 1
	var/thrust_limit = 1	//Value between 1 and 0 to limit the resulting thrust
	var/nominal_thrust = 3000
	var/effective_power = 100000
	var/datum/ship_engine/electric/controller

	initialize()
		..()
		controller = new controller(src)

	Del()
		..()
		controller.die()

	proc/burn()
		if(!on)
			icon_state = "Still_Off"
			return
		if(!powered(chan = EQUIP))
			return
		if(avail() >= effective_power)
			icon_state = "Animated_On"
			var/power_used = (avail()/effective_power * thrust_limit)
			use_power(power_used, chan = EQUIP)

			/*if(power_used > effective_power)
				var/exhaust_dir = reverse_direction(dir)
				var/turf/T = get_step(src, exhaust_dir)
				if(T)
					new/obj/effect/engine_exhaust(T,exhaust_dir,avail())*/
			return 1