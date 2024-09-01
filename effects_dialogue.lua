epic_animation_frame = 0
function draw_flash_effect()
    if epic_animation_frame == 1 then
        if flash == FLASH_ENABLED then
            cls(7)
        end
        epic_animation_frame = 0
    end
end
current_frame_of_animation = 0 --number of frames that passed since last change of shown dialogue
current_point = 1 -- shown dialogue
start_dialogue = {"my dear,", "do NOT come back", "without milk"}
function update_start_dialogue()
    if (current_point == 1) and (current_frame_of_animation<=10) then 
        return
    end
    if current_frame_of_animation >= #(start_dialogue[current_point]) then
        if btnp(0) or btnp(1) or btnp(2) or btnp(3) or btnp(4) or btnp(5) then
            current_point+=1
            if current_point > #start_dialogue then
                state = STATE_GAME
                current_point = 1
            end
            current_frame_of_animation = 0
        end
    end
end
function draw_start_dialogue()
    mapX = 0
    mapY = 0
    
    cls(0)
    
    draw_background()
    -- draw a screen of tiles in map
    map(mapX*16, mapY*16, 0, 0, 16, 12)
    
    draw_player()
    adjust_platforms()
    print(start_dialogue[current_point], 50, 30, 6)
    current_frame_of_animation +=1
end