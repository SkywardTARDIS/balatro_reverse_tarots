SMODS.Joker{
    key = 'rekoj',
    loc_txt = {
        name = 'Rekoj',
        text = {
            '{C:mult}#1#{} Mult'
        }
    },
    rarity = 1,
    cost = 1,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 0},
    config = {extra = {mult = -4}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                mult_mod = card.ability.extra.mult,
                message = "" .. card.ability.extra.mult,
                colour = G.C.Mult
            }
        end
    end
}

SMODS.Joker{
    key = 'crystal_joker',
    loc_txt = {
        name = 'Crystal Joker',
        text = {
            "This Joker gains {X:chips,C:white} X#1# {} Chips",
                    "for every {C:attention}Crystal{} card",
                    "that is destroyed",
                    "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)"
        },
        unlock = {
            "Have at least {E:1,C:attention}5",
            "{E:1,C:attention}Crystal Cards{} in",
            "your deck",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 0},
    unlock_condition = {type = 'modify_deck', extra = {count = 5, enhancement = 'm_reverse_crystal'}},
    enhancement_gate = 'm_reverse_crystal',
    unlocked = false,
    config = {
            x_chips = 1,
            gain = 0.75
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_crystal
        return {vars = {center.ability.gain, center.ability.x_chips}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_chips = card.ability.x_chips
            }
        elseif context.cards_destroyed and not context.blueprint then
            local glasses = 0
                for k, v in ipairs(context.glass_shattered) do
                    if v.shattered and SMODS.has_enhancement(v, 'm_reverse_crystal') then
                        glasses = glasses + 1
                    end
                end
                if glasses > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card.ability.x_chips = card.ability.x_chips + card.ability.gain*glasses
                          return true
                        end
                      }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_chips + card.ability.gain*glasses}}})
                    return true
                end
              }))
                end
        elseif context.remove_playing_cards and not context.blueprint then
            local glass_cards = 0
            for k, val in ipairs(context.removed) do
                if val.shattered and SMODS.has_enhancement(val, 'm_reverse_crystal') then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.x_chips = card.ability.x_chips + card.ability.gain*glass_cards
                    return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_chips + card.ability.gain*glass_cards}}})
                return true
                    end
                }))                    return nil, true
            end
        elseif context.using_consumeable then
            if not context.blueprint and context.consumeable.ability.name == 'The Hanged Man' then
                local shattered_glass = 0
                    for k, val in ipairs(G.hand.highlighted) do
                        if SMODS.has_enhancement(val, 'm_reverse_crystal') then shattered_glass = shattered_glass + 1 end
                    end
                    if shattered_glass > 0 then
                        card.ability.x_chips = card.ability.x_chips + card.ability.gain*shattered_glass
                        G.E_MANAGER:add_event(Event({
                            func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.x_chips}}}); return true
                            end}))
                    end
            end
        end
    end
}

