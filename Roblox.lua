-- N1zoxir: НОРМАЛЬНАЯ КИТАЙСКАЯ ШЛЯПА (КОНУС)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function createCoolieHat()
    local char = Player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    -- Удаляем старую шляпу, если она есть
    for _, child in pairs(char:GetChildren()) do
        if child.Name == "CoolieHat" then
            child:Destroy()
        end
    end

    -- 1. ОСНОВАНИЕ ШЛЯПЫ (широкий край)
    local base = Instance.new("Part")
    base.Name = "CoolieHat"
    base.Size = Vector3.new(2.4, 0.15, 2.4)
    base.BrickColor = BrickColor.new("Bright yellow") -- Цвет соломы
    base.Material = Enum.Material.SmoothPlastic
    base.Shape = Enum.PartType.Cylinder
    base.Position = head.Position + Vector3.new(0, 1.5, 0)
    base.Parent = char

    -- 2. КОНУС (основная часть шляпы)
    local cone = Instance.new("Part")
    cone.Name = "CoolieHat"
    cone.Size = Vector3.new(1.0, 1.4, 1.0)
    cone.BrickColor = BrickColor.new("Bright yellow")
    cone.Material = Enum.Material.SmoothPlastic
    cone.Shape = Enum.PartType.Cylinder
    cone.Position = head.Position + Vector3.new(0, 2.3, 0)
    cone.Parent = char

    -- 3. ВЕРХУШКА (закругление)
    local tip = Instance.new("Part")
    tip.Name = "CoolieHat"
    tip.Size = Vector3.new(0.3, 0.3, 0.3)
    tip.BrickColor = BrickColor.new("Bright yellow")
    tip.Material = Enum.Material.SmoothPlastic
    tip.Shape = Enum.PartType.Ball
    tip.Position = head.Position + Vector3.new(0, 3.0, 0)
    tip.Parent = char

    -- 4. ПРИВЯЗКА К ГОЛОВЕ (через Weld)
    local function weldHat(part)
        local weld = Instance.new("Weld")
        weld.Parent = part
        weld.Part0 = part
        weld.Part1 = head
        weld.C0 = part.CFrame:inverse() * head.CFrame
    end

    weldHat(base)
    weldHat(cone)
    weldHat(tip)

    print("✅ Китайская шляпа создана!")
end

-- ВЫЗЫВАЕМ ФУНКЦИЮ
createCoolieHat()
