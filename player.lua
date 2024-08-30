player = {
    x = 20, -- left edge, in px
    y = 10, -- top edge, in px
    spr = 0,
    width = 6, -- in px
    height = 7, -- in px
    spd = 15, -- in px per second
    face_right = true,
}

FRAME_TIME = 1 / 30.0 -- in seconds
animation_speed = 0.5
day_cooldown = 0

function animate_player()
    if player.sp <= 2 then
        player.sp += animation_speed
    else
        player.sp = 0
    end
end

function draw_player()
    spr(255, player.x, player.y, player.width / 8, player.height / 8, not player.face_right)
end

FLAG_BLOCK_PLATFORM = 0x1
FLAG_BLOCK_ALL = 0x2
old_input = {move_x = 0, jump=false, flip=false}

function player_input()
    -- all input actions
    local input = {move_x = 0, jump=false, flip=false}
    if btn(0) then
        input.move_x -= 1
    end
    if btn(1) then
        input.move_x += 1
    end
    input.jump = btn(2) or btn(4)
    input.flip = btn(5)

    -- flip day and night
    if input.flip and (not old_input.flip) and day_cooldown <= 0 then
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

        journey_days += 0.5
    end

    -- move player horizontally
    if input.move_x ~= 0 then
        local collision = player_collision(input.move_x, 0)
        if (collision & FLAG_BLOCK_ALL) == 0 then
            player.x += input.move_x * player.spd * FRAME_TIME
        end

        player.face_right = input.move_x > 0
    end

    -- process cooldowns
    if day_cooldown > 0 then
        day_cooldown -= FRAME_TIME
    end

    -- save values for next frame
    old_input = input
end

function player_collision(dir_x, dir_y)
    OFFSET = 0.3
    local point1 = {}
    local point2 = {}
    if dir_x ~= 0 then
        -- horizontal move
        point1.y = player.y
        point2.y = player.y + player.height
        if dir_x < 0 then
            -- check left
            point1.x = player.x - OFFSET
        else
            -- check right
            point1.x = player.x + (player.width - 1) + OFFSET
        end
        point2.x = point1.x
    else
        -- vertical move
        point1.x = player.x
        point2.x = player.x + player.width
        if dir_y < 0 then
            -- check up
            point1.y = player.y - OFFSET
        else
            -- check down
            point1.y = player.y + (player.height - 1) + OFFSET
        end
        point2.y = point1.y
    end

    -- floor divide by 8 to go from pixel coordinates to map tiles
    -- bitwise OR flags to get all that appear on either point
    local sprite1 = mget(flr(point1.x / 8), flr(point1.y / 8))
    local sprite2 = mget(flr(point2.x / 8), flr(point2.y / 8))
    local flags = fget(sprite1) | fget(sprite2)
    return flags
end
