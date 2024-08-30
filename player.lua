player = {
    x = 10,
    y = 10,
    sp = 0,
    width = 6,
    height = 7,
}

animation_speed = 0.5

function animate_player()
    if player.sp <= 3 then
        player.sp += animation_speed
    else
        player.sp = 0
    end
end

function draw_player()
    spr(255, player.x, player.y)
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