SMODS.Joker{
    key = 'copper_joker',
    loc_txt = {
        name = 'Copper Joker',
        text = {
            "Gives {X:chips,C:white} X#1# {} Chips",
            "for each {C:attention}Copper{} card",
            "in your {C:attention}full deck",
            "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 0},
    config = {
        extra = {
            copper_tally = 0,
            gain = .2
        }
    },
    rarity = 2,
    cost = 7,
    enhancement_gate = 'm_reverse_copper',
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_copper
        return {vars = {center.ability.extra.gain,  1 + center.ability.extra.gain*center.ability.extra.copper_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_chips = 1 + card.ability.extra.gain*card.ability.extra.copper_tally
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.copper_tally = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_reverse_copper') then card.ability.extra.copper_tally = card.ability.extra.copper_tally+1 end
            end
        end
    end
}

SMODS.Joker{
    key = 'sculptor',
    loc_txt = {
        name = 'Sculptor',
        text = {
            "Adds one {C:attention}Marble{} card",
            "to deck when",
            "{C:attention}Blind{} is selected",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 1},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_marble
        return
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not self.debuff then
            if not (context.blueprint_card or card).getting_sliced then
                G.E_MANAGER:add_event(Event({
                func = function() 
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local acard = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_reverse_marble, {playing_card = G.playing_card})
                    card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                    G.play:emplace(acard)
                    table.insert(G.playing_cards, acard)
                    return true
                end}))
            G.E_MANAGER:add_event(Event({
                func = function() 
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end}))
                draw_card(G.play,G.deck, 90,'up', nil)  

                playing_card_joker_effects({true})
                return nil, true
            end
        end
    end
}

SMODS.Joker{
    key = 'marbled_joker',
    loc_txt = {
        name = 'Marbled Joker',
        text = {
            "Gives {C:mult}+#1#{} Mult for",
                    "each {C:attention}Marble{} card",
                    "in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 1},
    config = {
        extra = {
            marble_tally = 0,
            gain = 5
        }
    },
    blueprint_compat = true,
    enhancement_gate = 'm_reverse_marble',
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_marble
        return {vars = {center.ability.extra.gain, center.ability.extra.gain*center.ability.extra.marble_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                mult = card.ability.extra.gain*card.ability.extra.marble_tally
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.marble_tally = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_reverse_marble') then card.ability.extra.marble_tally = card.ability.extra.marble_tally + 1 end
            end
        end
    end
}

SMODS.Joker{
    key = 'omni_joker',
    loc_txt = {
        name = 'Omni-Joker',
        text = {
            "Each {C:attention}Omnirank{} card in",
            "played hand gives",
            "{X:chips,C:white}X#1#{} Chips when scored",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 1},
    config = {extra = {x_chips = 1.5}},
    blueprint_compat = true,
    enhancement_gate = 'm_reverse_omnirank',
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_omnirank
        return {vars = {center.ability.extra.x_chips}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if is_omnirank(context.other_card) then
                return {
                    x_chips = card.ability.extra.x_chips,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'wild_joker',
    loc_txt = {
        name = 'Wild Joker',
        text = {
            "Gives {X:mult,C:white} X#1# {} Mult",
            "for each {C:attention}multisuited{} card",
            "in your {C:attention}full deck",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 2},
    config = {
        extra = {
            suit_tally = 0,
            gain = .1
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    set_sprites = function(self, card, front)
        if G.SETTINGS.CUSTOM_DECK.Collabs.Spades == "reverse_ourple" then
            card.children.center:set_sprite_pos({x = 0, y = 5})
        end
    end,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.gain,  1 + center.ability.extra.gain*center.ability.extra.suit_tally}}
    end,
    in_pool = function(self, args)
        for _, v in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_wild') or v:has_secondary_suit() then
                return true
            end
        end
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_mult = 1 + card.ability.extra.gain*card.ability.extra.suit_tally
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.suit_tally = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_wild') or v:has_secondary_suit() then card.ability.extra.suit_tally = card.ability.extra.suit_tally + 1 end
            end
        end
    end
}

SMODS.Joker{
    key = 'counterfeit_bill',
    loc_txt = {
        name = 'Counterfeit Bill',
        text = {
            "This Joker earns {C:money}$#1#{} at end of",
            "round and gains {C:money}$#2#{}",
            "every time a {C:attention}Counterfeit{} card",
            "{C:green}successfully{} triggers",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 1},
    config = {
        extra = {
            current_money = 5,
            gain = 1
        }
    },
    rarity = 2,
    cost = 6,
    enhancement_gate = 'm_reverse_counterfeit',
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_counterfeit
        return {vars = {center.ability.extra.current_money,  center.ability.extra.gain}}
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra.current_money
            }
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card.counterfeit_trigger and not context.blueprint then
                card.ability.extra.current_money = card.ability.extra.current_money + card.ability.extra.gain
                return {
                    card = card,
                    message = "+$" .. card.ability.extra.gain,
                    colour = G.C.money
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'fools_gold',
    loc_txt = {
        name = "Fool's Gold",
        text = {
            "{C:attention}Pyrite{} cards",
            "Now {C:attention}earn{} {C:money}$#1#{}",
            "while it stays",
            "in your hand"
        },
        unlock = {
            "Play a 5 card hand",
            "that contains only",
            "{C:attention,E:1}Pyrite{} cards",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 0},
    config = {
        extra = {
            earned = 4
        }
    },
    rarity = 1,
    cost = 5,
    enhancement_gate = 'm_reverse_pyrite',
    unlock_condition = {type = 'hand_contents', enhancement_gate = 'm_reverse_pyrite'},
    unlocked = false,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_pyrite
        return {vars = {center.ability.extra.earned}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.hand then
            if SMODS.has_enhancement(context.other_card, 'm_reverse_pyrite') then
                return {dollars = card.ability.extra.earned}
            end
        end
    end
}

SMODS.Joker{
    key = 'rewrite',
    loc_txt = {
        name = "Rewrite",
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "when a selected {C:attention}Enhanced{} card",
            "is {C:attention}Enhanced{} again",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 1},
    config = {
        extra = {
            enhance_tally = 0,
            gain = .1
        }
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.gain, 1 + center.ability.extra.gain*center.ability.extra.enhance_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_mult = 1 + card.ability.extra.gain*card.ability.extra.enhance_tally
            }
        end
        if not context.blueprint then
            local overwrite = 0
            if context.using_consumeable then
                for k, v in ipairs(G.hand.highlighted) do
                    if v.ability.name ~= "Default Base" then
                        card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + 1
                        overwrite = overwrite + 1
                    end
                end
            end
            if context.before and next(find_joker("Midas Mask")) then
                --INSERT MIDAS MASK CONDITION
                local midas = #find_joker("Midas Mask")
                for k, v in ipairs(context.scoring_hand) do
                    local already_enhanced = 1
                    if v:is_face() then
                        if v.ability.name ~= "Default Base" then
                            already_enhanced = 0
                        end
                        card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + midas - already_enhanced
                        overwrite = overwrite + midas - already_enhanced
                    end
                end
            end
            if overwrite > 0 then
                return {
                    card = card,
                    message = "X" .. card.ability.extra.gain * overwrite,
                    colour = G.C.x_mult
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'cartomancer?',
    loc_txt = {
        name = "Cartomancer?",
        text = {
            "Create a {C:tarot}Reverse Tarot{} card",
            "when {C:attention}Blind{} is selected",
            "{C:inactive}(Must have room)",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 0},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not card.getting_sliced then
            if not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'rcar')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))                    
                        return true
                    end)}))
                return {
                    card = card,
                    message = "+1 Tarot",
                    colour = G.C.PURPLE
                    }          
            end
        end
    end
}

SMODS.Joker{
    key = 'card_reading',
    loc_txt = {
        name = "Card Reading",
        text = {
            "Create a {C:purple}Reverse Tarot{} card",
                    "if hand is played",
                    "with money over the",
                    "{C:money}interest cap ($#1#)"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 2},
    soul_pos = {x = 0, y = 3},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.interest_cap or 25}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local dollars = (type(G.GAME.dollars) == "table" and to_number(G.GAME.dollars)) or G.GAME.dollars --Talisman my beloathed
                if dollars >= G.GAME.interest_cap then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'rvag')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                        return {
                            card = card,
                            message = "+1 Tarot",
                            colour = G.C.PURPLE
                        }
                end
            end
        end
    end
}

SMODS.Joker{
    key = 'd6',
    loc_txt = {
        name = "The D6",
        text = {
            "Gives a random amount",
            "of {X:mult,C:white}XMult",
            "between 1 and 6"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 2},
    soul_pos = {x = 1, y = 3},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {x_mult = math.floor(pseudorandom('D6')*6) + 1}
        end
    end
}

SMODS.Joker{
    key = 'dead_cat',
    loc_txt = {
        name = "Dead Cat",
        text = {
            "Prevents Death",
            "up to 9 times",
            "if chips scored",
            "are at least {C:attention}50%",
            "of required chips",
            "sets hands per round to 1",
            "{S:1.1,C:red,E:2}#1# remaining{}",
        }
    },
    rarity = 3,
    cost = 10,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 2},
    soul_pos = {x = 2, y = 3},
    config = {
        extra = {
            lives = 9
        }
    },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.lives}}
    end,
    calculate = function(self,card,context)
        if context.first_hand_drawn then
            ease_hands_played(-G.GAME.current_round.hands_left + 1)
            return {
                message = "Final Hand!",
                colour = G.C.RED
            }
        end
        if context.end_of_round and not context.blueprint and context.main_eval then
            if to_big(G.GAME.chips)/to_big(G.GAME.blind.chips) >= to_big(0.5) and to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) then
                card.ability.extra.lives = card.ability.extra.lives - 1
                if card.ability.extra.lives <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand_text_area.blind_chips:juice_up()
                            G.hand_text_area.game_chips:juice_up()
                            play_sound('tarot1')
                            card:start_dissolve()
                            return true
                        end
                    })) 
                end
                return {
                    message = localize('k_saved_ex'),
                    saved = true,
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'double_or_nothing',
    loc_txt = {
        name = "Double or Nothing",
        text = {
            "Starts at {X:mult,C:white}X#1#{{} Mult",
            "{C:green}#2# in 2{} chance to",
            "{C:attention}double{} its {X:mult,C:white}XMult{} for each",
            "hand played {C:attention}this round",
            "{C:inactive}(currently at {X:mult,C:white}X#3#{C:inactive} Mult)"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 2},
    config = {
        extra = {
            gain = 2,
            base = 1
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {1, G.GAME.probabilities.normal, center.ability.extra.base}}
    end,
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            if pseudorandom('double') <= G.GAME.probabilities.normal/2 then
                card.ability.extra.base = card.ability.extra.base*card.ability.extra.gain
                return {
                    message = "X2 Mult",
                    colour = G.C.RED
                }
            end
        elseif context.joker_main then
            return {x_mult = card.ability.extra.base}
        elseif context.end_of_round and not context.blueprint and context.main_eval then
            card.ability.extra.base = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker{ --To add: info_queue for effects.
    key = 'daily_double',
    loc_txt = {
        name = "Daily Double",
        text = {
            "Doubles a different value",
            "based on the current day of the week",
            "#1#: {B:1,C:white}X2{} #2#"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 2},
    config = {
        extra = 
        {
            day = os.date("*t").wday
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        local effect = ""
        self.config.extra.day = os.date("*t").wday
        if self.config.extra.day == 1 then
            effect = "Mult"
            color = "mult"
            self.blueprint_compat = true
        elseif self.config.extra.day == 2 then
            effect = "Payout from round (max $40)"
            color = "money"
            self.blueprint_compat = true
        elseif self.config.extra.day == 3 then
            effect = "Packs appear per shop"
            color = "attention"
            self.blueprint_compat = true
        elseif self.config.extra.day == 4 then
            effect = "Consumable slots"
            color = "tarot"
            self.blueprint_compat = false
        elseif self.config.extra.day == 5 then
            effect = "levels per planet card"
            color = "planet"
            self.blueprint_compat = false
        elseif self.config.extra.day == 6 then
            effect = "chance for cards to have editions"
            color = "dark_edition"
            self.blueprint_compat = false
        else
            effect = "Chips"
            color = "chips"
            self.blueprint_compat = true
        end
        info_queue[#info_queue+1] = { set = 'Other', key = 'daily_description' }
        return {vars = { os.date("%A"), effect, colours = {G.ARGS.LOC_COLOURS[color]}}}
    end,
    add_to_deck = function(self, card, from_debuff)
        update_daily_double()
        if G.GAME.day == 3 then
            local mod = 2 ^ (#find_joker("j_reverse_daily_double") + 1)
            SMODS.change_booster_limit(mod)
        elseif G.GAME.day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit * 2
        elseif G.GAME.day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate * 2
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        update_daily_double()
        if G.GAME.day == 3 then
            local mod = - 2 ^ (#find_joker("j_reverse_daily_double") + 1)
            SMODS.change_booster_limit(mod)
        elseif G.GAME.day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit / 2
        elseif G.GAME.day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate / 2
        end
    end,
    calculate = function(self,card,context)
        update_daily_double()
        if context.joker_main then
            if G.GAME.day == 1 then
                return {x_mult = 2}
            elseif G.GAME.day == 7 then
                return {x_chips = 2}
            end
        end
    end,
    update = function(self, card, card_table, other_card)
        --update_daily_double()
    end
}

function update_daily_double()
    local current_day = os.date("*t").wday
    if G.GAME.day ~= current_day and G.GAME.day then
        if G.GAME.day == 3 then
            local mod = - 2 ^ (#find_joker("j_reverse_daily_double") + 1) + 2
            SMODS.change_booster_limit(mod)
        elseif G.GAME.day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit / 2 ^ (#find_joker("j_reverse_daily_double"))
        elseif G.GAME.day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate / 2 ^ (#find_joker("j_reverse_daily_double"))
        end
        if current_day == 3 then
            local mod = 2 ^ (#find_joker("j_reverse_daily_double") + 1)
            SMODS.change_booster_limit(mod)
        elseif current_day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit * 2 ^ (#find_joker("j_reverse_daily_double"))
        elseif current_day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate * 2 ^ (#find_joker("j_reverse_daily_double"))
        end
    end
    G.GAME.day = current_day
end

SMODS.Joker{
    key = 'negative',
    loc_txt = {
        name = "Negative",
        text={
            "First played {C:attention}face",
            "card gives {X:chips,C:white} X#1# {} Chips",
            "when scored",
        },
    },
    rarity = 1,
    cost = 5,
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 4},
    config = {
        extra = {
            value = 2
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {2}}
    end,
    calculate = function(self,card,context)
        if context.individual then
            if context.cardarea == G.play then
                local first_face = nil
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
                end
                if context.other_card == first_face then
                    return {
                        x_chips = 2,
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    end,
    load = function(self, card, card_table, other_card)
        local scale = 1
        local H = G.CARD_H
        local W = G.CARD_W
        card.T.h = H*scale/1.2*scale
        card.T.w = W*scale
    end,
    set_sprites = function(self, card, front)
        card.children.center.scale.y = card.children.center.scale.y/1.2
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local H = card.T.h
        H = H/1.2
        card.T.h = H
    end,
    
}

SMODS.Joker{
    key = 'harmonic_convergence',
    loc_txt = {
        name = "Harmonic Convergence",
        text={
            "{C:green}#1# in #2#{} chance to gain",
            "{X:mult,C:white} X#3# {} Mult when hand scored,",
            "{C:green}odds{} decrease on successful trigger",
            "{C:inactive}(currently at {X:mult,C:white} X#4# {C:inactive} Mult)"
        },
    },
    rarity = 2,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 4},
    config = {
        extra = {
            n = 1,
            gain = .25
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal, center.ability.extra.n, center.ability.extra.gain, 1 + center.ability.extra.gain * (center.ability.extra.n - 1)}}
    end,
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            local convergence = pseudorandom('convergence')
            if convergence < G.GAME.probabilities.normal/card.ability.extra.n then
                card.ability.extra.n = card.ability.extra.n + 1
                return {
                    card = card,
                    message = "X" .. card.ability.extra.gain,
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                x_mult = 1 + card.ability.extra.gain * (card.ability.extra.n - 1)
            }
        end
    end
}

SMODS.Joker{
    key = 'cathode_ray_tube',
    loc_txt = {
        name = 'Cathode Ray Tubes',
        text = {
            "{C:chips}+#1#{} Chips per",
            "level of {C:green}CRT{} in {C:attention}Settings{}",
            "decreases {C:green}CRT{} by {C:attention}#3#{} per hand played",
            "currently {C:chips}+#2#{} Chips",
            "{C:green}#4# in #5#{} chance to break",
            "if {C:green}CRT{} is {C:attention}0{}"
        }
    },
    rarity = 1,
    cost = 5,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 4},
    config = {extra = {chips = 1, decrease = 10, prob = 3}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, round(G.SETTINGS.GRAPHICS.crt)*center.ability.extra.chips, center.ability.extra.decrease, G.GAME.probabilities.normal, center.ability.extra.prob}}
    end,
    in_pool = function(self, args)
        if G.GAME.pool_flags.crt_extinct then
            return false
        else
            return true
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.crt_extinct = false
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local chip_val = round(G.SETTINGS.GRAPHICS.crt)
            G.SETTINGS.GRAPHICS.crt = round(math.max(G.SETTINGS.GRAPHICS.crt - card.ability.extra.decrease, 0))
            if chip_val <= 0 and pseudorandom('crt') < G.GAME.probabilities.normal/card.ability.extra.prob then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                G.GAME.pool_flags.crt_extinct = true
                return {
                    message = "Broken!",
                    colour = G.C.GREEN
                }
            end
            return {
                chips = chip_val*card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker{
    key = 'liquid_crystal_display',
    loc_txt = {
        name = 'Liquid Crystal Display',
        text = {
            "This Joker gains {X:chips,C:white}X#1#{} Chips per",
            "level of {C:green}CRT{} {C:attention}below max{} in {C:attention}Settings{}",
            "increases {C:green}CRT{} by {C:attention}#3#{} per hand played",
            "currently {X:chips,C:white}X#2#{} Chips",
            "{C:attention}will break{} at max {C:green}CRT{}"
        }
    },
    rarity = 1,
    cost = 4,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 6},
    config = {extra = {chips = .02, increase = 10}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, round(100-G.SETTINGS.GRAPHICS.crt)*center.ability.extra.chips + 1, center.ability.extra.increase}}
    end,
    in_pool = function(self, args)
        return G.GAME.pool_flags.crt_extinct
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local chip_val = round(100-G.SETTINGS.GRAPHICS.crt)
            G.SETTINGS.GRAPHICS.crt = round(math.min(G.SETTINGS.GRAPHICS.crt + card.ability.extra.increase, 100))
            if G.SETTINGS.GRAPHICS.crt >= 100 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = "Broken!",
                    colour = G.C.GREEN
                }
            end
            return {
                x_chips = chip_val*card.ability.extra.chips + 1
            }
        end
    end
}

SMODS.Joker{
    key = 'mirthful',
    loc_txt = {
        name = 'Mirthful Joker',
        text = {
            "{C:red}+#1#{} Mult if played",
            "hand contains",
            "a {C:attention}#2#",
        }
    },
    rarity = 1,
    cost = 1,
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 2},
    config = {t_mult = 10, type = 'reverse_parity'},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.t_mult, "Parity"}}
    end,
}

SMODS.Joker{
    key = 'cunning',
    loc_txt = {
        name = 'Cunning Joker',
        text = {
            "{C:blue}+#1#{} Chips if played",
            "hand contains",
            "a {C:attention}#2#",
        }
    },
    rarity = 1,
    cost = 1,
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 3},
    config = {t_chips = 80, type = 'reverse_parity'},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.t_chips, "Parity"}}
    end,
}

SMODS.Joker{
    key = 'nebula',
    loc_txt = {
        name = 'Nebula',
        text = {
            "Adds the number of times",
            "{C:attention}other poker hands{} have been",
            "played this run to Mult",
        }
    },
    rarity = 1,
    cost = 5,
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 5},
    config = {extra = {mult = 1}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        --return {vars = {center.ability.extra.mult}}
        return {vars = {}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local sum = 0
            for k, v in pairs(G.GAME.hands) do
                if G.GAME.hands[context.scoring_name] ~= v then
                    if type(G.GAME.hands[k].played) == "table" then
                        sum = sum + to_number(G.GAME.hands[k].played)
                    else
                        sum = sum + G.GAME.hands[k].played
                    end
                end
            end
            return {
                mult = sum
            }
        end
    end
}

SMODS.Joker{
    key = 'divination',
    loc_txt = {
        name = 'Divination',
        text = {
            '{C:reverse_zodiac}Zodiac Packs{} in the',
            "shop are now free"
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 5},
    config = {},
    blueprint_compat = false,
    loc_vars = function(self, info_queue, center)
        --done in patches
    end,
    calculate = function(self,card,context)
    end
}

SMODS.Joker{
    key = 'astromancer',
    loc_txt = {
        name = 'Astromancer',
        text = {
            "Create a {C:reverse_zodiac}Zodiac{} card",
            "when {C:attention}Boss Blind{} is selected",
            "{C:inactive}(Must have room)",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 5},
    soul_pos = {x = 2, y = 4},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if G.GAME.blind.boss then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                local card = create_card('reverse_zodiac',G.consumeables, nil, nil, nil, nil, nil, 'ast')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))                        
                        return true
                    end)}))
                    return {card = card, message = "Zodiac", colour = HEX("C61CBB")}
            end
        end
    end
}

SMODS.Joker{
    key = 'oracle',
    loc_txt = {
        name = 'Oracle',
        text={
            "This Joker gains",
            "{X:chips,C:white} X#1# {} Chips every time",
            "a {C:reverse_zodiac}Zodiac{} card is used",
            "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)",
        },
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 5},
    config = {extra = {scaling = .25, tally = 0}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.scaling, 1 + center.ability.extra.scaling*center.ability.extra.tally}}
    end,
    calculate = function(self,card,context)
        if context.using_consumeable then
            if context.consumeable.ability.set == 'reverse_zodiac' and not context.blueprint then
                card.ability.extra.tally = card.ability.extra.tally + 1
                return {
                    card = card,
                    message =  "X" .. card.ability.extra.scaling,
                    colour = G.C.BLUE
                }
            end
        end
        if context.joker_main then
            return {
                x_chips = 1 + card.ability.extra.scaling*card.ability.extra.tally
            }
        end
    end
}

SMODS.Joker{
    key = 'monkeys_paw',
    loc_txt = {
        name = "Monkey's Paw",
        text = {
            "{C:red}+#1#{} Hand if about to lose,",
            "{C:attention}-#1#{} Hand Size every time",
            "this Joker activates",
            "{C:inactive}({C:attention}#2#{C:inactive} activations left)"
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 5, y = 0},
    config = {extra = {remaining = 3, hands = 1}},
    blueprint_compat = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.hands, center.ability.extra.remaining}}
    end,
    set_sprites = function(self, card, front)
        if card.ability and card.ability.extra then
            card.children.center:set_sprite_pos({x = 5, y = 3 - card.ability.extra.remaining})
        end
    end,
    calculate = function(self,card,context)
        if context.final_scoring_step and G.GAME.current_round.hands_left <= 0 and not context.blueprint then
            card.ability.extra.remaining = card.ability.extra.remaining - 1
            local full_score = to_big(G.GAME.chips) + to_big(hand_chips) * to_big(mult)
            if full_score < to_big(G.GAME.blind.chips) then
                G.E_MANAGER:add_event(Event({ -- flip card
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        card:flip();  
                        play_sound('card1', percent);
                        card:juice_up(0.3, 0.3);
                        return true
                    end
                }))
                delay(.5)
                G.E_MANAGER:add_event(Event({ --update sprite
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        card.children.center:set_sprite_pos({x = 5, y = 3 - card.ability.extra.remaining})
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({ -- flip card
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        card:flip();  
                        play_sound('card1', percent);
                        card:juice_up(0.3, 0.3);
                        return true
                    end
                }))
                ease_hands_played(card.ability.extra.hands)
                G.hand:change_size(-1)
                if card.ability.extra.remaining <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                    return {
                        message = "Granted...",
                        colour = G.C.Yellow
                    }
                end
                return {
                    message = "Granted...",
                    colour = G.C.Yellow,
                    card = card
                }
            end
        end
    end 
}

SMODS.Joker{
    key = 'equality',
    loc_txt = {
        name = 'The Equality',
        text = {
            "{X:mult,C:white} X#1# {} Mult if played",
            "hand contains",
            "a {C:attention}#2#",
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 6},
    config = {Xmult = 3, type = 'reverse_parity'},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.Xmult, "Parity"}}
    end,
}

SMODS.Joker{
    key = 'goddess_sword',
    loc_txt = {
        name = 'Goddess Sword',
        text = {
            "This Joker gains an effect",
            "every time hand score",
            "exceeds blind requirement",
            "Currently: {X:mult,C:white}X#1#{} Mult, {X:green,C:white}+#2#{} Base Probability",
            "{X:blue,C:white}+#3#{} Hands, {C:red}+#4#{} Discards"
        }
    },
    rarity = 4,
    cost = 20,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 6},
    soul_pos = {x = 0, y = 7},
    config = {extra = {level = 0, probability = 0, hands = 0, discards = 0}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        local mult = math.max(center.ability.extra.level - 4, 0) + 2 + (center.ability.extra.level > 0 and 1 or 0)
        return {vars =
            {
                mult,
                center.ability.extra.probability,
                center.ability.extra.hands,
                center.ability.extra.discards,
            }
        }
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        full_UI_table.name = localize { type = 'name', set = "Other", key = "sword_" .. math.min(card.ability.extra.level, 4), nodes = {} }
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end,
    set_sprites = function(self, card, front)
        if card.ability then
            if card.ability.extra then
                card.children.floating_sprite:set_sprite_pos({x = math.min(card.ability.extra.level, 4), y = 7})
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability then
            if card.ability.extra then
                card.children.floating_sprite:set_sprite_pos({x = math.min(card.ability.extra.level, 4), y = 7})
            end
        end
    end,
    calculate = function(self,card,context)
        --change hands and discards to apply *after* blind effect, i.e. Burglar
        --update card name on level up
        if context.joker_main then
            return {x_mult = math.max(card.ability.extra.level - 4, 0) + 2 + (card.ability.extra.level > 0 and 1 or 0)}
        end
        if context.setting_blind then
            ease_hands_played(card.ability.extra.hands)
            ease_discard(card.ability.extra.discards)
        end
        if context.final_scoring_step and not context.blueprint then
            if G.GAME.challenge == "c_reverse_trial" then
                if hand_chips * mult < G.GAME.blind.chips then
                    hand_chips = 0
                    mult = 0
                    return {
                        message = "Too Low!",
                        colour = G.C.YELLOW,
                        card = card
                    }
                end
                if not G.GAME.blind.boss then
                    return
                end
            end
            if hand_chips * mult > G.GAME.blind.chips then
                local sword_message = ""
                local sword_color = G.C.RED
                card.ability.extra.level = card.ability.extra.level + 1
                if card.ability.extra.level == 1 then
                    sword_color = G.C.RED
                    sword_message = "Power"
                elseif card.ability.extra.level == 2 then
                    sword_color = G.C.GREEN
                    sword_message = "Courage"
                elseif card.ability.extra.level == 3 then
                    sword_color = G.C.BLUE
                    sword_message = "Wisdom"
                elseif card.ability.extra.level == 4 then
                    sword_message = "Awaken"
                else
                    sword_message = "X1 Mult"
                end
                G.E_MANAGER:add_event(Event({ -- flip card
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        card:flip();  
                        play_sound('card1', percent);
                        card:juice_up(0.3, 0.3);
                        return true
                    end
                }))
                delay(.5)
                G.E_MANAGER:add_event(Event({ --update values
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        if card.ability.extra.level == 2 then
                            card.ability.extra.probability = 1
                            for k, v in pairs(G.GAME.probabilities) do 
                                G.GAME.probabilities[k] = v + card.ability.extra.probability * 2 ^ #find_joker("Oops! All 6s")
                            end
                        elseif card.ability.extra.level == 3 then
                            card.ability.extra.hands = 1
                        elseif card.ability.extra.level == 4 then
                            card.ability.extra.discards = 1
                        end
                        card.children.floating_sprite:set_sprite_pos({x = math.min(card.ability.extra.level, 4), y = 7})
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({ -- flip card
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        card:flip();  
                        play_sound('card1', percent);
                        card:juice_up(0.3, 0.3);
                        return true
                    end
                }))
                return {message = sword_message, colour = sword_color, card = card}
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v - card.ability.extra.probability * 2 ^ #find_joker("Oops! All 6s")
        end
    end
}

SMODS.Joker{
    key = 'nazuna',
    loc_txt = {
        name = "Nazuna",
        text={
            "This Joker gains {X:mult,C:white} X#1# {} Mult",
            "per scoring {C:attention}Enhanced card{} played,",
            "{C:attention}keeps{} card {C:attention}Enhancement",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
        },
    },
    rarity = 4,
    cost = 20,
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 3},
    soul_pos = {x = 3, y = 4},
    config = {
        extra = {
            enhance_tally = 0,
            gain = .1
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.gain, 1 + center.ability.extra.gain*center.ability.extra.enhance_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_mult = 1 + card.ability.extra.gain*card.ability.extra.enhance_tally
            }
        end
        if not context.blueprint then
            local increase = 0
            if context.before then
                for k, v in ipairs(context.scoring_hand) do
                    if v.ability.name ~= "Default Base" then
                        card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + 1
                        increase = increase + 1
                    end
                end
                if next(find_joker("Midas Mask")) then
                    increase = #context.scoring_hand
                end
                if increase > 0 then
                    card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + increase
                    return {
                        card = card,
                        message = "X" .. card.ability.extra.gain * increase,
                        colour = G.C.x_mult
                    }
                end
            end
        end
    end
}

--[[
SMODS.Joker{
    key = 'Rekoj',
    loc_txt = {
        name = 'Rekoj',
        text = {
            '{C:mult}#1#{} Mult'
        }
    },
    rarity = 1,
    cost = 1,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 0},
    config = {extra = {mult = -4}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                mult_mod = card.ability.extra.mult,
                message = "" .. card.ability.extra.mult,
                colour = G.C.Mult
            }
        end
    end
}
]]