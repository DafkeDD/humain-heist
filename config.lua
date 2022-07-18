Config = {}


-- Start heist :
Config.MinCop = 0 -- min amount of cops needed to be able to do the heist
Config.StartPrice = 5000 -- price to start the heist
Config.BlackoutTimer = 1 -- time the blackout last for in minuits


--------- Hack's ----------

-- cut power
Config.PowerItem = 'thermite' -- item needed to be able to cut the power
Config.BombBlocks = 2 -- amount of blocks need to be hacked
Config.BombBlocksFail = 5 -- amount of wrong blocks you can select before fail
Config.BombShowTime =  4 -- how long you get to see the blocks in seconds
Config.BombHackTime = 10 -- how long you have to do the hack in seconds

-- pc hack
Config.PCItem = 'electronickit' -- item needed to hack the pc
Config.PCTime = 15 -- how much time you have for the hack
Config.PCSquares = 2 -- how many squares to hack 
Config.PCRepeat = 1 -- how many times you need to repeat the hack

-- Reward's
Config.DefaultReward = 'weapon_combatpistol' -- default reward
Config.DefaultMin = 1 -- min amount of default reward you can get
Config.DefaultMax = 5 -- max amount of default reward you can get

Config.RareReward = 'weapon_smg'-- rare reward 
Config.RareMin = 1 -- max amount of rare reward you can get
Config.RareMax = 3 -- max amount of rare reward you can get
Config.RareChance = 50 -- chance in % 

Config.ExtraRareReward = 'weapon_assaultrifle'-- rare reward 
Config.ExtraRareMin = 1 -- max amount of rare reward you can get
Config.ExtraRareMax = 2 -- max amount of rare reward you can get
Config.ExtraRareChance = 25 -- chance in % 



-- NPC
Config.SpawnPedOnBlackout = true -- you want peds to spawn after the blackout hack ?
Config.SpawnPedOnHack = true -- you want peds to spawn after the PC hack ?
Config.PedAccuracy = 70 -- how accurate ped is shooting ( 10-100 )
Config.PedGun = 'weapon_assaultrifle' -- weapon ped's use

Config.Shooters = {
    ['soldiers'] = {
        locations = {
            [1] = { -- spawn peds on Blackout
                peds = {vector3(3510.92, 3635.03, 41.47),vector3(3518.2, 3629.81, 41.34),vector3(3515.37, 3642.08, 49.03),vector3(3518.16, 3643.39, 49.1),vector3(3524.15, 3640.33, 49.14),vector3(3538.24, 3636.88, 49.11),vector3(3542.44, 3640.38, 48.99),vector3(3536.12, 3646.14, 41.34),vector3(3546.41, 3643.08, 41.34),vector3(3560.65, 3643.64, 41.34),vector3(3562.35, 3631.78, 42.85),vector3(3548.98, 3639.59, 41.47),vector3(3447.73, 3739.72, 30.51),vector3(3447.21, 3733.01, 30.52),vector3(3442.06, 3723.41, 30.64),vector3(3437.67, 3711.1, 31.65),vector3(3449.94, 3706.59, 31.75),vector3(3465.26, 3709.15, 35.5),vector3(3467.78, 3718.05, 36.64),vector3(3462.01, 3731.44, 36.64),vector3(3485.02, 3730.69, 36.64),vector3(3522.88, 3719.39, 36.64),vector3(3528.11, 3710.95, 36.64)}
            },
            [2] = { -- spawn peds on PC HACK
            peds = {vector3(3529.51, 3657.44, 27.69),vector3(3531.82, 3648.19, 27.52),vector3(3542.47, 3645.82, 28.12),vector3(3549.09, 3652.01, 28.12),vector3(3550.44, 3659.41, 28.12),vector3(3555.15, 3663.0, 28.12),vector3(3556.55, 3676.54, 28.12),vector3(3561.79, 3678.84, 28.12),vector3(3564.42, 3682.8, 28.12),vector3(3564.28, 3692.5, 28.12),vector3(3567.91, 3689.79, 28.12)}
            },
        },
    }
}