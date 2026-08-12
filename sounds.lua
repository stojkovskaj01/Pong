local Sounds = {}

function Sounds.createSound(frequency, duration, volume)

    local sampleRate = 44100

    local samples =
        math.floor(sampleRate * duration)

    local soundData =
        love.sound.newSoundData(
            samples,
            sampleRate,
            16,
            1
        )

    for i = 0, samples - 1 do

        local t = i / sampleRate

        local value =
            math.sin(
                2 * math.pi * frequency * t
            )

        local fade =
            1 - (i / samples)

        soundData:setSample(
            i,
            value * fade * volume
        )
    end

    return love.audio.newSource(
        soundData,
        "static"
    )
end

return Sounds