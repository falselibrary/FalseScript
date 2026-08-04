-- MM2 Auto Coin Farm v3 — Clean GUI
-- LinearVelocity + firetouchinterest + NoClip

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================
--       Настройки
-- ========================
local COIN_FARM_SPEED = 80
local MIN_SPEED = 20
local MAX_SPEED = 250
local COIN_NAMES = { coin = true, gold = true, pickup = true, collectible = true, money = true }

local STATE = {
    FARM = false,
    NOCLIP = false,
    COINS = 0,
}

local CoinCache = {}
local CoinFarmLV = nil
local CoinFarmConn = nil
local CoinFarmLastTick = 0
local noclipLoop = nil

-- ========================
--    Персонаж
-- ========================
local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = player.Character
    return char and char:FindFirstChild("Humanoid")
end

-- ========================
--      Система монет
-- ========================
local function IsCoin(obj)
    if not obj then return false end
    local n = obj.Name:lower()
    for k in pairs(COIN_NAMES) do
        if n:find(k) then return true end
    end
    return false
end

local function GetPartOfObject(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then return obj:FindFirstChildWhichIsA("BasePart") end
    return nil
end

Workspace.DescendantAdded:Connect(function(obj)
    if IsCoin(obj) then CoinCache[obj] = true end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if CoinCache[obj] then CoinCache[obj] = nil end
end)

for _, obj in ipairs(Workspace:GetDescendants()) do
    if IsCoin(obj) then CoinCache[obj] = true end
end

local function GetNearestCoin()
    local HRP = getHRP()
    if not HRP then return nil, math.huge end
    local nearest, nearestDist = nil, math.huge
    local myPos = HRP.Position
    for obj in pairs(CoinCache) do
        if not obj or not obj.Parent then CoinCache[obj] = nil continue end
        local part = GetPartOfObject(obj)
        if part then
            local d = (myPos - part.Position).Magnitude
            if d < nearestDist then nearest = part; nearestDist = d end
        end
    end
    return nearest, nearestDist
end

-- ========================
--     LinearVelocity
-- ========================
local function RemoveCoinFarmLV()
    if CoinFarmLV and CoinFarmLV.Parent then CoinFarmLV:Destroy() end
    CoinFarmLV = nil
    if CoinFarmConn then CoinFarmConn:Disconnect() CoinFarmConn = nil end
end

local function TickCoinFarm()
    if not STATE.FARM then RemoveCoinFarmLV() return end
    local HRP = getHRP()
    if not HRP then return end
    local now = tick()
    if now - CoinFarmLastTick < 0.05 then return end
    CoinFarmLastTick = now

    local coin, dist = GetNearestCoin()
    if not coin then
        if CoinFarmLV and CoinFarmLV.Parent then
            CoinFarmLV.VectorVelocity = Vector3.zero
        end
        return
    end

    if not CoinFarmLV or not CoinFarmLV.Parent then
        RemoveCoinFarmLV()
        local attach = Instance.new("Attachment")
        attach.Name = "MM2_CoinAttach"
        attach.Parent = HRP
        local lv = Instance.new("LinearVelocity")
        lv.Name = "MM2_CoinFarmLV"
        lv.Attachment0 = attach
        lv.MaxForce = 1e6
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VectorVelocity = Vector3.zero
        lv.Parent = HRP
        CoinFarmLV = lv
    end

    local direction = (coin.Position - HRP.Position)
    if direction.Magnitude < 3 then
        pcall(function()
            firetouchinterest(HRP, coin, 0)
            task.defer(function()
                pcall(function() firetouchinterest(HRP, coin, 1) end)
            end)
        end)
        CoinFarmLV.VectorVelocity = Vector3.zero
        STATE.COINS = STATE.COINS + 1
    else
        CoinFarmLV.VectorVelocity = direction.Unit * COIN_FARM_SPEED
    end
end

-- ========================
--       NoClip
-- ========================
local function startNoclip()
    if noclipLoop then return end
    STATE.NOCLIP = true
    noclipLoop = RunService.Stepped:Connect(function()
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function stopNoclip()
    STATE.NOCLIP = false
    if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end
end

-- ========================
--     Старт / Стоп
-- ========================
local function startFarm()
    STATE.FARM = true
    local hum = getHumanoid()
    if hum then hum.PlatformStand = true end
    startNoclip()
    CoinFarmConn = RunService.Heartbeat:Connect(TickCoinFarm)
end

local function stopFarm()
    STATE.FARM = false
    RemoveCoinFarmLV()
    stopNoclip()
    local hum = getHumanoid()
    if hum then hum.PlatformStand = false end
    local HRP = getHRP()
    if HRP then HRP.AssemblyLinearVelocity = Vector3.zero end
end

-- ========================
--       ЧИСТЫЙ GUI
-- ========================
if playerGui:FindFirstChild("MM2FarmGUI") then
    playerGui.MM2FarmGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MM2FarmGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Цвета
local BG = Color3.fromRGB(20, 20, 30)
local ACCENT = Color3.fromRGB(100, 65, 220)
local BTN_OFF = Color3.fromRGB(32, 32, 48)
local BTN_ON_GREEN = Color3.fromRGB(30, 75, 45)
local BTN_ON_BLUE = Color3.fromRGB(25, 50, 85)
local TEXT_WHITE = Color3.fromRGB(220, 220, 220)
local TEXT_DIM = Color3.fromRGB(130, 130, 160)
local TEXT_GREEN = Color3.fromRGB(120, 230, 120)

-- Главная панель
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 240, 0, 300)
panel.Position = UDim2.new(0, 24, 0.5, -150)
panel.BackgroundColor3 = BG
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
panel.Parent = gui

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0, 10)

