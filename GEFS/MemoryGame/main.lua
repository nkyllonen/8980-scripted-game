--Simple Example
print("Starting Lua for Memory Game")
require "CommonLibs/vec3"
math.randomseed(os.time())

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

-- state variables
boardSize = 4
flipVelocity = 4.0
maxFlipTime = 2.0
flippedUpTime = 0.0
firstFlipped = nil
secondFlipped = nil

-- board state variables
spacingY = 1.1 --Give a small space between grid cells to create boundries
startingY = -.6
startingZ = -1.8
spacingZ = 1.2

-- arrays containing world objects
tiles = {} -- array mapping index --> modelID
tileItems = {} -- array mapping index --> item string
items = {"Tower", "Crystal", "Pug", "Sheep", "Ship", "Poplar", "Bottle", "Carrot"}
modelIndices = {} -- array mapping modelID --> index

-- array containing amount each tile has rotated in radians
flipped = {}

--Tile variables
gridLayer = 0
curPos = {}
colliders = {}

function frameUpdate(dt)
  -- update flippedUpTime
  if flippedUpTime > 0 then
    flippedUpTime = flippedUpTime + dt
  end

  -- check for match
  if firstFlipped and secondFlipped then
    -- print(tileItems[firstFlipped].." matches "..tileItems[secondFlipped].."?")
    if tileItems[firstFlipped] == tileItems[secondFlipped] then
      print("MATCH!!")
    end
  end

  if flippedUpTime > maxFlipTime then
    -- time is up
    print("time is up!")
    flippedUpTime = 0.0

    -- reset
    flipDown(firstFlipped)
    flipDown(secondFlipped)
    firstFlipped = nil
    secondFlipped = nil
  else
    -- flip non-zero models
    for idx, val in pairs(flipped) do
      if (val > 0) and (val < 3.14) then
        -- positive means flipping up
        rotateModel(tiles[idx], flipVelocity*dt, 0 , 1, 0)
        flipped[idx] = flipped[idx] + flipVelocity*dt
      elseif (val < 0) and (val > -3.14) then
        -- negative means flipping down
        rotateModel(tiles[idx], -1.0*flipVelocity*dt, 0 , 1, 0)
        flipped[idx] = flipped[idx] - flipVelocity*dt
      end
    end
  end
end

function keyHandler(keys)
  -- if keys.up then
  --   -- flip up random tile
  --   r = math.random(#tileItems)
  --   flipUp(r)
  -- end
end

-- Mouse handler
function mouseHandler(mouse)
  if (mouse.left and not haveClicked) then
    --See which grid item we clicked on
    hitID, dist = getMouseClickWithLayer(gridLayer)
    print("hitID: "..hitID)

    -- rotate that tile if it was valid
    if (hitID > -1) then
      flipUp(modelIndices[hitID])
    end

    haveClicked = true
  end
  if (not mouse.left) then
    haveClicked = false
  end
end

function flipUp(index)
  -- disallow flipping a rotating tile or flipping first tile
  if not (flipped[index] == 0) and (firstFlipped == index) then
    return
  end

  -- only flip 2 tiles
  if secondFlipped == nil then
    print("flipping up index " .. index)
    flipped[index] = 0.0001
    flippedUpTime = 0.0001

    -- keep track of which indices were flipped
    if firstFlipped == nil then
      firstFlipped = index
    else
      secondFlipped = index
    end

  end
end

function flipDown(index)
  -- if flipped up
  if not (index == nil) and flipped[index] > 0 then
    print("flipping down index " .. index)
    flipped[index] = -0.0001
  end
end

function initializeBoard()
  -- randomize order of tileItems
  shuffle(tileItems)

  -- Create a 4x4 grid of tiles
  -- fill tiles according to tileItems
  idx = 1
  for i = 0,3 do
    for j = 0,3 do
      pos = vec3(0, startingY + spacingY*i, startingZ + spacingZ*j)
      tiles[idx] = addModel(tileItems[idx].."Tile", pos.x, pos.y, pos.z)
      modelIndices[tiles[idx]] = idx
      --Grid cell needs a collider for click interaction
      colliders[tiles[idx]] = addCollider(tiles[idx], gridLayer, 0.6, 0, 0, 0)
      idx = idx + 1
    end
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

-- fill tileItems, 2 at a time
idx = 1
for i = 1, boardSize*boardSize, 2 do
  tileItems[i] = items[idx]
  flipped[i] = 0

  tileItems[i+1] = items[idx]
  flipped[i+1] = 0
  idx = idx + 1
end

initializeBoard()