--[[
    Cortana Xeno-Style Bee Swarm Macro
    Fully Functional with Tween Movement
--]]

local ok, err = pcall(function()
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("SendNotification", {
        Title = "Cortana",
        Text = "Macro Loaded Successfully!",
        Duration = 5
    })

    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local TweenService = game:GetService("TweenService")
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- CONFIG
    local C = {
        Fields = {"Clover Field","Blue Flower Field","Red Flower Field","White Flower Field"},
        QuestNPC = "QuestGiver",
        Hive = "Hive",
        MoveTime = 0.3
    }

    -- FUNCTION TO MOVE WITH TWEEN
    local function TweenTo(pos)
        local tw = TweenService:Create(hrp, TweenInfo.new(C.MoveTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
        tw:Play()
        tw.Completed:Wait()
    end

    -- GET NEAREST FLOWER
    local function GetNearestFlower()
        local nearest, minDist = nil, math.huge
        for _, fieldName in ipairs(C.Fields) do
            local field = Workspace:FindFirstChild(fieldName)
            if field then
                for _, fl in ipairs(field:GetChildren()) do
                    if fl:FindFirstChild("TouchInterest") then
                        local dist = (fl.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            nearest = fl
                            minDist = dist
                        end
                    end
                end
            end
        end
        return nearest
    end

    -- MAIN LOOP
    while task.wait(0.1) do
        -- COLLECT FLOWERS
        local flower = GetNearestFlower()
        if flower then
            TweenTo(flower.Position + Vector3.new(0,3,0))
        end

        -- GO TO QUEST NPC
        local npc = Workspace:FindFirstChild(C.QuestNPC)
        if npc then
            TweenTo(npc.Position + Vector3.new(0,3,0))
        end

        -- GO TO HIVE TO DEPOSIT
        local hive = Workspace:FindFirstChild(C.Hive)
        if hive then
            TweenTo(hive.Position + Vector3.new(0,3,0))
        end
    end
end)

if not ok then
    warn("CORTANA ERROR: "..tostring(err))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Cortana Error",
        Text = tostring(err),
        Duration = 10
    })
end
