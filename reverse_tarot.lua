assert(SMODS.load_file('reverse_enhancements.lua'))()
assert(SMODS.load_file('reverse_jokers.lua'))()
assert(SMODS.load_file('reverse_blinds.lua'))()
assert(SMODS.load_file('reverse_tarot_cards.lua'))()
assert(SMODS.load_file('reverse_zodiac.lua'))()
assert(SMODS.load_file('deck_skins.lua'))()
assert(SMODS.load_file('reverse_challenges.lua'))()

SMODS.Atlas{
    key = 'Reverse_Jokers',
    path = 'Reverse_Jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Reverse_Tarots",
    path = "Reverse_Tarots.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "New_Enhance",
    path = "Enhancers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "New_Sticker",
    path = "stickers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Reverse_Bosses",
    path = "reverse_bosses.png",
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
}

SMODS.Atlas{
    key = "Zodiac_Booster",
    path = "reverse_boosters.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Reverse_Vouchers",
    path = "reverse_vouchers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Reverse_Tags",
    path = "reverse_tags.png",
    px = 34,
    py = 34
}

SMODS.Sticker{
    key = "ephemeral",
    atlas = "New_Sticker",
    pos = {x = 4, y = 2},
    badge_colour = HEX "1ad141",
    loc_txt = {
        label = "Ephemeral",
        name = "Ephemeral",
        text = {
            "Debuffed after",
            "{C:attention}#1#{} rounds",
            "Has no sell value",
            "{C:inactive}({}{C:attention}#2#{}{C:inactive} remaining)"
        }
    },
    default_compat = true,
    sets = {
        Joker = true
    },
    config = {
        extra = {
            total_turns = 3,
            turns_remaining = 3
        }
    },
    rate = 0,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability[self.key].extra.total_turns, center.ability[self.key].extra.turns_remaining}}
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val and copy_table(self.config)
        card.base_cost = 0
        return
    end,
    calculate = function(self, card, context)
        card.extra_value = 0
        card.sell_cost = 0
        card.base_cost = 0
        card:set_cost()
        if card.ability[self.key].extra.turns_remaining > 0 and context.end_of_round and context.main_eval then
            card.ability[self.key].extra.turns_remaining = card.ability[self.key].extra.turns_remaining - 1
            --print(card.ability[self.key].extra.turns_remaining)
        end
        if card.ability[self.key].extra.turns_remaining <= 0 then
            SMODS.debuff_card(card, true, self)
        end
    end
}

function is_rank(card, ranks)
    if SMODS.has_no_rank(card) and not card.vampired then return false end
    if is_omnirank(card) then return true end
    for _, value in ipairs(ranks) do
        if card.base.id == value then return true end
    end
    return false
end

function is_omnirank(card)
    if card.ability.name and not card.debuff then
        return card.ability.name == 'm_reverse_omnirank'
    end
    return false
end

function round(val)
    return math.floor(val + 0.5)
end

local align_hook = CardArea.align_cards

function CardArea:align_cards()
    align_hook(self)
    if self and G.P_CENTERS['c_fool'].atlas then
        if #self.cards > 0 then
            for k, card in ipairs(self.cards) do
                if card.config.center.mod then
                    if card.config.center.mod.id == "reverse_tarot" and card.config.center.set == "Tarot" then
                        card.children.center.role.r_bond = 'Weak'
                        card.children.center.role.role_type = 'Major'
                        local t = card.T
                        card.children.center.T = setmetatable({}, {
                            __index = function(_, k)
                                if k == "r" then
                                    return math.pi
                                end
                                return t[k]
                            end,
                            __newindex = function(_, k, v)
                                t[k] = v
                            end
                        })
                    end
                end
            end
        end
    end
end

local pack_hook = get_pack

function get_pack(_key, _type) --patch out modded packs if my challenges are active
    local ret = pack_hook(_key, _type)
    if G.GAME.challenge and string.find(G.GAME.challenge, "c_reverse") then
        while ret.mod do
            if ret.mod.id ~= "reverse_tarot" then
                print(ret.mod.id)
                ret = pack_hook(_key, _type)
            else
                break
            end
        end
    else
        ret = pack_hook(_key, _type)
    end
    return ret
end

local pool_hook = get_current_pool

function  get_current_pool(_type, _rarity, _legendary, _append) --patch out modded jokers, vouchers, consumeables, tags if my challenges are active
    local pool, pool_key =  pool_hook(_type, _rarity, _legendary, _append)
    if G.GAME.challenge and string.find(G.GAME.challenge, "c_reverse") then
        local pool_holder = ""
        for k, v in ipairs(pool) do
            if pool_holder == "" then
                if G.P_CENTERS[v] then
                    pool_holder = "P_CENTERS"
                elseif G.P_TAGS[v] then
                    pool_holder = "P_TAGS"
                end
            end
            if pool_holder ~= "" then
                if G[pool_holder][v] then
                    if G[pool_holder][v].mod and G[pool_holder][v].mod.id ~= "reverse_tarot" then
                        pool[k] = "UNAVAILABLE"
                    end
                end
            end
        end
    end
    local valid = false
    for k, v in ipairs(pool) do
        if v ~= "UNAVAILABLE" then valid = true break end
    end
    if not valid then --failsafe if pool has no eligible members?
        return get_current_pool("Tarot", _rarity, _legendary, _append)
    end
    return pool, pool_key
end

local hand_hook = evaluate_poker_hand

