--Milk1 Way
STATE_MENU = 0
STATE_GAME = 1
STATE_DIALOGUE_START = 2 -- dialogue on the start
STATE_DIALOGUE_END = 3 -- dialogue on the end
STATE_CREDITS = 4
FLASH_UNKNOWN = 0
FLASH_ENABLED = 1
FLASH_DISABLED = 2
current_frame = 0
frame = 0
dialogue_frame = 0
state = STATE_MENU
journey_days = 0
function _init()
    mapX = 7
    mapY = 1
    day = true
    set_day(day)
    debug = false
    temp_mapx = mapX
    temp_mapy = mapY
    exploded = 0
    flash = FLASH_UNKNOWN
end

function _update()
    if state == STATE_MENU then
        if stat(46) < 0 and stat(48) < 0 then
            main_menu_music()
        end

        if flash == FLASH_UNKNOWN then
            if btnp(4) then
                flash = FLASH_ENABLED  
                frame = 0
                
            end
            if btnp(5) then
                flash = FLASH_DISABLED  
                frame = 0              
            end
        else
            if (btnp(0) or btnp(1) or btnp(2) or btnp(3) or btnp(4) or btnp(5)) and frame>=10 then
                state = STATE_DIALOGUE_START
                mapX = 0
                mapY = 0
                frame = 0
                music(-1)
            end
        end
    elseif state == STATE_DIALOGUE_START then
        update_start_dialogue()
    elseif state == STATE_DIALOGUE_END then
        update_final_dialogue()
    elseif state == STATE_GAME then
        if stat(46) < 0 and stat(48) < 0 then
            if level_index != 4  then
                if day then
                    music_day()
                else
                    music_night()
                end
            else
                cow_music()
            end
        end
 
        for obj in all(current_objects) do
            if day == obj.day then
                obj.update(obj);
            end
        end
        if frame>=10 and dialogue_frame == 0 then
            player_input()
        end
        update_level()

        if player.y > 130 then
            dead()
        end
    end
end
function _draw()
    if state == STATE_MENU then
        cls(0)
        --draw_background()
        map(16, 12, 0, 0, 16, 16)
        spr(32, 11, 72, 2, 1)
        print("milk1 way", 20, 30)
        if flash == FLASH_UNKNOWN then
            rectfill(10, 32, 118, 92, 0)
            rect(10, 32, 118, 92, 7)
            print("warning\nTHIS GAME CONTAINS\nFLASHING EFFECTS.\nPRESS x TO\n DISABLE FLASH\nPRESS z/O TO\n ENABLE FLASh", 20, 42, 7)
        end
    elseif state == STATE_DIALOGUE_START then
        draw_start_dialogue()
    elseif state == STATE_DIALOGUE_END then
        draw_final_dialogue()
    elseif state == STATE_CREDITS then
        cls(0)
        print("the end\n\n\nmade by:\n rezlfiction\n volfie\n natsue\n pilot", 30, 40, 7)
    elseif state == STATE_GAME then
        adjust_platforms()
        cls(0)

        draw_background()
        -- draw a screen of tiles in map
        map(mapX*16, mapY*16, 0, 0, 16, 12)

        draw_player()

        for obj in all(current_objects) do
            if obj.day == day then
                obj.draw(obj)
            end
        end

        if player.has_key then
            spr(133, 110, 5)
        end
        
        draw_level()
        if epic_animation_frame != 0 then
            draw_flash_effect()
        end
        

        --debug
        if debug then
            print(player.x,0,10,7)
            print(player.y,0,20,7)
            print(stat(46),0,30,7)
            print(stat(48),0,30,7)
            
        end
    end
    current_frame+=1
    frame += 1
end
