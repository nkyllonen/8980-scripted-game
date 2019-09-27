--Simple Example
print("Starting Lua for HW2 Problem 1")

--Todo:
-- Lua modules (for better organization, and maybe reloading?)

CameraPosX = -3.0
CameraPosY = 1.0
CameraPosZ = 0.0

CameraDirX = 1.0
CameraDirY = -0.0
CameraDirZ = -0.0

CameraUpX = 0.0
CameraUpY = 1.0
CameraUpZ = 0.0

animatedModels = {}
velModel = {}
rotYVelModel = {}

function frameUpdate(dt)
  frameDt = dt

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

theta = 0
function keyHandler(keys)
  -- rotate camera to the left
  if keys.left then
    theta = theta + 1*frameDt
  end
  -- rotate camera to the right
  if keys.right then
    theta = theta - 1*frameDt
  end
  -- move camera forward
  if keys.up then
    CameraPosX = CameraPosX + CameraDirX*frameDt
    CameraPosZ = CameraPosZ + CameraDirZ*frameDt
  end
  -- move camera backward
  if keys.down then
    CameraPosX = CameraPosX - CameraDirX*frameDt
    CameraPosZ = CameraPosZ - CameraDirZ*frameDt
  end

  -- apply theta changes
  CameraDirX = math.cos(theta)
  CameraDirZ = -math.sin(theta)
end

id = addModel("Teapot",0,0,0)
setModelMaterial(id,"Shiny Red Plastic")
--setModelMaterial(id,"Steel")
animatedModels[id] = true
rotYVelModel[id] = 1
id = addModel("FloorPart",0,0,0)
placeModel(id,0,-.02,0)
scaleModel(id,3,1,3)
setModelMaterial(id,"Gold")
dino = addModel("Dino",0,0,-.15)  --VeryFancyCube
--placeModel(dino,-1.5,1.5,0.5)
--scaleModel(dino,.5,0.5,1.5)
--animatedModels[dino] = true
--rotZVelModel[dino] = 1
tree = addModel("Tree", 0, 0, -0.15)