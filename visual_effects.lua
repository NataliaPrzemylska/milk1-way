screen_shake_offset = 0
function screen_shake()
    local fade = 0.95
    local offset_x=16-rnd(32)
    local offset_y=16-rnd(32)
    offset_x*=screen_shake_offset
    offset_y*=screen_shake_offset
    
    camera(offset_x,offset_y)
    screen_shake_offset*=fade
    if screen_shake_offset<0.05 then
        screen_shake_offset=0
    end
end

function make_shake(pwr)
    screen_shake_offset = pwr
end