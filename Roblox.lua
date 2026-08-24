-- [[ San Diego | Visual Hub (Full Fixed Visuals + New Features + Advanced Static/Info) ]] --
task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    -- Защита от дубликатов интерфейса
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

    if guiParent:FindFirstChild("SanDiegoVisualsMenu") then
        guiParent.SanDiegoVisualsMenu:Destroy()
    end

    -- Главный GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SanDiegoVisualsMenu"
    ScreenGui.Parent = guiParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Кнопка открытия меню
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
    OpenStroke.Color = Color3.fromRGB(0, 170, 255)
    OpenStroke.Thickness = 2
    OpenStroke.Parent = OpenButton

    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
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

    -- Шапка
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
    Title.Text = "SAN DIEGO — Hub (PRO)"
    Title.TextColor3 = Color3.fromRGB(240, 240, 255)
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 1
    Title.Parent = TopBar

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

    -- Вкладки
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 35)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.Parent = TabContainer

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -20, 1, -95)
    PagesContainer.Position = UDim2.new(0, 10, 0, 90)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = MainFrame

    local pages = {}
    local currentTabBtn = nil

    local function CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
        TabBtn.TextSize = 13
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Parent = TabContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollBarThickness = 3
        Page.Parent = PagesContainer

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = Page

        pages[name] = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do p.Visible = false end
            Page.Visible = true

            if currentTabBtn then
                TweenService:Create(currentTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 38), TextColor3 = Color3.fromRGB(150, 150, 170)}):Play()
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            currentTabBtn = TabBtn
        end)

        if not currentTabBtn then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            currentTabBtn = TabBtn
        end

        return Page
    end

    local StaticPage = CreateTab("Static")
    local VisualsPage = CreateTab("Visuals")

    local function CreateToggle(parentPage, name, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parentPage

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
    -- ВКЛАДКА STATIC: PING, FPS, INTERNET + INFORMATION
    -- ========================================================
    
    -- Оверлей Пинг / ФПС
    local StatsOverlay = Instance.new("TextLabel")
    StatsOverlay.Name = "StatsOverlay"
    StatsOverlay.Size = UDim2.new(0, 180, 0, 75)
    StatsOverlay.Position = UDim2.new(0, 15, 0, 15)
    StatsOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    StatsOverlay.BackgroundTransparency = 0.3
    StatsOverlay.TextColor3 = Color3.fromRGB(0, 255, 120)
    StatsOverlay.TextSize = 13
    StatsOverlay.Font = Enum.Font.Code
    StatsOverlay.TextXAlignment = Enum.TextXAlignment.Left
    StatsOverlay.TextYAlignment = Enum.TextYAlignment.Top
    StatsOverlay.Visible = false
    StatsOverlay.Parent = ScreenGui

    local OverlayCorner = Instance.new("UICorner")
    OverlayCorner.CornerRadius = UDim.new(0, 8)
    OverlayCorner.Parent = StatsOverlay

    local OverlayPadding = Instance.new("UIPadding")
    OverlayPadding.PaddingLeft = UDim.new(0, 10)
    OverlayPadding.PaddingTop = UDim.new(0, 8)
    OverlayPadding.Parent = StatsOverlay

    local statsEnabled = false
    CreateToggle(StaticPage, "Show Stats (Ping, FPS, Internet)", function(state)
        statsEnabled = state
        StatsOverlay.Visible = state
    end)

    -- Оверлей Information (Время в игре, входы и т.д.)
    local InfoOverlay = Instance.new("TextLabel")
    InfoOverlay.Name = "InfoOverlay"
    InfoOverlay.Size = UDim2.new(0, 220, 0, 95)
    InfoOverlay.Position = UDim2.new(0, 15, 0, 105)
    InfoOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    InfoOverlay.BackgroundTransparency = 0.3
    InfoOverlay.TextColor3 = Color3.fromRGB(0, 170, 255)
    InfoOverlay.TextSize = 12
    InfoOverlay.Font = Enum.Font.Code
    InfoOverlay.TextXAlignment = Enum.TextXAlignment.Left
    InfoOverlay.TextYAlignment = Enum.TextYAlignment.Top
    InfoOverlay.Visible = false
    InfoOverlay.Parent = ScreenGui

    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 8)
    InfoCorner.Parent = InfoOverlay

    local InfoPadding = Instance.new("UIPadding")
    InfoPadding.PaddingLeft = UDim.new(0, 10)
    InfoPadding.PaddingTop = UDim.new(0, 8)
    InfoPadding.Parent = InfoOverlay

    local sessionStartTime = tick()
    local joinCount = 1 -- Количество заходов в сессию
    local infoEnabled = false

    CreateToggle(StaticPage, "Information (Время в игре / Статистика)", function(state)
        infoEnabled = state
        InfoOverlay.Visible = state
    end)

    -- Расчет FPS, Ping и Информации
    local lastTime = tick()
    local frameCount = 0
    local currentFPS = 60

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            currentFPS = frameCount
            frameCount = 0
            lastTime = currentTime
        end

        if statsEnabled then
            local pingVal = 0
            pcall(function()
                pingVal = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            end)
            StatsOverlay.Text = string.format(" 📊 SYSTEM STATS\n FPS: %d\n Ping: %d ms\n Internet: %d ms", currentFPS, pingVal, pingVal)
        end

        if infoEnabled then
            local playTimeSec = math.floor(tick() - sessionStartTime)
            local hours = math.floor(playTimeSec / 3600)
            local mins = math.floor((playTimeSec % 3600) / 60)
            local secs = playTimeSec % 60

            InfoOverlay.Text = string.format(" ℹ️ PLAYER INFO\n User: %s\n Session Time: %02d:%02d:%02d\n Visits / Joins: %d\n Server ID: %s", 
                LocalPlayer.Name, hours, mins, secs, joinCount, tostring(game.JobId):sub(1, 6).."...")
        end
    end)


    -- ========================================================
    -- ВКЛАДКА VISUALS (ИСПРАВЛЕННЫЕ И НОВЫЕ ФУНКЦИИ)
    -- ========================================================

    -- 1. ESP Игроков
    local espEnabled = false
    CreateToggle(VisualsPage, "ESP Игроков", function(state)
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
    CreateToggle(VisualsPage, "ESP Принтеров (Деньги)", function(state)
        printerEspEnabled = state
        if not printerEspEnabled then
            for _, h in pairs(printerHighlights) do if h then h:Destroy() end end
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
    CreateToggle(VisualsPage, "ESP Машин", function(state)
        carEspEnabled = state
        if not carEspEnabled then
            for _, h in pairs(carHighlights) do if h then h:Destroy() end end
            carHighlights = {}
        end
    end)

    task.spawn(function()
        while true do
            if carEspEnabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj:FindFirstChild("Steering") or obj:FindFirstChild("Wheels") or string.match(string.lower(obj.Name), "car") or string.match(string.lower(obj.Name), "vehicle")) then
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

    -- 4. Fullbright (Яркий свет без тени)
    local fullbrightConn = nil
    CreateToggle(VisualsPage, "Fullbright (Яркое освещение)", function(state)
        if state then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            fullbrightConn = RunService.RenderStepped:Connect(function()
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
            end)
        else
            if fullbrightConn then fullbrightConn:Disconnect() end
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end)

    -- 5. FOV Changer (Широкий угол обзора)
    CreateToggle(VisualsPage, "FOV Changer (Угол обзора 100)", function(state)
        if state then
            Camera.FieldOfView = 100
        else
            Camera.FieldOfView = 70
        end
    end)

    -- 6. Trails (Шлейф)
    CreateToggle(VisualsPage, "Trails (Шлейф за игроком)", function(state)
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if state and rootPart then
            if not rootPart:FindFirstChild("SD_Trail") then
                local att0 = Instance.new("Attachment", rootPart)
                att0.Name = "TrailAtt0"
                att0.Position = Vector3.new(0, 1, 0)
                local att1 = Instance.new("Attachment", rootPart)
                att1.Name = "TrailAtt1"
                att1.Position = Vector3.new(0, -1, 0)
                local trail = Instance.new("Trail")
                trail.Name = "SD_Trail"
                trail.Attachment0 = att0
                trail.Attachment1 = att1
                trail.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
                })
                trail.Lifetime = 0.8
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

    -- 7. China Hat (Шляпа)
    CreateToggle(VisualsPage, "China Hat (Шляпа)", function(state)
        local char = LocalPlayer.Character
        local head = char and char:FindFirstChild("Head")
        if state and head then
            if not head:FindFirstChild("SD_ChinaHat") then
                local hatPart = Instance.new("Part")
                hatPart.Name = "SD_ChinaHat"
                hatPart.Size = Vector3.new(2, 0.4, 2)
                hatPart.Color = Color3.fromRGB(240, 230, 210)
                hatPart.CanCollide = false
                hatPart.Massless = true
                local mesh = Instance.new("SpecialMesh", hatPart)
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = "rbxassetid://1033714"
                mesh.Scale = Vector3.new(2.2, 0.8, 2.2)
                local weld = Instance.new("WeldConstraint", hatPart)
                weld.Part0 = head
                weld.Part1 = hatPart
                hatPart.Parent = head
            end
        else
            if head and head:FindFirstChild("SD_ChinaHat") then head.SD_ChinaHat:Destroy() end
        end
    end)

    -- 8. Invisible Player (Невидимка)
    CreateToggle(VisualsPage, "Invisible Player (Невидимка)", function(state)
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.LocalTransparencyModifier = state and 1 or 0
                end
            end
        end
    end)

    -- 9. Aura (Красная аура)
    CreateToggle(VisualsPage, "Aura (Красные эффекты)", function(state)
        local char = LocalPlayer.Character
        local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        if state and torso then
            if not torso:FindFirstChild("SD_AuraEmitter") then
                local emitter = Instance.new("ParticleEmitter", torso)
                emitter.Name = "SD_AuraEmitter"
                emitter.Color = ColorSequence.new(Color3.fromRGB(255, 30, 30))
                emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1.2)})
                emitter.Texture = "rbxassetid://258125463"
                emitter.Lifetime = NumberRange.new(0.5, 1)
                emitter.Rate = 25
                emitter.Speed = NumberRange.new(2, 4)
            end
        else
            if torso and torso:FindFirstChild("SD_AuraEmitter") then torso.SD_AuraEmitter:Destroy() end
        end
    end)

    -- 10. Purple Sky (Фиолетовое небо)
    CreateToggle(VisualsPage, "Purple Sky (Фиолетовое небо)", function(state)
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


    -- Анимация меню
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
        MainFrame.Position = OpenButton.Position
        TweenService:Create(OpenButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.1)
        OpenButton.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Title.TextTransparency = 0
        TopBar.BackgroundTransparency = 0
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, 440, 0, 400), BackgroundTransparency = 0}):Play()
    end

    CloseBtn.MouseButton1Click:Connect(CloseMenu)
    OpenButton.MouseButton1Click:Connect(OpenMenu)
end)
