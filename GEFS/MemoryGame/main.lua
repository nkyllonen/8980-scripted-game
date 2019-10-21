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

function frameUpdate(dt)
  for modelID,v in pairs(animatedModels) do
    local vel = velModel[modelID]
    if vel then 
      translateModel(modelID,dt*vel[1],dt*vel[2],dt*vel[3])
    end

    local rotYvel = rotYVelModel[modelID]
    if rotYvel then 
      rotateModel(modelID,rotYvel*dt, 0, 1, 0)
    end

  end
end

function keyHandler(keys)
  if keys.left then
    translateModel(piller,0,0,-0.1)
  end
  if keys.right then
    translateModel(piller,0,0,0.1)
  end
  if keys.up then
    translateModel(piller,0.1,0,0)
  end
  if keys.down then
    translateModel(piller,-0.1,0,0)
  end
end

-- arrays containing world objects
tiles = {}
tileItems = {}
items = {"Tower", "Crystal", "Pug", "Sheep", "Ship", "Poplar", "Bottle", "Carrot"}

function initializeBoard()
  -- fill tileItems, 2 at a time
  local idx = 1
  for i = 1, boardSize*boardSize, 2 do
    tileItems[i] = items[idx]
    tileItems[i+1] = items[idx]
    idx = idx + 1
  end

  -- TODO: randomize order of tileItems

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
    animatedModels[tiles[i]] = true
    rotYVelModel[tiles[i]] = 1

    print(tileItems[i] .. " @ (0, " .. y .. " , " .. z .. ")")
    z = z + 1.2
  end

end

initializeBoard()

-- bottom row
-- idx = 1
-- y = 0
-- for z = -1.8, 1.8, 1.2 do
--   if idx % 2 == 0 then
--     tiles[idx] = addModel("PoplarTile", 0, y, z)
--     tileItems[idx] = "Poplar"
--   else
--     tiles[idx] = addModel("BottleTile", 0, y, z)
--     tileItems[idx] = "Bottle"
--   end

--   -- rotate models around y-axis
--   animatedModels[tiles[idx]] = true
--   rotYVelModel[tiles[idx]] = 1

--   idx = idx + 1
-- end

-- -- middle row
-- y = y + 1.2
-- for z = -1.8, 1.8, 1.2 do
--   if idx % 2 == 0 then
--     tiles[idx] = addModel("CarrotTile", 0, y, z)
--     tileItems[idx] = "Carrot"
--   else
--     tiles[idx] = addModel("ShipTile", 0, y, z)
--     tileItems[idx] = "Ship"
--   end

--   -- rotate models around y-axis
--   animatedModels[tiles[idx]] = true
--   rotYVelModel[tiles[idx]] = 1

--   idx = idx + 1
-- end

-- -- top row
-- y = y + 1.2
-- for z = -1.8, 1.8, 1.2 do
--   if idx % 2 == 0 then
--     tiles[idx] = addModel("SheepTile", 0, y, z)
--     tileItems[idx] = "Sheep"
--   else
--     tiles[idx] = addModel("PugTile", 0, y, z)
--     tileItems[idx] = "Pug"
--   end

--   -- rotate models around y-axis
--   animatedModels[tiles[idx]] = true
--   rotYVelModel[tiles[idx]] = 1

--   idx = idx + 1
-- end