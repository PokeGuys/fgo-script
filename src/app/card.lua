Card = {}

Card.NP = { false, false, false }
Card.info = {}

function getRegion(pos, isNP)
    if (isNP) then
        return Region(500 + Config.CARD_NP_POSITION_OFFSET * (pos - 1), 80, 285, 435)
    end
    return Region(60 + Config.CARD_POSITION_OFFSET * (pos - 1), 530, 300, 400)
end

function defineAttribute(info)
    if (info.region:exists('buster.png', 0)) then
        info.rating = Config.BUSTER_CARD_RATING
        return Config.Buster
    elseif (info.region:exists('arts.png', 0)) then
        info.rating = Config.ARTS_CARD_RATING
        return Config.Arts
    elseif (info.region:exists('quick.png', 0)) then
        info.rating = Config.QUICK_CARD_RATING
        return Config.Quick
    end
    return Config.DEFAULT_CARD_ATTR
end

function Card.reset()
    Card.info = {
        {
            idx = 1,
            region = getRegion(1, true),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.NP_RATING,
            weak = 0,
            enabled = false
        },
        {
            idx = 2,
            region = getRegion(2, true),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.NP_RATING,
            weak = 0,
            enabled = false
        },
        {
            idx = 3,
            region = getRegion(3, true),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.NP_RATING,
            weak = 0,
            enabled = false
        },
        {
            idx = 4,
            region = getRegion(1, false),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.CARD_RATING,
            weak = 0,
            enabled = true
        },
        {
            idx = 5,
            region = getRegion(2, false),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.CARD_RATING,
            weak = 0,
            enabled = true
        },
        {
            idx = 6,
            region = getRegion(3, false),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.CARD_RATING,
            weak = 0,
            enabled = true
        },
        {
            idx = 7,
            region = getRegion(4, false),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.CARD_RATING,
            weak = 0,
            enabled = true
        },
        {
            idx = 8,
            region = getRegion(5, false),
            attribute = Config.DEFAULT_CARD_ATTR,
            rating = Config.CARD_RATING,
            weak = 0,
            enabled = true
        }
    }
    for i, NP in pairs(Card.NP) do
        Card.info[i].enabled = NP
    end
end

local function compare(a, b)
    return a.rating > b.rating
end

function Card.update()
    snapshot()
    Card.reset()
    for key, info in pairs(Card.info) do
        info.attribute = defineAttribute(info)
        if (info.attribute == Config.perference.attackType) then
            info.rating = info.rating * Config.CARD_PREFER_RATING
        end
        if (info.region:exists('card_paralyzed.png', 2)) then
            info.enabled = false
        elseif (info.region:exists('card_resist.png', 2)) then
            info.weak = -1
            info.rating = info.rating * Config.CARD_RESIST_RATING
        elseif (info.region:exists('card_weak.png', 2)) then
            info.weak = 1
            info.rating = info.rating * Config.CARD_WEAK_RATING
        end
        if (not info.enabled) then
            info.rating = 0
        end
    end
    table.sort(Card.info, compare)
    usePreviousSnap(false)
end

function Card.select()
    if (Card.info[1].idx < 4) then wait(2) end
    for i = 1, 3 do
        click(Card.info[i].region)
    end
end
