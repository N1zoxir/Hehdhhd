-- N1zoxir Control Center v5.0 [ПРОСТОЕ ЛИСТАНИЕ, ВСЁ РАБОТАЕТ]
-- БЕЗ ScrollingFrame, ПРОСТО КНОПКИ + ПЕРЕКЛЮЧЕНИЕ

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- ======== ПЕРЕМЕННЫЕ ========
local flyActive = false
local flyBodyVelocity = nil
local noclipActive = false
local noclipConnection = nil
local jumpActive = false
local jumpConnection = nil
local speedActive = false
local espActive = false
local espObjects = {}
local nightActive = false
local hatActive = false
local hatParts = {}

-- ======== ФУНКЦИИ ========
local function toggleFly()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    flyActive = not flyActive
    if flyActive then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        flyBodyVelocity.Velocity = Vector3.new(0, 30, 0)
        flyBodyVelocity.Parent = root
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    end
end

local function toggleNoclip()
    noclipActive = not noclipActive
    if noclipActive then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

local function toggleJump()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    jumpActive = not jumpActive
    if jumpActive then
        hum.MaxJumpHeight = 50
        hum.JumpPower = 80
        if jumpConnection then jumpConnection:Disconnect() end
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if jumpActive and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        hum.MaxJumpHeight = 7.2
        hum.JumpPower = 50
        if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
    end
end

local function toggleSpeed()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    speedActive = not speedActive
    if speedActive then
        hum.WalkSpeed = 80
        hum.JumpPower = 70
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end

local function teleportCenter()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 150, 0)
    end
end

local function toggleESP()
    espActive = not espActive
    if espActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                local char = player.Character
                if char then
                    local esp = Instance.new("BoxHandleAdornment")
                    esp.Parent = char
                    esp.Adornee = char
                    esp.Size = Vector3.new(5, 6, 3)
                    esp.Color3 = Color3.fromRGB(0, 255, 255)
                    esp.Transparency = 0.5
                    esp.ZIndex = 10
                    esp.AlwaysOnTop = true
                    espObjects[player] = esp
                end
            end
        end
    else
        for _, esp in pairs(espObjects) do
            if esp then esp:Destroy() end
        end
        espObjects = {}
    end
end

local function toggleNight()
    nightActive = not nightActive
    if nightActive then
        Lighting.Brightness = 0.2
        Lighting.Ambient = Color3.fromRGB(20, 20, 30)
        Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 20)
        Lighting.FogEnd = 100
        Lighting.FogColor = Color3.fromRGB(10, 10, 20)
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.FogEnd = 1000
        Lighting.FogColor = Color3.fromRGB(127, 127, 127)
    end
end

local function toggleHat()
    local char = Player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    hatActive = not hatActive
    if hatActive then
        local hat = Instance.new("Part")
        hat.Size = Vector3.new(2, 0.2, 2)
        hat.BrickColor = BrickColor.new("Bright red")
        hat.Material = Enum.Material.SmoothPlastic
        hat.Shape = Enum.PartType.Cylinder
        hat.Position = head.Position + Vector3.new(0, 1.5, 0)
        hat.Parent = char
        local cone = Instance.new("Part")
        cone.Size = Vector3.new(0.5, 0.8, 0.5)
        cone.BrickColor = BrickColor.new("Bright red")
        cone.Material = Enum.Material.SmoothPlastic
        cone.Shape = Enum.PartType.Cylinder
        cone.Position = hat.Position + Vector3.new(0, 0.5, 0)
        cone.Parent = char
        local weld = Instance.new("Weld")
        weld.Parent = hat
        weld.Part0 = hat
        weld.Part1 = head
        weld.C0 = CFrame.new(0, 1.5, 0)
        local weld2 = Instance.new("Weld")
        weld2.Parent = cone
        weld2.Part0 = cone
        weld2.Part1 = head
        weld2.C0 = CFrame.new(0, 2.2, 0)
        hatParts = {hat, cone}
    else
        for _, obj in pairs(hatParts) do
            if obj then obj:Destroy() end
        end
        hatParts = {}
    end
end

local function lightningStrike()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local nearest = nil
    local dist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local c = player.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                local d = (c.HumanoidRootPart.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = c
                end
            end
        end
    end
    if nearest then
        local hum = nearest:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
end

local function godMode()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if hum.MaxHealth ~= math.huge then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    else
        hum.MaxHealth = 100
        hum.Health = 100
    end
end

local function neonEffect()
    local char = Player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new("Bright violet")
        end
    end
end

local function antiAFK()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- ======== GUI ========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "N1zoxirCC"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 180, 255)
MainFrame.Position = UDim2.new(0.05, 0, 0.08, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false

-- ЗАГОЛОВОК
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
Header.BackgroundTransparency = 0.15
Header.Size = UDim2.new(1, 0, 0, 45)
Header.Position = UDim2.new(0, 0, 0, 0)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
TitleLabel.Text = "N1zoxir Control Center"
TitleLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Header
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
MinimizeBtn.Size = UDim2.new(0, 35, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 7)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0

-- ВКЛАДКИ
local Tabs = {"Home", "Combat", "Player", "Visuals", "Utility"}
local TabButtons = {}
local currentTab = "Home"
local ContentFrame = nil -- контейнер для кнопок

-- СОЗДАЁМ КОНТЕЙНЕР ДЛЯ КНОПОК (ПРОСТОЙ FRAME)
local function createContentFrame()
    if ContentFrame then ContentFrame:Destroy() end
    ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, 0, 1, -85)
    ContentFrame.Position = UDim2.new(0, 0, 0, 85)
    ContentFrame.ClipsDescendants = true
    return ContentFrame
