-- Advanced Roblox FPS Devourer Script with Enhanced GUI
-- Discord: https://discord.gg/akundisco
-- Version: 2.0 Advanced

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Advanced Configuration
local CONFIG = {
    ACCESSORY_ID = 12804776473, -- Blue Swirl Aura
    DISCORD_LINK = "https://discord.gg/akundisco",
    RAPID_PRESS_RATE = 2000, -- Presses per second
    MAX_PRESS_RATE = 5000, -- Maximum achievable rate
    ANTI_LAG_MODE = true,
    STEALTH_MODE = false,
    AUTO_OPTIMIZE = true,
    PERFORMANCE_MONITOR = true
}

-- Advanced Variables
local DevourerSystem = {
    isActive = false,
    currentRate = CONFIG.RAPID_PRESS_RATE,
    totalPresses = 0,
    startTime = 0,
    pressConnection = nil,
    optimizationConnection = nil,
    performanceData = {}
}

-- Advanced Performance Optimization
local PerformanceOptimizer = {
    originalSettings = {},
    isOptimized = false
}

function PerformanceOptimizer:OptimizeGraphics()
    if self.isOptimized then return end
    
    -- Store original settings
    self.originalSettings = {
        Quality = settings().Rendering.QualityLevel,
        ShadowMap = Lighting.ShadowMapEnabled,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        Brightness = Lighting.Brightness
    }
    
    -- Apply optimizations
    settings().Rendering.QualityLevel = 1
    Lighting.ShadowMapEnabled = false
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100
    Lighting.Brightness = 0
    
    self.isOptimized = true
end

function PerformanceOptimizer:RestoreGraphics()
    if not self.isOptimized then return end
    
    -- Restore original settings
    settings().Rendering.QualityLevel = self.originalSettings.Quality
    Lighting.ShadowMapEnabled = self.originalSettings.ShadowMap
    Lighting.GlobalShadows = self.originalSettings.GlobalShadows
    Lighting.FogEnd = self.originalSettings.FogEnd
    Lighting.Brightness = self.originalSettings.Brightness
    
    self.isOptimized = false
end

