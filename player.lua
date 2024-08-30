GRAVITY = 5 -- down (positive Y), in px per second squared
player = {
    x = 20, -- left edge, in px
    y = 10, -- top edge, in px
    vy = 0, -- current velocity down, in px per second
    spr = 0,
    width = 6, -- in px
    height = 7, -- in px
    walk_spd = 30, -- side to side, in px per second
    jump_spd = 2, -- up, in px per second
    face_right = true,
    has_milk = false,
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
    -- the sprite positions are always rounded down, adding 0.5 makes them round to nearest integer
    spr(255, player.x + 0.5, player.y + 0.5, player.width / 8, player.height / 8, not player.face_right)

    if player.has_milk then
        spr(251, player.x + 0.5, player.y + 0.5 - 9)
    end
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
            player.x += input.move_x * player.walk_spd * FRAME_TIME
        end

        player.face_right = input.move_x > 0
    end

    -- move player vertically
    local is_on_ground = player_grounded()
    if not is_on_ground then
        player.vy += GRAVITY * FRAME_TIME
    elseif is_on_ground and player.vy > 0 then
        -- set velocity to 0 if falling onto ground
        player.vy = 0
    end

    if is_on_ground and input.jump then
        player.vy = -player.jump_spd
    end

    if debug then
        if is_on_ground then
            print("ground", 0, 96)
        else
            print("air", 0, 96)
        end
        print("x", 0, 104)
        print(player.x, 8, 104)
        print("y", 0, 112)
        print(player.y, 8, 112)
        print("vy", 0, 120)
        print(player.vy, 16, 120)
    end

    -- move in small steps to not end up inside wall
    local move_y = 0
    while abs(move_y) < abs(player.vy) do
    	local step = 0.1 * sgn(player.vy)
    	local stop = false
    	if player.vy < 0 then
    	    -- going up
    	    stop = (player_collision(0, -1) & FLAG_BLOCK_ALL) ~= 0
    	else
    	    -- going down
    	    stop = player_grounded()
    	end
    	if not stop then
    	    player.y += step
    	    move_y += step
    	else
    	    break
    	end
    end

    -- handle level bounds
    if player.x > 127 - (player.width) then
        change_level(true)
    elseif player.x < 1 then
        change_level(false)
    end

    -- process cooldowns
    if day_cooldown > 0 then
        day_cooldown -= FRAME_TIME
    end

    -- save values for next frame
    old_input = input
end

function player_grounded()
    local flags = player_collision(0, 1)
    return (flags & (FLAG_BLOCK_ALL | FLAG_BLOCK_PLATFORM)) ~= 0
end
