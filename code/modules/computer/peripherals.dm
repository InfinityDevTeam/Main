/obj/item/weapon/circuitboard/peripherals
	name = "peripheral card"
	desc = "This card shouldn't exist."
	icon = 'module.dmi'
	icon_state = "std_mod"

/obj/item/weapon/circuitboard/peripherals/harddisk
	name = "harddisk"
	icon_state = "harddisk"
	desc = "A peripheral module for storing data."
	var/list/filesystem
	var/datum/computer/file/bootsector
	var/drivenumber
	var/size = 100

/obj/item/weapon/circuitboard/peripherals/floppy
	name = "floppy drive"
	desc = "A peripheral module for reading from datadisks."
	icon_state = "card_mod"
	var/obj/item/weapon/disk/floppy/disk
	var/drivenumber

/obj/item/weapon/disk/floppy
	name = "floppy Disk"
	desc = "A disk for storing data."
	icon = 'cloning.dmi'
	icon_state = "datadisk1"
	item_state = "card-id"
	w_class = 1.0
	m_amt = 30
	g_amt = 10
	var/list/filesystem
	var/datum/computer/file/bootsector
	var/size = 10
	var/readonly = 0
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/weapon/circuitboard/peripherals/network
	name = "network card"
	desc = "A peripheral module for interfacing with the network."
	icon_state = "std_mod"

/obj/item/weapon/circuitboard/peripherals/wireless
	name = "wireless network card"
	desc = "A peripheral module for wireless interfacing with the network."
	icon_state = "std_mod"

/obj/item/weapon/circuitboard/peripherals/relay
	name = "high-power relay"
	desc = "A peripheral module for measuring circuit from powerlines."
	icon_state = "power_mod"

/obj/item/weapon/circuitboard/peripherals/battery
	name = "battery box"
	desc = "A peripheral module for using energy cells as auxillary power."
	icon_state = "power_mod"


/obj/item/weapon/circuitboard/peripherals/cardreader
	name = "\proper ID-card reader"
	desc = "A peripheral module for scanning ID-cards."
	icon_state = "id_mod"
	var/obj/item/weapon/card/id/scan

/obj/item/weapon/circuitboard/peripherals/print
	name = "nanoprinter"
	desc = "A peripheral module for printing text to paper."
	icon_state = "std_mod"

/obj/item/weapon/circuitboard/peripherals/sound
	name = "soundcard"
	desc = "A peripheral module for playing sounds."
	icon_state = "std_mod"

	proc/makesound(name)
//		switch(name)
//			if("honk")
