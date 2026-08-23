-- N1zoxir Visuals ONLY v2.0 [NO CHEATS, ONLY VISUALS]
-- Только визуальные эффекты, без читов!

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- ======== НАСТРОЙКИ ========
local settings = {
    esp = false,
    night = false,
    hat = false,
    trail = false,
    rainbow = false,
    size = false
}

local trailParts = {}
local espObjects = {}
local hatParts = {}

-- ======== ТОЛЬКО ВИЗУАЛЫ ========
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
                    esp.Transparency = 0.4
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

local function toggleHat()
    local char = Player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    settings.hat = not settings.hat
    if settings.hat then
        local hat = Instance.new("Part")
        hat.Size = Vector3.new(2, 0.3, 2)
        hat.BrickColor = BrickColor.new("Really red")
        hat.Material = Enum.Material.Neon
        hat.Shape = Enum.PartType.Cylinder
        hat.Position = head.Position + Vector3.new(0, 1.5, 0)
        hat.Parent = char
        
        local cone = Instance.new("Part")
        cone.Size = Vector3.new(0.6, 1, 0.6)
        cone.BrickColor = BrickColor.new("Really red")
        cone.Material = Enum.Material.Neon
        cone.Shape = Enum.PartType.Cylinder
        cone.Position = hat.Position + Vector3.new(0, 0.6, 0)
        cone.Parent = char
        
        local ball = Instance.new("Part")
        ball.Size = Vector3.new(0.3, 0.3, 0.3)
        ball.BrickColor = BrickColor.new("Bright yellow")
        ball.Material = Enum.Material.Neon
        ball.Shape = Enum.PartType.Ball
        ball.Position = cone.Position + Vector3.new(0, 0.6, 0)
        ball.Parent = char
        
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
        
        local weld3 = Instance.new("Weld")
        weld3.Parent = ball
        weld3.Part0 = ball
        weld3.Part1 = head
        weld3.C0 = CFrame.new(0, 2.8, 0)
        
        hatParts = {hat, cone, ball}
    else
        for _, obj in pairs(hatParts) do
            if obj then obj:Destroy() end
        end
        hatParts = {}
    end
end

local function toggleTrail()
    settings.trail = not settings.trail
    if settings.trail then
        RunService.Heartbeat:Connect(function()
            if not settings.trail then return end
            local char = Player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local trail = Instance.new("Part")
            trail.Size = Vector3.new(0.5, 0.5, 0.5)
            trail.BrickColor = BrickColor.new("Bright cyan")
            trail.Material = Enum.Material.Neon
            trail.CFrame = root.CFrame
            trail.Anchored = true
            trail.CanCollide = false
            trail.Parent = workspace
            trail.Name = "TrailPart"
            
            table.insert(trailParts, trail)
            
            if #trailParts > 100 then
                local old = trailParts[1]
                if old then old:Destroy() end
                table.remove(trailParts, 1)
            end
        end)
    else
        for _, part in pairs(trailParts) do
            if part then part:Destroy() end
        end
        trailParts = {}
    end
end

local function toggleRainbow()
    settings.rainbow = not settings.rainbow
    if settings.rainbow then
        RunService.Heartbeat:Connect(function()
            if not settings.rainbow then return end
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.BrickColor = BrickColor.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
                end
            end
        end)
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

-- ======== МЕНЮ С ДИЗАЙНОМ ========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "N1zoxirVisuals"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

-- Заголовок
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Header.BackgroundTransparency = 0.2
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Position = UDim2.new(0, 0, 0, 0)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "N1zoxir Visuals ONLY"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- Кнопки
local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color or Color3.fromRGB(20, 20, 40)
    btn.BackgroundTransparency = 0.2
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 255)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local y = 65
createButton("👁️ ESP (обводка)", y, Color3.fromRGB(0, 200, 200), toggleESP)
y = y + 50
createButton("🌙 Ночной режим", y, Color3.fromRGB(100, 50, 200), toggleNight)
y = y + 50
createButton("🐉 Китайская шляпа", y, Color3.fromRGB(255, 50, 50), toggleHat)
y = y + 50
createButton("✨ Следы (трейл)", y, Color3.fromRGB(200, 0, 255), toggleTrail)
y = y + 50
createButton("🌈 Радуга", y, Color3.fromRGB(255, 200, 0), toggleRainbow)
y = y + 50
createButton("📏 Увеличение", y, Color3.fromRGB(255, 100, 0), toggleSize)

-- Закрытие
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame:Destroy()
    ScreenGui:Destroy()
end)

print("✅ N1zoxir Visuals ONLY загружен!")
print("🎨 Только визуалы, без читов!")
