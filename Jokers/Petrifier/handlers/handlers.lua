-- ============================================================
-- PETRIFIER JOKER - NETWORKING PATCH
-- Instructions: add these three snippets to action_handlers.lua
-- ============================================================


-- SNIPPET 1: Receiver function
-- Add this near the other local action_* functions (e.g. after action_eat_pizza)
-- -----------------------------------------------------------------
local function action_petrifier(count)
	count = tonumber(count)
	if not count or count < 1 then return end

	-- Collect non-Stone cards from the player's deck as candidates
	local candidates = {}
	for _, v in ipairs(G.playing_cards) do
		if v.ability.effect ~= "Stone Card" then
			table.insert(candidates, v)
		end
	end

	-- Pick `count` unique random cards and turn them into Stone cards
	local chosen = {}
	for i = 1, math.min(count, #candidates) do
		local idx = math.random(1, #candidates)
		table.insert(chosen, table.remove(candidates, idx))
	end

	for _, v in ipairs(chosen) do
		G.E_MANAGER:add_event(Event({
			func = function()
				v:set_ability(G.P_CENTERS.m_stone, nil, true)
				v:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end

	-- Juice the phantom joker on your side so the opponent sees it activate
	local phantom = MP.UTILS.get_phantom_joker("j_mp_petrifier")
	if phantom then phantom:juice_up() end
end
-- -----------------------------------------------------------------


-- SNIPPET 2: Sender function
-- Add this near the other MP.ACTIONS functions (e.g. after MP.ACTIONS.eat_pizza)
-- -----------------------------------------------------------------
function MP.ACTIONS.petrifier(count)
	Client.send({
		action = "petrifier",
		count = count,
	})
end
-- -----------------------------------------------------------------


-- SNIPPET 3: Dispatch case
-- Add this inside the big elseif chain in the message handler
-- (e.g. after the "eatPizza" elseif block)
-- -----------------------------------------------------------------
elseif parsedAction.action == "petrifier" then
	action_petrifier(parsedAction.count)
-- -----------------------------------------------------------------
