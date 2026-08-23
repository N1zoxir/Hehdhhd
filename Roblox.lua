-- N1zoxir ULTRA VISUAL v9.0 [FPS/PING + НОВЫЙ ДИЗАЙН]
-- Все функции: ESP, Night, Trail, Rainbow, Size, FPS/Ping
-- Меню с прокруткой, перетаскиванием, сворачиванием

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

-- ======== ПЕРЕМЕННЫЕ ========
local settings = {
    esp = false,
    night = false,
    trail = false,
    rainbow = false,
    size = false,
    showStats = false
}

local trailParts = {}
local espObjects = {}
local rainbowConnection = nil
local trailConnection = nil
local statLabel = nil
local statConnection = nil

-- ======== ФУНКЦИИ (ESP, NIGHT, TRAIL, RAINBOW, SIZE) ========
local function toggleESP()
    settings.esp = not settings.esp
    if settings.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                local char = player.Character
                if char then
                    local esp = Instance.new("BoxHandleAdornment")
                    esp.Parent = char
                    esp.Adornee = char
                    esp.Size = Vector3.new(5, 6, 3)
                    esp.Color3 = Color3.fromRGB(0, 255, 255)
                    esp.Transparency = 0.3
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
    settings.night = not settings.night
    if settings.night then
        Lighting.Brightness = 0.1
        Lighting.Ambient = Color3.fromRGB(10, 10, 20)
        Lighting.OutdoorAmbient = Color3.fromRGB(5, 5, 15)
        Lighting.FogEnd = 80
        Lighting.FogColor = Color3.fromRGB(5, 5, 15)
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.FogEnd = 1000
        Lighting.FogColor = Color3.fromRGB(127, 127, 127)
    end
end

local function toggleTrail()
    settings.trail = not settings.trail
    if settings.trail then
        if trailConnection then trailConnection:Disconnect() end
        trailConnection = RunService.Heartbeat:Connect(function()
            if not settings.trail then return end
            local char = Player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local trail = Instance.new("Part")
            trail.Size = Vector3.new(0.5, 0.5, 0.5)
            trail.BrickColor = BrickColor.new(Color3.fromHSV(math.random(), 1, 1))
            trail.Material = Enum.Material.Neon
            trail.CFrame = root.CFrame
            trail.Anchored = true
            trail.CanCollide = false
            trail.Parent = workspace
            trail.Name = "TrailPart"
            table.insert(trailParts, trail)
            if #trailParts > 150 then
                local old = trailParts[1]
                if old then old:Destroy() end
                table.remove(trailParts, 1)
            end
        end)
    else
        if trailConnection then trailConnection:Disconnect() trailConnection = nil end
        for _, part in pairs(trailParts) do if part then part:Destroy() end end
        trailParts = {}
    end
end

local function toggleRainbow()
    settings.rainbow = not settings.rainbow
    if settings.rainbow then
        if rainbowConnection then rainbowConnection:Disconnect() end
        rainbowConnection = RunService.Heartbeat:Connect(function()
            if not settings.rainbow then return end
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.BrickColor = BrickColor.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
                    part.Material = Enum.Material.Neon
                end
            end
        end)
    else
        if rainbowConnection then rainbowConnection:Disconnect() rainbowConnection = nil end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("White")
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
end

local function toggleSize()
    settings.size = not settings.size
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local scale = settings.size and 5 or 1
    root.Size = Vector3.new(2 * scale, 1 * scale, 1 * scale)
end

-- ======== FPS / PING (НОВАЯ ФУНКЦИЯ) ========
local function toggleStats()
    settings.showStats = not settings.showStats
    if settings.showStats then
        if not statLabel then
            local sg = Instance.new("ScreenGui")
            sg.Name = "N1zoxirStats"
            sg.Parent = Player.PlayerGui
            sg.ResetOnSpawn = false
            statLabel = Instance.new("TextLabel", sg)
            statLabel.Size = UDim2.new(0, 200, 0, 40)
            statLabel.Position = UDim2.new(0.02, 0, 0.02, 0)
            statLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            statLabel.BackgroundTransparency = 0.5
            statLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
            statLabel.TextSize = 18
            statLabel.Font = Enum.Font.GothamBold
            statLabel.Text = "FPS: 0 | Ping: 0ms"
            statLabel.TextXAlignment = Enum.TextXAlignment.Left
            statLabel.BorderSizePixel = 0
            statLabel.ZIndex = 10
            local corner = Instance.new("UICorner", statLabel)
            corner.CornerRadius = UDim.new(0, 8)
        end
        if statConnection then statConnection:Disconnect() end
        statConnection = RunService.RenderStepped:Connect(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = Stats.Network:GetAveragePing() * 1000
            statLabel.Text = string.format("⚡ FPS: %d  |  📶 Ping: %.0fms", fps, ping)
        end)
    else
        if statConnection then statConnection:Disconnect() statConnection = nil end
        if statLabel then
            local sg = statLabel.Parent
            if sg then sg:Destroy() end
            statLabel = nil
        end
    end
