level_index = 1

levels = {}
levels[1] = { left_lvl=nil, right_lvl=2, mapX=0, mapY=0,
    spawn_left={x=10, y=20}, spawn_right={x=120, y=32},
    quote="we had to leave\nthe house at dawn"}

levels[2] = { left_lvl=1, right_lvl=3, mapX=1, mapY=0,
    spawn_left={x=1, y=64}, spawn_right={x=120, y=32},
    quote="we had to walk uphill\nall the way"}

levels[3] = { left_lvl=2, right_lvl=nil, mapX=1, mapY=0,
    spawn_left={x=1, y=64}, spawn_right={x=120, y=32},
    quote="the mountains were tall"}

mapX = levels[1].mapX
mapY = levels[1].mapY
quote = levels[1].quote

function change_level(right)
    local old_level_info = levels[level_index]
    if right then
        level_index = old_level_info.right_lvl
    else
        level_index = old_level_info.left_lvl
    end

    local level_info =levels[level_index]
    mapX = level_info.mapX
    mapY = level_info.mapY
    quote = level_info.quote
    local spawn
    if right then
        spawn = level_info.spawn_left
    else
        spawn = level_info.spawn_right
    end
    player.x = spawn.x
    player.y = spawn.y
end

function draw_level()
    local fg = day and 8 or 7
    local bg = day and 15 or 0
    rect(7, 95, 121, 121, fg)
    print('back in my days...', 9, 97, fg)
    print(quote, 12, 103)
end