local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = ACCENT
panelStroke.Thickness = 1.5
panelStroke.Transparency = 0.3

-- Заголовок
local header = Instance.new("TextLabel")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(26, 22, 42)
header.BorderSizePixel = 0
header.Text = "MM2 Coin Farm"
header.TextColor3 = TEXT_WHITE
header.TextSize = 15
header.Font = Enum.Font.GothamBold
header.Parent = panel

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 10)

-- Кнопка Auto Farm
local farmBtn = Instance.new("TextButton")
farmBtn.Name = "FarmBtn"
farmBtn.Size = UDim2.new(0.88, 0, 0, 36)
farmBtn.Position = UDim2.new(0.06, 0, 0, 52)
farmBtn.BackgroundColor3 = BTN_OFF
farmBtn.BorderSizePixel = 0
farmBtn.Text = "Auto Farm: OFF"
farmBtn.TextColor3 = TEXT_WHITE
farmBtn.TextSize = 13
farmBtn.Font = Enum.Font.GothamSemibold
farmBtn.AutoButtonColor = false
farmBtn.Parent = panel

Instance.new("UICorner", farmBtn).CornerRadius = UDim.new(0, 7)

-- Кнопка NoClip
local noclipBtn = Instance.new("TextButton")
noclipBtn.Name = "NoclipBtn"
noclipBtn.Size = UDim2.new(0.88, 0, 0, 36)
noclipBtn.Position = UDim2.new(0.06, 0, 0, 98)
noclipBtn.BackgroundColor3 = BTN_OFF
noclipBtn.BorderSizePixel = 0
noclipBtn.Text = "NoClip: OFF"
noclipBtn.TextColor3 = TEXT_WHITE
noclipBtn.TextSize = 13
noclipBtn.Font = Enum.Font.GothamSemibold
noclipBtn.AutoButtonColor = false
noclipBtn.Parent = panel

Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 7)

-- Скорость текст
local speedText = Instance.new("TextLabel")
speedText.Name = "SpeedText"
speedText.Size = UDim2.new(0.88, 0, 0, 20)
speedText.Position = UDim2.new(0.06, 0, 0, 148)
speedText.BackgroundTransparency = 1
speedText.Text = "Speed: " .. COIN_FARM_SPEED
speedText.TextColor3 = TEXT_DIM
speedText.TextSize = 12
speedText.Font = Enum.Font.GothamSemibold
speedText.TextXAlignment = Enum.TextXAlignment.Left
speedText.Parent = panel

-- Слайдер
local sliderBg = Instance.new("Frame")
sliderBg.Name = "SliderBg"
sliderBg.Size = UDim2.new(0.88, 0, 0, 6)
sliderBg.Position = UDim2.new(0.06, 0, 0, 174)
sliderBg.BackgroundColor3 = BTN_OFF
sliderBg.BorderSizePixel = 0
sliderBg.Parent = panel

Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

