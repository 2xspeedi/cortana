--[[
    Cortana Xeno-Style Bee Swarm Macro
    Full Progression Bot
    Xeno Executor Ready
--]]

local plr = game:GetService("Players").LocalPlayer
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local C = {
    AutoCollect = true,
    AutoQuest = true,
    AutoDeposit = true,
    AutoBuff = true,
    AutoEnemy = true,
    Fields = {"Clover Field","Blue Flower Field","Red Flower Field","White Flower Field"},
    Buffs = {"Sugar","Clover","WindShoes"},
    Enemies = {"Brown Bear","Queen Bee"},
    MoveTime = 0.25
}

local F = {}

function F.Move(pos,t)
    t = t or C.MoveTime
    local tw = ts:Create(hrp,TweenInfo.new(t,Enum.EasingStyle.Linear),{CFrame=CFrame.new(pos)})
    tw:Play()
    tw.Completed:Wait()
end

function F.GetFlower()
    local n,d = nil,math.huge
    for _,fName in ipairs(C.Fields) do
        local fld = ws:FindFirstChild(fName)
        if fld then
            for _,fl in ipairs(fld:GetChildren()) do
                if fl:FindFirstChild("TouchInterest") then
                    local dist = (fl.Position - hrp.Position).Magnitude
                    if dist < d then
                        n,d = fl,dist
                    end
                end
            end
        end
    end
    return n
end

function F.Collect()
    if not C.AutoCollect then return end
    local flower = F.GetFlower()
    if flower then
        F.Move(flower.Position + Vector3.new(0,3,0), 0.2)
    end
end

function F.Quest()
    if not C.AutoQuest then return end
    local q = ws:FindFirstChild("QuestGiver")
    if q then
        F.Move(q.Position + Vector3.new(0,3,0), 0.4)
        local rem = rs:FindFirstChild("QuestRemote")
        if rem then rem:FireServer("CompleteQuest") end
    end
end

function F.Deposit()
    if not C.AutoDeposit then return end
    local hive = ws:FindFirstChild("Hive")
    if hive then
        F.Move(hive.Position + Vector3.new(0,3,0), 0.4)
        local rem = rs:FindFirstChild("DepositRemote")
        if rem then rem:FireServer() end
    end
end

function F.Buff()
    if not C.AutoBuff then return end
    for _,b in ipairs(C.Buffs) do
        local rem = rs:FindFirstChild(b.."Remote")
        if rem then rem:FireServer() end
    end
end

function F.Enemy()
    if not C.AutoEnemy then return end
    for _,e in ipairs(ws:GetChildren()) do
        if e:IsA("Model") and table.find(C.Enemies,e.Name) then
            F.Move(e.HumanoidRootPart.Position + Vector3.new(0,3,0), 0.4)
            local rem = rs:FindFirstChild("AttackRemote")
            if rem then rem:FireServer(e) end
        end
    end
end

while task.wait(0.1) do
    F.Collect()
    F.Quest()
    F.Deposit()
    F.Buff()
    F.Enemy()
end