-- Advanced Starry Background with Particles
local function createAdvancedStarryBackground()
    local stars = {}
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(8, 12, 25)
    frame.BorderSizePixel = 0
    
    -- Create gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 12, 25)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 20, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 25))
    })
    gradient.Rotation = 45
    gradient.Parent = frame
    
    -- Create animated star field
    for i = 1, 100 do
        local star = Instance.new("Frame")
        local size = math.random(1, 3)
        star.Size = UDim2.new(0, size, 0, size)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.Parent = frame
        
        -- Add corner radius for circular stars
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = star
        
        -- Advanced twinkling animation
        local twinkle1 = TweenService:Create(star, 
            TweenInfo.new(math.random(100, 300) / 100, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
            {BackgroundTransparency = math.random(20, 80) / 100}
        )
        
        local twinkle2 = TweenService:Create(star, 
            TweenInfo.new(math.random(200, 500) / 100, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), 
            {Size = UDim2.new(0, size * 1.5, 0, size * 1.5)}
        )
        
        twinkle1:Play()
        spawn(function()
            wait(math.random(0, 200) / 100)
            twinkle2:Play()
        end)
        
        stars[i] = star
    end
    
    return frame
end

-- Advanced Performance Monitor
local function createPerformanceMonitor(parent)
    local monitorFrame = Instance.new("Frame")
    monitorFrame.Name = "PerformanceMonitor"
    monitorFrame.Size = UDim2.new(1, 0, 0, 120)
    monitorFrame.Position = UDim2.new(0, 0, 0, 400)
    monitorFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    monitorFrame.BorderSizePixel = 0
    monitorFrame.Parent = parent
    
    local monitorCorner = Instance.new("UICorner")
    monitorCorner.CornerRadius = UDim.new(0, 8)
    monitorCorner.Parent = monitorFrame
    
    local monitorStroke = Instance.new("UIStroke")
    monitorStroke.Color = Color3.fromRGB(50, 200, 150)
    monitorStroke.Thickness = 1
    monitorStroke.Parent = monitorFrame
    
    -- Performance labels
    local labels = {
        {name = "FPS", pos = UDim2.new(0, 10, 0, 10)},
        {name = "Press Rate", pos = UDim2.new(0.5, 0, 0, 10)},
        {name = "Total Presses", pos = UDim2.new(0, 10, 0, 40)},
        {name = "Runtime", pos = UDim2.new(0.5, 0, 0, 40)},
        {name = "Memory Usage", pos = UDim2.new(0, 10, 0, 70)},
        {name = "Ping", pos = UDim2.new(0.5, 0, 0, 70)}
    }
    
    local performanceLabels = {}
    for _, labelData in pairs(labels) do
        local label = Instance.new("TextLabel")
        label.Name = labelData.name:gsub(" ", "")
        label.Size = UDim2.new(0.45, 0, 0, 25)
        label.Position = labelData.pos
        label.BackgroundTransparency = 1
        label.Text = labelData.name .. ": --"
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextScaled = true
        label.Font = Enum.Font.RobotoMono
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = monitorFrame
        
        performanceLabels[labelData.name] = label
    end
    
    return performanceLabels
end

-- Advanced Settings Panel
local function createSettingsPanel(parent)
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name = "SettingsPanel"
    settingsFrame.Size = UDim2.new(1, 0, 0, 150)
    settingsFrame.Position = UDim2.new(0, 0, 0, 530)
    settingsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    settingsFrame.BorderSizePixel = 0
    settingsFrame.Parent = parent
    
    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 8)
    settingsCorner.Parent = settingsFrame
    
    local settingsStroke = Instance.new("UIStroke")
    settingsStroke.Color = Color3.fromRGB(255, 100, 50)
    settingsStroke.Thickness = 1
    settingsStroke.Parent = settingsFrame
    
    -- Settings title
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 25)
    settingsTitle.Position = UDim2.new(0, 0, 0, 5)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "ADVANCED SETTINGS"
    settingsTitle.TextColor3 = Color3.fromRGB(255, 100, 50)
    settingsTitle.TextScaled = true
    settingsTitle.Font = Enum.Font.SourceSansBold
    settingsTitle.Parent = settingsFrame
    
    -- Rate slider
    local rateLabel = Instance.new("TextLabel")
    rateLabel.Size = UDim2.new(0.3, 0, 0, 30)
    rateLabel.Position = UDim2.new(0, 10, 0, 35)
    rateLabel.BackgroundTransparency = 1
    rateLabel.Text = "Press Rate: " .. CONFIG.RAPID_PRESS_RATE
    rateLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    rateLabel.TextScaled = true
    rateLabel.Font = Enum.Font.SourceSans
    rateLabel.TextXAlignment = Enum.TextXAlignment.Left
    rateLabel.Parent = settingsFrame
    
    local rateSlider = Instance.new("Frame")
    rateSlider.Size = UDim2.new(0.6, -20, 0, 8)
    rateSlider.Position = UDim2.new(0.35, 0, 0, 46)
    rateSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    rateSlider.BorderSizePixel = 0
    rateSlider.Parent = settingsFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = rateSlider
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 20, 0, 20)
    sliderKnob.Position = UDim2.new((CONFIG.RAPID_PRESS_RATE - 1000) / (CONFIG.MAX_PRESS_RATE - 1000), -10, 0, -6)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = rateSlider
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    -- Toggle buttons
    local toggles = {
        {name = "Anti-Lag Mode", var = "ANTI_LAG_MODE", pos = UDim2.new(0, 10, 0, 80)},
        {name = "Stealth Mode", var = "STEALTH_MODE", pos = UDim2.new(0.33, 0, 0, 80)},
        {name = "Auto Optimize", var = "AUTO_OPTIMIZE", pos = UDim2.new(0.66, 0, 0, 80)}
    }
    
    local toggleButtons = {}
    for _, toggleData in pairs(toggles) do
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0.3, -10, 0, 35)
        toggleButton.Position = toggleData.pos
        toggleButton.BackgroundColor3 = CONFIG[toggleData.var] and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(70, 70, 80)
        toggleButton.Text = toggleData.name .. "\n" .. (CONFIG[toggleData.var] and "ON" or "OFF")
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.TextScaled = true
        toggleButton.Font = Enum.Font.SourceSans
        toggleButton.Parent = settingsFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleButton
        
        toggleButtons[toggleData.var] = toggleButton
    end
    
    return rateLabel, sliderKnob, rateSlider, toggleButtons
end

