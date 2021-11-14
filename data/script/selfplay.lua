-- Written by Gann4Life (ign: mega34)

--                                  Changelog
-- SelfPlay v2.0
-- * Added unload hook, no restart required anymore to unload the script.
-- * Added a bit more of documentation.
-- * Added four player support.
-- * Tweaked few functionality for making it more flexible and dynamic.

local script_author = "Gann4Life"
local script_version = "2.0"
local player = 0
-- local currentTurn = 0


-- Executes when the script is loaded
function init()
    print_msg("SelfPlay v" .. script_version .. " written by " .. script_author)
    print_msg("Press 'Q' to quickly switch between players.")
    print_msg("Press number '6' to prevent focus on all players at the same time.")
end

-- Reset variables once a new match starts
function on_match_begin()
    player = 0
    -- currentTurn = 0
    
    select_player(player)

    
end

-- Recieves the user input
function key_up(key)
    if key == string.byte(' ') then
        next_player_turn()
        if player ~= 0 then 
            return 1
        end
    elseif key == string.byte('q') then
        next_player_turn()
    end
end

-- Applies the turn, and decide if the turn should be actually applied or not based on the players turn queue
function next_player_turn()
    -- Prevent replay from edit mode
    if get_world_state()["replay_mode"] == 1 then 
        return 1 
    end

    select_next_player()
    
    set_ghost(2) -- Show ghost properly (May change user preferences, something unwanted.)
end

-- Makes the camera look towards the next player on the list
function select_next_player()
    if player < get_gamerule("numplayers") - 1 then 
        player = player + 1
    else 
        player = 0
        on_finish_turn()
    end

    select_player(player) 
end

-- Executed when all players finish the turn
function on_finish_turn()
    -- Disabled because "run_cmd" prints output to chat. If it is possible to prevent echoes, this will come back.
    -- currentTurn = currentTurn + 1
    -- run_cmd("cp Turn N°" .. currentTurn)
end

-- Prints a message with the SelfPlay syntax
function print_msg(message)
    echo("[SelfPlay] " .. message)
end

-- Returns the value from a specific gamerule name
function get_gamerule(gamerule)
    for key, value in pairs(get_game_rules()) do
        if key == gamerule then
            return value
        end
    end
end

-- Unloads the script
function unload()
	print_msg("Script unloaded.")
end


add_hook("match_begin", "", on_match_begin)
add_hook("key_up", "", key_up)
add_hook("unload", "", unload)

init()