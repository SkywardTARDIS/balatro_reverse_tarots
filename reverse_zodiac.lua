SMODS.UndiscoveredSprite {
    key = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 0, y = 0} 
}

SMODS.Tag{
    key = "polaris",
    atlas = "Reverse_Tags",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Polaris Tag",
        text={
            "Gives a free",
            "{C:reverse_zodiac}Mega Astrology Pack",
        }
    },
    apply = function(self, tag, context)
        tag:yep('+', G.C.PURPLE,function() 
            local key = 'p_reverse_zodiac_4'
            local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
            G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
            card.cost = 0
            card.from_tag = true
            G.FUNCS.use_card({config = {ref_table = card}})
            card:start_materialize()
            --G.CONTROLLER.locks[lock] = nil
            return true
        end)
        tag.triggered = true
        return true
    end
}

SMODS.ConsumableType {
    key = "reverse_zodiac",
    primary_colour = HEX("C61CBB"),
    secondary_colour = HEX("96108D"),
    loc_txt = {
        name = "Zodiac",
        collection = "Zodiac Cards"
    },
    collection_rows = {7, 6},
    shop_rate = 0,
    default = "c_reverse_aquarius",
}

SMODS.PokerHand {
    key = "parity",
    mult = 2,
    chips = 25,
    l_mult = 2,
    l_chips = 25,
    visible = true,
    above_hand = "Two Pair",
    example = {
        {'D_T', true},
        {'C_8', true},
        {'C_6', true},
        {'S_2', true},
        {'H_2', true}
    },
    loc_txt = {
        name = "Parity",
        description = {
            "Play five cards that are either all even or all odd",
            "(excludes face cards)"
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    evaluate = function(parts, hand)
        local four = next(find_joker("Four Fingers")) and 1 or 0
        subhand = {}
        if #hand >= 5 - four then
            if hand[1].base.id then
                local parity = hand[1].base.id % 2
                if hand[1].base.id == 14 then parity = 1 end
                for i=1, #hand, 1 do
                    if hand[i]:is_face() or SMODS.has_enhancement(hand[i], "m_stone") or SMODS.has_enhancement(hand[i], "m_reverse_marble") then
                        --return {}
                    elseif hand[i].base.id and (hand[i].base.id % 2 ~= parity and not (hand[i].base.id == 14 and parity == 1)) then
                        --return {}
                    else
                        subhand[#subhand + 1] = hand[i]
                    end
                end
                if #subhand >= 5 - four then
                    return {subhand}
                end
            end
        end
        return {}
    end
}

SMODS.Seal{
    key = "magenta",
    atlas = "New_Enhance",
    pos = {x = 2, y = 2},
    badge_colour = HEX("96108D"),
    loc_txt = {
        name = "Magenta Seal",
        label = "Magenta Seal",
        text={
            "Creates the {C:reverse_zodiac}Zodiac{} card",
            "for final played {C:attention}poker hand{}",
            "of round if {C:attention}held in hand{}", -- change to if scored
            "{C:inactive}(Must have room)",
        },
    },
    loc_vars = function(self, info_queue, center)
        if G.hand then
            if #G.hand.highlighted >= 1 then
                local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                local _planet = {}
                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == text then
                        _planet = v.key
                    end
                end
                for i, v in ipairs(G.GAME.fool_table) do
                    if _planet == v then
                        _planet = G.P_CENTERS[G.GAME.fool_table[i+13]]
                    end
                end
                info_queue[#info_queue+1] = _planet
                return {}
            end
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.playing_card_end_of_round then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local ret = {}
                local card_type = 'Planet'
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local _planet = 0
                        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                _planet = v.key
                            end
                        end
                        for i, v in ipairs(G.GAME.fool_table) do
                            if _planet == v then
                                local card = create_card("Tarot_Planet",G.consumeables, nil, nil, nil, nil, G.GAME.fool_table[i+13], 'blusl')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0 break
                            end
                        end
                return true
            end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Zodiac", colour = HEX("C61CBB")})
                ret.effect = true
                return ret
            end
        end
    end
}

SMODS.Voucher {
    key = "zodiac_merchant",
    atlas = "Reverse_Vouchers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Zodiac Merchant",
        text={
            "{C:reverse_zodiac}Zodiac{} cards can appear",
            "in the shop",
        },
    },
    redeem = function(self, card)
        G.GAME['reverse_zodiac_rate'] = G.GAME['reverse_zodiac_rate'] + 2
    end
}

SMODS.Voucher {
    key = "zodiac_tycoon",
    atlas = "Reverse_Vouchers",
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "Zodiac Tycoon",
        text={
            "{C:reverse_zodiac}Zodiac{} cards appear",
            "{C:attention}#1#X{} more frequently",
            "in the shop",
        },
    },
    config = {
        extra = 2
    },
    requires = {"v_reverse_zodiac_merchant"},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra}}
    end,
    redeem = function(self, card)
        G.GAME['reverse_zodiac_rate'] = G.GAME['reverse_zodiac_rate'] + 2
    end
}

