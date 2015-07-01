/obj/machinery/power/Reactor

	name = "Fancy Scientific Generator"
	desc = "A fancy fusion-based generator designed primarily for use with Elerium, but will accept other ores at risk of reaction instability."
	icon = 'icons/obj/machines/reactor.dmi'
	icon_state = "placeholder"
	anchored = 1
	density = 1

	var/active = 0
	var/fuel = 0
	var/maxfuel = 600
	var/genrate = 5000
	var/effmult = 0.6
	var/enrichment = 0
	var/risk = 0
	var/busy = 0

/obj/machinery/power/Reactor/process()

	if((stat & BROKEN) || !active)
		return

	if(!fuel)
		active = 0
		visible_message("<span class='danger'>\The [src] runs out of fuel and shuts down!</span>")
		if(icon_state != "placeholder1")
			busy = 1
			flick("placeholder2", src)
			sleep(14)
			busy = 0
		return

	if(prob(risk))
		visible_message("<span class='danger'>\The [src] starts to overload!</span>")
		stat = BROKEN
		flick("reactormelt", src)
		sleep(41)
		visible_message("<span class='danger'>)\The [src] explodes!</span>")
		explosion(src.loc,0,rand(1,3),rand(2,6),rand(4,8),rand(6,10))
		sleep(21)
		icon_state = "dead"
		return

	add_avail(src.genrate * src.enrichment * src.effmult)
	fuel--

/obj/machinery/power/Reactor/attack_hand(var/mob/user as mob)

	if(busy || (stat & BROKEN))
		return

	if (!fuel)
		visible_message("<span class='warning'>There is no fuel in the \the [src]!</span>")
	else
		active = !active
		user << "You switch \the [src] [src.active ? "on" : "off"]."
	return

	busy = 1
	if(active)
		if(icon_state != "placeholder1")
			flick("placeholder2", src)
	else
		if(icon_state != "placeholder")
			flick("placeholder3", src)
	busy = 0

/obj/machinery/power/Reactor/attackby(var/obj/item/weapon/ore/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/ore/char))
		src.fuel += (src.fuel + 600)
		enrichment = 10
		risk = 0
		del W
	else if (istype(W, /obj/item/weapon/ore/cerenkite))
		src.fuel += (src.fuel + 600)
		enrichment = 75
		risk = 0
		del W
	else if(istype(W, /obj/item/weapon/ore/plasma))
		src.fuel += (src.fuel + 600)
		enrichment = 7500
		risk = 0
		del W
	else if (istype(W, /obj/item/weapon/ore/uranium))
		src.fuel = (src.fuel + 600)
		enrichment = 850
		risk = 2
		del W
	else if(istype(W, /obj/item/weapon/ore/erebite))
		src.fuel = (src.fuel + 600)
		enrichment = 2000
		risk = 100
		del W
	return

	if(src.fuel > src.maxfuel)
		src.fuel = src.maxfuel
		user << "\blue The reactor is now full!"
