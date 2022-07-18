-- start location
exports['qb-target']:AddBoxZone("nxte-humain:startheist", vector3(4.23, -199.82, 52.72), 2, 1.3, {
	name = "nxte-humain:startheist",
	heading = 339.04,
	debugPoly = false,
	minZ = 52.0,
	maxZ = 54.0,
}, {
	options = {
		{
            type = "client",
            event = "nxte-humain:client:startheist",
			icon = "fas fa-circle",
			label = "Knock on Door",
		},
	},
	distance = 2.5
})

-- Power cut location
exports['qb-target']:AddBoxZone("nxte-humain:powersupply", vector3(3500.12, 3652.84, 42.59), 2, 2.9, {
	name = "nxte-humain:powersupply",
	heading = 80.48,
	debugPoly = false,
	minZ = 41.5,
	maxZ = 43.5,
}, {
	options = {
		{
            type = "client",
            event = "nxte-humain:client:cutpower",
			icon = "fas fa-circle",
			label = "Cut Power Supply",
		},
	},
	distance = 2.5
})


-- pc hack location
exports['qb-target']:AddBoxZone("nxte-humain:pchack", vector3(3536.46, 3658.5, 29.38), 0.5, 0.3, {
	name = "nxte-humain:pchack",
	heading = 348.08,
	debugPoly = false,
	minZ = 28,
	maxZ = 28.8,
}, {
	options = {
		{
            type = "client",
            event = "nxte-humain:client:pchack",
			icon = "fas fa-circle",
			label = "hack computer",
		},
	},
	distance = 2.5
})

exports['qb-target']:AddBoxZone("nxte-humain:loot",vector3(3623.17, 3730.52, 30.06) , 1.3, 1.8, {
	name = "nxte-humain:loot",
	heading = 59.33,
	debugPoly = false,
	minZ = 27.5,
	maxZ = 29.0,
}, {
	options = {
		{
            type = "client",
            event = "nxte-humain:client:loot",
			icon = "fas fa-circle",
			label = "loot crate",
		},
	},
	distance = 2.5
})
