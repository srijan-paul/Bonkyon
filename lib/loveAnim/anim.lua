  local SpriteSheet = {}


function SpriteSheet:new(imagePath, hFrames, vFrames)
  newSheet = {
    _imageData = {source = nil, rows = 0, cols = 0},
    frameWidth = 0, frameHeight = 0
  }

  if type(imagePath) == 'string' then
    newSheet._imageData.source = love.graphics.newImage(imagePath)
  else  newSheet._imageData.source = imagePath end

  if newSheet._imageData.source == nil then return nil end

  -- set spritesheet grid dimensions

  local width, height = newSheet._imageData.source:getDimensions()
  newSheet.frameWidth = width / hFrames
  newSheet.frameHeight = height / vFrames

  newSheet._imageData.cols = width  / newSheet.frameWidth
  newSheet._imageData.rows = height / newSheet.frameHeight

  -- set of all the quads that can be accessed by indexing

  newSheet._frames = {}

  local r,c  = newSheet._imageData.rows, newSheet._imageData.cols

  for i = 1, r do
    for j = 1,c do
      newSheet._frames[(i - 1) * r + j] =
          love.graphics.newQuad(newSheet.frameWidth * (j - 1) ,
              newSheet.frameHeight * (i - 1),
              newSheet.frameWidth,
              newSheet.frameHeight,
              newSheet._imageData.source:getDimensions())
    end
  end

  self.__index = self
  return setmetatable(newSheet, self)
end


function SpriteSheet:showFrame(frameIndex, x, y, r, sx, sy)

  if frameIndex > table.getn(self._frames) or frameIndex <= 0 then
    return nil
  end

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self._imageData.source,
      self._frames[frameIndex],
      x, y, r, sx, sy)
end


-- The animation table contains data about the the 'Frame set' which is a
-- collection of frames in a spritesheet.

local Animation = {}


function Animation:new(spriteSheet, s, e, t, l)
  newAnim = {
    sheet = spriteSheet,
    startIndex = s,
    endIndex = e,
    duration = t,
    loop = l,
    currentIndex = s,
    frameCount = e - s + 1,
    timeElapsed = 0
  }

  assert(newAnim.frameCount >= 0)
  self.__index = self
  return setmetatable(newAnim, self)
end


function Animation.newSpriteSheet(path, hFrames, vFrames)
  return SpriteSheet:new(path, hFrames, vFrames)
end


function Animation:update(dt)
  self.timeElapsed = self.timeElapsed + dt
  if self.timeElapsed >= self.duration then
    if self.currentIndex + 1 > self.frameCount then
      if self.loop then self.currentIndex = self.startIndex end
    else
      self.currentIndex = self.currentIndex + 1
    end
    self.timeElapsed = 0
  end
end


function Animation:show(x, y, r, sx, sy)
  self.sheet:showFrame(self.currentIndex, x, y, r, sx, sy)
end

return Animation