end

-- ======== ГЛАВНОЕ МЕНЮ (НОВЫЙ ДИЗАЙН) ========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "N1zoxirGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 180, 255)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -280)
MainFrame.Size = UDim2.new(0, 420, 0, 560)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
-- Скругление углов
local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

-- Заголовок
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
Header.BackgroundTransparency = 0.2
Header.Size = UDim2.new(1, 0, 0, 55)
Header.Position = UDim2.new(0, 0, 0, 0)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "⚡ N1zoxir PRO"
Title.TextColor3 = Color3.fromRGB(0, 180, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка сворачивания (в иконку)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Header
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -45, 0, 10)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 24
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", MinimizeBtn)
minCorner.CornerRadius = UDim.new(0, 6)

-- Контейнер с прокруткой
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Parent = MainFrame
ScrollContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Size = UDim2.new(1, 0, 1, -55)
ScrollContainer.Position = UDim2.new(0, 0, 0, 55)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.ScrollBarThickness = 6
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
ScrollContainer.ScrollBarImageTransparency = 0.5
ScrollContainer.BorderSizePixel = 0

-- Функция создания кнопки с новым дизайном
local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollContainer
    btn.BackgroundColor3 = color or Color3.fromRGB(20, 20, 40)
    btn.BackgroundTransparency = 0.15
    btn.Size = UDim2.new(0.88, 0, 0, 50)
    btn.Position = UDim2.new(0.06, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 17
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    -- Скругление кнопок
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)
    -- Тень
    local shadow = Instance.new("UIStroke", btn)
    shadow.Color = Color3.fromRGB(0, 180, 255)
    shadow.Thickness = 1.5
    shadow.Transparency = 0.3
    -- Анимация при наведении (для ПК) и нажатии
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Заполняем кнопки
local y = 10
createButton("👁️ ESP (обводка)", y, Color3.fromRGB(0, 200, 200), toggleESP)
y = y + 55
createButton("🌙 Ночной режим", y, Color3.fromRGB(100, 50, 200), toggleNight)
y = y + 55
createButton("✨ Радужный след", y, Color3.fromRGB(200, 0, 255), toggleTrail)
y = y + 55
createButton("🌈 Радуга на игроке", y, Color3.fromRGB(255, 200, 0), toggleRainbow)
y = y + 55
createButton("📏 Увеличение (x5)", y, Color3.fromRGB(255, 100, 0), toggleSize)
y = y + 55
createButton("📊 FPS / Ping (показ)", y, Color3.fromRGB(0, 255, 128), toggleStats)

ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- ======== МИНИ-ИКОНКА (ПРИ СВОРАЧИВАНИИ) ========
local MiniIcon = Instance.new("ImageButton")
MiniIcon.Parent = ScreenGui
MiniIcon.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
MiniIcon.BackgroundTransparency = 0.2
MiniIcon.Size = UDim2.new(0, 55, 0, 55)
MiniIcon.Position = UDim2.new(0.02, 0, 0.85, 0)
MiniIcon.Image = "rbxassetid://6031098377"
MiniIcon.BorderSizePixel = 2
MiniIcon.BorderColor3 = Color3.fromRGB(0, 180, 255)
MiniIcon.Visible = false
local miniCorner = Instance.new("UICorner", MiniIcon)
miniCorner.CornerRadius = UDim.new(1, 0)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

-- ======== ПЕРЕТАСКИВАНИЕ (ДЛЯ ТЕЛЕФОНА) ========
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

print("✅ N1zoxir PRO v9.0 загружен! (FPS/Ping, новый дизайн)")
