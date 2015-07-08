#define FIRST_DRIVE "A"
#define LAST_DRIVE "Z"

/obj/machinery/newcomputer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "command0"
	density = 1
	anchored = 1.0
	emagged = 0
	var/slots = 4
	var/obj/item/weapon/circuitboard/mainboard/circuit
	var/crash = 0
	var/on = 0
	var/booted = 0
	var/list/initperipherals = new()
	var/list/drives = new()
	var/screen = ""
	var/hardware = ""

/obj/machinery/newcomputer/New()
	..()

	hardware += "<BR>"
	hardware += text("Power: <A href='?src=\ref[];power=1'>[]</A><HR>",src,(on ? "ON" : "OFF"))

	spawn(2)
		var/i = 1

		for(var/obj/item/weapon/circuitboard/peripherals/P in contents)
			initperipherals += P
			if(istype(P,/obj/item/weapon/circuitboard/peripherals/floppy))
				var/obj/item/weapon/circuitboard/peripherals/floppy/f = P
				hardware += text("Floppy: <A href='?src=\ref[];hardware=[]'>[]</A><HR>", src,i, (f.disk ? "##########" : "----------"))
			else if(istype(P,/obj/item/weapon/circuitboard/peripherals/cardreader))
				var/obj/item/weapon/circuitboard/peripherals/cardreader/r = P
				hardware += text("ID-Scanner: <A href='?src=\ref[];hardware=[]'>[]</A><HR>", src,i, (r.scan ? text("[]",r.scan) : "----------"))
			else
				hardware += ""
			i+=1

		power_change()

/obj/machinery/newcomputer/meteorhit(var/obj/O as obj)
	set_broken()

/obj/machinery/newcomputer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()

/obj/machinery/newcomputer/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(25))
				del(src)
				return
			if (prob(50))
				set_broken()
		if(3.0)
			if (prob(25))
				set_broken()
		else
	return

/obj/machinery/newcomputer/blob_act()
	if (prob(75))
		set_broken()

/obj/machinery/newcomputer/power_change()
	if(powered())
		stat &= ~NOPOWER
		//boot()
	else
		spawn(rand(0, 15))
			//icon_state = "c_unpowered"
			icon_state = "command0" + ((stat & BROKEN) ? "b" : "")
			stat |= NOPOWER
			overlays = null

/obj/machinery/newcomputer/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(250)

/obj/machinery/newcomputer/proc/set_broken()
	if(on)
		crash()
	icon_state += "b"
	stat |= BROKEN

/obj/machinery/newcomputer/proc/boot()
	if(stat & (NOPOWER|BROKEN))
		return

	on = 1
	src.icon_state = "command"
	src.desc = "This computer appears to be booting."
	var/drivenumber = text2ascii(FIRST_DRIVE)

	for(var/obj/item/weapon/circuitboard/peripherals/P in contents)
		if(stat & (BROKEN|NOPOWER))
			return

		screen += "Initializing [P.name]... "
		sleep(10+rand(0,10))
		screen += "Done.<BR>"
		if(istype(P,/obj/item/weapon/circuitboard/peripherals/harddisk))
			var/obj/item/weapon/circuitboard/peripherals/harddisk/HD = P
			if(drivenumber <= text2ascii(LAST_DRIVE))
				HD.drivenumber = "[ascii2text(drivenumber)]:"
				drives += HD
				screen += "Added [HD.name] as [ascii2text(drivenumber)]: ([HD.size] nB)..."
				drivenumber += 1
			else
				screen += "Unable to add another drive."
		else if(istype(P,/obj/item/weapon/circuitboard/peripherals/floppy))
			var/obj/item/weapon/circuitboard/peripherals/floppy/DD = P
			if(drivenumber <= text2ascii(LAST_DRIVE))
				DD.drivenumber = "[ascii2text(drivenumber)]:"
				drives += DD
				screen += "Added [DD.name] as [ascii2text(drivenumber)]: (? nB)..."
				drivenumber += 1
			else
				screen += "Unable to add another drive."

		initperipherals += P

	if(drives.len)
		for(var/obj/item/weapon/circuitboard/peripherals/drive in drives)
			var/obj/item/weapon/circuitboard/peripherals/harddisk/HD = drive
			var/obj/item/weapon/circuitboard/peripherals/floppy/DD = drive
			if(HD)
				if(HD.bootsector)
					screen += "Attempting to boot from [HD.drivenumber] ..."
					HD.bootsector.execute()
				else
					screen += "Cannot boot from [HD.drivenumber] .<BR>"
			else if(DD)
				if(DD.disk && DD.disk.bootsector)
					screen += "Attempting to boot from [DD.drivenumber] ..."
					DD.disk.bootsector.execute()
				else
					screen += "Cannot boot from [DD.drivenumber] .<BR>"



	if(stat & (BROKEN|NOPOWER))
		return

	if(!booted)
		screen += "Failed to boot. No valid bootloader found.<BR>"
		return

