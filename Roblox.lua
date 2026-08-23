-- N1zoxir Over Mod v4.0 [FULL FIXED]
-- Для Arceus X / Hydrogen / Codex
-- Работает: FLY, NOCLIP, INFINITE JUMP, SPEED, TELEPORT + НОВЫЙ GUI

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ======== ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ ========
local flyActive = false
local flyBodyVelocity = nil
local noclipActive = false
local noclipConnection = nil
local jumpActive = false
local jumpConnection = nil
local speedActive = false

-- ======== ФУНКЦИИ ДВИЖЕНИЯ ========

-- ФЛАЙ (БЕСКОНЕЧНЫЙ, РАБОЧИЙ)
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
        print("[FLY] ON")
    else
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        print("[FLY] OFF")
    end
end

-- НОКЛИП (РАБОЧИЙ, БЕЗ СБОЕВ)
local function toggleNoclip()
    noclipActive = not noclipActive

    if noclipActive then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        print("[NOCLIP] ON")
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        print("[NOCLIP] OFF")
    end
end

-- ИНФИНИТИ ДЖАМП (РАБОЧИЙ)
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
            if jumpActive and hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        print("[INFINITE JUMP] ON")
    else
        hum.MaxJumpHeight = 7.2
        hum.JumpPower = 50
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        print("[INFINITE JUMP] OFF")
    end
end

-- СПИД (x5)
local function toggleSpeed()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    speedActive = not speedActive

    if speedActive then
        hum.WalkSpeed = 80
        hum.JumpPower = 70
        print("[SPEED] ON")
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        print("[SPEED] OFF")
    end
end

-- ТЕЛЕПОРТ
local function teleportToCenter()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 150, 0)
        print("[TELEPORT] TO CENTER")
    end
end

-- ======== ГЛАВНОЕ МЕНЮ (НОВЫЙ GUI) ========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "N1zoxirGUI"
ScreenGui.ResetOnSpawn = false

-- ОСНОВНАЯ ПАНЕЛЬ
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
MainFrame.Position = UDim2.new(0.1, 0, 0.05, 0)
MainFrame.Size = UDim2.new(0, 380, 0, 580)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
Title.BackgroundTransparency = 0.2
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "N1zoxir Over Mod v4.0"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Center

-- КНОПКА ЗАКРЫТИЯ (КРЕСТИК)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Size = UDim2.new(0, 50, 0, 40)
CloseBtn.Position = UDim2.new(1, -55, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true -- ПОЯВЛЯЕТСЯ МАЛЕНЬКАЯ ИКОНКА
end)

-- ======== КОНТЕЙНЕР ДЛЯ КНОПОК (СКРОЛЛИНГ) ========
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Parent = MainFrame
ScrollContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Size = UDim2.new(1, 0, 1, -50)
ScrollContainer.Position = UDim2.new(0, 0, 0, 50)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.ScrollBarThickness = 8
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)

local function addCategory(title, yPos)
    local cat = Instance.new("TextLabel")
    cat.Parent = ScrollContainer
    cat.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    cat.BackgroundTransparency = 0.8
    cat.Size = UDim2.new(0.9, 0, 0, 30)
    cat.Position = UDim2.new(0.05, 0, 0, yPos)
    cat.Text = title
    cat.TextColor3 = Color3.fromRGB(0, 200, 255)
    cat.TextSize = 18
    cat.Font = Enum.Font.GothamBold
    cat.TextXAlignment = Enum.TextXAlignment.Left
    return cat
end

local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollContainer
    btn.BackgroundColor3 = color or Color3.fromRGB(25, 25, 45)
    btn.BackgroundTransparency = 0.1
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 255)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ======== КНОПКИ ПО КАТЕГОРИЯМ ========
local y = 10
addCategory("▶ MOVEMENT", y)
y = y + 35
createButton("🪁 FLY (toggle)", y, Color3.fromRGB(0, 100, 200), toggleFly)
y = y + 50
createButton("🌀 NOCLIP (toggle)", y, Color3.fromRGB(150, 0, 200), toggleNoclip)
y = y + 50
createButton("🦘 INFINITE JUMP (toggle)", y, Color3.fromRGB(0, 200, 100), toggleJump)
y = y + 50
createButton("💨 SPEED x5 (toggle)", y, Color3.fromRGB(200, 100, 0), toggleSpeed)
y = y + 50
createButton("📍 TELEPORT TO CENTER", y, Color3.fromRGB(0, 200, 200), teleportToCenter)

y = y + 70
addCategory("▶ FIGHT", y)
y = y + 35
createButton("⚡ LIGHTNING STRIKE", y, Color3.fromRGB(255, 200, 0), function()
    print("[LIGHTNING] NOT IMPLEMENTED YET")
end)
y = y + 50
createButton("🛡️ GOD MODE (toggle)", y, Color3.fromRGB(0, 150, 255), function()
    print("[GOD MODE] NOT IMPLEMENTED YET")
end)

y = y + 70
addCategory("▶ UTILS", y)
y = y + 35
createButton("🌈 NEON EFFECT", y, Color3.fromRGB(200, 0, 255), function()
    print("[NEON] NOT IMPLEMENTED YET")
end)

ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, y + 50)

-- ======== МАЛЕНЬКАЯ ИКОНКА (ПЛАВАЮЩАЯ) ========
local MiniIcon = Instance.new("ImageButton")
MiniIcon.Parent = ScreenGui
MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
MiniIcon.BackgroundTransparency = 0.2
MiniIcon.Size = UDim2.new(0, 60, 0, 60)
MiniIcon.Position = UDim2.new(0.02, 0, 0.8, 0)
MiniIcon.Image = "rbxassetid://6031098377" -- Шестеренка
MiniIcon.BorderSizePixel = 2
MiniIcon.BorderColor3 = Color3.fromRGB(0, 200, 255)
MiniIcon.Visible = false

MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
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

print("✅ N1zoxir Over Mod v4.0 [FULL FIXED] загружен!")
print("📱 Нажми на шестерёнку внизу экрана, чтобы открыть меню.")
