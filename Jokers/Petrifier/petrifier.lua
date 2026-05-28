SMODS.Atlas({
	key = "petrifier",
	path = "j_petrifier.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "petrifier",
	atlas = "petrifier",
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { min_stones = 1, max_stones = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.min_stones, card.ability.extra.max_stones } }
	end,
	mp_include = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers
	end,
	calculate = function(self, card, context)
		if context.mp_end_of_pvp and (not card.edition or card.edition.type ~= "mp_phantom") then
			local count = math.random(card.ability.extra.min_stones, card.ability.extra.max_stones)
			MP.ACTIONS.petrifier(count)
			return {
				message = localize("k_whoa_ex"),
				colour = G.C.GREY,
			}
		end
	end,
	add_to_deck = function(self, card, from_debuffed)
		if not from_debuffed and (not card.edition or card.edition.type ~= "mp_phantom") then
			MP.ACTIONS.send_phantom("j_mp_petrifier")
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and (not card.edition or card.edition.type ~= "mp_phantom") then
			MP.ACTIONS.remove_phantom("j_mp_petrifier")
		end
	end,
	mp_credits = {
		idea = { "Adahii" },
		art = { "Adahii" },
		code = { "Adahii" },
	},
})
