mapX = 0
mapY = 0
level_index = 1

levels = {}
levels[1] = { left_lvl=nil, right_lvl=2, mapX=0, mapY=0,
    spawn_left={x=10, y=20}, spawn_right={x=120, y=32}}

levels[2] = { left_lvl=1, right_lvl=nil, mapX=1, mapY=0,
    spawn_left={x=1, y=64}, spawn_right={x=120, y=32}}

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
    local spawn
    if right then
        spawn = level_info.spawn_left
    else
        spawn = level_info.spawn_right
    end
    player.x = spawn.x
    player.y = spawn.y
end
