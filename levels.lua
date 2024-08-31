level_index = 1

levels = {}
levels[1] = { left_lvl=nil, right_lvl=2, mapX=0, mapY=0,
    spawn_left={x=10, y=20}, spawn_right={x=120, y=32},
    quote="back in my days\nwe had to leave\nthe house at dawn"}

levels[2] = { left_lvl=1, right_lvl=3, mapX=1, mapY=0,
    spawn_left={x=1, y=64}, spawn_right={x=120, y=16},
    quote="back in my days\nwe had to walk uphill\nall the way"}

levels[3] = { left_lvl=2, right_lvl=4, mapX=1, mapY=0,
    spawn_left={x=1, y=64}, spawn_right={x=120, y=16},
    quote="and the hills\nwere *really* tall"}

levels[4] = { left_lvl=3, right_lvl=nil, mapX=2, mapY=0,
    spawn_left={x=1, y=64}, spawn_right=nil,
    quote="but I finally found the cow",
    cow_location={x=64, y=32, width=8, height=8}}

mapX = levels[1].mapX
mapY = levels[1].mapY
quote = levels[1].quote
cow_location = nil

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
    cow_location = level_info.cow_location
    local spawn
    if right then
        spawn = level_info.spawn_left
    else
        spawn = level_info.spawn_right
    end
    player.x = spawn.x
    player.y = spawn.y
end

-- reconfigure the game for >>>comeback<<<
function get_milk()
    player.has_milk = true

    levels[4].quote = "back in my days\nwe milked the cows ourselves"
    levels[1].quote = "and this is how I got\nthe fresh milk for us"
    quote = levels[level_index].quote

    levels[4].left_lvl = 1

    mset(8, 3, 66)
end

function draw_level()
    local fg = day and 8 or 7
    local bg = day and 15 or 0
    rect(7, 95, 121, 121, fg)
    print(quote, 9, 97, fg)
end

function update_level()
    if cow_location and not player.has_milk then
        if player_overlap(cow_location.x, cow_location.y,
            cow_location.width, cow_location.height) then
            get_milk()
        end
    end
end
