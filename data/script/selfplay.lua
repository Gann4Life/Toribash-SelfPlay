-- Written by Gann4Life (ign: mega34)

local player = 0
-- local currentTurn = 0


local function printHelp()
    echo("[SelfPlay] Press 'Q' to quickly switch between players.")
end

local function switchPlayer()
    -- Prevent replay from edit mode
    if get_world_state()["replay_mode"] == 1 then return 1 end
    
    -- Choose a player
    if player == 0 then player = 1
    else player = 0 end

    -- Look at player
    select_player(player) 

    -- Show ghost properly (May change user preferences, something unwanted.)
    set_ghost(2)
end

-- Reset variables once a new match starts
local function match_begin()
    player = 0
    currentTurn = 0
    select_player(player)
end


-- Executed when both players finish the turn
local function OnTurnFinished()
    -- // Disabled because "run_cmd" prints output to chat. If it is possible to prevent echoes, this will come back.
    -- currentTurn = currentTurn + 1
    -- run_cmd("cp Turn N°" .. currentTurn)
end

local function key_up(key)
    if key == string.byte(' ') then

        switchPlayer()
        if player == 0 then 
            OnTurnFinished()
        elseif player == 1 then
            if get_world_state()["replay_mode"] == 0 then
                return 1 
            end
        end

    elseif key == string.byte('q') then

        switchPlayer()

    end
    -- 54 (Key 6) Zoom tori
    -- 55 (Key 7) Zoom uke
end

local function draw_tooltip()
    local w, h = get_window_size()

    if player == 0 then         -- Tori turn tooltip
        set_color(1, 0, 0, 0.4)
        draw_quad(w-200, 100, 200, 25)

        set_color(1, 1, 1, 1)
        draw_text("Is taking the current turn.", w-200+10, 105)

    elseif player == 1 then     -- Uke turn tooltip
        set_color(1, 0, 0, 0.4)
        draw_quad(0, 100, 200, 25)

        set_color(1, 1, 1, 1)
        draw_text("Is taking the current turn.", 10, 105)

    end
end

add_hook("match_begin", "", match_begin)
add_hook("key_up", "", key_up)
add_hook("draw2d", "tooltip", draw_tooltip)

printHelp()