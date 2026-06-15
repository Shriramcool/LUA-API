-- Provides readable examples for VP events and AddEnvControlEvent usage of Weathe.

local NIGHT_WEATHER     = WeatherPreset["21_WeatherPreset_3"]
local RAIN_WEATHER      = WeatherPreset["21_WeatherPreset_6"]
local OVERCAST_WEATHER  = WeatherPreset["21_WeatherPreset_9"]
local SANDSTORM_WEATHER = WeatherPreset["21_WeatherPreset_12"]

-- Console debugging
print("Weather =", tostring(EnvironmentAPI.GetWeatherId()))

-- Set WeatherPreset when Player Spwan first time.
EnvironmentAPI.SetWeatherId(NIGHT_WEATHER)

-- AddEnvControlEvent before adding ChangeWeather function
    self:AddTimer(
        60,
        function()
            self:ChangeWeather()
        end,
        9999,
        60
    )

-- ChangeWeather
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
