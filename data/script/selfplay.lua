-- Written by Gann4Life (ign: mega34)

--                                  Changelog

-- SelfPlay v2.1
-- * Added on_unload hook, no restart required anymore to on_unload the script.
-- * Added and improved GUI:
    -- * Name of the player's turn is displayed on screen
    -- * Remaining turns are displayed on screen
    -- * Game progress is displayed on screen
    -- * Remaining rounds are displayed on screen
-- SelfPlay v2.0
-- * Added multiple player support.
-- * Removed ingame GUI.
-- * Updated core functions.

-- ACLARATIONS (SelfPlay dictionary just in case)
-- TURNS: Stands for every player turn.
-- ROUNDS: Stands for the event where ALL players finish their turn.

local window_width, window_height = get_window_size()

local SCRIPT_AUTHOR = "Gann4Life"
local SCRIPT_VERSION = "2.1"
local player = 0
local round_count = 0
local turn_count = 0


-- Executes when the script is loaded
local function init()
    print_msg("SelfPlay v" .. SCRIPT_VERSION .. " written by " .. SCRIPT_AUTHOR)
    print_msg("Press 'Q' to quickly switch between players.")
    print_msg("Press number '6' to prevent focus on all players at the same time.")
end

-- Reset variables once a new match starts
local function on_match_begin()
    refresh_script()
    select_player(player)
end

-- Recieves the user input
local function on_key_up(key)
    if key == string.byte(' ') then
        next_player_turn()
        if player ~= 0 then 
            return 1
        end
    elseif key == string.byte('q') then
        next_player_turn()
    end
end

-- GUI Drawing
local function on_draw_gui()

    local player_section = get_current_turn_playername() .. "'s turn."
    local turn_section = get_remaining_turns() .. " turns left."
    local progress_section = get_turn_progress() .. "% done."

    set_color(0, 0, 0, 1)
    draw_centered_text(player_section .. " - " .. turn_section .. " - " .. progress_section, 75, FONTS.SMALL)
end

-- Remove all hooks
local function on_unload()
    remove_hook("match_begin", "match_begin")
    remove_hook("key_up", "on_key_up")
    remove_hook("unload", "on_unload")
    remove_hook("draw2d", "on_draw_gui")
    remove_hook("end_game")
	print_msg("Script unloaded.")
end

-- Applies the turn, and decide if the turn should be actually applied or not based on the players turn queue
function next_player_turn()
    -- Prevent replay from edit mode
    if get_world_state()["replay_mode"] == 1 then 
        return 1 
    end

    select_next_player()
    on_finish_turn()
    
    set_ghost(2) -- Show ghost properly (May change user preferences, something unwanted.)
end

-- Makes the camera look towards the next player on the list
function select_next_player()
    if player < get_total_players() - 1 then 
        player = player + 1
    else 
        player = 0
        on_finish_round()
    end

    select_player(player) 
end

-- Executed when ALL players finish their turn
function on_finish_round()
    round_count = round_count + 1
    UIElement:runCmd("cp Round " .. get_remaining_rounds() .. " of " .. get_total_rounds())
end

-- Executed when a player finishes his turn
function on_finish_turn()
    turn_count = turn_count + 1
end

-- Reloads all required variables for starting a new match
function refresh_script()
    player = 0
    round_count = 0
    turn_count = 0
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

-- Returns the player name by index
function get_player_name(index)
    for key, value in pairs(get_player_info(index)) do 
            if key == "name" then 
                return value 
            end
    end
end

-- Returns the value of the gamerule "numplayers"
function get_total_players()
    return get_gamerule("numplayers")
end

-- Returns the name of the player that is currently using its turn.
function get_current_turn_playername()
    return get_player_name(player)
end

-- Returns the total rounds the match requires to be finished
function get_total_rounds()
    local matchframes = get_gamerule("matchframes")
    local turnframes = get_gamerule("turnframes")
    return math.floor(matchframes / turnframes)
end

-- Returns the remaining rounds to finish the game
function get_remaining_rounds()
    return get_total_rounds() - round_count
end

-- Returns the total amount of turns based on the amount of players and total rounds
function get_total_turns()
    return get_total_rounds() * get_total_players()
end

-- Returns the amount of turns remaining to finis the match based on the amount of players and rounds left
function get_remaining_turns()
    return get_total_turns() - turn_count
end

-- Returns the round progress in a value between 0 and 100 (as percentage)
function get_round_progress()
    return math.floor(round_count / get_total_rounds()*100)
end

-- Returns the turn progress in a value between 0 and 100 (as percentage)
function get_turn_progress()
    return math.floor(turn_count / get_total_turns()*100)
end

add_hook("match_begin", "match_begin", on_match_begin)
add_hook("key_up", "on_key_up", on_key_up)
add_hook("unload", "on_unload", on_unload)
add_hook("draw2d", "on_draw_gui", on_draw_gui)
add_hook("end_game", "end_game", refresh_script)

init()