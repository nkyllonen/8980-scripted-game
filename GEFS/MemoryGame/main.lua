--Simple Example
print("Starting Lua for Memory Game")

--Todo:
-- Lua modules (for better organization, and maybe reloading?)

require "CommonLibs/vec3"

CameraPosX = -5.0
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

function frameUpdate(dt)
  for modelID,v in pairs(animatedModels) do
    --print("ID",modelID)
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

-- bottom row
idx = 1
for z = -1.8, 1.8, 1.2 do
  tiles[idx] = addModel("TeapotTile", 0, 0, z)
  setModelMaterial(tiles[idx], "Shiny Red Plastic")

  -- rotate models around y-axis
  animatedModels[tiles[idx]] = true
  rotYVelModel[tiles[idx]] = 1

  idx = idx + 1
end