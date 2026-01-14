-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PineTreeAutoFarmGUI"
screenGui.Parent = PlayerGui

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Pine Tree AutoFarm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Start Button
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0.8, 0, 0, 30)
startButton.Position = UDim2.new(0.1, 0, 0, 40)
startButton.Text = "Start Farm"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
startButton.Font = Enum.Font.SourceSansBold
startButton.TextSize = 16
startButton.Parent = frame

-- Stop Button
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0.8, 0, 0, 30)
stopButton.Position = UDim2.new(0.1, 0, 0, 80)
stopButton.Text = "Stop Farm"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
stopButton.Font = Enum.Font.SourceSansBold
stopButton.TextSize = 16
stopButton.Parent = frame

-- Auto-farm control variable
local farming = false

-- Connect buttons
startButton.MouseButton1Click:Connect(function()
    if not farming then
        farming = true
        print("Auto-farm started!")
        -- Spawn the farming loop
        task.spawn(function()
            while farming do
                for _, targetPos in ipairs(pinePattern) do
                    moveTo(targetPos)
                    task.wait(0.05)
                    if not farming then break end
                end
