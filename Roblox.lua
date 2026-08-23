-- N1zoxir Control Center v6.0 [ЛИСТАЙ И ПЕРЕМЕЩАЙ]
-- ВСЕ ФУНКЦИИ В ОДНОМ СПИСКЕ, СКРОЛЛ, ПЕРЕТАСКИВАНИЕ

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

-- ======== ВСЕ ФУНКЦИИ ========
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

-- ======== GUI С ПРОКРУТКОЙ ========
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
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
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

-- СКРОЛЛИНГ-КОНТЕЙНЕР
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Size = UDim2.new(1, 0, 1, -85)
ScrollFrame.Position = UDim2.new(0, 0, 0, 85)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
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

-- ЗАПОЛНЯЕМ ВСЕ ФУНКЦИИ В ОДИН СПИСОК
local y = 10

-- Заголовок
local label = Instance.new("TextLabel")
label.Parent = ScrollFrame
label.BackgroundTransparency = 1
label.Size = UDim2.new(1, 0, 0, 30)
label.Position = UDim2.new(0, 0, 0, y)
label.Text = "MOVEMENT"
label.TextColor3 = Color3.fromRGB(0, 180, 255)
label.TextSize = 14
label.Font = Enum.Font.GothamBold
y = y + 35

createButton("🪁 FLY (toggle)", y, Color3.fromRGB(0, 100, 200), toggleFly)
y = y + 45
createButton("🌀 NOCLIP (toggle)", y, Color3.fromRGB(150, 0, 200), toggleNoclip)
y = y + 45
createButton("🦘 INFINITE JUMP (toggle)", y, Color3.fromRGB(0, 200, 100), toggleJump)
y = y + 45
createButton("💨 SPEED x5 (toggle)", y, Color3.fromRGB(200, 100, 0), toggleSpeed)
y = y + 45
createButton("📍 TELEPORT TO CENTER", y, Color3.fromRGB(0, 200, 200), teleportCenter)

y = y + 60
local label2 = Instance.new("TextLabel")
label2.Parent = ScrollFrame
label2.BackgroundTransparency = 1
label2.Size = UDim2.new(1, 0, 0, 30)
label2.Position = UDim2.new(0, 0, 0, y)
label2.Text = "COMBAT"
label2.TextColor3 = Color3.fromRGB(0, 180, 255)
label2.TextSize = 14
label2.Font = Enum.Font.GothamBold
y = y + 35

createButton("⚡ LIGHTNING STRIKE", y, Color3.fromRGB(255, 200, 0), lightningStrike)
y = y + 45
createButton("🛡️ GOD MODE (toggle)", y, Color3.fromRGB(0, 150, 255), godMode)

y = y + 60
local label3 = Instance.new("TextLabel")
label3.Parent = ScrollFrame
label3.BackgroundTransparency = 1
label3.Size = UDim2.new(1, 0, 0, 30)
label3.Position = UDim2.new(0, 0, 0, y)
label3.Text = "PLAYER"
label3.TextColor3 = Color3.fromRGB(0, 180, 255)
label3.TextSize = 14
label3.Font = Enum.Font.GothamBold
y = y + 35

createButton("🐉 CHINESE HAT (toggle)", y, Color3.fromRGB(255, 50, 50), toggleHat)

y = y + 60
local label4 = Instance.new("TextLabel")
label4.Parent = ScrollFrame
label4.BackgroundTransparency = 1
label4.Size = UDim2.new(1, 0, 0, 30)
label4.Position = UDim2.new(0, 0, 0, y)
label4.Text = "VISUALS"
label4.TextColor3 = Color3.fromRGB(0, 180, 255)
label4.TextSize = 14
label4.Font = Enum.Font.GothamBold
y = y + 35

createButton("👁️ ESP (toggle)", y, Color3.fromRGB(0, 200, 200), toggleESP)
y = y + 45
createButton("🌙 NIGHT MODE (toggle)", y, Color3.fromRGB(100, 50, 200), toggleNight)
y = y + 45
createButton("🌈 NEON EFFECT", y, Color3.fromRGB(200, 0, 255), neonEffect)

y = y + 60
local label5 = Instance.new("TextLabel")
label5.Parent = ScrollFrame
label5.BackgroundTransparency = 1
label5.Size = UDim2.new(1, 0, 0, 30)
label5.Position = UDim2.new(0, 0, 0, y)
label5.Text = "UTILITY"
label5.TextColor3 = Color3.fromRGB(0, 180, 255)
label5.TextSize = 14
label5.Font = Enum.Font.GothamBold
y = y + 35

createButton("🔄 ANTI AFK", y, Color3.fromRGB(100, 100, 200), antiAFK)

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 50)

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

print("✅ N1zoxir Control Center v6.0 загружен!")
print("📱 Листай список, перетаскивай окно.")