SMODS.Booster{
    key = "zodiac_1",
    atlas = "Zodiac_Booster",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Astrology Pack",
        group_name = "Zodiac Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:reverse_zodiac} Zodiac{} cards to",
            "be used immediately",
        }
    },
    cost = 4,
    weight = 1,
    draw_hand = true,
    config = {extra = 3, choose = 1},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.choose, center.ability.extra}}
    end,
    create_card = function (self, card, i) 
        return create_card("reverse_zodiac", G.pack_cards, nil, nil, true, true, nil, "pack")
    end,
    ease_background_colour = function(self)
        ease_colour(HEX("380335"), HEX("96108D"))
        ease_background_colour({ new_colour = HEX("380335"), special_colour = HEX("96108D"), contrast = 2 })
    end,
}

SMODS.Booster{
    key = "zodiac_2",
    atlas = "Zodiac_Booster",
    pos = {x = 1, y = 0},
    loc_txt = {
        name = "Astrology Pack",
        group_name = "Zodiac Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:reverse_zodiac} Zodiac{} cards to",
            "be used immediately",
        }
    },
    cost = 4,
    weight = 1,
    draw_hand = true,
    config = {extra = 3, choose = 1},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.choose, center.ability.extra}}
    end,
    create_card = function (self, card, i) 
        return create_card("reverse_zodiac", G.pack_cards, nil, nil, true, true, nil, "pack")
    end,
    ease_background_colour = function(self)
        ease_colour(HEX("380335"), HEX("96108D"))
        ease_background_colour({ new_colour = HEX("380335"), special_colour = HEX("96108D"), contrast = 2 })
    end,
}

SMODS.Booster{
    key = "zodiac_3",
    atlas = "Zodiac_Booster",
    pos = {x = 2, y = 0},
    loc_txt = {
        name = "Jumbo Astrology Pack",
        group_name = "Zodiac Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:reverse_zodiac} Zodiac{} cards to",
            "be used immediately",
        }
    },
    cost = 6,
    weight = 1,
    draw_hand = true,
    config = {extra = 5, choose = 1},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.choose, center.ability.extra}}
    end,
    create_card = function (self, card, i) 
        return create_card("reverse_zodiac", G.pack_cards, nil, nil, true, true, nil, "pack")
    end,
    ease_background_colour = function(self)
        ease_colour(HEX("380335"), HEX("96108D"))
        ease_background_colour({ new_colour = HEX("380335"), special_colour = HEX("96108D"), contrast = 2 })
    end,
}

SMODS.Booster{
    key = "zodiac_4",
    atlas = "Zodiac_Booster",
    pos = {x = 3, y = 0},
    loc_txt = {
        name = "Mega Astrology Pack",
        group_name = "Zodiac Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:reverse_zodiac} Zodiac{} cards to",
            "be used immediately",
        }
    },
    cost = 8,
    weight = 1,
    draw_hand = true,
    config = {extra = 5, choose = 2},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.choose, center.ability.extra}}
    end,
    create_card = function (self, card, i) 
        return create_card("reverse_zodiac", G.pack_cards, nil, nil, true, true, nil, "pack")
    end,
    ease_background_colour = function(self)
        ease_colour(HEX("380335"), HEX("96108D"))
        ease_background_colour({ new_colour = HEX("380335"), special_colour = HEX("96108D"), contrast = 2 })
    end,
}

SMODS.Consumable{
    key = "horoscope",
    set = "Spectral",
    atlas = "Reverse_Tarots",
    pos = {x = 10, y = 2},
    soul_pos = {x = 11, y = 2},
    loc_txt = {
        name = "Horoscope",
        text = {
            "Add a {C:reverse_zodiac}Magenta Seal{}",
            "to {C:attention}1{} selected",
            "card in your hand",
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
        info_queue[#info_queue+1] = G.P_SEALS.reverse_magenta
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        local seal = pseudorandom_element(G.P_SEALS, pseudoseed('reverse_virgo_seal'))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            conv_card:set_seal("reverse_magenta", nil, true)
            return true end }))
        
        delay(0.5)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}

