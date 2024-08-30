player = {
    x = 10,
    y = 10,
    spr = 0,
    width = 6,
    height = 7,
    spd = 10,
    face_right = true,
}

animation_speed = 0.5
day_cooldown = 0
day_button = 0

function animate_player()
    if player.sp <= 2 then
        player.sp += animation_speed
    else
        player.sp = 0
    end
end

function draw_player()
    spr(255, player.x, player.y, 1, 1, not player.face_right)
end

function player_input()
    if btn(0) then
        player.x -= player.spd
    elseif btn(1) then
        player.x += player.spd
    elseif btn(2) or btn(4) then
        --jump
    end

    if btn(5) and day_cooldown <= 0 and day_button == 0 then
        day = not day

        if day then
            pal(8,8)
            pal(9,9)
            pal(3,8)
            pal(11,9)
        else
            pal(3,3)
            pal(11,11)
            pal(8,3)
            pal(9,11)
        end
        
        day_cooldown = 0.3
        day_button = 1
    end

    if not btn(5) then
        day_button = 0
    end

    if day_cooldown > 0 then
        day_cooldown -= 0.03
    end
end

function player_collision(dir_x, dir_y)
    local point1 = {}
    local point2 = {}
    if dir_x ~= 0 then
        -- horizontal move
        point1.y = player.y
        point2.y = player.y + player.height
        if dir_x < 0 then
            -- check left
            point1.x = player.x - 1
        else
            -- check right
            point1.x = player.x + player.width + 1
        end
        point2.x = point1.x
    else
        -- vertical move
        point1.x = player.x
        point2.x = player.x + player.width
        if dir_y < 0 then
            -- check up
            point1.y = player.y - 1
        else
            -- check down
            point1.y = player.y + player.height + 1
        end
        point2.y = point1.y
    end

    -- floor divide by 8 to go from pixel coordinates to map tiles
    -- bitwise OR flags to get all that appeared anywhere
    local flags = fget(mget(point1.x // 8, point1.y // 8))
                | fget(mget(point2.x // 8, point2.y // 8))
    return flags
end
