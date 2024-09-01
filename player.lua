GRAVITY = 5 -- down (positive Y), in px per second squared
player = {
    x = 70, -- left edge, in px
    y = 81, -- top edge, in px
    vy = 0, -- current velocity down, in px per second
    width = 6, -- in px
    height = 7, -- in px
    walk_spd = 30, -- side to side, in px per second
    jump_spd = 2.5, -- up, in px per second
    face_right = true,
    has_milk = false,
    has_key = false,
    current_sprite = 0,
    animation_index = 1,
    dead_animation_index = 0,
}

ANIM = {
    -- repeat the animations to have the same lenght for simplicity
    walk = {0, 1, 2, 0, 1, 2},
    idle = {0, 0, 0, 5, 5, 5},
    LEN = 6,
    air_up = 3,
    air_down = 4,
    falling = 16,
    laying = 17
}

FRAME_TIME = 1 / 30.0 -- in seconds
day_cooldown = 0

function animate_player(walking, in_air)
    if player.dead_animation_index ~= 0 then
        player.dead_animation_index+=1
        if player.dead_animation_index < 10 then
            player.current_sprite = ANIM.falling
        elseif player.dead_animation_index == 60 then
            player.current_sprite = ANIM.laying
            player.dead_animation_index = 0
            respawn()
        else
            player.current_sprite = ANIM.laying
        end
    else
    -- show the frame from correct animation
        if in_air then
            if walking then
                player.current_sprite = player.vy < 0 and ANIM.air_up or ANIM.air_down
            else
                player.current_sprite = player.vy < 0 and 5 or 0
            end
        else
            player.current_sprite = (walking and ANIM.walk or ANIM.idle)[flr(player.animation_index)]
        end 
    end


    -- move the counter forward and loop it
    local animation_speed = walking and 0.5 or 0.125
    player.animation_index += animation_speed
    if flr(player.animation_index) >= ANIM.LEN + 1 then
        player.animation_index -= ANIM.LEN
    end
end

function draw_player()
    local height_change = 1
    -- the sprite positions are always rounded down, adding 0.5 makes them round to nearest integer
    spr(player.current_sprite, player.x + 0.5, player.y + 0.5 - height_change,
        player.width / 8, (player.height + height_change) / 8, not player.face_right)

    if player.has_milk then
        spr(8, player.x + 0.5, player.y + 0.5 - 10)
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
    if input.flip and (not old_input.flip) then
        if start_day_change() then
            if day then
                music_change_to_night()
            else
                music_change_to_day()
            end
            journey_days += 0.5
            adjust_platforms()
            
        end
    end


    -- move player horizontally (if the player isn't dead)
    if input.move_x ~= 0 and player.dead_animation_index == 0 then
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

    if is_on_ground and input.jump and player.dead_animation_index == 0 then -- if the player isn't dead
        player.vy = -player.jump_spd
        if day then
            sfx_jump_day()
        else
            sfx_jump_night()
        end
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

    animate_player(input.move_x ~= 0, not is_on_ground)

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


function respawn()
    if player.has_milk then
        player.x = levels[level_index].spawn_right.x
        player.y = levels[level_index].spawn_right.y
    else
        player.x = levels[level_index].spawn_left.x
        player.y = levels[level_index].spawn_left.y
    end
    
end
function dead()
    if player.dead_animation_index==0 then
        sfx_death()
        if epic_animation_frame == 0 then
            epic_animation_frame = 1
        end
        player.dead_animation_index = 1
    end
end