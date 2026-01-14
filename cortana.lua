--== Ant Field Autofarm ==--

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- HumanoidRootPart CFrame + Size
local HRP_SIZE = Vector3.new(2.3299996852874756, 1.8899999856948853, 2.5200002193450928)
local hrpCF = CFrame.new(
    42.0162849, 32.219265, 611.874084,
    0.932346046,  4.60245756e-05, -0.361567199,
    4.87543948e-05, 1, 0.000253011181,
    0.361567199, -0.000253521954, 0.932346046
)
hrp.CFrame = hrpCF -- set starting position

-- Ant Field center + size
local FIELD_CENTER = Vector3.new(95.8802795, 29.7700119, 594.6203)
local FIELD_SIZE = Vector3.new(127.63992309570312, 1, 50.27999496459961)

local HALF_X = FIELD_SIZE.X / 2
local HALF_Z = FIELD_SIZE.Z / 2
local bounds = {
    minX = FIELD_CENTER.X - HALF_X,
    maxX = FIELD_CENTER.X + HALF_X,
    minZ = FIELD_CENTER.Z - HALF_Z,
    maxZ = FIELD_CENTER.Z + HALF_Z
}

-- Ant avoidance settings
local ANT_DANGER_RADIUS = 18 + HRP_SIZE.X/2
local DODGE_DISTANCE = HRP_SIZE.Z * 4

-- Move HRP safely using Tween
local function moveTo(pos)
    local target = Vector3.new(
        math.clamp(pos.X, bounds.minX, bounds.maxX),
        hrp.Position.Y, -- preserve height
        math.clamp(pos.Z, bounds.minZ, bounds.maxZ)
    )

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new((hrp.Position - target).Magnitude / 22, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(target)}
    )
    tween:Play()
    tween.Completed:Wait()
end

-- Get nearby ants
local function getNearbyAnts(position)
    local ants = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            if string.find(obj.Name:lower(), "ant") then
                local dist = (obj.HumanoidRootPart.Position - position).Magnitude
                if dist < ANT_DANGER_RADIUS then
                    table.insert(ants, obj)
                end
            end
        end
    end
    return ants
end

-- Calculate safe dodge position
local function getSafePosition(currentPos, antPos)
    local direction = (currentPos - antPos).Unit
    local safePos = currentPos + direction * DODGE_DISTANCE

    -- Clamp inside Ant Field
    safePos = Vector3.new(
        math.clamp(safePos.X, bounds.minX, bounds.maxX),
        currentPos.Y,
        math.clamp(safePos.Z, bounds.minZ, bounds.maxZ)
    )

    return safePos
end

-- Generate snake pattern points inside field
local function generatePattern(stepX, stepZ)
    local points = {}
    for z = -HALF_Z, HALF_Z, stepZ do
        local reverse = math.floor(z / stepZ) % 2 == 1
        for x = -HALF_X, HALF_X, stepX do
            local px = reverse and -x or x
            table.insert(points, FIELD_CENTER + Vector3.new(px, 0, z))
        end
    end
    return points
end

-- Main farming loop
local patternPoints = generatePattern(8,6)
local farming = true

while farming do
    for _, targetPos in pairs(patternPoints) do
        local ants = getNearbyAnts(hrp.Position)
        if #ants > 0 then
            local dodgePos = getSafePosition(hrp.Position, ants[1].HumanoidRootPart.Position)
            moveTo(dodgePos)
        else
            moveTo(targetPos)
        end
        task.wait(0.1)
    end
end
