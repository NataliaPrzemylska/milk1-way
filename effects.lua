epic_animation_frame = 0
function draw_flash_effect()
    if epic_animation_frame == 1 then
        if flash == FLASH_ENABLED then
            cls(7)
        end
        epic_animation_frame = 0
    end
end