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

--Tile variables
gridLayer = 0
gridModel = {}
gridPos = {}
curPos = {}



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



--Mouse handler

function mouseHandler(mouse)
  id = addModel("Teapot",0,0,0)
  setModelMaterial(id,"Shiny Red Plastic")
  if (mouse.left and not haveClicked) then
    hitID, dist = getMouseClickWithLayer(gridLayer) --See which grid item we clicked on
    print("hitID",hitID)
    haveClicked = true

  end
  if (not mouse.left) then
    haveClicked = false
  end
end


--Create a 4x4 grid of tiles
spacingY = 1.1 --Give a small space between grid cells to create boundries
startingY = -.6
startingZ = -1.8
spacingZ = 1.2
idx = 1
for i = 0,3 do
  for j = 0,3 do
    gridModel[idx] = addModel("Tile",0,startingY + spacingY*i,startingZ + spacingZ*j)
    gridPos[gridModel[idx]] = vec3(0,startingY + spacingY*i,startingZ + spacingZ*j)
    addCollider(gridModel[idx],gridLayer,0.6,0,0,0) --Grid cell needs a collider for click interaction
    setModelMaterial(gridModel[idx],"Dark Polished Wood")
    idx = idx + 1
  end
end


--id = addModel("Teapot",0,0,0)
--setModelMaterial(id,"Shiny Red Plastic")
-- --setModelMaterial(id,"Steel")
-- animatedModels[id] = true
-- rotYVelModel[id] = 1
-- id = addModel("FloorPart",0,0,0)
-- placeModel(id,0,-.02,0)
-- scaleModel(id,3,1,3)
-- setModelMaterial(id,"Gold")
-- piller = addModel("Dino",0,0,-.15)  --VeryFancyCube
--placeModel(piller,-1.5,1.5,0.5)
--scaleModel(piller,.5,0.5,1.5)
--animatedModels[piller] = true
--rotZVelModel[piller] = 1
