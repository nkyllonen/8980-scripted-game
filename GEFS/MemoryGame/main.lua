--Simple Example
print("Starting Lua for Memory Game")
require "CommonLibs/vec3"
math.randomseed(os.time())

splashMessage = [[Welcome to Memory Tiles!
Behind each of the tiles are
8 pairs of items, randomly
scrambled and waiting for
you to find!]]

endMessage = [[**Great job! You won!**
Right click anywhere to play the next level.
Otherwise, exit by pressing ESC.]]

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

-- Game state variables
boardSize = 4
flipVelocity = 4.0
maxFlipTime = 1.5
flippedUpTime = 0.0
firstFlipped = nil
secondFlipped = nil
match = false
finished = false
numMatches = 0

-- Board state variables
spacingY = 1.1 --Give a small space between grid cells to create boundries
startingY = -.6
startingZ = -1.8
spacingZ = 1.2

-- Arrays containing world objects
tiles = {}        -- array mapping index --> modelID
tileItems = {}    -- array mapping index --> item string
items = {"Tower", "Crystal", "Pug", "Sheep", "Ship", "Poplar", "Bottle", "Carrot"}
modelIndices = {} -- array mapping modelID --> index

-- Array containing amount each tile has rotated in radians
flipped = {}

--Tile variables
gridLayer = 0
curPos = {}
curScale = {}
colliders = {}

--Variables used for shrinking
animatedModels = {}
shrinkSpeed = 1

function frameUpdate(dt)
  -- check for winning state
  if numMatches == #tiles then
    finished = true
  end

  -- update flippedUpTime
  if flippedUpTime > 0 then
    flippedUpTime = flippedUpTime + dt
  end

  -- check for match
  if firstFlipped and secondFlipped and (tileItems[firstFlipped] == tileItems[secondFlipped]) then
    if match == false then
      -- increment matches
      numMatches = numMatches + 2
    end

    animatedModels[tiles[firstFlipped]] = true
    animatedModels[tiles[secondFlipped]] = true
    match = true
  end

  -- time is up
  if flippedUpTime > maxFlipTime then
    flippedUpTime = 0.0

    -- reset flipped tiles
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
  
  -- check if we need to start shrinking
  -- shrink as soon as second tile has flipped all the way
  if match and secondFlipped and (flipped[secondFlipped] > 3.14) then
    shrinking(dt)
  end
end

function shrinking(dt)
  --Shrink the tiles if there's a match i.e. when the models are in animated models
  for m,_ in pairs(animatedModels) do
    --print("What is flipped[modelIndices[m]]"..flipped[modelIndices[m]])
    if animatedModels[m] then
      --print("What is curScale[m]"..curScale[m])
      curScale[m] = curScale[m] - shrinkSpeed*dt
      -- print(m,_,curScale[m])
      if (curScale[m] < .1) then
        curScale[m] = 0
        animatedModels[m] = false
        match = false
      end

      --resetModelTransform(m)
      placeModel(m, curPos[m].x, curPos[m].y, curPos[m].z)
      scaleModel(m, curScale[m], curScale[m], curScale[m])
    end
  end


end

function keyHandler(keys)
  -- if keys.up then
  --   deleteBoard()
  --   initializeBoard()
  -- end
end

-- Mouse handler
function mouseHandler(mouse)
  if (mouse.left and not haveClicked) then
    -- TODO: next level with left click...
    
    -- See which grid item we clicked on
    hitID, dist = getMouseClickWithLayer(gridLayer)

    -- rotate that tile if it was valid
    if (hitID > -1 and not finished) then
      flipUp(modelIndices[hitID])
    end

    haveClicked = true
  end
  -- right clicks
  if (mouse.right and not haveClicked) then
    -- restart the game if we're done
    if finished then
      -- update to next level values
      flipVelocity = flipVelocity + 0.2
      maxFlipTime = maxFlipTime - 0.1

      -- reset board
      deleteBoard()
      initializeBoard()
    end

    haveClicked = true;
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

  -- disallow flipping a mini item
  if animatedModels[tiles[index]] then
    return
  end

  -- only flip 2 tiles
  if secondFlipped == nil then
    -- print("flipping up index " .. index)
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
  if not (index == nil) and (flipped[index] > 0) then
    -- print("flipping down index " .. index)
    flipped[index] = -0.0001
  end
end

function initializeBoard()
  -- make sure everything is empty
  tiles = {}
  modelIndices = {}
  curPos = {}
  curScale = {}
  colliders = {}
  animatedModels = {}

  idx = 1
  for i = 1, boardSize*boardSize do
    flipped[idx] = 0
  end

  -- reset all our state variables
  firstFlipped = nil
  secondFlipped = nil
  match = false
  finished = false
  numMatches = 0

  -- randomize order of tileItems
  shuffle(tileItems)

  -- Create a 4x4 grid of tiles
  -- fill tiles according to tileItems
  local idx = 1
  for i = 0,3 do
    for j = 0,3 do
      pos = vec3(0, startingY + spacingY*i, startingZ + spacingZ*j)

      -- find prefab that matches the item
      tiles[idx] = addModel(tileItems[idx].."Tile", pos.x, pos.y, pos.z)
      modelIndices[tiles[idx]] = idx

      --Grid cell needs a collider for click interaction
      colliders[tiles[idx]] = addCollider(tiles[idx], gridLayer, 0.6, 0, 0, 0)
      curScale[tiles[idx]] = 1
      curPos[tiles[idx]] = vec3(pos.x,pos.y,pos.z)
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

-- actually delete all of the tiles
function deleteBoard()
  for i,mid in pairs(tiles) do
    deleteModel(mid);
  end
end

-- fill tileItems, 2 at a time
idx = 1
for i = 1, boardSize*boardSize, 2 do
  tileItems[i] = items[idx]
  -- flipped[i] = 0

  tileItems[i+1] = items[idx]
  -- flipped[i+1] = 0
  idx = idx + 1
end

initializeBoard()