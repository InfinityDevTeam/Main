datum/computer
	var/obj/machinery/newcomputer/comp

datum/computer/file
	var/size
	var/extension
	var/path
	var/drive
	var/hidden
	var/access
	var/content

	New(newpath)
		..()
		path = newpath

	proc/execute(list/parameters)

	proc/copy(drive,path)
		var/dest = comp.finddrive(drive)
		var/datum/computer/file/copyfile = new type(path)
		copyfile.name = src.name
		copyfile.extension = src.extension
		copyfile.size = src.size
		copyfile.content = src.content

		if(dest)
			copyfile.drive = dest:drivenumber
			if(path == "boot")
				dest:bootsector = copyfile
			else
				dest:filesystem += copyfile


	nano
		name = "nano"
		extension = ""
		size = 10
		var/loginname
		var/loginpass
		var/login = 0

		execute(list/parameters)
			comp.desc = "This computer appears to be running NANO."
			comp.screen = ""
			if(!src.login)
				comp.screen += "<center><h4>NT Nano</h4><BR>"
				comp.screen += text("Enter Username: <A href='?src=\ref[];loginname=1'>[]</A><HR>", src, (src.loginname ? text("[]", src.loginname) : "----------"))
				comp.screen += text("Enter Password: <A href='?src=\ref[];loginpass=1'>[]</A><HR>", src, (src.loginpass ? text("[]", src.loginpass) : "----------"))
				comp.screen += text("<BR><A href='?src=\ref[];login=1'>Login</A><HR>", src)
				comp.screen += "</center>"
			else
				comp.screen += "Stuff"

		Topic(href, href_list)
			var/t1

			if(href_list["loginname"])
				t1 = input("Enter login name.","Enter username")
				if(t1)
					loginname = t1
			if(href_list["loginname"])
				t1 = input("Enter login password.","Enter password")
				if(t1)
					loginpass = t1
			if(href_list["login"])
				login = 1

			comp.add_fingerprint(usr)
			comp.updateUsrDialog()

	nanoinstall
		name = "nanoinstall"
		extension = ""
		size = 10
		var/progress = 0

		execute(list/parameters)
			comp.desc = "This computer appears to be installing NANO."
			comp.screen = ""

			comp.screen += "Initializing NANO Install...<BR>"
			sleep(10+rand(10))
			var/obj/item/weapon/circuitboard/peripherals/harddisk/HD
			HD = comp.finddevice(/obj/item/weapon/circuitboard/peripherals/harddisk)
			if(!HD)
				comp.screen += "Failed to find a harddisk to install NANO."
				return
			comp.screen += "Starting NANO Install... "
			sleep(10+rand(10))
			comp.screen += text("[]%<BR>",progress)
			sleep(10+rand(10))
			while(progress <= 100)
				if(!HD)
					comp.crash()
				sleep(10+rand(10))
				progress += 1
			sleep(10+rand(10))
			if(HD)
				for(var/datum/computer/file/f in comp.finddir("[drive][path]"))
					f.copy(HD,"boot")
				comp.screen += "Installed NANO successfully!<BR>"

datum/computer/user
	var/username
	var/password
	var/powerlevel = 0
	//0 = guest
	//1 = user
	//2 = admin
	//3 = root