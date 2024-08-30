--Milk Journey

function _init()
    day = true
end

function _update()
    for i in current_objects do
        if i.spd != nil then
            i.x += i.spd
        end
    end
end

function _draw()
    if day then
        cls(15)
    else
        cls(0)
    end
    draw_player()
    player_input()

    for i in current_objects do
        if i.day == day then
            i.draw(i)
        end
    end
end
