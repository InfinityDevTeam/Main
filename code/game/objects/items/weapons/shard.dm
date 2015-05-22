/*
 * Glass shards
 */

/obj/item/weapon/shard
	var/size = "large"
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	sharpness = 0.8
	desc = "Could probably be used as ... a throwing weapon?"
	w_class = 1.0
	force = 5.0
	throwforce = 15.0
	item_state = "shard-glassnew"
	g_amt = 3750
	w_type = RECYK_GLASS
	melt_temperature = MELTPOINT_GLASS
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	var/glass = /obj/item/stack/sheet/glass/glass

/obj/item/weapon/shard/New()

	src.size = pick("large", "medium", "small")
	src.icon_state = src.size
	switch(src.icon_state)
		if("small")
			src.pixel_x = rand(-12, 12)
			src.pixel_y = rand(-12, 12)
		if("medium")
			src.pixel_x = rand(-8, 8)
			src.pixel_y = rand(-8, 8)
		if("large")
			src.pixel_x = rand(-5, 5)
			src.pixel_y = rand(-5, 5)
		else
	..()
	return

/obj/item/weapon/shard/shiv
	name = "Shiv"
	desc = "A selfbuild shiv, made from a piece of cloth and a glass shard"
	sharpness = 1.0
	force = 15
	icon_state = "shivmedium"

/obj/item/weapon/shard/shiv/New(var/sizeShard)
/*
	..()
	src.icon_state = pick("shivlarge", "shivmedium", "shivsmall")
*/
	src.size = size
	if(sizeShard == "small" || sizeShard == "medium" || sizeShard == "large")
		src.icon_state = "shiv[sizeShard]"
	switch(src.size)
		if("small")
			src.pixel_x = rand(-12, 12)
			src.pixel_y = rand(-12, 12)
		if("medium")
			src.pixel_x = rand(-8, 8)
			src.pixel_y = rand(-8, 8)
		if("large")
			src.pixel_x = rand(-5, 5)
			src.pixel_y = rand(-5, 5)
		else
	return


/obj/item/weapon/shard/plasma
	name = "plasma shard"
	desc = "A shard of plasma glass. Considerably tougher then normal glass shards. Apparently not tough enough to be a window."
	force = 8.0
	throwforce = 15.0
	icon_state = "plasmalarge"
	item_state = "shard-plasglass"
	glass = /obj/item/stack/sheet/glass/plasmaglass

/obj/item/weapon/shard/plasma/New()
	..()
	src.icon_state = pick("plasmalarge", "plasmamedium", "plasmasmall")
	return

/obj/item/weapon/shard/shrapnel
	name = "shrapnel"
	icon = 'icons/obj/shards.dmi'
	icon_state = "shrapnellarge"
	desc = "A bunch of tiny bits of shattered metal."
	m_amt=5
	w_type=RECYK_METAL
	melt_temperature=MELTPOINT_STEEL

/obj/item/weapon/shard/shrapnel/New()
	..()
	src.icon_state = pick("shrapnellarge", "shrapnelmedium", "shrapnelsmall")
	return

/obj/item/weapon/shard/suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the shard of glass! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the shard of glass! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/obj/item/weapon/shard/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/shard/resetVariables()
	..("icon_state", "pixel_y", "pixel_x")

/obj/item/weapon/shard/Bump()

	spawn( 0 )
		if (prob(20))
			src.force = 15
		else
			src.force = 4
		..()
		return
	return

/obj/item/weapon/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (iswelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			var/obj/item/stack/sheet/glass/new_item = new glass(user.loc)
			new_item.add_to_stacks(usr)
			returnToPool(src)
			return
	if (istype(W, /obj/item/weapon/rag))
		var/size = src.size
		returnToPool(W)
		user << "<span class='notice'>You wrap the rag around the shard, creating a dangerous weapon!</span>"
		user.put_in_active_hand(new /obj/item/weapon/shard/shiv(size))
		returnToPool(src)
		return
	return ..()

/obj/item/weapon/shard/Crossed(AM as mob|obj)
	if(ismob(AM))
		var/mob/M = AM
		M << "<span class='danger'>You step in the broken glass!</span>"
		playsound(get_turf(src), 'sound/effects/glass_step.ogg', 50, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if( !H.shoes && ( !H.wear_suit || !(H.wear_suit.body_parts_covered & FEET) ) )
				var/datum/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot"))
				if(affecting.status & (ORGAN_ROBOT|ORGAN_PEG))
					return

				H.Weaken(3)
				if(affecting.take_damage(5, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
	..()