local function createAdvancedMainGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FPSDevourerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Background with stars
    local backgroundFrame = createStarryBackground()
    backgroundFrame.Parent = screenGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 130, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -20, 0, 50)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🌀 FPS DEVOURER 🌀"
    titleLabel.TextColor3 = Color3.fromRGB(70, 130, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = mainFrame
    
    -- Discord Button
    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Size = UDim2.new(0.8, 0, 0, 40)
    discordButton.Position = UDim2.new(0.1, 0, 0, 70)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.Text = "📋 Copy Discord Link"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextScaled = true
    discordButton.Font = Enum.Font.SourceSansBold
    discordButton.Parent = mainFrame
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordButton
    
    -- Activate Button
    local activateButton = Instance.new("TextButton")
    activateButton.Name = "ActivateButton"
    activateButton.Size = UDim2.new(0.8, 0, 0, 50)
    activateButton.Position = UDim2.new(0.1, 0, 0, 130)
    activateButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
    activateButton.Text = "⚡ ACTIVATE FPS DEVOURER ⚡"
    activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    activateButton.TextScaled = true
    activateButton.Font = Enum.Font.SourceSansBold
    activateButton.Parent = mainFrame
    
    local activateCorner = Instance.new("UICorner")
    activateCorner.CornerRadius = UDim.new(0, 8)
    activateCorner.Parent = activateButton
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    statusLabel.Position = UDim2.new(0.05, 0, 0, 200)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Inactive"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = mainFrame
    
    -- Info Label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Size = UDim2.new(0.9, 0, 0, 40)
    infoLabel.Position = UDim2.new(0.05, 0, 0, 240)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Press '1' rapidly to equip/unequip weapon\nUp to 2000 presses per second!"
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.Parent = mainFrame
    
    -- Make GUI draggable
    local function makeDraggable(frame)
        local dragToggle = nil
        local dragSpeed = 0.25
        local dragStart = nil
        local startPos = nil
        
        local function updateInput(input)
            local delta = input.Position - dragStart
            local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
        end
        
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
                updateInput(input)
            end
        end)
    end
    
    makeDraggable(mainFrame)
    
    return screenGui, activateButton, discordButton, statusLabel
end

-- Equip accessory function
local function equipAccessory()
    spawn(function()
        local success, accessoryModel = pcall(function()
            return InsertService:LoadAsset(ACCESSORY_ID)
        end)
        
        if success and accessoryModel then
            local accessory = accessoryModel:FindFirstChildOfClass("Accessory")
            if accessory then
                accessory.Parent = LocalPlayer.Character
                print("✅ Blue Swirl Aura equipped successfully!")
            end
        else
            warn("⚠️ Failed to load accessory")
        end
    end)
end

-- Rapid key pressing function
local function startRapidPressing()
    if pressConnection then
        pressConnection:Disconnect()
    end
    
    local interval = 1 / RAPID_PRESS_RATE
    local lastPress = 0
    
    pressConnection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastPress >= interval then
            lastPress = currentTime
            
            -- Simulate key press
            local key1Down = {
                KeyCode = Enum.KeyCode.One,
                UserInputType = Enum.UserInputType.Keyboard,
                UserInputState = Enum.UserInputState.Begin
            }
            
            local key1Up = {
                KeyCode = Enum.KeyCode.One,
                UserInputType = Enum.UserInputType.Keyboard,
                UserInputState = Enum.UserInputState.End
            }
            
            -- Fire key events rapidly
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.One, false, game)
                wait(0.001)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.One, false, game)
            end)
        end
    end)
end

-- Stop rapid pressing
local function stopRapidPressing()
    if pressConnection then
        pressConnection:Disconnect()
        pressConnection = nil
    end
end

-- Copy to clipboard function
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif syn and syn.write_clipboard then
        syn.write_clipboard(text)
        return true
    elseif Clipboard and Clipboard.set then
        Clipboard.set(text)
        return true
    end
    return false
end

-- Main execution
local function initializeScript()
    -- Wait for character
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    
    -- Equip the blue aura accessory
    equipAccessory()
    
    -- Create GUI
    local screenGui, activateButton, discordButton, statusLabel = createMainGUI()
    
    -- Discord button functionality
    discordButton.MouseButton1Click:Connect(function()
        if copyToClipboard(DISCORD_LINK) then
            discordButton.Text = "✅ Copied to Clipboard!"
            discordButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
            wait(2)
            discordButton.Text = "📋 Copy Discord Link"
            discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        else
            discordButton.Text = "❌ Copy Failed"
            discordButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            wait(2)
            discordButton.Text = "📋 Copy Discord Link"
            discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        end
    end)
    
    -- Activate button functionality
    activateButton.MouseButton1Click:Connect(function()
        isDevourerActive = not isDevourerActive
        
        if isDevourerActive then
            activateButton.Text = "🔥 DEVOURER ACTIVE 🔥"
            activateButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            statusLabel.Text = "Status: ACTIVE - Rapid Pressing!"
            statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            startRapidPressing()
        else
            activateButton.Text = "⚡ ACTIVATE FPS DEVOURER ⚡"
            activateButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
            statusLabel.Text = "Status: Inactive"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            stopRapidPressing()
        end
    end)
    
    -- Auto-equip accessory on respawn
    LocalPlayer.CharacterAdded:Connect(function()
        wait(1)
        equipAccessory()
    end)
    
    print("🌀 FPS Devourer Script Loaded Successfully!")
    print("📋 Discord: " .. DISCORD_LINK)
    print("⚡ Ready to devour FPS!")
end

-- Initialize the script
initializeScript()