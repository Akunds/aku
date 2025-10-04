-- FPS Devourer Script by AKUNDISCO
-- Discord: https://discord.gg/akundisco
-- Simple Black & White Design

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local InsertService = game:GetService("InsertService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    ACCESSORY_ID = 12804776473,
    DISCORD_LINK = "https://discord.gg/akundisco",
    RAPID_PRESS_RATE = 2000,
    MAX_PRESS_RATE = 15000
}

-- System Variables
local DevourerSystem = {
    isActive = false,
    isMinimized = false,
    currentRate = CONFIG.RAPID_PRESS_RATE,
    totalPresses = 0,
    startTime = 0,
    pressThreads = {}
}

-- Snow Effect System
local function createSnowEffect(parent)
    local snowContainer = Instance.new("Frame")
    snowContainer.Size = UDim2.new(1, 0, 1, 0)
    snowContainer.Position = UDim2.new(0, 0, 0, 0)
    snowContainer.BackgroundTransparency = 1
    snowContainer.Parent = parent
    
    for i = 1, 100 do
        local snowflake = Instance.new("Frame")
        local size = math.random(2, 5)
        snowflake.Size = UDim2.new(0, size, 0, size)
        snowflake.Position = UDim2.new(math.random(), 0, -0.1, 0)
        snowflake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        snowflake.BorderSizePixel = 0
        snowflake.Parent = snowContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = snowflake
        
        local fallTween = TweenService:Create(snowflake,
            TweenInfo.new(math.random(10, 20), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false),
            {Position = UDim2.new(snowflake.Position.X.Scale + math.random(-30, 30) / 100, 0, 1.2, 0)}
        )
        
        spawn(function()
            wait(math.random(0, 1000) / 100)
            fallTween:Play()
        end)
    end
    
    return snowContainer
end

-- Main Interface
local function createSimpleInterface()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SimpleDevourerInterface"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Transparent background with snow
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backgroundFrame.BackgroundTransparency = 0.8
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = screenGui
    
    -- Snow effect
    createSnowEffect(backgroundFrame)
    
    -- Main container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 400, 0, 250)
    mainContainer.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = screenGui
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = mainContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -40, 0, 10)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.Parent = mainFrame
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0)
    minimizeCorner.Parent = minimizeButton
    
    return screenGui, mainContainer, mainFrame, minimizeButton, backgroundFrame
end

-- Minimized Button
local function createMinimizedButton(parent)
    local minimizedFrame = Instance.new("Frame")
    minimizedFrame.Size = UDim2.new(0, 120, 0, 40)
    minimizedFrame.Position = UDim2.new(1, -140, 0, 20)
    minimizedFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    minimizedFrame.BorderSizePixel = 0
    minimizedFrame.Visible = false
    minimizedFrame.Parent = parent
    
    local minimizedCorner = Instance.new("UICorner")
    minimizedCorner.CornerRadius = UDim.new(0, 20)
    minimizedCorner.Parent = minimizedFrame
    
    local minimizedStroke = Instance.new("UIStroke")
    minimizedStroke.Color = Color3.fromRGB(255, 255, 255)
    minimizedStroke.Thickness = 1
    minimizedStroke.Parent = minimizedFrame
    
    local minimizedButton = Instance.new("TextButton")
    minimizedButton.Size = UDim2.new(1, 0, 1, 0)
    minimizedButton.Position = UDim2.new(0, 0, 0, 0)
    minimizedButton.BackgroundTransparency = 1
    minimizedButton.Text = "AKUNDISCO"
    minimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizedButton.TextScaled = true
    minimizedButton.Font = Enum.Font.SourceSansBold
    minimizedButton.Parent = minimizedFrame
    
    return minimizedFrame, minimizedButton
end

-- Simple Control Panel
local function createSimpleControlPanel(parent)
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 60)
    titleLabel.Position = UDim2.new(0, 10, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "FPS DEVOURER AKUNDISCO"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = parent
    
    -- Discord button
    local discordFrame = Instance.new("Frame")
    discordFrame.Size = UDim2.new(1, -40, 0, 40)
    discordFrame.Position = UDim2.new(0, 20, 0, 100)
    discordFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    discordFrame.BorderSizePixel = 0
    discordFrame.Parent = parent
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 10)
    discordCorner.Parent = discordFrame
    
    local discordButton = Instance.new("TextButton")
    discordButton.Size = UDim2.new(1, 0, 1, 0)
    discordButton.Position = UDim2.new(0, 0, 0, 0)
    discordButton.BackgroundTransparency = 1
    discordButton.Text = "COPY DISCORD"
    discordButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    discordButton.TextScaled = true
    discordButton.Font = Enum.Font.SourceSansBold
    discordButton.Parent = discordFrame
    
    -- Activate button
    local activateFrame = Instance.new("Frame")
    activateFrame.Size = UDim2.new(1, -40, 0, 50)
    activateFrame.Position = UDim2.new(0, 20, 0, 160)
    activateFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    activateFrame.BorderSizePixel = 0
    activateFrame.Parent = parent
    
    local activateCorner = Instance.new("UICorner")
    activateCorner.CornerRadius = UDim.new(0, 10)
    activateCorner.Parent = activateFrame
    
    local activateButton = Instance.new("TextButton")
    activateButton.Size = UDim2.new(1, 0, 1, 0)
    activateButton.Position = UDim2.new(0, 0, 0, 0)
    activateButton.BackgroundTransparency = 1
    activateButton.Text = "ACTIVATE"
    activateButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    activateButton.TextScaled = true
    activateButton.Font = Enum.Font.SourceSansBold
    activateButton.Parent = activateFrame
    
    return discordButton, activateButton, discordFrame, activateFrame
