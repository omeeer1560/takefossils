-- made by omeeer#1560 KEV STORE --
-- https://discord.gg/WxJTF38YpJ --


-- FARM LIST --
farmList = {"",""} -- farm worlds can multiworld
doorFarm = "" -- farm world door id

-- STORAGE WORLD --
storageWorld = "" -- storage world name
storageID  = "" -- storage world door id

-- ADD BOT --
addBotCustom = true   --true/false set true if want add bot
botname = "" 
passwordbot = ""

-- OTHER SETTINGS --
webhook = "" -- Discord webhook
maxFossilBP = 3 -- max fossil in backpack to drop






-- DONT CHANGE ANYTHING HERE --


--[ KETIBAN FUCKTA ]-- 
ddrop  = 20 --

if addBotCustom then
    addBot(botname, passwordbot)
    sleep(5000)
end

local hammer = 3932 --[ DON'T CHANGE! ]--
local chisel = 3934 --[ DON'T CHANGE! ]--
local rock   = 10   --[ DON'T CHANGE! ]--
local brush  = 4132 --[ DON'T CHANGE! ]--
local poli   = 4134 --[ DON'T CHANGE! ]--

function webhook(status)
    local wh = {}
    wh.url = webhook
    wh.username = "TakeFOSSIL"
    wh.content = status
    webhook(wh)
end


local function join(world,id)
    sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
    sleep(5000)
    while getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 do
        sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
        sleep(1000)
    end
end

local function goPos(pos) 
    for _, tile in pairs(getTiles()) do
        if tile.fg == pos or tile.bg == pos then
            findPath(tile.x - 1,tile.y)
            sleep(700)
        end
    end
end


local function scanFossil()
    local count = 0
    for _, tile in pairs(getTiles()) do
        if tile.fg == 3918 then
            count = count + 1
        end
    end
    return count
end

local function goFloat(id)
    for _, obj in pairs(getObjects()) do
        if obj.id == id then
            collectSet(true,3)           
            if (getTile(math.floor((obj.x+10)/32),math.floor((obj.y+10)/32)).flags == 0 or 
                getTile(math.floor((obj.x+10)/32),math.floor((obj.y+10)/32)).flags == 2) then
                findPath(math.floor((obj.x+10)/32),math.floor((obj.y+10)/32))
                sleep(1000)
                return true
            end
        end
    end
  return false
end

local function dropeh(world,id,itemid)
    join(world,id)
    sleep(1000)
    goPos(ddrop)
    sleep(1000)
    collectSet(false,3)
    sleep(500)
    while findItem(itemid) ~= 0 do
        drop(itemid)
        sleep(1000)
        move(-1,0)
        sleep(800)
    end
end

local function takeBanh(world,id)
    join(world,id)
    sleep(1000)
    if findItem(hammer) == 0 or findItem(chisel) == 0 then
        goFloat(hammer)
        sleep(800)
        move(-1,0)
        sleep(500)
        if findItem(hammer) ~= 1 then
            collectSet(false,3)
            sleep(500)
            drop(hammer,(findItem(hammer)-1))
            sleep(800)
        end
        if findItem(chisel) ~= 1 then
            collectSet(false,3)
            sleep(500)
            drop(chisel,(findItem(chisel)-1))
            sleep(800)
        end
    end
    goFloat(brush)
    sleep(1000)
    goFloat(rock)
    sleep(1000)
    collectSet(false,3)
end

gebuk = true
local function hoek(v) 
    if v[0] == "OnTalkBubble" and v[2]:find("I unearthed a Fossil") then 
        gebuk = false 
        sleep(1000)
    end 
end 

addHook("w",hoek)


say("/love")
sleep(1500)
local nFarms = 1
::etdah::
for nFarm = nFarms,#farmList do 
    ::join::
    join(farmList[nFarm],doorFarm)
    sleep(1000)
    ::lagi::
    if scanFossil() == 0 then
        if nFarms == #farmList then
        end
        nFarms = nFarms + 1
        goto etdah
    elseif scanFossil() > 0 then
        for _, tile in pairs(getTiles()) do 
            if tile.fg == 3918 then
                if findItem(hammer) == 0 or findItem(chisel) == 0 or findItem(brush) == 0 or findItem(rock) == 0 then
                    takeBanh(storageWorld,storageID)
                    sleep(1500)
                    goto join
                end
                findPath(tile.x,tile.y-1)
                sleep(800)
                if not findClothes(hammer) then
                    wear(hammer)
                    sleep(500)
                end
                while getTile(math.floor(getBot().x/32),math.floor(getBot().y/32)+1).fg == 3918 and gebuk do
                    for i = 1,10 do
                        punch(0,1)
                        sleep(5500)
                        if not gebuk then
                            break
                        end
                    end
                end
                wear(chisel)
                sleep(1000)
                while getTile(math.floor(getBot().x/32),math.floor(getBot().y/32)+1).fg == 3918 do
                    punch(0,1) 
                    sleep(180)
                end
                sleep(1000)
                place(brush,0,1)
                sleep(1500)
                collectSet(true,3)
                sleep(800)
                place(rock,0,1)
                sleep(2000)
                collectSet(false,3)
                gebuk = true
            end
        end
        if findItem(poli) >= maxFossilBP then
            dropeh(storageWorld,storageID,poli)
            sleep(1500)
            goto etdah
        else
            goto lagi
        end
    end
end
if findItem(hammer) ~= 0 or findItem(chisel) ~= 0 or findItem(brush) ~= 0 or findItem(poli) ~= 0 then
    join(storageWorld,storageID)
    say("`2Dropping items..")
    sleep(1000)
    drop(hammer)
    sleep(800)
    drop(chisel)
    sleep(800)
    drop(brush)
    sleep(800)
    drop(poli)
    sleep(800)
    drop(rock)
    sleep(800)
    say("`cAll fossils collected")
    sleep(1000)
    say("`4Removing bot..")
    removeBot(getBot().name)
end