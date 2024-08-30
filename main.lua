--Milk Journey

function _init()
    day = true
    journey_days = 0
    debug = false
end

function _update()
    for obj in all(current_objects) do
        if obj.spd != nil then
            obj.x += obj.spd
        end
    end
    player_input()
end

function _draw()
    if day then
        cls(15)
    else
        cls(0)
    end
    draw_player()

    -- draw a screen of tiles in map
    map(mapX*16, mapY*16, 0, 0, 16, 16)

    for obj in all(current_objects) do
        if obj.day == day then
            obj.draw(obj)
        end
    end
    draw_level()
end
