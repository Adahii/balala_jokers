SMODS.Atlas({
	key = "gambler",
	path = "j_gambler.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "gambler",
	atlas = "gambler",
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = { extra = { xmult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		-- Apply accumulated total as xmult during scoring
		if context.cardarea == G.jokers and context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end

		-- Roll when the Boss Blind is defeated (end_of_round fires after blind_states.Boss = 'Defeated')
		if
			context.end_of_round
			and context.game_over == false
			and context.main_eval
			and not context.blueprint
			and context.beat_boss
		then
			local roll = math.random(0, 4)
			card.ability.extra.xmult = card.ability.extra.xmult + roll
			if roll > 0 then
				return {
					message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
					colour = G.C.MULT,
				}
			else
				return {
					message = localize("k_nope_ex"),
					colour = G.C.RED,
				}
			end
		end
	end,
	mp_credits = {
		idea = { "Adahii" },
		art = { "Adahii" },
		code = { "Adahii" },
	},
})
