/obj/item/weapon/disk/floppy/nano
	name = "install disk"
	desc = "A disk for installing NT Nano."
	readonly = 1
	size = 20
	New()
		..()
		bootsector = new/datum/computer/file/nanoinstall()
		filesystem += new/datum/computer/file/nano("/")
