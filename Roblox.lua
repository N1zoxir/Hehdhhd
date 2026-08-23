-- N1zoxir Over Mod v3.1 [MOBILE ULTRA]
-- Для Arceus X / Hydrogen / Codex
-- Фикс: FLY, NOCLIP, INFINITE JUMP
-- Новый дизайн + плавающая иконка

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ======== ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ ========
local flyActive = false
local flyBodyVel = nil
local noclipActive = false
local jumpActive = false

-- ======== ГЛАВНОЕ МЕНЮ ========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "N1zoxirMenu"
ScreenGui.ResetOnSpawn = false

-- ======== ФОН МЕНЮ (НОВЫЙ ДИЗАЙН) ========
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 200) -- НЕОНОВЫЙ РОЗОВЫЙ
MainFrame.Position = UDim2.new(0.1, 0, 0.08, 0)
MainFrame.Size = UDim2.new(0, 380, 0, 580)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false

-- ======== ЗАГОЛОВОК С ГРАДИЕНТОМ ========
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
Title.BackgroundTransparency = 0.2
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "🔥 N1zoxir Over Mod v3.1"
Title.TextColor3 = Color3.fromRGB(255, 0, 200)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Center

-- ======== КНОПКА ЗАКРЫТИЯ (КРАСНЫЙ КРЕСТ) ========
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Size = UDim2.new(0, 50, 0, 40)
CloseBtn.Position = UDim2.new(1, -55, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true -- ПОЯВЛЯЕТСЯ МАЛЕНЬКИЙ КВАДРАТИК
end)

-- ======== ФУНКЦИЯ СОЗДАНИЯ КНОПОК (НОВЫЙ СТИЛЬ) ========
local function CreateButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color or Color3.fromRGB(25, 25, 45)
    btn.BackgroundTransparency = 0.1
    btn.Size = UDim2.new(0.82, 0, 0, 50)
    btn.Position = UDim2.new(0.09, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255, 0, 200)
    
    -- ЭФФЕКТ НАЖАТИЯ
    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 80)
    end)
    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = color or Color3.fromRGB(25, 25, 45)
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ======== ФУНКЦИИ С ФИКСАМИ ========

-- **ФЛАЙ (БЕСКОНЕЧНЫЙ)**
local function FlyMobile()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if flyActive then
        flyActive = false
        if flyBodyVel then flyBodyVel:Destroy() end
        return
    end
    
    flyActive = true
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
    flyBodyVel.Velocity = Vector3.new(0, 30, 0)
    flyBodyVel.Parent = root
    
    -- АВТООТКЛЮЧЕНИЕ ПО ПОВТОРНОМУ НАЖАТИЮ
end

-- **НОКЛИП (РАБОЧИЙ)**
local function NoclipMobile()
    local char = Player.Character
    if not char then return end
    
    noclipActive = not noclipActive
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclipActive
        end
    end
    
    -- ПОСТОЯННЫЙ НОКЛИП (ЧЕРЕЗ СТИМ)
    if noclipActive then
        game:GetService("RunService").Stepped:Connect(function()
            if not noclipActive then return end
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end

-- **ИНФИНИТИ ДЖАМП (РАБОЧИЙ)**
local function JumpMobile()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    jumpActive = not jumpActive
    
    if jumpActive then
        hum.MaxJumpHeight = 50
        -- БЕСКОНЕЧНЫЙ ДЖАМП ЧЕРЕЗ ПРЫЖОК
        hum.JumpPower = 80
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if jumpActive and hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        hum.MaxJumpHeight = 7.2
        hum.JumpPower = 50
    end
end

-- **ТЕЛЕПОРТ**
local function TeleportMobile()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 150, 0)
    end
end

-- **ГОД МОД**
local function GodMobile()
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

-- **УДАР МОЛНИИ**
local function LightningStrike()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local lightning = Instance.new("Part")
    lightning.Size = Vector3.new(1, 50, 1)
    lightning.BrickColor = BrickColor.new("Bright yellow")
    lightning.Material = Enum.Material.Neon
    lightning.CFrame = root.CFrame + Vector3.new(0, 25, 0)
    lightning.Parent = workspace
    lightning.Anchored = true
    
    -- УДАР ПО БЛИЖАЙШЕМУ ИГРОКУ
    local nearest = nil
    local dist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local d = (char.HumanoidRootPart.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = char
                end
            end
        end
    end
    
    if nearest then
        local hum = nearest:FindFirstChild("Humanoid")
        if hum then
            hum.Health = 0
        end
    end
    
    game:GetService("Debris"):AddItem(lightning, 0.5)
end

-- **ЭФФЕКТ НЕОНА**
local function NeonEffect()
    local char = Player.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new("Bright violet")
        end
    end
end

-- ======== КНОПКИ С НОВЫМИ ФУНКЦИЯМИ ========
CreateButton("🪁 FLY (toggle)", 60, Color3.fromRGB(0, 100, 200), FlyMobile)
CreateButton("💨 SPEED x5", 120, Color3.fromRGB(200, 100, 0), SpeedMobile)
CreateButton("🌀 NOCLIP (toggle)", 180, Color3.fromRGB(150, 0, 200), NoclipMobile)
CreateButton("🦘 INFINITE JUMP (toggle)", 240, Color3.fromRGB(0, 200, 100), JumpMobile)
CreateButton("🛡️ GOD MODE", 300, Color3.fromRGB(0, 150, 255), GodMobile)
CreateButton("📍 TELEPORT", 360, Color3.fromRGB(0, 200, 200), TeleportMobile)
CreateButton("⚡ LIGHTNING STRIKE", 420, Color3.fromRGB(255, 200, 0), LightningStrike)
CreateButton("🌈 NEON EFFECT", 480, Color3.fromRGB(200, 0, 255), NeonEffect)

-- ======== МАЛЕНЬКИЙ КВАДРАТИК (ПЛАВАЮЩАЯ ИКОНКА) ========
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 200)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.8, 0)
ToggleBtn.Image = "rbxassetid://6031098377" -- шестерёнка
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 200)
ToggleBtn.Visible = false -- СНАЧАЛА СКРЫТА

-- ПРИ НАЖАТИИ НА КВАДРАТИК - ОТКРЫВАЕМ МЕНЮ
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- ======== ПЕРЕТАСКИВАНИЕ ДЛЯ ТЕЛЕФОНА ========
local dragging = false
local dragStart = nil
local startPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("✅ N1zoxir Over Mod v3.1 [MOBILE ULTRA] загружен!")
print("📱 Нажми на шестерёнку внизу экрана"
