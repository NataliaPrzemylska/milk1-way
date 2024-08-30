--Milk Journey

function _init()
    day = true
end

function _update()

end

function _draw()
    if day then
        cls(15)
    else
        cls(0)
    end
    draw_player()
    player_input()
end
