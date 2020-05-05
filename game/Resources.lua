local name = require "lib/loveAnim/anim"
local Resources = {
    Audio = {},
    Image = {},
    UITexture = {},
    Fonts = {}
}

function Resources.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Textures and spritesheets
    Resources.TileTexture = love.graphics.newImage("assets/images/tileset_light_2t.png")
    Resources.DevilTexture = love.graphics.newImage("assets/images/devilGuy.png")
    Resources.AngelTexture = love.graphics.newImage("assets/images/angelGuy.png")
    Resources.UITexture.Button = love.graphics.newImage("assets/images/button_pink.png")
    -- Fonts
    Resources.Fonts.PixelFont = love.graphics.newFont("assets/font/font.ttf", 20)
    Resources.Fonts.PixelFontLarge = love.graphics.newFont("assets/font/font.ttf", 30)
    Resources.Fonts.MenuFont = love.graphics.newFont("assets/font/west_england.ttf", 20)
    -- Audio
    Resources.Audio.Jump = love.audio.newSource("assets/sounds/jump.wav", "static")
    Resources.Audio.Jump:setVolume(1)
    Resources.Image.Logo = love.graphics.newImage("assets/images/bonkyon_logo_final.png")
    Resources.Audio.WhooshOut = love.audio.newSource("assets/sounds/59988__qubodup__swosh-01-44-1khz.flac", "static")
    Resources.Audio.WhooshIn = love.audio.newSource("assets/sounds/60029__qubodup__swosh-42.flac", "static")
    Resources.Audio.Button = love.audio.newSource("assets/sounds/219477__jarredgibb__button-04.wav", "static")
    Resources.Audio.Track =
        love.audio.newSource(
        "assets/sounds/166392__questiion__8bit-blix-aka-lost-moons-make-me-a-game-snippet-notify-if-longer-version-is-needed.wav",
        "static"
    )
    Resources.Audio.Track:setVolume(0.8)
    Resources.Audio.Track:setLooping(true)
    Resources.Audio.GameOver = love.audio.newSource("assets/sounds/442127__euphrosyyn__8-bit-game-over.wav", "static")
    Resources.Audio.Win = love.audio.newSource("assets/sounds/253887__themusicalnomad__positive-beeps.wav", "static")
end

return Resources
