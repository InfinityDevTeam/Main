/obj/item/weapon/circuitboard/mainboard
	name = "Computer Mainboard"
	icon_state = "mainboard"
	board_type = "none"
	origin_tech = "programming=3"
	build_path = "/obj/machinery/newcomputer"

/obj/structure/newcomputerframe
	density = 1
	anchored = 0
	name = "Computer-frame"
	icon = 'stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/weapon/circuitboard/mainboard/circuit = null
	var/list/peripherals = new()
	var/slots = 4
//	weight = 1.0E8


/obj/structure/newcomputerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You wrench the frame into place."
					src.anchored = 1
					src.state = 1
			if(istype(P, /obj/item/weapon/weldingtool))
				P:welding = 2
				playsound(src.loc, 'Welder.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You deconstruct the frame."
					new /obj/item/stack/sheet/metal( src.loc, 5 )
					del(src)
				P:welding = 1
		if(1)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You unfasten the frame."
					src.anchored = 0
					src.state = 0
			if(istype(P, /obj/item/weapon/circuitboard/mainboard) && !circuit)
				var/obj/item/weapon/circuitboard/mainboard/B = P
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				user << "\blue You place the mainboard inside the frame."
				src.icon_state = "1"
				src.circuit = B
				user.drop_item()
				B.loc = src
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'Screwdriver.ogg', 50, 1)
				user << "\blue You screw the mainboard into place."
				src.state = 2
				src.icon_state = "2"
			if(istype(P, /obj/item/weapon/crowbar) && circuit)
				playsound(src.loc, 'Crowbar.ogg', 50, 1)
				user << "\blue You remove the mainboard."
				src.state = 1
				src.icon_state = "0"
				circuit.loc = src.loc
				src.circuit = null
		if(2)
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'Screwdriver.ogg', 50, 1)
				user << "\blue You unfasten the circuit board."
				src.state = 1
				src.icon_state = "1"
			if(istype(P, /obj/item/stack/cable_coil))
				if(P:amount >= 5)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						if(P)
							P:amount -= 5
							if(!P:amount) del(P)
							user << "\blue You add cables to the frame."
							src.state = 3
							src.icon_state = "3"
			if(istype(P, /obj/item/weapon/crowbar) && peripherals)
				var/obj/item/weapon/circuitboard/peripherals/c = peripherals[peripherals.len]
				if(c)
					playsound(src.loc, 'Crowbar.ogg', 50, 1)
					user << "\blue You remove [c]."
					c.loc = src.loc
					src.peripherals -= c
			if(istype(P, /obj/item/weapon/circuitboard/peripherals) && peripherals)
				var/obj/item/weapon/circuitboard/peripherals/c = P
				if(peripherals.len < slots)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					user << "\blue You place [c] on the mainboard."
					src.peripherals += c
					user.drop_item()
					c.loc = src
		if(3)
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(src.loc, 'wirecutter.ogg', 50, 1)
				user << "\blue You remove the cables."
				src.state = 2
				src.icon_state = "2"

			if(istype(P, /obj/item/stack/sheet/glass))
				if(P:amount >= 2)
					playsound(src.loc, 'Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						if(P)
							P:use(2)
							user << "\blue You put in the glass panel."
							src.state = 4
							src.icon_state = "4"
		if(4)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'Crowbar.ogg', 50, 1)
				user << "\blue You remove the glass panel."
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/sheet/glass( src.loc, 2 )
			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'Screwdriver.ogg', 50, 1)
				user << "\blue You connect the monitor."
				var/obj/machinery/newcomputer/B = new( src.loc )
				B.slots = slots
				B.circuit = circuit
				circuit.Move(B)
				for(var/obj/o in peripherals)
					o.Move(B)
				del(src)
