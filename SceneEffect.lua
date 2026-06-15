-- Provides readable examples for VP events and AddEnvControlEvent usage of SceneEffectAPI.


local MINE_EFFECT = AssetRef["13_EffectPreset_100007"]


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
end    