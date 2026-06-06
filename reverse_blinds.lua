SMODS.Blind{
    key = "dagaz",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "The Pure",
        text = {
            "Debuffs the effects",
            "of all cards",
            "{C:attention}held in hand"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 1},
    boss_colour = HEX('28ADB5'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    set_blind = function(self)
        if self.disabled then return end
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(true)
        end
        return
    end,
    press_play = function(self)
        for _, v in ipairs(G.hand.highlighted) do
            v:set_debuff(false)
        end
        return
    end,
    disable = function(self)
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(false)
        end
        return
    end,
    defeat = function(self)
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(false)
        end
        return
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff
    end
}

SMODS.Blind{
    key = "berkano",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "The Companion",
        text = {
            "Debuffs the effects",
            "of every other card (1, 3, 5)",
            "{C:attention}in played hand"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 2},
    boss_colour = HEX('C71FC7'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    press_play = function(self)
        if not self.disabled then
            for i=0, #G.hand.highlighted do
                if i%2 == 1 then
                    G.hand.highlighted[i]:set_debuff(true)
                end
            end
        end
        return
    end,
    disable = function(self)
        self.disabled = true
        return
    end,
    defeat = function(self)
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(false)
        end
        return
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff
    end
}

SMODS.Blind{
    key = "perthro",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 2},
    loc_txt = {
        name = "The Change",
        text = {
            "Order of scored and held",
            "cards is randomized"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 2},
    boss_colour = HEX('BD2745'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    press_play = function(self)
        if not self.disabled then
            G.E_MANAGER:add_event(Event({ func = function() G.play:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
            delay(0.15)
            G.E_MANAGER:add_event(Event({ func = function() G.play:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
            delay(0.15)
            G.E_MANAGER:add_event(Event({ func = function() G.play:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
            delay(0.5)
            G.E_MANAGER:add_event(Event({ func = function() G.hand:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
            delay(0.15)
            G.E_MANAGER:add_event(Event({ func = function() G.hand:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
            delay(0.15)
            G.E_MANAGER:add_event(Event({ func = function() G.hand:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
            delay(0.5)
        end
        return
    end,
    disable = function(self)
        self.disabled = true
        return
    end
}

SMODS.Blind{
    key = "ehwaz",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 3},
    loc_txt = {
        name = "The Passage",
        text = {
            "Cards held in hand score",
            "instead of played cards",
            "{C:inactive}(scores as played hand)"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 3},
    boss_colour = HEX('BE721E'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    press_play = function(self)
        return
    end,
    drawn_to_hand = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end,
    disable = function(self)
        self.disabled = true
        return
    end
}

SMODS.Blind{
    key = "jera",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 4},
    loc_txt = {
        name = "The Abundant",
        text = {
            "Extra extra large blind",
            "X2 hands, X2 discards",
            "+2 hand size"
        }
    },
    dollars = 5,
    mult = 6,
    discovered = false,
    boss = {min = 2},
    boss_colour = HEX('8900A2'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    set_blind = function(self)
        if self.disabled then return end
        ease_hands_played(G.GAME.current_round.hands_left)
        ease_discard(G.GAME.current_round.discards_left)
        G.hand:change_size(2)
    end,
    disable = function(self)
        self.disabled = true
        ease_hands_played(-G.GAME.current_round.hands_left + G.GAME.current_round.hands_left/2)
        ease_discard(-G.GAME.current_round.discards_left + G.GAME.current_round.discards_left/2)
        G.hand:change_size(-2)
        G.GAME.blind.chips = G.GAME.blind.chips/3
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        return
    end,
    defeat = function(self)
        if self.disabled then return end
        G.hand:change_size(-2)
        return
    end
}

SMODS.Blind{
    key = "algiz",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 5},
    loc_txt = {
        name = "The Resistant",
        text = {
            "Base Hands and",
            "Discards are halved"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 2},
    boss_colour = HEX('969BC3'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    set_blind = function(self)
        if self.disabled then return end
        ease_hands_played(-G.GAME.current_round.hands_left + G.GAME.current_round.hands_left/2)
        ease_discard(-G.GAME.current_round.discards_left + G.GAME.current_round.discards_left/2)
    end,
    disable = function(self)
        if self.disabled then return end
        ease_hands_played(G.GAME.current_round.hands_left)
        ease_discard(G.GAME.current_round.discards_left)
        self.disabled = true
        return
    end
}

SMODS.Blind{
    key = "ansuz",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 6},
    loc_txt = {
        name = "The Vision",
        text = {
            "Only your most played hand",
            "{C:attention}#1#{} will score"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 2},
    boss_colour = HEX('B7D130'),
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.current_round.most_played_poker_hand}}
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if not self.disabled then
            if handname ~= G.GAME.current_round.most_played_poker_hand then
                return true
            end
        end
        return false
    end,
    disable = function(self)
        self.disabled = true
        return
    end,
    get_loc_debuff_text = function(self)
        return "Must play a " .. G.GAME.current_round.most_played_poker_hand
    end
}

SMODS.Blind{
    key = "hagalaz",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 7},
    loc_txt = {
        name = "The Destruction",
        text = {
            "Debuffs two random",
            "cards on draw"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 4},
    boss_colour = HEX('1E8267'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    drawn_to_hand = function(self)
        if not self.disabled then
            local debuff_count = 0
            local indices = {}
            for i=1, #G.hand.cards, 1 do
                --print(G.hand.cards[i].debuff)
                if not G.hand.cards[i].debuff then
                    table.insert(indices, i)
                end
            end
            --print(indices)
            if #indices <= 2 then
                for i=1, #G.hand.cards, 1 do
                    if not G.hand.cards[i].debuff then
                        G.hand.cards[i]:set_debuff(true)
                    end
                end
            else
                local first = math.floor(pseudorandom('debuff')*#indices) + 1
                G.hand.cards[indices[first]]:set_debuff(true)
                local second = math.floor(pseudorandom('debuff')*#indices) + 1
                while second == first do
                    second = math.floor(pseudorandom('debuff')*#indices) + 1
                end
                G.hand.cards[indices[second]]:set_debuff(true)
            end
        end
        return
    end,
    disable = function(self)
        --undebuff all cards in deck
        self.disabled = true
        return
    end,
}

function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.pool_flags.crt_extinct = G.GAME.pool_flags.crt_extinct
    G.GAME.eligible_blinds = {
        'bl_hook',
        'bl_ox',
        'bl_arm',
        'bl_club',
        --'bl_wheel',
        --'bl_fish',
        'bl_psychic',
        'bl_goad',
        'bl_plant',
        'bl_serpent',
        'bl_pillar',
        'bl_head',
        'bl_tooth',
        'bl_flint',
        --'bl_mark',
        'bl_reverse_berkano',
        'bl_reverse_dagaz',
        'bl_reverse_perthro',
        'bl_reverse_ansuz'
        --'bl_reverse_void'
    }
    G.GAME.blank_blind = G.GAME.blank_blind or G.GAME.eligible_blinds[math.floor(pseudorandom('blinds')*#G.GAME.eligible_blinds) + 1]
    G.GAME.blank_played = G.GAME.blank_played
    --G.GAME.blank_obj = Blind(G.GAME.blind.T.x, G.GAME.blind.T.y, G.GAME.blind.T.w, G.GAME.blind.T.h)
    --G.GAME.blank_obj:set_blind(G.P_BLINDS[G.GAME.blank_blind])
    G.GAME.beast_wave = G.GAME.beast_wave
    G.GAME.famine_hands = G.GAME.famine_hands
    G.GAME.beast_prepped = G.GAME.beast_prepped
    G.GAME.beast_blinds = {
        'bl_reverse_final_famine',
        'bl_reverse_final_pestilence',
        'bl_reverse_final_war',
        'bl_reverse_final_death',
        'bl_reverse_final_beast_dummy'
    }
    G.GAME.day = G.GAME.day
    G.GAME.fool_table = {
        "c_mercury",
        "c_venus",
        "c_earth",
        "c_mars",
        "c_jupiter",
        "c_saturn",
        "c_uranus",
        "c_neptune",
        "c_pluto",
        "c_planet_X",
        "c_ceres",
        "c_eris",
        "c_reverse_janus",
        "c_reverse_aquarius",
        "c_reverse_pisces",
        "c_reverse_aries",
        "c_reverse_taurus",
        "c_reverse_gemini",
        "c_reverse_cancer",
        "c_reverse_leo",
        "c_reverse_virgo",
        "c_reverse_libra",
        "c_reverse_scorpio",
        "c_reverse_sagittarius",
        "c_reverse_capricorn",
        "c_reverse_ophiuchus",
    }
    return
end

SMODS.Blind{
    key = "blank",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 8},
    loc_txt = {
        name = "The Blank",
        text = {
            "Random Boss effect",
            "activates each hand",
            "Currently active: #1#"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 6},
    boss_colour = HEX('ECECEC'),
    set_blind = function(self)
        G.GAME.blank_played = false
        G.GAME.blank_obj = Blind(G.GAME.blind.T.x, G.GAME.blind.T.y, G.GAME.blind.T.w, G.GAME.blind.T.h)
        G.GAME.blank_obj:set_blind(G.P_BLINDS[G.GAME.blank_blind])
        --G.GAME.blind.boss_colour = G.GAME.blank_obj.boss_colour
        self.disabled = false
        return
    end,
    loc_vars = function(self, info_queue, center)
        if G.P_BLINDS[G.GAME.blank_blind] then
            return {vars = {G.localization.descriptions.Blind[G.GAME.blank_blind].name}}
        end
        return {vars = {'[Blind name]'}}
    end,
    press_play = function(self)
        G.GAME.blank_played = true
        G.GAME.blank_obj:press_play()
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        if not self.disabled then
            if G.GAME.blank_blind == 'bl_flint' then
                --print('flint')
                return math.max(math.floor(mult*0.5 + 0.5), 1), math.max(math.floor(hand_chips*0.5 + 0.5), 0), true
            end
        end
        return mult, hand_chips, false
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if not self.disabled then
            self.triggered = false
            if G.GAME.blank_blind == 'bl_psychic' then
                if #cards < 5 then
                    self.triggered = true
                    return true
                end
            elseif G.GAME.blank_blind == 'bl_reverse_ansuz' then
                if handname ~= G.GAME.current_round.most_played_poker_hand then
                    self.triggered = true
                    return true
                end
            elseif G.GAME.blank_blind == 'bl_ox' then
                if handname == G.GAME.current_round.most_played_poker_hand then
                    self.triggered = true
                    if not check then
                        ease_dollars(-G.GAME.dollars, true)
                    end
                end
            elseif G.GAME.blank_blind == 'bl_arm' then
                if G.GAME.hands[handname].level > 1 then
                    self.triggered = true
                    if not check then
                        level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -1)
                        G.GAME.blind:wiggle()
                    end
                end
            end
        end
    end,
    drawn_to_hand = function(self)
        if not self.disabled then
            if G.GAME.blank_played then
                G.GAME.blank_blind = G.GAME.eligible_blinds[math.floor(pseudorandom('blinds')*#G.GAME.eligible_blinds) + 1]
                G.GAME.blank_obj = Blind(G.GAME.blind.T.x, G.GAME.blind.T.y, G.GAME.blind.T.w, G.GAME.blind.T.h)
                G.GAME.blank_obj:set_blind(G.P_BLINDS[G.GAME.blank_blind])
                G.GAME.blind:set_text()
            end
            G.GAME.blank_obj:change_colour()
            --print(G.GAME.blank_obj)
            --print(G.GAME.blank_played)
            --print(G.GAME.blank_blind)
            G.GAME.blank_played = false
            return
        end
    end,
    stay_flipped = function(area, card)
        --[[
        if not G.GAME.blind.disabled then
            if area == G.hand then
                if G.GAME.blank_blind == 'bl_wheel' and pseudorandom(pseudoseed('wheel')) < G.GAME.probabilities.normal/7 then
                    return true
                elseif G.GAME.blank_blind == 'bl_mark' and card:is_face(true) then
                    return true
                elseif G.GAME.blank_blind == 'bl_fish' and G.GAME.blank_played then 
                    return true
                end
            end
        end
        ]]
    end,
    disable = function(self)
        --undebuff all cards in deck?
        self.disabled = true
        return
    end,
}

SMODS.Blind{
    key = "black",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 9},
    loc_txt = {
        name = "The Void",
        text = {
            "Removes {C:attention}Enhancements{} from all",
            "scored cards after scoring"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 6},
    boss_colour = HEX('252525'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    --implementation is done through patch
    disable = function(self)
        self.disabled = true
        return
    end,
}

SMODS.Blind{
    key = "final_beast_dummy",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 10},
    loc_txt = {
        name = "The Beast",
        text = {
            "The end is nigh",
            " ",
        }
    },
    mult = 2,
    no_collection = true,
    discovered = false,
    boss = {min = 6},
    in_pool = function(self)
        return false
    end,
    boss_colour = HEX('C72A00'),
    loc_vars = function(self, info_queue, center)
        return {vars = {"Be", "not", "afraid"}}
    end,
    --implementation is done through patch
    disable = function(self)
        self.disabled = true
        return
    end,
}

SMODS.Blind{
    key = "final_famine",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 11},
    loc_txt = {
        name = "The Famine",
        text = {
            "-2 Hand Size",
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('613333'),
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, center)
        return
    end,
    set_blind = function(self)
        if self.disabled or G.GAME.famine_hands then
            return
        else
            G.hand:change_size(-2)
            G.GAME.famine_hands = G.hand.config.card_limit
        end
    end,
    disable = function(self)
        self.disabled = true
        G.hand:change_size(2)
        return
    end,
    defeat = function(self)
        if self.disabled then return end
        G.hand:change_size(2)
        return
    end
}

SMODS.Blind{
    key = "final_pestilence",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 12},
    loc_txt = {
        name = "The Pestilence",
        text = {
            "Debuffs scored cards",
            "for all future waves"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('42694B'),
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, center)
        return
    end,
    --debuff effect handled in patches a la The Void
    disable = function(self)
        self.disabled = true
        return
    end,
}

SMODS.Blind{
    key = "final_war",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 13},
    loc_txt = {
        name = "The Warrior",
        text = {
            "Two random Jokers",
            "disabled each Hand"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('862D2D'),
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, center)
        return
    end,
    set_blind = function(self)
        if self.disabled then end
        self.prepped = true
        if self.prepped then
            for k, v in pairs(G.jokers.cards) do
                if v.debuff then
                    v:set_debuff(false)
                end
            end
            if #G.jokers.cards <= 2 then
                for k, v in pairs(G.jokers.cards) do
                    v:set_debuff(true)
                end
            else
                local _card1 = pseudorandom_element(G.jokers.cards, pseudoseed('crimson_heart'))
                local _card2 = pseudorandom_element(G.jokers.cards, pseudoseed('crimson_heart'))
                while _card1 == _card2 do
                    _card2 = pseudorandom_element(G.jokers.cards, pseudoseed('crimson_heart'))
                end
                _card1:set_debuff(true)
                _card2:set_debuff(true)
            end
        end
        self.prepped = nil
    end,
    press_play = function(self)
        self.prepped = true
    end,
    drawn_to_hand = function(self)
        if self.disabled then end
        print("t1", G.GAME.blind.prepped)
        if self.prepped then
            for k, v in pairs(G.jokers.cards) do
                if v.debuff then
                    v:set_debuff(false)
                end
            end
            if #G.jokers.cards <= 2 then
                for k, v in pairs(G.jokers.cards) do
                    v:set_debuff(true)
                end
            else
                local _card1 = pseudorandom_element(G.jokers.cards, pseudoseed('crimson_heart'))
                local _card2 = pseudorandom_element(G.jokers.cards, pseudoseed('crimson_heart'))
                while _card1 == _card2 do
                    _card2 = pseudorandom_element(G.jokers.cards, pseudoseed('crimson_heart'))
                end
                _card1:set_debuff(true)
                _card2:set_debuff(true)
            end
        end
        self.prepped = nil
    end,
    disable = function(self)
        self.disabled = true
        for k, v in pairs(G.jokers.cards) do
            if v.debuff then
                v:set_debuff(false)
            end
        end
        return
    end,
    defeat = function(self)
        for k, v in pairs(G.jokers.cards) do
            if v.debuff then
                v:set_debuff(false)
            end
        end
    end
}

SMODS.Blind{
    key = "final_death",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 14},
    loc_txt = {
        name = "The Reaper",
        text = {
            "Destroys leftmost played card",
            "before hand is scored"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('929292'),
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, center)
        return
    end,
    press_play = function(self)
        
    end,
    disable = function(self)
        self.disabled = true
        return
    end,
}

SMODS.Blind{
    key = "final_beast",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 10},
    loc_txt = {
        name = "The Beast",
        text = {
            "Face the gauntlet...",
            "#1#",
            "#2#",
            "#3#"
        }
    },
    dollars = 8,
    mult = 1.5,
    discovered = false,
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('C72A00'),
    loc_vars = function(self, info_queue, center)
        if G.GAME.beast_wave then
            if #G.localization.descriptions.Blind[G.GAME.beast_wave].text == 1 then
                return {vars = {G.localization.descriptions.Blind[G.GAME.beast_wave].name, G.localization.descriptions.Blind[G.GAME.beast_wave].text[1], " "}}
            else
                return {vars = {G.localization.descriptions.Blind[G.GAME.beast_wave].name, G.localization.descriptions.Blind[G.GAME.beast_wave].text[1], G.localization.descriptions.Blind[G.GAME.beast_wave].text[2]}}
            end
        else
            return {vars = {"Be", "not", "afraid"}}
        end
    end,
    collection_loc_vars = function (self)
        return {vars = {"Be", "not", "afraid"}}
    end,
    set_blind = function(self)
        local current_blind = 1
        for k, v in ipairs(G.GAME.beast_blinds) do
            if v == G.GAME.beast_wave then
                current_blind = k
            end
        end
        if G.GAME.beast_wave == 'bl_reverse_final_war' then
            G.GAME.beast_prepped = true
        end
        G.GAME.beast_wave = G.GAME.beast_blinds[current_blind]
        G.GAME.blind.children.animatedSprite:set_sprite_pos(G.P_BLINDS[G.GAME.beast_wave].pos)
        G.GAME.blind:set_text()
        G.GAME.blank_obj = Blind(G.GAME.blind.T.x, G.GAME.blind.T.y, G.GAME.blind.T.w, G.GAME.blind.T.h)
        G.GAME.blank_obj:set_blind(G.P_BLINDS[G.GAME.beast_blinds[current_blind]])
        G.GAME.blank_obj:set_text()
        G.GAME.blank_obj:change_colour()
        --print(G.GAME.beast_prepped)
        --print(G.GAME.beast_wave)
        if G.GAME.beast_prepped and G.GAME.beast_wave == 'bl_reverse_final_war' then
            for k, v in pairs(G.jokers.cards) do
                if v.debuff then
                    v:set_debuff(false)
                end
            end
            if #G.jokers.cards <= 2 then
                for k, v in pairs(G.jokers.cards) do
                    v:set_debuff(true)
                end
            else
                temp_hand = {}
                for k, v in ipairs(G.jokers.cards) do temp_hand[#temp_hand+1] = v end
                pseudoshuffle(temp_hand, pseudoseed('crimson_heart'))
                temp_hand[1]:set_debuff(true)
                temp_hand[2]:set_debuff(true)
            end
        end
        G.GAME.beast_prepped = nil
    end,
    press_play = function(self)
        if self.disabled then return end
        G.GAME.beast_prepped = true
    end,
    drawn_to_hand = function(self)
        G.GAME.blank_obj:set_text()
        G.GAME.blind.children.animatedSprite:set_sprite_pos(G.P_BLINDS[G.GAME.beast_wave].pos)
        if self.disabled then return end
        if G.GAME.blank_played then
            G.GAME.blank_obj:set_blind(G.P_BLINDS[G.GAME.beast_wave])
            G.GAME.blind:set_text()
        end
        G.GAME.blank_obj:change_colour()
        if G.GAME.beast_prepped and G.GAME.beast_wave == 'bl_reverse_final_war' then
            for k, v in pairs(G.jokers.cards) do
                if v.debuff then
                    v:set_debuff(false)
                end
            end
            if #G.jokers.cards <= 2 then
                for k, v in pairs(G.jokers.cards) do
                    v:set_debuff(true)
                end
            else
                temp_hand = {}
                for k, v in ipairs(G.jokers.cards) do temp_hand[#temp_hand+1] = v end
                pseudoshuffle(temp_hand, pseudoseed('crimson_heart'))
                temp_hand[1]:set_debuff(true)
                temp_hand[2]:set_debuff(true)
            end
        elseif G.GAME.beast_wave ~= 'bl_reverse_final_war' then
            for k, v in pairs(G.jokers.cards) do
                if v.debuff then
                    v:set_debuff(false)
                end
            end
        end
        G.GAME.beast_prepped = nil
        G.GAME.blank_played = false
    end,
    disable = function(self)
        self.disabled = true
        for k, v in ipairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'bl_reverse_final_pestilence')
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up()
                    return true
                end
            }))
        end
        for k, v in ipairs(G.jokers.cards) do
            if v.debuff then
                v:set_debuff(false)
            end
        end
    end,
    defeat = function(self)
        self.disabled = true
        G.GAME.beast_wave = nil
        for k, v in ipairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'bl_reverse_final_pestilence')
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up()
                    return true
                end
            }))
        end
        for k, v in ipairs(G.jokers.cards) do
            if v.debuff then
                v:set_debuff(false)
            end
        end
    end,
}

SMODS.Blind{
    key = "final_delirium",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 15},
    loc_txt = {
        name = "The Delirium",
        text = {
            "Insert effect here"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    in_pool = function(self)
        return false
    end,
    no_collection = true,
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('E3E3E3'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    disable = function(self)
        self.disabled = true
        return
    end,
}