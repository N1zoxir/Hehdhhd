-- N1zoxir Over Mod v3.0 [MOBILE]
-- Для Arceus X / Hydrogen / Codex
-- Работает на телефоне!

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ======== СОЗДАЁМ GUI ДЛЯ ТЕЛЕФОНА ========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "N1zoxirMobile"

-- ======== ГЛАВНОЕ МЕНЮ (БОЛЬШИЕ КНОПКИ ДЛЯ ПАЛЬЦЕВ) ========
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 520)
MainFrame.Active = true
MainFrame.Draggable = true

-- ======== ЗАГОЛОВОК ========
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 30, 50)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "🔥 N1zoxir Mod [Mobile]"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Center

-- ======== КНОПКА ЗАКРЫТИЯ (БОЛЬШАЯ) ========
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
CloseBtn.Size = UDim2.new(0, 50, 0, 40)
CloseBtn.Position = UDim2.new(1, -55, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ======== ФУНКЦИЯ СОЗДАНИЯ БОЛЬШИХ КНОПОК ========
local function CreateBigButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
    btn.BackgroundTransparency = 0.2
    btn.Size = UDim2.new(0.85, 0, 0, 50)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 255)
    btn.MouseButton1Click:Connect(callback)
    
    -- Эффект нажатия для телефона
    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    end)
    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
    end)
    return btn
end

-- ======== ФУНКЦИИ ДЛЯ ТЕЛЕФОНА ========
local function FlyMobile()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(4000, 4000, 4000)
    bv.Velocity = Vector3.new(0, 30, 0)
    bv.Parent = root
    task.wait(0.3)
    bv:Destroy()
end

local function SpeedMobile()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if hum.WalkSpeed ~= 80 then
        hum.WalkSpeed = 80
        hum.JumpPower = 70
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end

local function NoclipMobile()
    local char = Player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not part.CanCollide
        end
    end
end

local function JumpMobile()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if hum.MaxJumpHeight == 50 then
        hum.MaxJumpHeight = 7.2
    else
        hum.MaxJumpHeight = 50
    end
end

local function TeleportMobile()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 150, 0)
    end
end

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

-- ======== БОЛЬШИЕ КНОПКИ ДЛЯ ТЕЛЕФОНА ========
CreateBigButton("🪁 FLY", 60, Color3.fromRGB(0, 100, 200), FlyMobile)
CreateBigButton("💨 SPEED x5", 120, Color3.fromRGB(200, 100, 0), SpeedMobile)
CreateBigButton("🌀 NOCLIP", 180, Color3.fromRGB(150, 0, 200), NoclipMobile)
CreateBigButton("🦘 INFINITE JUMP", 240, Color3.fromRGB(0, 200, 100), JumpMobile)
CreateBigButton("🛡️ GOD MODE", 300, Color3.fromRGB(0, 150, 255), GodMobile)
CreateBigButton("📍 TELEPORT", 360, Color3.fromRGB(0, 200, 200), TeleportMobile)

-- ======== КНОПКА ВЫХОДА ========
local ExitMobile = Instance.new("TextButton")
ExitMobile.Parent = MainFrame
ExitMobile.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ExitMobile.Size = UDim2.new(0.85, 0, 0, 50)
ExitMobile.Position = UDim2.new(0.075, 0, 0, 420)
ExitMobile.Text = "❌ ВЫХОД"
ExitMobile.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitMobile.TextSize = 20
ExitMobile.Font = Enum.Font.GothamBold
ExitMobile.BorderSizePixel = 2
ExitMobile.BorderColor3 = Color3.fromRGB(255, 0, 0)
ExitMobile.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ======== ОТКРЫТИЕ ПО КНОПКЕ (ДЛЯ ТЕЛЕФОНА) ========
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType == Enum.UserInputType.Touch then
            -- Двойной тап по экрану (имитация)
            print("👆 Нажми на иконку в левом верхнем углу")
        end
    end
end)

-- ======== ДОБАВЛЯЕМ КНОПКУ НА ЭКРАН (ДЛЯ ТЕЛЕФОНА) ========
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
ToggleBtn.Image = "rbxassetid://6031098377" -- шестерёнка
ToggleBtn.BorderSizePixel = 0

ToggleBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        MainFrame.Visible = true
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    end
end)

print("✅ N1zoxir Over Mod v3.0 [MOBILE] загружен!")
print("📱 Нажми на шестерёнку внизу экрана")