end

-- Press System
local function createPressSystem()
    local function createPressThread(threadId)
        return coroutine.create(function()
            while DevourerSystem.isActive do
                local interval = 1 / (DevourerSystem.currentRate / 16)
                
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                    wait(0.001)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
                    DevourerSystem.totalPresses = DevourerSystem.totalPresses + 1
                end)
                
                wait(math.max(0.0001, interval))
            end
        end)
    end
    
    return {
        start = function()
            for i = 1, 16 do
                DevourerSystem.pressThreads[i] = createPressThread(i)
                coroutine.resume(DevourerSystem.pressThreads[i])
            end
        end,
        
        stop = function()
            for i = 1, 16 do
                if DevourerSystem.pressThreads[i] then
                    coroutine.close(DevourerSystem.pressThreads[i])
                    DevourerSystem.pressThreads[i] = nil
                end
            end
        end
    }
end

-- Accessory System
local function equipAccessory()
    spawn(function()
        local success, accessoryModel = pcall(function()
            return InsertService:LoadAsset(CONFIG.ACCESSORY_ID)
        end)
        
        if success and accessoryModel then
            local accessory = accessoryModel:FindFirstChildOfClass("Accessory")
            if accessory and LocalPlayer.Character then
                wait(math.random(100, 300) / 100)
                accessory.Parent = LocalPlayer.Character
            end
        end
    end)
end

-- Clipboard Manager
local function copyToClipboard(text)
    local success = false
    
    local methods = {
        function() setclipboard(text); return true end,
        function() syn.write_clipboard(text); return true end,
        function() Clipboard.set(text); return true end,
        function() toclipboard(text); return true end
    }
    
    for _, method in pairs(methods) do
        success = pcall(method)
        if success then break end
    end
    
    return success
end

-- Main System
local function initializeSimpleSystem()
    -- Wait for character
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    
    -- Equip accessory
    equipAccessory()
    
    -- Create interface
    local screenGui, mainContainer, mainFrame, minimizeButton, backgroundFrame = createSimpleInterface()
    local minimizedFrame, minimizedButton = createMinimizedButton(screenGui)
    local discordButton, activateButton, discordFrame, activateFrame = createSimpleControlPanel(mainFrame)
    
    -- Initialize press system
    local pressSystem = createPressSystem()
    
    -- Drag functionality
    local function createDragSystem(frame)
        local dragToggle = false
        local dragStart = nil
        local startPos = nil
        
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragToggle = true
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragToggle = false
                    end
                end)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
                local delta = input.Position - dragStart
                local position = UDim2.new(
                    startPos.X.Scale, 
                    math.clamp(startPos.X.Offset + delta.X, 0, screenGui.AbsoluteSize.X - frame.AbsoluteSize.X),
                    startPos.Y.Scale, 
                    math.clamp(startPos.Y.Offset + delta.Y, 0, screenGui.AbsoluteSize.Y - frame.AbsoluteSize.Y)
                )
                frame.Position = position
            end
        end)
    end
    
    createDragSystem(mainContainer)
    
    -- Minimize functionality
    minimizeButton.MouseButton1Click:Connect(function()
        DevourerSystem.isMinimized = true
        mainContainer.Visible = false
        backgroundFrame.Visible = false
        minimizedFrame.Visible = true
    end)
    
    -- Restore functionality
    minimizedButton.MouseButton1Click:Connect(function()
        DevourerSystem.isMinimized = false
        mainContainer.Visible = true
        backgroundFrame.Visible = true
        minimizedFrame.Visible = false
    end)
    
    -- Discord functionality
    discordButton.MouseButton1Click:Connect(function()
        local success = copyToClipboard(CONFIG.DISCORD_LINK)
        
        if success then
            discordButton.Text = "COPIED!"
            spawn(function()
                wait(2)
                discordButton.Text = "COPY DISCORD"
            end)
        else
            discordButton.Text = "FAILED"
            spawn(function()
                wait(2)
                discordButton.Text = "COPY DISCORD"
            end)
        end
    end)
    
    -- Activation functionality
    activateButton.MouseButton1Click:Connect(function()
        DevourerSystem.isActive = not DevourerSystem.isActive
        
        if DevourerSystem.isActive then
            DevourerSystem.startTime = tick()
            DevourerSystem.totalPresses = 0
            
            activateButton.Text = "ACTIVE"
            activateFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            pressSystem.start()
            
        else
            activateButton.Text = "ACTIVATE"
            activateFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            activateButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            
            pressSystem.stop()
        end
    end)
    
    -- Auto-equip on respawn
    LocalPlayer.CharacterAdded:Connect(function()
        wait(2)
        equipAccessory()
    end)
    
    print("[AKUNDISCO] FPS Devourer System Loaded")
    print("[AKUNDISCO] Discord: " .. CONFIG.DISCORD_LINK)
end

-- Execute System
initializeSimpleSystem()