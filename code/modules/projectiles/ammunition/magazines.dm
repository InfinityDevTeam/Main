//Magazines are loaded directly into weapons
//Unlike boxes, they have no fumbling. Simply loading a magazine is instant

/obj/item/ammo_storage/magazine
	desc = "A magazine capable of holding bullets. Can be loaded into certain weapons."
	exact = 1 //we only load the thing we want to load

/obj/item/ammo_storage/magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/c9mm"
	max_ammo = 8
	sprite_modulo = 8
	multiple_sprites = 1

/obj/item/ammo_storage/magazine/mc9mm/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/a12mm
	name = "magazine (12mm)"
	icon_state = "12mm"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/a12mm"
	max_ammo = 20
	multiple_sprites = 1
	sprite_modulo = 2


/obj/item/ammo_storage/magazine/a12mm/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/battle_rifle_clip
	name = "magazine (battle rifle)"
	icon_state = "battle_rifle_clip"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/a95"
	max_ammo = 36
	multiple_sprites = 1
	sprite_modulo = 36

/obj/item/ammo_storage/magazine/battle_rifle_clip/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/ma5
	name = "magazine (ma5)"
	icon_state = "ma5"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/a762"
	max_ammo = 32
	multiple_sprites = 1
	sprite_modulo = 32

/obj/item/ammo_storage/magazine/ma5/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/magnum_clip
	name = "magazine(magnum)"
	icon_state = "magnum_clip"
	origin_tech = "combat=2"
	ammo_type ="/obj/item/ammo_casing/a127"
	max_ammo = 8
	multiple_sprites = 1
	sprite_modulo = 8

/obj/item/ammo_storage/magazine/magnum_clip/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/socom_clip
	name = "magazine(SOCOM)"
	icon_state = "socom_clip"
	origin_tech = "combat=2"
	ammo_type ="/obj/item/ammo_casing/a127"
	max_ammo = 12
	multiple_sprites = 1
	sprite_modulo = 12

/obj/item/ammo_storage/magazine/socom_clip/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/m7smg_clip
	name = "magazine(M7SMG)"
	icon_state = "m7smg_clip"
	origin_tech = "combat=2"
	ammo_type ="/obj/item/ammo_casing/a197"
	max_ammo = 60
	multiple_sprites = 1
	sprite_modulo = 60

/obj/item/ammo_storage/magazine/m7smg_clip/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/subsonic
	name = "magazine(.380 Subsonic)"
	icon_state = "subsonic"
	origin_tech = "combat=2"
	ammo_type ="/obj/item/ammo_casing/c38"
	max_ammo = 7
	multiple_sprites = 1
	sprite_modulo = 1

/obj/item/ammo_storage/magazine/socom_clip/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/smg9mm
	name = "magazine (9mm)"
	icon_state = "smg9mm"
	origin_tech = "combat=3"
	ammo_type = "/obj/item/ammo_casing/c9mm"
	max_ammo = 18
	sprite_modulo = 3
	multiple_sprites = 1

/obj/item/ammo_storage/magazine/a50
	name = "magazine (.50)"
	icon_state = "50ae"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/a50"
	max_ammo = 7
	multiple_sprites = 1
	sprite_modulo = 1

/obj/item/ammo_storage/magazine/a50/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/a75
	name = "magazine (.75)"
	icon_state = "75"
	ammo_type = "/obj/item/ammo_casing/a75"
	multiple_sprites = 1
	max_ammo = 8
	sprite_modulo = 8

/obj/item/ammo_storage/magazine/a75/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/a762
	name = "magazine (a762)"
	icon_state = "a762"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/a762"
	max_ammo = 50
	multiple_sprites = 1
	sprite_modulo = 10

/obj/item/ammo_storage/magazine/a762/empty
	starting_ammo = 0

/obj/item/ammo_storage/magazine/c45
	name = "magazine (.45)"
	icon_state = "45"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/c45"
	max_ammo = 8
	multiple_sprites = 1
	sprite_modulo = 1

/obj/item/ammo_storage/magazine/uzi45 //Uzi mag
	name = "magazine (.45)"
	icon_state = "uzi45"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/c45"
	max_ammo = 16
	multiple_sprites = 1
	sprite_modulo = 2
