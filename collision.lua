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

function player_overlap(x, y, width, height)
    if player.x < x + width and
       player.x + player.width > x and
       player.y < y + height and
       player.y + player.height > y then
        return true
    else
        return false
    end
end

function check_sprite(s, sx, sy)
    if s == 35 then -- mine
        
    elseif s == 133 or s == 148 then --key
        mset(sx, sy, 254)
        player.has_key = true

    elseif s == 150 then --door
        mset(sx,sy,134)
        player.has_key = false

    elseif s == 161 or s == 163 or s == 176 or s == 178 then --spikes
        dead()
    end
end