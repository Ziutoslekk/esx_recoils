Config = {}
Config.Dot = false
Config.Controls = false

Config.Servers = {
    --[[
    {
        name = "EXAMPLE",
        recoil = {
            [`WEAPON_PISTOL`] = {1.0, 1.0}
        },
        effect = {
            [`WEAPON_PISTOL`] = {0.15, 0.15}
        }
    },
    ]]--
    {
        name = "Name #1",
        recoil = {
            [`WEAPON_PISTOL`] = {1.0, 2.5}
        },
        effect = {
            [`WEAPON_PISTOL`] = {0.05, 0.10}
        }
    },
    {
        name = "Name #2",
        recoil = {
            [`WEAPON_PISTOL`] = {3.2, 2.2}
        },
        effect = {
            [`WEAPON_PISTOL`] = {0.15, 0.20}
        }
    },
}
