-- [[ San Diego | Visual Hub (Fixed & Draggable) ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Защита от повторного запуска
if PlayerGui:FindFirstChild("SanDiegoVisualsMenu") then
    PlayerGui.SanDiegoVisualsMenu:Destroy()
end

-- Главный контейнер
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SanDiegoVisualsMenu"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Маленький квадрат (Кнопка открытия - появляется сразу)
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Position = UDim2.new(0, 30, 0.5, -22)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
OpenButton.Text = "X"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = true
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(50, 50, 70)
OpenStroke.Thickness = 1.5
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

-- Шапка окна (с поддержкой перетаскивания)
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

-- Кнопка закрытия (крестик)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

-- Перетаскивание для Главного меню (MainFrame)
local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Перетаскивание для маленькой кнопки (OpenButton)
local openDragging, openDragInput, openDragStart, openStartPos

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = true
        openDragStart = input.Position
        openStartPos = OpenButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                openDragging = false
            end
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
        OpenButton.Position = UDim2.new(
            openStartPos.X.Scale, 
            openStartPos.X.Offset + delta.X, 
            openStartPos.Y.Scale, 
            openStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Контейнер для прокрутки функций
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

-- Функция генерации переключателей
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
-- ФУНКЦИОНАЛ ВИЗУАЛОВ
-- ========================================================

-- 1. ESP Игроков
local espEnabled = false
local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if espEnabled then
                if not player.Character:FindFirstChild("SD_PlayerESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "SD_PlayerESP"
                    hl.Adornee = player.Character
                    hl.FillColor = Color3.fromRGB(255, 60, 60)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = player.Character
                end
            else
                if player.Character:FindFirstChild("SD_PlayerESP") then
                    player.Character.SD_PlayerESP:Destroy()
                end
            end
        end
    end
end

CreateToggle("ESP Игроков", function(state)
    espEnabled = state
end)

RunService.RenderStepped:Connect(function()
    if espEnabled then UpdateESP() end
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

RunService.Heartbeat:Connect(function()
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
end)

-- 3. Night Mode
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

-- 4. Fullbright
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
-- АНИМАЦИИ ОТКРЫТИЯ / ЗАКРЫТИЯ
-- ========================================================

local function CloseMenu()
    OpenButton.Position = MainFrame.Position

    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
    tween:Play()
    
    Title.TextTransparency = 1
    TopBar.BackgroundTransparency = 1
    
    tween.Completed:Wait()
    MainFrame.Visible = false
    OpenButton.Visible = true
    
    OpenButton.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(OpenButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 45, 0, 45)}):Play()
end

local function OpenMenu()
    if openDragging then return end

    MainFrame.Position = OpenButton.Position

    TweenService:Create(OpenButton, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.1)
    
    OpenButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    Title.TextTransparency = 0
    TopBar.BackgroundTransparency = 0
    
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 440, 0, 320), BackgroundTransparency = 0})
    openTween:Play()
end

CloseBtn.MouseButton1Click:Connect(CloseMenu)
OpenButton.MouseButton1Click:Connect(OpenMenu)