function evaluate_poker_hand(hand)
    local omni = {}
    local best_hand = nil
    for i=1, #hand, 1 do
        if hand[i].ability.name and not hand[i].debuff  then
            if is_omnirank(hand[i]) then
                table.insert(omni, i)
            end
        end
    end
    if #omni > 0 then
        return get_best_omnihand(omni, hand, best_hand, 1)
    else
        return hand_hook(hand)
    end
end

function get_best_omnihand(omni, hand, best_hand, iteration)
    if #omni <=3 then
        local current_card = omni[iteration]
        for i=2, 14, 1 do
            hand[current_card].base.id = i
            local current_hand = {}
            if #omni > iteration then
                current_hand = get_best_omnihand(omni, hand, best_hand, iteration + 1)
            else
                for j = 1, #hand, 1 do
                end
                --if new_straight(hand) then print("Straight!") end
                current_hand = hand_hook(hand)
            end
            best_hand = compare_hand(current_hand, best_hand)
        end
    elseif #omni == #hand and #omni == 4 then --if 4 cards played, no need to check for anything less than 4oaK
        --print("4 played, 4 hand size")
        if next(get_flush(hand)) then --if there is a flush, then it must be a straight flush (accounts for 4 fingers in get_flush())
            --print("straight flush")
            for i = 2, 5, 1 do
                hand[i-1].base.id = i
                --print(hand[i-1].base.id)
            end
            best_hand = hand_hook(hand)
        else
            --print("4oaK")
            for i = 1, 4, 1 do
                hand[i].base.id = 1
            end
            best_hand = hand_hook(hand)
        end
    else -- if 5 or more cards played (5oaK or Flush 5)
        --print("5oaK")
        correct_value = 1
        for j=1, #hand, 1 do
            if not is_omnirank(hand[j]) then
                correct_value = hand[j].base.id
            end
        end
        for j=1, #hand, 1 do
            if is_omnirank(hand[j]) then
                hand[j].base.id = correct_value
            end
        end
        current_hand = hand_hook(hand)
        best_hand = compare_hand(current_hand, best_hand)
    end
    return best_hand
end

function compare_hand(current_hand, best_hand)
    if best_hand then
        for _, v in ipairs(G.handlist) do
            if next(current_hand[v]) then return current_hand
            elseif next(best_hand[v])then return best_hand end 
        end
    else
        return current_hand
    end
end

function copy(obj, seen) --unused
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

function Card:is_secondary_suit(suit)
    local words = {}
    for w in self.ability.name:gmatch("([^_]+)") do
        table.insert(words, w) 
    end
    if words[3] == 'secondary' and not self.debuff then
        local new_suit = words[4]:gsub("^%l", string.upper) .. 's'
        if next(find_joker('Smeared Joker')) and (new_suit == 'Hearts' or new_suit == 'Diamonds') == (suit == 'Hearts' or suit == 'Diamonds') then
            return true
        else
            return new_suit == suit
        end
    end
    return false
end

function Card:has_secondary_suit()
    local words = {}
    for w in self.ability.name:gmatch("([^_]+)") do
        table.insert(words, w) 
    end
    if words[3] == 'secondary' and not self.debuff then
        return true
    end
    return false
end

-- eval evaluate_poker_hand_wrapper(G.hand.highlighted, 1)

function new_straight(hand) --unused
    local ace_high = {}
    local ace_low = {}
    local all_hands = {}
    length = next(SMODS.find_card('j_four_fingers')) and 4 or 5
    can_skip = next(SMODS.find_card('j_shortcut')) and 2 or 1
    if #hand >= length then
        for i=1, #hand, 1 do
            table.insert(ace_high, hand[i].base.id)
        end
        table.sort(ace_high)
        if ace_high[#ace_high] == 14 then
            for i=1, #hand, 1 do
                if hand[i].base.id == 14 then
                    table.insert(ace_low, 1)
                else
                    table.insert(ace_low, hand[i].base.id)
                end
            end
        end
        table.sort(ace_low)
        table.insert(all_hands, ace_high)
        if ace_low then table.insert(all_hands, ace_low) end
        for i=1, #all_hands, 1 do
            local cards_in_straight = {}
            for j=1, #hand-1, 1 do
                if (all_hands[i][j] == all_hands[i][j+1] or all_hands[i][j+1] - all_hands[i][j] > can_skip) and #cards_in_straight < length then
                    cards_in_straight = {all_hands[i][j+1]}
                elseif not (all_hands[i][j] == all_hands[i][j+1] or all_hands[i][j+1] - all_hands[i][j] > can_skip) then
                    if #cards_in_straight == 0 then
                        table.insert(cards_in_straight, all_hands[i][j])
                        table.insert(cards_in_straight, all_hands[i][j+1])
                    else
                        table.insert(cards_in_straight, all_hands[i][j+1])
                    end
                end
            end
            if #cards_in_straight >= length then
                final_cards = {}
                for index, value in ipairs(cards_in_straight) do
                    print(value)
                    for k=1, #hand, 1 do
                        if hand[k].base.id == value then
                            table.insert(final_cards, hand[k])
                            break
                        end
                    end
                end
                print(final_cards)
                return final_cards
            end
        end
    end
    return {}
end

--[[
target = "functions/misc_functions.lua"
pattern = '''function get_straight(hand)'''
position = "at"
payload = '''function old_straight(hand)'''
match_indent = true
times = 1
]]