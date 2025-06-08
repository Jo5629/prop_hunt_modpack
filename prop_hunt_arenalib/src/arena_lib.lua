arena_lib.register_minigame("prop_hunt", {
    name = "Prop Hunt",
    prefix = "[Prop Hunt] ",
    teams = {
        "Hunters",
        "Props",
    },
    is_team_chat_default = true,
    teams_color_overlay = {
        "red",
        "blue",
    },
    min_players = 1,
    hotbar = {
        slots = 4,
        background_image = "arenalib_gui_hotbar4.png",
    },
    time_mode = "decremental",
    spectate_mode = "blind",
    load_time = 30,
    temp_properties = {
        hunter_huds = {},
        frozen = {},
        started = 0,
    },
    properties = {
        ENABLED_NOISEMAKER = true,
        TIMER_NOISEMAKER = 15,
        ENABLED_RADAR = true,
        RADAR_DISTANCE = 20,
        RADAR_COOLDOWN = 20,
        ENABLED_STUN = true,
        STUN_RADIUS = 5,
        STUN_COOLDOWN = 20,
        STUN_FROZEN = 4,
    },
    in_game_physics = {
        speed_fast = 1,
    },
    celebration_time = 3,
    hud_flags = {minimap = false, basic_debug = false},
    can_drop = false,
    disabled_damage_types = {"fall", "node_damage", "drown"},
})

audio_lib.register_sound("sfx", "noisemaker", "Noisemaker", {gain = 2, max_hear_distance = 20})
audio_lib.register_sound("sfx", "radar_ping", "Radar Ping", {gain = 2})
audio_lib.register_sound("sfx", "taser", "Taser", {gain = 1.25, max_hear_distance = 16})