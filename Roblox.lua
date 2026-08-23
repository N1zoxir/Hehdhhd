-- КИТАЙСКАЯ ШЛЯПА (РАБОЧАЯ, БЕЗ ЧИТОВ)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function createHat()
    local char = Player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    -- Удаляем старую шляпу
    for _, v in pairs(char:GetChildren()) do
        if v.Name == "ChinaHat" then v:Destroy() end
    end
    
    -- ОСНОВАНИЕ (широкая часть)
    local base = Instance.new("Part")
    base.Name = "ChinaHat"
    base.Size = Vector3.new(2.5, 0.2, 2.5)
    base.BrickColor = BrickColor.new("Bright red")
    base.Material = Enum.Material.SmoothPlastic
    base.Shape = Enum.PartType.Cylinder
    base.CFrame = head.CFrame * CFrame.new(0, 1.5, 0)
    base.Parent = char
    
    -- КОНУС (верхушка)
    local cone = Instance.new("Part")
    cone.Name = "ChinaHat"
    cone.Size = Vector3.new(0.8, 1.2, 0.8)
    cone.BrickColor = BrickColor.new("Bright red")
    cone.Material = Enum.Material.SmoothPlastic
    cone.Shape = Enum.PartType.Cylinder
    cone.CFrame = head.CFrame * CFrame.new(0, 2.2, 0)
    cone.Parent = char
    
    -- ШАРИК НА КОНУСЕ
    local ball = Instance.new("Part")
    ball.Name = "ChinaHat"
    ball.Size = Vector3.new(0.4, 0.4, 0.4)
    ball.BrickColor = BrickColor.new("Bright yellow")
    ball.Material = Enum.Material.Neon
    ball.Shape = Enum.PartType.Ball
    ball.CFrame = head.CFrame * CFrame.new(0, 2.8, 0)
    ball.Parent = char
    
    -- ПРИВЯЗКА (Weld)
    local function weld(part)
        local w = Instance.new("Weld")
        w.Parent = part
        w.Part0 = part
        w.Part1 = head
        w.C0 = part.CFrame:inverse() * head.CFrame
    end
    
    weld(base)
    weld(cone)
    weld(ball)
end

-- ВЫЗОВ
createHat()
