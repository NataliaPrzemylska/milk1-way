function player_collision(dir_x, dir_y)
    OFFSET = 0.1
    local point1 = {}
    local point2 = {}
    if dir_x ~= 0 then
        -- horizontal move
        point1.y = player.y
        point2.y = player.y + player.height - 1
        if dir_x < 0 then
            -- check left
            point1.x = player.x - OFFSET
        else
            -- check right
            point1.x = player.x + player.width + OFFSET
        end
        point2.x = point1.x
    else
        -- vertical move
        point1.x = player.x
        point2.x = player.x + player.width - 1
        if dir_y < 0 then
            -- check up
            point1.y = player.y - OFFSET
        else
            -- check down
            point1.y = player.y + player.height + OFFSET
        end
        point2.y = point1.y
    end

    -- floor divide by 8 to go from pixel coordinates to map tiles
    -- bitwise OR flags to get all that appear on either point
    local sprite1 = mget(mapX*16 + flr(point1.x / 8), mapY*16 + flr(point1.y / 8))
    local sprite2 = mget(mapX*16 + flr(point2.x / 8), mapY*16 + flr(point2.y / 8))
    local flags = fget(sprite1) | fget(sprite2)
    return flags
end
