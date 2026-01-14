--[[
    Cortana Xeno-Style Bee Swarm Macro
    Properly rewritten for real farming
--]]

local ok, err = pcall(function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local StarterGui = game:GetService("StarterGui")
    local PathfindingService = game:GetService("PathfindingService")

    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Notification
    StarterGui:SetCore("SendNotification", {
        Title = "Cortana",
        Text = "Macro Loaded Successfully!",
        Duration = 5
    })

    -- CONFIG
    local C = {
        Fields = {"Clover Field","Blue Flower Field","Red Flower Field","White Flower Field"},
        QuestNPC = "QuestGiver",
        Hive = "Hive",
        MoveDelay = 0.2
    }

    -- WALK FUNCTION USING HUMANOID:MoveTo()
    local function WalkTo(pos)
        humanoid:MoveTo(pos)
        humanoid.MoveToFinished:Wait()
    end

    -- GET NEAREST FLOWER
    local function GetNearestFlower()
        local nearest, minDist = nil, math.huge
        for _, fieldName in ipairs(C.Fields) do
            local field = Workspace:FindFirstChild(fieldName)
            if field then
                for _, flower in pairs(field:GetChildren()) do
                    if flower:IsA("BasePart") and flower:FindFirstChild("TouchInterest") then
                        local dist = (flower.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            nearest = flower
                            minDist = dist
                        end
                    end
                end
            end
        end
        return nearest
    end

    -- MAIN LOOP
    while task.wait(C.MoveDelay) do
        -- COLLECT FLOWERS
        local flower = GetNearestFlower()
        if flower then
            WalkTo(flower.Position + Vector3.new(0,2,0))
        end

        -- GO TO QUEST NPC
        local npc = Workspace:FindFirstChild(C.QuestNPC)
        if npc then
            WalkTo(npc.Position + Vector3.new(0,2,0))
        end

        -- GO TO HIVE
        local hive = Workspace:FindFirstChild(C.Hive)
        if hive then
            WalkTo(hive.Position + Vector3.new(0,2,0))
        end
    end

end)

-- ERROR HANDLING
if not ok then
    warn("CORTANA ERROR: "..tostring(err))
    StarterGui:SetCore("SendNotification",