local initRatio = (COIN_FARM_SPEED - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(initRatio, 0, 1, 0)
sliderFill.BackgroundColor3 = ACCENT
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg

Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local sliderKnob = Instance.new("TextButton")
sliderKnob.Name = "SliderKnob"
sliderKnob.Size = UDim2.new(0, 14, 0, 14)
sliderKnob.Position = UDim2.new(initRatio, -7, 0.5, -7)
sliderKnob.BackgroundColor3 = Color3.fromRGB(180, 160, 240)
sliderKnob.BorderSizePixel = 0
sliderKnob.Text = ""
sliderKnob.AutoButtonColor = false
sliderKnob.ZIndex = 5
sliderKnob.Parent = sliderBg

Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

-- Статус собранных монет
local coinText = Instance.new("TextLabel")
coinText.Name = "CoinText"
coinText.Size = UDim2.new(0.88, 0, 0, 20)
coinText.Position = UDim2.new(0.06, 0, 0, 200)
coinText.BackgroundTransparency = 1
coinText.Text = "Coins: 0"
coinText.TextColor3 = TEXT_GREEN
coinText.TextSize = 12
coinText.Font = Enum.Font.Gotham
coinText.TextXAlignment = Enum.TextXAlignment.Left
coinText.Parent = panel

-- Статус фарма
local farmStatusText = Instance.new("TextLabel")
farmStatusText.Name = "FarmStatus"
farmStatusText.Size = UDim2.new(0.88, 0, 0, 20)
farmStatusText.Position = UDim2.new(0.06, 0, 0, 224)
farmStatusText.BackgroundTransparency = 1
farmStatusText.Text = "Idle"
farmStatusText.TextColor3 = TEXT_DIM
farmStatusText.TextSize = 11
farmStatusText.Font = Enum.Font.Gotham
farmStatusText.TextXAlignment = Enum.TextXAlignment.Left
farmStatusText.Parent = panel

-- Разделитель
local sep = Instance.new("Frame")
sep.Size = UDim2.new(0.88, 0, 0, 1)
sep.Position = UDim2.new(0.06, 0, 0, 252)
sep.BackgroundColor3 = ACCENT
sep.BackgroundTransparency = 0.7
sep.BorderSizePixel = 0
sep.Parent = panel

-- Подпись
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 0, 262)
footer.BackgroundTransparency = 1
footer.Text = "v3 | LinearVelocity"
footer.TextColor3 = Color3.fromRGB(60, 60, 80)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = panel

-- Кнопка скрытия панели
local hideBtn = Instance.new("TextButton")
hideBtn.Name = "HideBtn"
hideBtn.Size = UDim2.new(0, 26, 0, 26)
hideBtn.Position = UDim2.new(1, -32, 0, 7)
hideBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
hideBtn.BorderSizePixel = 0
hideBtn.Text = "X"
hideBtn.TextColor3 = TEXT_WHITE
hideBtn.TextSize = 12
hideBtn.Font = Enum.Font.GothamBold
hideBtn.AutoButtonColor = false
hideBtn.ZIndex = 10
hideBtn.Parent = panel

Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 6)

-- Мини кнопка для открытия панели
local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 36, 0, 36)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = ACCENT
openBtn.BorderSizePixel = 0
openBtn.Text = "CF"
openBtn.TextColor3 = TEXT_WHITE
openBtn.TextSize = 12
openBtn.Font = Enum.Font.GothamBold
openBtn.AutoButtonColor = false
openBtn.Visible = false
openBtn.Parent = gui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

-- ========================
--    GUI Логика
-- ========================

-- Скрыть / Показать
hideBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    panel.Visible = true
    openBtn.Visible = false
end)

-- Слайдер
local dragging = false

sliderKnob.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.Heartbeat:Connect(function()
    coinText.Text = "Coins: " .. STATE.COINS

    if not dragging then return end

    local mouse = UserInputService:GetMouseLocation()
    local pos = sliderBg.AbsolutePosition
    local size = sliderBg.AbsoluteSize
    local rel = math.clamp((mouse.X - pos.X) / size.X, 0, 1)

    sliderFill.Size = UDim2.new(rel, 0, 1, 0)
    sliderKnob.Position = UDim2.new(rel, -7, 0.5, -7)

    COIN_FARM_SPEED = math.floor(MIN_SPEED + (MAX_SPEED - MIN_SPEED) * rel)
    speedText.Text = "Speed: " .. COIN_FARM_SPEED
end)

-- Кнопка Auto Farm
farmBtn.MouseButton1Click:Connect(function()
    if STATE.FARM then
        stopFarm()
        farmBtn.Text = "Auto Farm: OFF"
        farmBtn.BackgroundColor3 = BTN_OFF
        farmStatusText.Text = "Idle"
        farmStatusText.TextColor3 = TEXT_DIM
    else
        startFarm()
        farmBtn.Text = "Auto Farm: ON"
        farmBtn.BackgroundColor3 = BTN_ON_GREEN
        farmStatusText.Text = "Farming..."
        farmStatusText.TextColor3 = TEXT_GREEN
    end
end)

-- Кнопка NoClip
noclipBtn.MouseButton1Click:Connect(function()
    if STATE.NOCLIP then
        stopNoclip()
        noclipBtn.Text = "NoClip: OFF"
        noclipBtn.BackgroundColor3 = BTN_OFF
    else
        startNoclip()
        noclipBtn.Text = "NoClip: ON"
        noclipBtn.BackgroundColor3 = BTN_ON_BLUE
    end
end)

-- Перезапуск после смерти
player.CharacterAdded:Connect(function()
    task.wait(2)
    if STATE.FARM then
        stopFarm()
        task.wait(1)
        startFarm()
    end
end)

print("[MM2 Farm] Loaded")
