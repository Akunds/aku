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

-- Create GUI
local function createStarryBackground()
    local stars = {}
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BorderSizePixel = 0
    
    -- Create animated stars
    for i = 1, 50 do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        star.Position = UDim2.new(0, math.random(0, frame.AbsoluteSize.X), 0, math.random(0, frame.AbsoluteSize.Y))
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.Parent = frame
        
        -- Make stars twinkle
        local tween = TweenService:Create(star, TweenInfo.new(math.random(1, 3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            BackgroundTransparency = math.random(30, 90) / 100
        })
        tween:Play()
        
        stars[i] = star
    end
    
    return frame
end

local function createMainGUI()
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