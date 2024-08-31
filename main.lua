--Milk Journey

function _init()
    day = true
    set_day(day)
    journey_days = 0
    debug = false
    adjust = 0
    temp_mapx = mapX
    temp_mapy = mapY
end

function _update()
    for obj in all(current_objects) do
        if day == obj.day then
            obj.update(obj);
        end
    end
    player_input()
    update_level()

    if player.y > 130 then
        dead()
    end
end

function _draw()
    if day then
        cls(15)
    else
        cls(0)
    end

    draw_level()
    draw_background()
    -- draw a screen of tiles in map
    map(mapX*16, mapY*16, 0, 0, 16, 16)

    draw_player()

    for obj in all(current_objects) do
        if obj.day == day then
            obj.draw(obj)
        end
    end

    if player.has_key then
        spr(133, 110, 5)
    end
    

    --debug
    --[[print(player.x,10,0)
    print(player.y)
    print(player.has_milk)
    print(adjust)
    print("-----")
    print(mapX)
    print(mapY)
    print(temp_mapx)
    print(temp_mapy)]]--
end
