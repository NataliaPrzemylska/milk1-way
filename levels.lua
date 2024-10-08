level_index = 1

levels = {}
levels[1] = { left_lvl=nil, right_lvl=2, mapX=0, mapY=0,
    spawn_left={x=100, y=20}, spawn_right={x=120, y=40},
    quote="back in my days\nwe had to leave\nthe house at dawn"}

levels[2] = { left_lvl=1, right_lvl=3, mapX=1, mapY=0,
    spawn_left={x=1, y=40}, spawn_right={x=120, y=80},
    quote="back in my days\nwe had to wait until\nnighttime to cross the road\n(press x)",
    dynamic_objects={car}}

levels[3] = { left_lvl=2, right_lvl=4, mapX=2, mapY=0,
    spawn_left={x=1, y=80}, spawn_right={x=120, y=16},
    quote="back in my days\nwe had to do parkour\non our way to school"}

levels[4] = { left_lvl=3, right_lvl=10 , mapX=3, mapY=0,
    spawn_left={x=1, y=16}, spawn_right={x=120,y=56},
    quote="back in my days\nwe milked the cows ourselves",
    cow_location={x=64, y=49, width=8, height=8}}

levels[5] = { left_lvl=6, right_lvl=4, mapX=4, mapY=0,
    spawn_left={x=1, y=80}, spawn_right={x=118, y=16},
    quote="back in my days\nwe had to fight orcs\nto survive"}

levels[6] = { left_lvl=7, right_lvl=5, mapX=5, mapY=0,
    spawn_left={x=1, y=30}, spawn_right={x=118, y=80},
    quote="back in my days\nwe had to have keys\nto keep going"}

levels[7] = { left_lvl=8, right_lvl=6, mapX=6, mapY=0,
    spawn_left={x=1, y=72}, spawn_right={x=118, y=30},
    quote="back in my days\nwe had to venture deep\n into the caves"}

levels[8] = { left_lvl=9, right_lvl=7, mapX=7, mapY=0,
    spawn_left={x=1, y=32}, spawn_right={x=118, y=80},
    quote="back in my days\nwe commited sacrifices\nto impress our wifes"}

levels[9] = { left_lvl=1, right_lvl=8, mapX=0, mapY=1,
    spawn_left={x=1, y=80}, spawn_right={x=118, y=24},
    quote="and the hills\nwere *really* tall"}

--secret level
levels[10] = { left_lvl=4, right_lvl=nil, mapX=2, mapY=1,
    spawn_left={x=1, y=48}, spawn_right={x=118, y=24},
    quote="and we even brought\nadditional things\nwithout being asked"}
-----

quote = levels[1].quote
cow_location = nil

function change_level(right) 
    if level_index == 4 then
        music(-1)
    end
    local old_level_info = levels[level_index]
    if (right==false) and (old_level_info.left_lvl==1) and player.has_milk then
        state = STATE_DIALOGUE_END
        return
    end
    if right then
        level_index = old_level_info.right_lvl
    else
        level_index = old_level_info.left_lvl
    end

    if level_index == 4 then
        music(-1)
        music(38, 0, 2)
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
    if spawn == nil then
        player.x = 10
        player.y = 30
    else
        player.x = spawn.x
        player.y = spawn.y
    end

    adjust_platforms()

    spawn_dynamic_objects()
end

-- reconfigure the game for >>>comeback<<<
function get_milk()
    player.has_milk = true
    sfx_jump_day()

    fset(106,1,false)
    fset(122,1,false)

    levels[4].left_lvl = 5
    levels[1].right_lvl = 9

    levels[1].quote = "and this is how i got\nthe fresh milk for us"
    quote = levels[level_index].quote

    --mset(8, 3, 66)

    --unlock secret level
    fset(101,3, true)
    fset(101,1, false)
    fset(101,2, false)
end

function adjust_platforms()
    --Changing day/night dependent objects
    for i=16*mapX, 16*mapX+16 do
        for j=16*mapY, 16*mapY+16 do
            local map_tile = mget(i,j)
            if fget(map_tile, 2) then
                if map_tile % 2 == 0 and day then
                    mset(i,j,map_tile+1)
                elseif map_tile % 2 != 0 and not day then
                    mset(i,j,map_tile-1)
                end
            end
        end
    end
end
function spawn_dynamic_objects()
    for i in pairs (current_objects) do
        current_objects [i] = nil
    end
    if levels[level_index].dynamic_objects ~= nil then
        for index, value in ipairs(levels[level_index].dynamic_objects) do
            current_objects[index] = value
        end
    end
end

function draw_level()
    local fg = 7
    local bg = 0
    rect(7, 97, 121, 123, fg)
    print(quote, 9, 99, fg)
end

function update_level()
    if cow_location and not player.has_milk then
        if player_overlap(cow_location.x, cow_location.y,
            cow_location.width, cow_location.height) then
            get_milk()
        end
    end

    if changing_now then
        sun_position += FRAME_TIME / change_time
        if sun_position >= 1 then
            day = not day
            set_day(day)
            changed_day = true
            sun_position = 0

            
        elseif changed_day and sun_position >= stop_position then
            changing_now = false
        end
    end
end

changing_now = false
changed_day = false
stop_position = 0.75 -- part of day
sun_position = stop_position
change_time = 2.0 -- in seconds
function start_day_change()
    if changing_now then
        return false
    end

    changed_day = false
    changing_now = true

    return true
end

function set_day(day_now)
    if day_now then
        pal(8,8)
        pal(9,9)
        pal(6,6)
        pal(3,8)
        pal(11,9)
        pal(5,6)
    else
        pal(3,3)
        pal(11,11)
        pal(5,5)
        pal(8,3)
        pal(9,11)
        pal(6,5)
    end
end

function draw_background()
    local width = 16
    local height = 16
    -- pico has inverted sin output
    local x = sun_position * (128 - width)
    local y = 32 * (1 + sin(sun_position / 2))

    spr(day and 130 or 128, x, y, width / 8, height / 8)
end