SMODS.Consumable{
    key = "janus",
    set = "Planet",
    atlas = "Reverse_Tarots",
    pos = {x = 1, y = 0},
    loc_txt = {
        name = "Janus",
        text={
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    config = {hand_type = 'reverse_parity'},
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                G.GAME.hands["reverse_parity"].level,
                "Parity",
                G.GAME.hands["reverse_parity"].mult,
                G.GAME.hands["reverse_parity"].chips,
                colours = {(G.GAME.hands["reverse_parity"].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands["reverse_parity"].level)])}
            }
        }
    end,
    can_use = function(self, card)
        return true
    end,
}

SMODS.Consumable{
    key = "aquarius",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 0, y = 3},
    soul_pos = {x = 0, y = 4},
    loc_txt = {
        name = "Aquarius",
        text = {
            "Adds a {C:attention}Marble{} and",
            "a {C:attention}Stone{} card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_marble
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand and #G.hand.cards > 1 then return true end
    end,
    use = function(self, card, area, copier)
        new_card = SMODS.create_card({area = G.hand, set = "Base", enhancement = 'm_reverse_marble'})
        new_card:add_to_deck()
        G.hand:emplace(new_card)
        table.insert(G.playing_cards, new_card)
        new_card:start_materialize(nil, _first_dissolve)
        new_card = SMODS.create_card({area = G.hand, set = "Base", enhancement = 'm_stone'})
        new_card:add_to_deck()
        G.hand:emplace(new_card)
        table.insert(G.playing_cards, new_card)
        new_card:start_materialize(nil, _first_dissolve)
        G.deck.config.card_limit = G.deck.config.card_limit + 2
        playing_card_joker_effects({true, true})
    end
}

SMODS.Consumable{
    key = "pisces",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 1, y = 3},
    soul_pos = {x = 1, y = 4},
    loc_txt = {
        name = "Pisces",
        text = {
            "Select {C:attention}#1#{} card,",
            "applies random {C:attention}Enhancement{} to it",
            "and {C:attention}#1#{} other card of the same",
            "{C:attention}rank{} in your {C:attention}full decck{}"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
        return {vars = {center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 and not (SMODS.has_enhancement(G.hand.highlighted[1], "m_stone") or SMODS.has_enhancement(G.hand.highlighted[1], "m_reverse_marble")) then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        local eligible_cards = {}
        for k, v in ipairs(G.playing_cards) do
            if (v.base.id == G.hand.highlighted[1].base.id or SMODS.has_enhancement(G.hand.highlighted[1], "m_reverse_omnirank")) and (v ~= G.hand.highlighted[1]) then
                eligible_cards[#eligible_cards+1] = v
            end
        end
        table.sort(eligible_cards, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(eligible_cards, pseudoseed("pisces"))
        cen_pool = {}
        for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
            if v.key ~= 'm_stone' and v.key ~= 'm_reverse_marble' then 
                cen_pool[#cen_pool+1] = v
            end
        end
        local ability = pseudorandom_element(cen_pool, pseudoseed('pisces_enhnace'))
        local final_cards = {}
        if #eligible_cards >= 1 then
            table.insert(final_cards, eligible_cards[1])
        end
        table.insert(final_cards, G.hand.highlighted[1])
        play_sound('tarot1')
        for i = 1, #final_cards do --flips cards
            local percent = 1.15 - (i-0.999)/(#final_cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    final_cards[i]:flip();  
                    play_sound('card1', percent);
                    final_cards[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #final_cards do --enhances cards
            local percent = 0.85 + (i-0.999)/(#final_cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    final_cards[i]:set_ability(G.P_CENTERS[ability.key]);
                    final_cards[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        for i = 1, #final_cards do --unflips cards
            local percent = 0.85 + (i-0.999)/(#final_cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    final_cards[i]:flip();
                    play_sound('tarot2', percent, 0.6);
                    final_cards[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "aries",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 2, y = 3},
    soul_pos = {x = 2, y = 4},
    loc_txt = {
        name = "Aries",
        text = {
            "Adds {C:attention}#1#{} copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
        return {vars = {center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
        local _card = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
        _card:add_to_deck()
        G.deck.config.card_limit = G.deck.config.card_limit + 1
        table.insert(G.playing_cards, _card)
        G.hand:emplace(_card)
        _card:start_materialize(nil, _first_dissolve)
        playing_card_joker_effects({true})
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "taurus",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 3, y = 3},
    soul_pos = {x = 3, y = 4},
    loc_txt = {
        name = "Taurus",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected card to an",
                "{C:attention}#2#{}"
        }
    },
    config = { context =
        {
            max_highlighted = 1,
            mod_conv = "Iridium Card"
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_iridium
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_reverse_iridium"]);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "gemini",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 4, y = 3},
    soul_pos = {x = 4, y = 4},
    loc_txt = {
        name = "Gemini",
        text = {
            "Select {C:attention}#1#{} card, all cards",
            "of this {C:attention}rank{} in your deck",
            "become that {C:attention}suit{}"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
        return {vars = {center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        for k, v in pairs(G.hand.cards) do
            if v.base.id == G.hand.highlighted[1].base.id then
                local percent = 1.15 - (1-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        v:flip();
                        play_sound('card1', percent);
                        v:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end
        end
        delay(0.5)
        for k, v in pairs(G.hand.cards) do
            if v.base.id == G.hand.highlighted[1].base.id then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    local suit_prefix = string.sub(G.hand.highlighted[1].base.suit, 1, 1)..'_'
                    local rank_suffix = v.base.id
                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                    elseif rank_suffix == 10 then rank_suffix = 'T'
                    elseif rank_suffix == 11 then rank_suffix = 'J'
                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                    elseif rank_suffix == 13 then rank_suffix = 'K'
                    elseif rank_suffix == 14 then rank_suffix = 'A'
                    end
                    v:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                return true end }))
            end
        end
        for k, v in pairs(G.hand.cards) do
            if v.base.id == G.hand.highlighted[1].base.id then
                local percent = 0.85 + (1-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     v:flip();
                     play_sound('tarot2', percent, 0.6);
                     v:juice_up(0.3, 0.3);
                     return true
                end
            }))
            end
        end
        for k, v in pairs(G.deck.cards) do
            if v.base.id == G.hand.highlighted[1].base.id then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    local suit_prefix = string.sub(G.hand.highlighted[1].base.suit, 1, 1)..'_'
                    local rank_suffix = v.base.id
                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                    elseif rank_suffix == 10 then rank_suffix = 'T'
                    elseif rank_suffix == 11 then rank_suffix = 'J'
                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                    elseif rank_suffix == 13 then rank_suffix = 'K'
                    elseif rank_suffix == 14 then rank_suffix = 'A'
                    end
                    v:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                return true end }))
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "cancer",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 5, y = 3},
    soul_pos = {x = 5, y = 4},
    loc_txt = {
        name = "Cancer",
        text = {
            "Copies {C:attention}Enhancements{}, {C:dark_edition}Editions{}, and {C:tarot}Seals{}",
            "from the {C:attention}right{} card to",
            "the {C:attention}left{} card"
        }
    },
    config = { context =
        {
            number_cards = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted == 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        local rightmost = G.hand.highlighted[1]
        for i=1, #G.hand.highlighted do if G.hand.highlighted[i].T.x > rightmost.T.x then rightmost = G.hand.highlighted[i] end end
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                if G.hand.highlighted[i] ~= rightmost then
                    --print(rightmost.config.center.key)
                    if rightmost.config.center.key ~= "c_base" then
                        G.hand.highlighted[i]:set_ability(G.P_CENTERS[rightmost.config.center.key])
                    end
                    if rightmost.edition then
                        G.hand.highlighted[i]:set_edition(rightmost.edition)
                    end
                    if rightmost.seal then
                        G.hand.highlighted[i]:set_seal(rightmost.seal)
                    end
                end
                return true
            end }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "leo",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 6, y = 3},
    soul_pos = {x = 6, y = 4},
    loc_txt = {
        name = "Leo",
        text = {
            "Destroys {C:attention}#1#{} random",
            "cards in hand"
        }
    },
    config = { context =
        {
            destroy = 3
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
        return {vars = {center.ability.context.destroy}}
    end,
    can_use = function(self, card)
        if G and G.hand and #G.hand.cards > 0 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        local temp_hand = {}
        for k, v in ipairs(G.hand.cards) do temp_hand[#temp_hand+1] = v end
        table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(temp_hand, pseudoseed('leo'))
        for i = 1, 3 do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local v = destroyed_cards[i]
                    if SMODS.shatters(v) then
                        v:shatter()
                    else
                        v:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true end }))
        delay(0.5)
        SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
    end
}

SMODS.Consumable{
    key = "virgo",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 7, y = 3},
    soul_pos = {x = 7, y = 4},
    loc_txt = {
        name = "Virgo",
        text = {
            "Add a {C:attention}Random Seal{}",
            "to {C:attention}1{} selected",
            "card in your hand",
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        local seal = pseudorandom_element(G.P_SEALS, pseudoseed('reverse_virgo_seal'))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            conv_card:set_seal(seal.key, nil, true)
            return true end }))
        
        delay(0.5)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}

SMODS.Consumable{
    key = "libra",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 8, y = 3},
    soul_pos = {x = 8, y = 4},
    loc_txt = {
        name = "Libra",
        text = {
            "Turns all cards in hand",
            "to their average rank",
            "{C:inactive}(currently {C:attention}#1#{C:inactive})"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        if G.hand then
            local sum = 0
            local total = 0
            for i=1, #G.hand.cards do
                if not(SMODS.has_enhancement(G.hand.cards[i], "m_stone") or SMODS.has_enhancement(G.hand.cards[i], "m_reverse_marble") or SMODS.has_enhancement(G.hand.cards[i], "m_reverse_omnirank")) then
                    sum = sum + G.hand.cards[i].base.id
                    total = total + 1
                end
            end
            sum = round(sum / #G.hand.cards)
            if sum > 10 then
                if sum == 11 then sum = "J"
                elseif sum == 12 then sum = "Q"
                elseif sum == 13 then sum = "K"
                else sum = "A" end
            end
            return {vars = {sum}}
        else
            return {vars = {"No cards in hand"}}
        end
    end,
    can_use = function(self, card)
        if G and G.hand and #G.hand.cards > 0 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        local sum = 0
        local total = 0
        for i=1, #G.hand.cards do
            if not(SMODS.has_enhancement(G.hand.cards[i], "m_stone") or SMODS.has_enhancement(G.hand.cards[i], "m_reverse_marble") or SMODS.has_enhancement(G.hand.cards[i], "m_reverse_omnirank")) then
                sum = sum + G.hand.cards[i].base.id
                total = total + 1
            end
        end
        sum = round(sum/total)
        for k, v in pairs(G.hand.cards) do
            local percent = 1.15 - (1-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    v:flip();
                    play_sound('card1', percent);
                    v:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for k, v in pairs(G.hand.cards) do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local suit_prefix = string.sub(v.base.suit, 1, 1)..'_'
                local rank_suffix = sum
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                v:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))
        end
        for k, v in pairs(G.hand.cards) do
            local percent = 0.85 + (1-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     v:flip();
                     play_sound('tarot2', percent, 0.6);
                     v:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "scorpio",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 9, y = 3},
    soul_pos = {x = 9, y = 4},
    loc_txt = {
        name = "Scorpio",
        text = {
            "Select {C:attention}#1# Enhanced{} card,",
            "its enhancement is applied to {C:attention}#2#",
            "unehanced cards in hand"
        }
    },
    config = { context =
        {
            select_cards = 1,
            number_cards = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.select_cards, center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                if G.hand.highlighted[1].config.center.key ~= "c_base" then
                    return true
                end
            end
        end
    end,
    use = function(self, card, area, copier)
        local eligible_cards = {}
        for k, v in ipairs(G.hand.cards) do
            if v.config.center.key == "c_base" then
                eligible_cards[#eligible_cards+1] = v
            end
        end
        table.sort(eligible_cards, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(eligible_cards, pseudoseed("scorpio"))
        local final_cards = {}
        if #eligible_cards <= 2 then
            final_cards = eligible_cards
        else
            table.insert(final_cards, eligible_cards[1])
            table.insert(final_cards, eligible_cards[2])
        end
        play_sound('tarot1')
        for i = 1, #final_cards do --flips cards
            local percent = 1.15 - (i-0.999)/(#final_cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    final_cards[i]:flip();
                    play_sound('card1', percent);
                    final_cards[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #final_cards do --enhances cards
            local percent = 0.85 + (i-0.999)/(#final_cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    final_cards[i]:set_ability(G.P_CENTERS[G.hand.highlighted[1].config.center.key]);
                    final_cards[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        for i = 1, #final_cards do --unflips cards
            local percent = 0.85 + (i-0.999)/(#final_cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    final_cards[i]:flip();
                    play_sound('tarot2', percent, 0.6);
                    final_cards[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "sagittarius",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 10, y = 3},
    soul_pos = {x = 10, y = 4},
    loc_txt = {
        name = "Sagittarius",
        text = {
            "Select {C:attention}#1#{} card, destroy",
            "it and {C:attention}#2#{} others from your",
            "{C:attention}full deck{} of the same {C:attention}base suit{}"
        }
    },
    config = { context =
    {
        select_cards = 1,
        number_cards = 2
    }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.select_cards, center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                if not(SMODS.has_enhancement(G.hand.highlighted[1], "m_stone") or SMODS.has_enhancement(G.hand.highlighted[1], "m_reverse_marble")) then
                    return true
                end
            end
        end
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        local eligible_cards = {}
        for k, v in ipairs(G.playing_cards) do
            if v.base.suit == G.hand.highlighted[1].base.suit and v ~= G.hand.highlighted[1] and not(SMODS.has_enhancement(v, "m_stone") or SMODS.has_enhancement(v, "m_reverse_marble")) then
                eligible_cards[#eligible_cards+1] = v
            end
        end
        table.sort(eligible_cards, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(eligible_cards, pseudoseed('sag'))
        local temp_hand = {}
        if #eligible_cards <= 2 then
            temp_hand = eligible_cards
        else
            table.insert(temp_hand, eligible_cards[1])
            table.insert(temp_hand, eligible_cards[2])
        end
        table.insert(temp_hand, G.hand.highlighted[1])
        for i = 1, #temp_hand do destroyed_cards[#destroyed_cards+1] = temp_hand[i] end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local v = destroyed_cards[i]
                    if SMODS.shatters(v) then
                        v:shatter()
                    else
                        v:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true end }))
        delay(0.5)
        SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
    end
}

SMODS.Consumable{
    key = "capricorn",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 11, y = 3},
    soul_pos = {x = 11, y = 4},
    loc_txt = {
        name = "Capricorn",
        text = {
            "Select up to {C:attention}#1#{} cards",
            "converts the {C:attention}left two{}",
            "into the {C:attention}rank{} of the {C:attention}right{}"
        }
    },
    config = { context =
        {
            number_cards = 3
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted == 2 or #G.hand.highlighted == 3 then
                local rightmost = G.hand.highlighted[1]
                for i=1, #G.hand.highlighted do
                    if G.hand.highlighted[i].T.x > rightmost.T.x then
                        rightmost = G.hand.highlighted[i]
                    end
                end
                if not(SMODS.has_enhancement(rightmost, "m_stone") or SMODS.has_enhancement(rightmost, "m_reverse_marble") or SMODS.has_enhancement(rightmost, "m_reverse_omnirank")) then
                    return true
                end
            end
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        local rightmost = G.hand.highlighted[2]
        for i=1, #G.hand.highlighted do if G.hand.highlighted[i].T.x > rightmost.T.x then rightmost = G.hand.highlighted[i] end end
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                if G.hand.highlighted[i] ~= rightmost then
                    local suit_prefix = string.sub(G.hand.highlighted[i].base.suit, 1, 1)..'_'
                    local rank_suffix = rightmost.base.id
                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                    elseif rank_suffix == 10 then rank_suffix = 'T'
                    elseif rank_suffix == 11 then rank_suffix = 'J'
                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                    elseif rank_suffix == 13 then rank_suffix = 'K'
                    elseif rank_suffix == 14 then rank_suffix = 'A'
                    end
                    G.hand.highlighted[i]:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                end
                return true
            end }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "ophiuchus",
    set = "reverse_zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 12, y = 3},
    soul_pos = {x = 12, y = 4},
    loc_txt = {
        name = "Ophiuchus",
        text = {
            "Creates up to {C:attention}#1#",
            "random {C:reverse_zodiac}Zodiac{} cards",
            "{C:inactive}(Must have room){}",
        }
    },
    config = { context =
        {
            number_cards = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then
            return true
        end
    end,
    use = function(self, card, area, copier)
        for i = 1, math.min(card.ability.context.number_cards, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    local card = create_card('reverse_zodiac', G.consumeables, nil, nil, nil, nil, nil, 'oph')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                end
                return true end }))
        end
        delay(0.6)
    end
}