-- Provides readable examples for VP events and AddEnvControlEvent usage of Audio.



local MINE_SOUND = AssetRef["19_SoundPreset_33"]

    AudioAPI.PlayAudio(
        playerState,
        MINE_SOUND,
        2,
        1.0,
        false,
        false,
        playerState
    )