/obj/machinery/newcomputer/proc/unboot()
	if(booted)
		screen += "Shutting down..."
		sleep(10+rand(0,10))
		booted = 0

	screen = ""
	on = 0
	icon_state = "command0" + ((stat & BROKEN) ? "b" : "")


/obj/machinery/newcomputer/proc/crash()

/obj/machinery/newcomputer/proc/finddevice(device)
	for(var/obj/O in contents)
		if(istype(O,device))
			return O

/obj/machinery/newcomputer/proc/finddrive(drivenum)
	if(drives.len)
		for(var/obj/item/weapon/circuitboard/peripherals/drive in drives)
			var/obj/item/weapon/circuitboard/peripherals/harddisk/HD = drive
			var/obj/item/weapon/circuitboard/peripherals/floppy/DD = drive
			if(HD && HD.drivenumber == drivenum)
				return HD
			if(DD && DD.drivenumber == drivenum && DD.disk)
				return DD.disk

/obj/machinery/newcomputer/proc/finddir(path)
	var/list/files = new()

	if(drives.len)
		for(var/obj/item/weapon/circuitboard/peripherals/drive in drives)
			var/obj/item/weapon/circuitboard/peripherals/harddisk/HD = drive
			var/obj/item/weapon/circuitboard/peripherals/floppy/DD = drive
			if(HD)
				for(var/datum/computer/file/f in HD.filesystem)
					if("[HD.drivenumber][f.path]" == path)
						files += f
			if(DD)
				if(DD.disk)
					for(var/datum/computer/file/f in DD.disk.filesystem)
						if("[DD.drivenumber][f.path]" == path)
							files += f

	return files

/obj/machinery/newcomputer/proc/findfile(path)
	if(drives.len)
		for(var/obj/item/weapon/circuitboard/peripherals/drive in drives)
			var/obj/item/weapon/circuitboard/peripherals/harddisk/HD = drive
			var/obj/item/weapon/circuitboard/peripherals/floppy/DD = drive
			if(HD)
				for(var/datum/computer/file/f in HD.filesystem)
					if("[HD.drivenumber][f.path][f.name]" == path)
						return f
			if(DD)
				if(DD.disk)
					for(var/datum/computer/file/f in DD.disk.filesystem)
						if("[DD.drivenumber][f.path][f.name]" == path)
							return f

/obj/machinery/newcomputer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver) && circuit)
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/newcomputerframe/A = new /obj/structure/newcomputerframe( src.loc )
			A.circuit = circuit
			A.anchored = 1
			A.slots = slots
			for (var/obj/C in src)
				C.loc = A
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/weapon/shard( src.loc )
				A.state = 3
				A.icon_state = "build_3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "build_4"
			del(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/newcomputer/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact_computer(user)

/obj/machinery/newcomputer/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact_computer(user)

/obj/machinery/newcomputer/proc/interact_computer(mob/user)
	if(!on)
		user << "You switch the computer on."
		boot()
	else
		/var/dat = ""
		dat = screen
		dat += hardware
		user << browse(dat, "window=computer")
		onclose(user, "computer")

/obj/machinery/newcomputer/Topic(href, href_list)
	if(href_list["hardware"])
		var/obj/item/weapon/circuitboard/peripherals/HW = initperipherals[href_list["hardware"]]

		if(istype(HW,/obj/item/weapon/circuitboard/peripherals/floppy))
			if (HW:disk)
				if(istype(usr,/mob/living/carbon/human) && !usr.get_active_hand())
					usr.put_in_hands()
				else
					HW:disk.loc = get_turf(src)
				HW:disk = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.loc = HW
					HW:disk = I
	else if(href_list["power"])
		if(!on)
			boot()
		else
			unboot()

	src.add_fingerprint(usr)
	src.updateDialog()
