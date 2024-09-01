function music_day()
    music(-1)
    music(2, 0, 2)
end

function music_night()
    music(-1)
    music(15, 0, 2)
end

function  music_change_to_day()
    music(-1)
    music(24, 0, 2)
end

function music_change_to_night()
    music(-1)
    music(26, 0, 2)
end

function sfx_death()
    sfx(17,3)
end

function sfx_jump_day()
    sfx(18,3)
end

function sfx_jump_night()
    sfx(19,3)
end

function sfx_boom()
    music(0, 0, 3)
end

function main_menu_music()
    music(-1)
    music(30, 0, 1)
end

function cow_music()
    music(-1)
    music(38)
end