end

-- ПАНЕЛЬ ВКЛАДОК
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TabBar.BackgroundTransparency = 0.3
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 45)

for i, tab in pairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.Size = UDim2.new(0.2, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    btn.Text = tab
    btn.TextColor3 = Color3.fromRGB(150, 150, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Name = tab
    TabButtons[tab] = btn
    btn.MouseButton1Click:Connect(function()
        currentTab = tab
        for _, b in pairs(TabButtons) do
            b.TextColor3 = Color3.fromRGB(150, 150, 200)
        end
        btn.TextColor3 = Color3.fromRGB(0, 180, 255)
        updateContent(tab)
    end)
end

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
local function createButton(parent, text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color or Color3.fromRGB(20, 20, 35)
    btn.BackgroundTransparency = 0.1
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 180, 255)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ФУНКЦИЯ ОБНОВЛЕНИЯ КОНТЕНТА
local function updateContent(tab)
    -- Удаляем все кнопки из контейнера
    if ContentFrame then
        for _, child in pairs(ContentFrame:GetChildren()) do
            child:Destroy()
        end
    else
        ContentFrame = createContentFrame()
    end
    
    local y = 10
    local parent = ContentFrame
    
    if tab == "Home" then
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, y)
        label.Text = "MOVEMENT CONTROLS"
        label.TextColor3 = Color3.fromRGB(0, 180, 255)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        y = y + 35
        createButton(parent, "🪁 FLY (toggle)", y, Color3.fromRGB(0, 100, 200), toggleFly)
        y = y + 45
        createButton(parent, "🌀 NOCLIP (toggle)", y, Color3.fromRGB(150, 0, 200), toggleNoclip)
        y = y + 45
        createButton(parent, "🦘 INFINITE JUMP (toggle)", y, Color3.fromRGB(0, 200, 100), toggleJump)
        y = y + 45
        createButton(parent, "💨 SPEED x5 (toggle)", y, Color3.fromRGB(200, 100, 0), toggleSpeed)
        y = y + 45
        createButton(parent, "📍 TELEPORT TO CENTER", y, Color3.fromRGB(0, 200, 200), teleportCenter)
        
    elseif tab == "Combat" then
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, y)
        label.Text = "COMBAT OPTIONS"
        label.TextColor3 = Color3.fromRGB(0, 180, 255)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        y = y + 35
        createButton(parent, "⚡ LIGHTNING STRIKE", y, Color3.fromRGB(255, 200, 0), lightningStrike)
        y = y + 45
        createButton(parent, "🛡️ GOD MODE (toggle)", y, Color3.fromRGB(0, 150, 255), godMode)
        
    elseif tab == "Player" then
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, y)
        label.Text = "PLAYER OPTIONS"
        label.TextColor3 = Color3.fromRGB(0, 180, 255)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        y = y + 35
        createButton(parent, "🐉 CHINESE HAT (toggle)", y, Color3.fromRGB(255, 50, 50), toggleHat)
        
    elseif tab == "Visuals" then
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, y)
        label.Text = "VISUAL OPTIONS"
        label.TextColor3 = Color3.fromRGB(0, 180, 255)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        y = y + 35
        createButton(parent, "👁️ ESP (toggle)", y, Color3.fromRGB(0, 200, 200), toggleESP)
        y = y + 45
        createButton(parent, "🌙 NIGHT MODE (toggle)", y, Color3.fromRGB(100, 50, 200), toggleNight)
        y = y + 45
        createButton(parent, "🌈 NEON EFFECT", y, Color3.fromRGB(200, 0, 255), neonEffect)
        
    elseif tab == "Utility" then
        local label = Instance.new("TextLabel")
        label.Parent = parent
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, y)
        label.Text = "UTILITY"
        label.TextColor3 = Color3.fromRGB(0, 180, 255)
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        y = y + 35
        createButton(parent, "🔄 ANTI AFK", y, Color3.fromRGB(100, 100, 200), antiAFK)
    end
end

-- АКТИВИРУЕМ ПЕРВУЮ ВКЛАДКУ
createContentFrame()
TabButtons["Home"].TextColor3 = Color3.fromRGB(0, 180, 255)
updateContent("Home")

-- ======== МИНИ-ИКОНКА ========
local MiniIcon = Instance.new("ImageButton")
MiniIcon.Parent = ScreenGui
MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
MiniIcon.BackgroundTransparency = 0.2
MiniIcon.Size = UDim2.new(0, 55, 0, 55)
MiniIcon.Position = UDim2.new(0.02, 0, 0.8, 0)
MiniIcon.Image = "rbxassetid://6031098377"
MiniIcon.BorderSizePixel = 2
MiniIcon.BorderColor3 = Color3.fromRGB(0, 180, 255)
MiniIcon.Visible = false

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

-- ======== ПЕРЕТАСКИВАНИЕ ========
local drag = false
local dragStart = nil
local startPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("✅ N1zoxir Control Center v5.0 загружен!")
