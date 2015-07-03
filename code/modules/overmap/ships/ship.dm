/obj/effect/map/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon_state = "sheet-sandstone"
	var/vessel_mass = 9000 //tonnes, random number
	var/default_delay = 60
	var/list/speed = list(0,0)
	var/last_burn = 0
	var/list/last_movement = list(0,0)
	var/fore_dir = NORTH
	var/list/ship_levels = list()
	var/list/ship_turfs = list()
	var/shipname = "Generic Space Vessel"

	var/obj/effect/map/current_sector
	var/obj/machinery/computer/helm/nav_control
	var/obj/machinery/computer/engines/eng_control

/obj/effect/map/ship/initialize()
	for(var/obj/machinery/computer/engines/E in machines)
		if (E.z in ship_levels)
			eng_control = E
			break
	for(var/obj/machinery/computer/helm/H in machines)
		if (H.z in ship_levels)
			nav_control = H
			break
	processing_objects.Add(src)


/obj/effect/map/ship/New(var/obj/effect/mapinfo/data)
	tag = "ship_[data.shipname]"
	map_z = data.z

	name = data.name
	shipname = data.shipname
	always_known = data.known
	if (data.icon != 'icons/mob/screen1.dmi')
		icon = data.icon
		icon_state = data.icon_state
	if(data.desc)
		desc = data.desc
	var/new_x = data.mapx ? data.mapx : rand(OVERMAP_EDGE, world.maxx - OVERMAP_EDGE)
	var/new_y = data.mapy ? data.mapy : rand(OVERMAP_EDGE, world.maxy - OVERMAP_EDGE)
	loc = locate(new_x, new_y, OVERMAP_ZLEVEL)

	if(data.landing_area)
		shuttle_landing = locate(data.landing_area)

/obj/effect/map/ship/proc/update_spaceturfs()
	for(var/turf/space/S in world)
		if(S.z in src.ship_levels)
			ship_turfs.Add(S)


/obj/effect/map/ship/relaymove(mob/user, direction)
	accelerate(direction)

/obj/effect/map/ship/proc/is_still()
	return !(speed[1] || speed[2])

/obj/effect/map/ship/proc/get_acceleration()
	return eng_control.get_total_thrust()/vessel_mass

/obj/effect/map/ship/proc/get_speed()
	return round(sqrt(speed[1]*speed[1] + speed[2]*speed[2]))

/obj/effect/map/ship/proc/get_heading()
	var/res = 0
	if(speed[1])
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(speed[2])
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/effect/map/ship/proc/adjust_speed(n_x, n_y)
	speed[1] = Clamp(speed[1] + n_x, -default_delay, default_delay)
	speed[2] = Clamp(speed[2] + n_y, -default_delay, default_delay)
	for(var/shipz in ship_levels)
		if(is_still())
			toggle_move_stars(shipz)
		else
			toggle_move_stars(shipz, fore_dir)

/obj/effect/map/ship/proc/can_burn()
	if (!eng_control)
		return 0
	if (world.time < last_burn + 10)
		return 0
	if (!eng_control.burn())
		return 0
	return 1

/obj/effect/map/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	return max(abs(speed[1]),abs(speed[2]))/get_acceleration()

#define SIGN(X) (X == 0 ? 0 : (X > 0 ? 1 : -1))
/obj/effect/map/ship/proc/decelerate()
	if(!is_still() && can_burn())
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_acceleration(),abs(speed[2])))
		last_burn = world.time

/obj/effect/map/ship/proc/accelerate(direction)
	if(can_burn())
		last_burn = world.time

		if(direction & EAST)
			adjust_speed(get_acceleration(), 0)
		if(direction & WEST)
			adjust_speed(-get_acceleration(), 0)
		if(direction & NORTH)
			adjust_speed(0, get_acceleration())
		if(direction & SOUTH)
			adjust_speed(0, -get_acceleration())

/obj/effect/map/ship/process()
	if(!is_still())
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(speed[i] && world.time > last_movement[i] + default_delay - speed[i])
				deltas[i] = speed[i] > 0 ? 1 : -1
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc)