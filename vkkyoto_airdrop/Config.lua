Config = {}

Config.Blip = { 
    ['airdrops'] = {
        sprite = 550,
        colour = 12,
        alpha  = 250,
        scale  = 0.9,
    }
}

Config.AirDrops = {
    status = true,
    models = { 'p_cargo_chute_s', 'ex_prop_adv_case_sm', 'cuban800', 's_m_m_pilot_02', 'prop_box_wood02a_pu' },
    times = {
        { hour = 15, minute = 10 },
    },
    spawns = {
        vector3(2269.6721191406, 2040.3735351563, 2000.01914978027),
    },
    drop = {
        { item = 'carchest', min = 1, max = 2 },
        { item = 'weaponchest', min = 1, max = 2 },
        { item = 'kawa', min = 200, max = 500 },
    }
}
