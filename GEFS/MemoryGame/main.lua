--Simple Example
print("Starting Lua for Memory Game")

--Todo:
-- Lua modules (for better organization, and maybe reloading?)

require "CommonLibs/vec3"

CameraPosX = -6.0
CameraPosY = 1.0
CameraPosZ = 0.0

CameraDirX = 1.0
CameraDirY = -0.0
CameraDirZ = -0.0

CameraUpX = 0.0
CameraUpY = 1.0
CameraUpZ = 0.0

CameraPos = vec3(CameraPosX, CameraPosY, CameraPosZ)
CameraDir = vec3(CameraDirX, CameraDirY, CameraDirZ)
CameraUp = vec3(CameraUpX, CameraUpY, CameraUpZ)

animatedModels = {}
velModel = {}
rotYVelModel = {}

boardSize = 4
flipVelocity = 4.0

-- arrays containing world objects
tiles = {}
tileItems = {}
items = {"Tower", "Crystal", "Pug", "Sheep", "Ship", "Poplar", "Bottle", "Carrot"}
flipped = {}

-- fill tileItems, 2 at a time
idx = 1
for i = 1, boardSize*boardSize, 2 do
  tileItems[i] = items[idx]
  flipped[i] = 0
  tileItems[i+1] = items[idx]
  idx = idx + 1
end

function frameUpdate(dt)
  -- see which models we should be flipping
  for idx, val in pairs(flipped) do
    if math.abs(val) > 3.14 then
      flipped[idx] = 0
    elseif val > 0 then
      -- if flipped is true
      -- print("flipped @ " .. idx .. " is true")
      rotateModel(tiles[idx], flipVelocity*dt, 0 , 1, 0)
      flipped[idx] = flipped[idx] + flipVelocity*dt
    elseif val < 0 then
      rotateModel(tiles[idx], -1.0*flipVelocity*dt, 0 , 1, 0)
      flipped[idx] = flipped[idx] - flipVelocity*dt
    end
  end
end

function keyHandler(keys)
  if keys.up then
    -- flip up random tile
    -- TODO: flip on mouse clicks instead
    r = math.random(#tileItems)
    flipUp(r)
  end
  if keys.down then
    -- flip down previous? tile
    -- TODO: flip down on timed value
    if (flipped[r]) then
      flipDown(r)
    end
  end
end

function flipUp(index)
  print("flipping up index " .. index)
  flipped[index] = 0.1
end

function flipDown(index)
  print("flipping down index " .. index)
  flipped[index] = -0.1
end

function initializeBoard()
  -- randomize order of tileItems
  shuffle(tileItems)

  -- fill tiles according to tileItems
  local y = -0.8
  local z = -1.8
  for i = 1, boardSize*boardSize do
    -- if past end of row, move up to next row
    if z > 1.8 then
      y = y + 1.2
      z = -1.8
    end

    tiles[i] = addModel(tileItems[i] .. "Tile", 0, y, z)
    -- print("tiles[i] = " .. tiles[i])
    -- animatedModels[tiles[i]] = true
    -- rotYVelModel[tiles[i]] = 1

    print(tileItems[i] .. " @ index " .. i)
    z = z + 1.2
  end
end

-- shuffle copied from: https://gist.github.com/Uradamus/10323382
function shuffle(tbl)
  for i = #tbl, 2, -1 do
    -- swap item at the end with another before it
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

initializeBoard()