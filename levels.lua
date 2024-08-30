mapX = 0
mapY = 0

spawn_points = {
    
}

function on_level_change(right)
    if right then
        if mapX < 3 then
            mapX += 1
        else
            mapY += 1
            mapX = 0
        end

        player.x -= 128
    else
        if mapX > 0 then
            mapX -= 1
        else
            mapY -= 1
            mapX = 3
        end
        
        player.x += 128
    end
end