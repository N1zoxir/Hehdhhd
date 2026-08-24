-- [[ San Diego | Visual Hub (Optimized & Fixed) ]] --
task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer

    -- Универсальный поиск контейнера для Delta / Roblox
    local guiParent = nil
    if gethui then
        local success, res = pcall(gethui)
        if success and res then guiParent = res end
    end
    if not guiParent then
        local success, res = pcall(function() return CoreGui end)
        if success and res then guiParent = res end
    end
    if not guiParent then
        guiParent = LocalPlayer:WaitForChild("PlayerGui", 10)
    end

    if not guiParent then return end

    -- Защита от дубликатов
    if guiParent:FindFirstChild("SanDiegoVisualsMenu") then
        guiParent.SanDiegoVisualsMenu:Destroy()
    end

    -- Главный контейнер
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SanDiegoVisualsMenu"
    ScreenGui.Parent = guiParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Кнопка открытия (Маленький квадрат "X" с синей обводкой)
    local OpenButton = Instance.new("TextButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 45, 0, 45)
    OpenButton.Position = UDim2.new(0, 50, 0.5, -22)
    OpenButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    OpenButton.Text = "X"
    OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenButton.TextSize = 18
    OpenButton.Font = Enum.Font.GothamBold
    OpenButton.Visible = true
    OpenButton.Parent = ScreenGui

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 8)
    OpenCorner.Parent = OpenButton

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(0, 170, 255) -- Синяя обводка
    OpenStroke.Thickness = 2
    OpenStroke.Parent = OpenButton

    -- Главное окно меню (Изначально скрыто)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -220, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(50, 50, 70)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    -- Шапка окна (с перетаскиванием)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    TopBar.BorderSizePixel = 0
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    local FixBar = Instance.new("Frame")
    FixBar.Size = UDim2.new(1, 0, 0, 10)
    FixBar.Position = UDim2.new(0, 0, 1, -10)
    FixBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    FixBar.BorderSizePixel = 0
    FixBar.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "SAN DIEGO — Visuals Hub"
    Title.TextColor3 = Color3.fromRGB(240, 240, 255)
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 1
    Title.Parent = TopBar

    -- Кнопка закрытия
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar

    -- Перетаскивание главного окна
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Перетаскивание кнопки "X"
    local openDragging, openDragInput, openDragStart, openStartPos
    OpenButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            openDragging = true
            openDragStart = input.Position
            openStartPos = OpenButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then openDragging = false end
            end)
        end
    end)
    OpenButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            openDragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == openDragInput and openDragging then
            local delta = input.Position - openDragStart
            OpenButton.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
        end
    end)

    -- Контейнер для функций (Список)
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Size = UDim2.new(1, -20, 1, -60)
    ContentContainer.Position = UDim2.new(0, 10, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentContainer.ScrollBarThickness = 3
    ContentContainer.Parent = MainFrame

    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)
    UIList.Parent = ContentContainer

    -- Функция создания переключателей
    local function CreateToggle(name, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = ContentContainer

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(210, 210, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 38, 0, 20)
        Switch.Position = UDim2.new(1, -48, 0.5, -10)
        Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        Switch.Text = ""
        Switch.Parent = ToggleFrame

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = UDim2.new(0, 2, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
        Circle.BorderSizePixel = 0
        Circle.Parent = Switch

        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = Circle

        local toggled = false
        Switch.MouseButton1Click:Connect(function()
            toggled = not toggled
            local goalColor = toggled and Color3.fromRGB(0, 180, 110) or Color3.fromRGB(50, 50, 70)
            local goalPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)

            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = goalPos}):Play()

            callback(toggled)
        end)
    end

    -- ========================================================
    -- ФУНКЦИОНАЛ
    -- ========================================================

    -- 1. ESP Игроков
    local espEnabled = false
    CreateToggle("ESP Игроков", function(state)
        espEnabled = state
        if not espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("SD_PlayerESP") then
                    player.Character.SD_PlayerESP:Destroy()
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            if espEnabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if not player.Character:FindFirstChild("SD_PlayerESP") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "SD_PlayerESP"
                            hl.Adornee = player.Character
                            hl.FillColor = Color3.fromRGB(255, 60, 60)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            hl.Parent = player.Character
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)

    -- 2. ESP Принтеров
    local printerEspEnabled = false
    local printerHighlights = {}
    CreateToggle("ESP Принтеров (Деньги)", function(state)
        printerEspEnabled = state
        if not printerEspEnabled then
            for _, h in pairs(printerHighlights) do
                if h then h:Destroy() end
            end
            printerHighlights = {}
        end
    end)

    task.spawn(function()
        while true do
            if printerEspEnabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and string.match(string.lower(obj.Name), "printer") then
                        if not printerHighlights[obj] then
                            local hl = Instance.new("Highlight")
                            hl.Name = "SD_PrinterESP"
                            hl.Adornee = obj
                            hl.FillColor = Color3.fromRGB(0, 255, 120)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.4
                            hl.Parent = obj
                            printerHighlights[obj] = hl
                        end
                    end
                end
            end
            task.wait(1.5)
        end
    end)

    -- 3. ESP Машин
    local carEspEnabled = false
    local carHighlights = {}
    CreateToggle("ESP Машин", function(state)
        carEspEnabled = state
        if not carEspEnabled then
            for _, h in pairs(carHighlights) do
                if h then h:Destroy() end
            end
            carHighlights = {}
        end
    end)

    task.spawn(function()
        while true do
            if carEspEnabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj:FindFirstChild("Steering") or obj:FindFirstChild("Wheels") or string.match(string.lower(obj.Name), "car") or string.match(string.lower(obj.Name), "vehicle") or string.match(string.lower(obj.Name), "automobile")) then
                        if not carHighlights[obj] then
                            local hl = Instance.new("Highlight")
                            hl.Name = "SD_CarESP"
                            hl.Adornee = obj
                            hl.FillColor = Color3.fromRGB(0, 160, 255)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            hl.Parent = obj
                            carHighlights[obj] = hl
                        end
                    end
                end
            end
            task.wait(2)
        end
    end)

    -- 4. Trails (Шлейф)
    local trailsEnabled = false
    CreateToggle("Trails (Шлейф за игроком)", function(state)
        trailsEnabled = state
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        if trailsEnabled and rootPart then
            if not rootPart:FindFirstChild("SD_Trail") then
                local attachment0 = Instance.new("Attachment", rootPart)
                attachment0.Name = "TrailAtt0"
                attachment0.Position = Vector3.new(0, 1, 0)

                local attachment1 = Instance.new("Attachment", rootPart)
                attachment1.Name = "TrailAtt1"
                attachment1.Position = Vector3.new(0, -1, 0)

                local trail = Instance.new("Trail")
                trail.Name = "SD_Trail"
                trail.Attachment0 = attachment0
                trail.Attachment1 = attachment1
                trail.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
                })
                trail.Lifetime = 0.8
                trail.MinLength = 0.1
                trail.Parent = rootPart
            end
        else
            if rootPart then
                if rootPart:FindFirstChild("SD_Trail") then rootPart.SD_Trail:Destroy() end
                if rootPart:FindFirstChild("TrailAtt0") then rootPart.TrailAtt0:Destroy() end
                if rootPart:FindFirstChild("TrailAtt1") then rootPart.TrailAtt1:Destroy() end
            end
        end
    end)

    -- 5. China Hat (Шляпа)
    local chinaHatEnabled = false
    CreateToggle("China Hat (Шляпа)", function(state)
        chinaHatEnabled = state
        local char = LocalPlayer.Character
        local head = char and char:FindFirstChild("Head")

        if chinaHatEnabled and head then
            if not head:FindFirstChild("SD_ChinaHat") then
                local hatPart = Instance.new("Part")
                hatPart.Name = "SD_ChinaHat"
                hatPart.Size = Vector3.new(2, 0.4, 2)
                hatPart.CFrame = head.CFrame + Vector3.new(0, 1, 0)
                hatPart.Color = Color3.fromRGB(240, 230, 210)
                hatPart.Material = Enum.Material.SmoothPlastic
                hatPart.CanCollide = false
                hatPart.Massless = true

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = "rbxassetid://1033714"
                mesh.Scale = Vector3.new(2.2, 0.8, 2.2)
                mesh.Parent = hatPart

                local weld = Instance.new("WeldConstraint")
                weld.Part0 = head
                weld.Part1 = hatPart
                weld.Parent = hatPart

                hatPart.Parent = head
            end
        else
            if head and head:FindFirstChild("SD_ChinaHat") then
                head.SD_ChinaHat:Destroy()
            end
        end
    end)

    -- 6. Invisible Player (Невидимка только для себя)
    CreateToggle("Invisible Player (Невидимка)", function(state)
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    if state then
                        part.LocalTransparencyModifier = 1
                    else
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    end)

    -- 7. Aura (Красные эффекты возле туловища)
    local auraEnabled = false
    CreateToggle("Aura (Красные эффекты)", function(state)
        auraEnabled = state
        local char = LocalPlayer.Character
        local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))

        if auraEnabled and torso then
            if not torso:FindFirstChild("SD_AuraEmitter") then
                local emitter = Instance.new("ParticleEmitter")
                emitter.Name = "SD_AuraEmitter"
                emitter.Color = ColorSequence.new(Color3.fromRGB(255, 30, 30))
                emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1.2)})
                emitter.Texture = "rbxassetid://258125463" -- Мягкая точка
                emitter.Lifetime = NumberRange.new(0.5, 1)
                emitter.Rate = 25
                emitter.Speed = NumberRange.new(2, 4)
                emitter.SpreadAngle = Vector2.new(360, 360)
                emitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
                emitter.Parent = torso
            end
        else
            if torso and torso:FindFirstChild("SD_AuraEmitter") then
                torso.SD_AuraEmitter:Destroy()
            end
        end
    end)

    -- 8. Purple Sky (Фиолетовое небо)
    CreateToggle("Purple Sky (Фиолетовое небо)", function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(90, 50, 120)
            Lighting.OutdoorAmbient = Color3.fromRGB(120, 80, 150)
            Lighting.ColorShift_Top = Color3.fromRGB(180, 100, 255)
            Lighting.ColorShift_Bottom = Color3.fromRGB(80, 20, 100)
        else
            Lighting.Ambient = Color3.fromRGB(120, 120, 120)
            Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        end
    end)

    -- 9. Night Mode
    CreateToggle("Night Mode (Ночь)", function(state)
        if state then
            Lighting.ClockTime = 0
            Lighting.Brightness = 0
            Lighting.Ambient = Color3.fromRGB(15, 15, 25)
        else
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(120, 120, 120)
        end
    end)

    -- 10. Fullbright
    CreateToggle("Fullbright (Яркий свет)", function(state)
        if state then
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
        end
    end)

    -- ========================================================
    -- АНИМАЦИИ ОТКРЫТИЯ ИЗ ПОЗИЦИИ КВАДРАТА «X»
    -- ========================================================

    local function CloseMenu()
        OpenButton.Position = MainFrame.Position
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        tween:Play()
        Title.TextTransparency = 1
        TopBar.BackgroundTransparency = 1
        tween.Completed:Wait()
        MainFrame.Visible = false
        OpenButton.Visible = true
        OpenButton.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(OpenButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 45, 0, 45)}):Play()
    end

    local function OpenMenu()
        if openDragging then return end
        
        -- Устанавливаем позицию меню точно туда, куда перетащили квадрат
        MainFrame.Position = OpenButton.Position

        TweenService:Create(OpenButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.1)
        OpenButton.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Title.TextTransparency = 0
        TopBar.BackgroundTransparency = 0
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, 440, 0, 380), BackgroundTransparency = 0}):Play()
    end

    CloseBtn.MouseButton1Click:Connect(CloseMenu)
    OpenButton.MouseButton1Click:Connect(OpenMenu)
end)
