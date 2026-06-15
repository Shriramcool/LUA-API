-- ServerGameMain: editor-only GameMain for first-wave sandbox users.
-- Provides readable examples for VP events and AddEnvControlEvent usage.
---@class ServerGameMain:WoWGameMain
local ServerGameMain = {}


local BTN_MINE           = CreativeInstance["1_CreativeInstance_23643901204603489"]
local TXT_GOLD           = CreativeInstance["1_CreativeInstance_23643900769356918"]
local TXT_LEVEL          = CreativeInstance["1_CreativeInstance_23643901723335036"]
local MINE_SOUND         = AssetRef["19_SoundPreset_33"]
local BTN_POWER          = CreativeInstance["1_CreativeInstance_23643901613760218"]
local TXT_COST           = CreativeInstance["1_CreativeInstance_23643898886755838"]

local TXT_POWER          = CreativeInstance["1_CreativeInstance_23643901406115362"]
local BTN_SPEED          = CreativeInstance["1_CreativeInstance_23643899371476446"]
local TXT_SPEED          = CreativeInstance["1_CreativeInstance_23643901087714351"]
local TXT_SPEED1         = CreativeInstance["1_CreativeInstance_23643901146199260"]

local MINING_AREA        = CreativeInstance["1_CreativeInstance_23643901663060061"]
local MINE_EFFECT        = AssetRef["13_EffectPreset_100007"]

local ROCK_EFFECT_POINT1 = CreativeInstance["1_CreativeInstance_23643902141627860"]
local ROCK_EFFECT_POINT2 = CreativeInstance["1_CreativeInstance_23643899099263945"]
local ROCK_EFFECT_POINT3 = CreativeInstance["1_CreativeInstance_23643898601008428"]
local ROCK_EFFECT_POINT4 = CreativeInstance["1_CreativeInstance_23643898267922928"]

local NIGHT_WEATHER      = WeatherPreset["21_WeatherPreset_3"]
local RAIN_WEATHER       = WeatherPreset["21_WeatherPreset_6"]
local OVERCAST_WEATHER   = WeatherPreset["21_WeatherPreset_9"]
local SANDSTORM_WEATHER  = WeatherPreset["21_WeatherPreset_12"]

function ServerGameMain:ctor()
    print("[ServerGameMain]ctor")

    self.gold = 0
    self.power = 1
    self.upgradeCost = 10
    self.level = 1
    self.exp = 0
    self.expNeeded = 20
    self.speed = 1
    self.speedCost = 25
end

--- OnStart: Primary game main start callback. Called from host bridge _OnStart after the default game-process listener is registered.
function ServerGameMain:OnStart()
    print("[ServerGameMain]OnStart")
end

--- OnGameStart: Callback when game process enters start.
function ServerGameMain:OnGameStart()
    print("[ServerGameMain]OnGameStart")
    print("Mining Area ID =", MINING_AREA)
    print("BTN_MINE =", BTN_MINE)
    print("MINING_AREA =", MINING_AREA)
    print("MINING_AREA =", tostring(MINING_AREA))

    print("Weather =", tostring(EnvironmentAPI.GetWeatherId()))

    EnvironmentAPI.SetWeatherId(NIGHT_WEATHER)

    CustomUIAPI.SetWidgetVisible(nil, BTN_MINE, false)
    CustomUIAPI.SetTextContent(nil, TXT_GOLD, "Gold: 0")

    self:RefreshUI()

    -- Mine button
    self:AddVPEvent(
        RcEventIdDefine.CustomUIClicked,
        self.OnMineClicked,
        self,
        BTN_MINE
    )



    self:AddTimer(
        60,
        function()
            self:ChangeWeather()
        end,
        9999,
        60
    )

    -- Upgrade button
    self:AddVPEvent(
        RcEventIdDefine.CustomUIClicked,
        function(_, playerState)
            print("Upgrade Clicked")

            if self.gold >= self.upgradeCost then
                self.gold = self.gold - self.upgradeCost
                self.power = self.power + 1
                self.upgradeCost = self.upgradeCost * 2

                self:RefreshUI()
            end
        end,
        self,
        BTN_POWER
    )

    self:AddVPEvent(
        RcEventIdDefine.CustomUIClicked,
        function(_, playerState)
            if self.gold >= self.speedCost then
                self.gold = self.gold - self.speedCost

                self.speed = self.speed + 1

                self.speedCost = self.speedCost * 2

                self:RefreshUI()
            end
        end,
        self,
        BTN_SPEED
    )

    self:AddVPEvent(
        RcEventIdDefine.TriggerAreaEnter,
        self.OnEnterMiningArea,
        self,
        MINING_AREA
    )

    self:AddVPEvent(
        RcEventIdDefine.TriggerAreaLeave,
        self.OnExitMiningArea,
        self,
        MINING_AREA
    )


    self:RefreshUI()
