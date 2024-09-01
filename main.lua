--Milk1 Way
STATE_MENU = 0
STATE_GAME = 1
FLASH_UNKNOWN = 0
FLASH_ENABLED = 1
FLASH_DISABLED = 2
current_frame = 0
frame = 0
function _init()
    mapX = 7
    mapY = 1
    day = true
    set_day(day)
    journey_days = 0
    debug = false
    state = STATE_MENU
    temp_mapx = mapX
    temp_mapy = mapY
    exploded = 0
    flash = FLASH_UNKNOWN
end

function _update()
    if state == STATE_MENU then
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
                state = STATE_GAME
                mapX = 0
                mapY = 0
                frame = 0
            end
        end
    elseif state == STATE_GAME then
        for obj in all(current_objects) do
            if day == obj.day then
                obj.update(obj);
            end
        end
        if frame>=10 then
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
        map(mapX*16, mapY*16, 0, 0, 16, 16)
        print("milk1 way", 20, 30)
        if flash == FLASH_UNKNOWN then
            rectfill(10, 32, 118, 92, 0)
            rect(10, 32, 118, 92, 7)
            print("warning\nTHIS GAME CONTAINS\nFLASHING EFFECTS.\nPRESS x TO\n DISABLE FLASH\nPRESS z/O TO\n ENABLE FLASh", 20, 42, 7)
        end
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
            print(player.x,10,0)
            print(player.y)
            
        end
    end
    current_frame+=1
    frame += 1
end
