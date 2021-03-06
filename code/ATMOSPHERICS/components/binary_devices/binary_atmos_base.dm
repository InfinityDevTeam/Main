/obj/machinery/atmospherics/binary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	use_power = 1

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2

	var/activity_log = ""

/obj/machinery/atmospherics/binary/investigation_log(var/subject, var/message)
	activity_log += ..()

/obj/machinery/atmospherics/binary/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = NORTH|SOUTH
		if(SOUTH)
			initialize_directions = NORTH|SOUTH
		if(EAST)
			initialize_directions = EAST|WEST
		if(WEST)
			initialize_directions = EAST|WEST
	air1 = new
	air2 = new

	air1.volume = 200
	air2.volume = 200

/obj/machinery/atmospherics/binary/buildFrom(var/mob/usr,var/obj/item/pipe/pipe)
	dir = pipe.dir
	initialize_directions = pipe.get_pipe_dir()
	if (pipe.pipename)
		name = pipe.pipename
	var/turf/T = loc
	level = T.intact ? 2 : 1
	initialize()
	build_network()
	if (node1)
		node1.initialize()
		node1.build_network()
	if (node2)
		node2.initialize()
		node2.build_network()
	return 1

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/binary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network1 = new_network

	else if(reference == node2)
		network2 = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/binary/Destroy()
	if(node1)
		node1.disconnect(src)
		if(network1)
			returnToDPool(network1)
	if(node2)
		node2.disconnect(src)
		if(network2)
			returnToDPool(network2)

	node1 = null
	node2 = null

	..()

/obj/machinery/atmospherics/binary/initialize()
	if(node1 && node2) return

	node1 = findConnecting(turn(dir, 180))
	node2 = findConnecting(dir)

	update_icon()

/obj/machinery/atmospherics/binary/build_network()
	if(!network1 && node1)
		network1 = getFromDPool(/datum/pipe_network)
		network1.normal_members += src
		network1.build_network(node1, src)

	if(!network2 && node2)
		network2 = getFromDPool(/datum/pipe_network)
		network2.normal_members += src
		network2.build_network(node2, src)


/obj/machinery/atmospherics/binary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return network1

	if(reference==node2)
		return network2

	return null

/obj/machinery/atmospherics/binary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network1 == old_network)
		network1 = new_network
	if(network2 == old_network)
		network2 = new_network

	return 1

/obj/machinery/atmospherics/binary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network1 == reference)
		results += air1
	if(network2 == reference)
		results += air2

	return results

/obj/machinery/atmospherics/binary/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		if(network1)
			returnToDPool(network1)
		node1 = null

	else if(reference==node2)
		if(network2)
			returnToDPool(network2)
		node2 = null

	return null

/obj/machinery/atmospherics/binary/unassign_network(datum/pipe_network/reference)
	if(network1 == reference)
		network1 = null
	if(network2 == reference)
		network2 = null