end

function ServerGameMain:RefreshUI()
    CustomUIAPI.SetTextContent(nil, TXT_GOLD, "Gold: " .. tostring(self.gold))

    CustomUIAPI.SetTextContent(nil, TXT_COST,
        "Power Lv." .. tostring(self.power) .. " Cost: " .. tostring(self.upgradeCost))

    CustomUIAPI.SetTextContent(nil, TXT_POWER, "Power: " .. tostring(self.power - 1))

    CustomUIAPI.SetTextContent(nil, TXT_LEVEL, "Level: " .. tostring(self.level))

    CustomUIAPI.SetTextContent(nil, TXT_SPEED,
        "Speed Lv." .. tostring(self.speed) .. " Cost: " .. tostring(self.speedCost))

    CustomUIAPI.SetTextContent(nil, TXT_SPEED1, "Speed: " .. tostring(self.speed - 1))
end

function ServerGameMain:OnMineClicked(playerState)
    local rocks = {
        ROCK_EFFECT_POINT1,
        ROCK_EFFECT_POINT2,
        ROCK_EFFECT_POINT3,
        ROCK_EFFECT_POINT4
    }

    local randomRock = rocks[math.random(#rocks)]

    local pos = MarkPointAPI.GetLoc(randomRock)

    if pos then
        SceneEffectAPI.CreateSceneEffect(
            MINE_EFFECT,
            pos,
            2
        )
    end

    AudioAPI.PlayAudio(
        playerState,
        MINE_SOUND,
        2,
        1.0,
        false,
        false,
        playerState
    )


    self.gold = self.gold + (self.power * self.speed)
    self.exp = self.exp + 1

    if self.exp >= self.expNeeded then
        self.exp = 0
        self.level = self.level + 1
        self.expNeeded = self.expNeeded + 20
        self.power = self.power + 1
    end

    self:RefreshUI()
end

function ServerGameMain:OnEnterMiningArea(triggerArea, character)
    print("Entered Mining Area")
    print("TRIGGER WORKS 1")


    CustomUIAPI.SetWidgetVisible(
        character,
        BTN_MINE,
        true
    )
end

function ServerGameMain:OnExitMiningArea(triggerArea, character)
    print("Exited Mining Area")
    print("TRIGGER WORKS 2 ")

    CustomUIAPI.SetWidgetVisible(
        character,
        BTN_MINE,
        false
    )
end

function ServerGameMain:ChangeWeather()
    local rnd = math.random(1, 3)

    if rnd == 1 then
        EnvironmentAPI.SetWeatherId(RAIN_WEATHER)
        print("Weather changed to Rain")
    elseif rnd == 2 then
        EnvironmentAPI.SetWeatherId(OVERCAST_WEATHER)
        print("Weather changed to Overcast")
    else
        EnvironmentAPI.SetWeatherId(SANDSTORM_WEATHER)
        print("Weather changed to Sandstorm")
    end

    print("Weather Changed" .. rnd)
end

--- OnGameEnd: Called when game process finishes.
function ServerGameMain:OnGameEnd()
    print("[ServerGameMain]OnGameEnd")
end

--- OnDestroy: Cleanup callback before sandbox VM release. VP events registered via AddVPEvent are auto-removed after this callback returns
function ServerGameMain:OnDestroy()
    print("[ServerGameMain]OnDestroy")
end

local CWoWGameMain = require("EnvLua.Core.WoWGameMain")
local CServerGameMain = WoWClass(CWoWGameMain, nil, ServerGameMain)
return CServerGameMain
