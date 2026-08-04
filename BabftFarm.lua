-- BABFT Premium Fly | Flux UI Library
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local followPath = false
local noclipEnabled = false
local flySpeed = 80
local pathSpeed = 110
local bv, ao
local currentWaypointIndex = 1

-- ==================== КООРДИНАТЫ ====================
local waypoints = {
    Vector3.new(-43.86, -2.08, 345.46),
    Vector3.new(-56.43, 42.69, 8703.92),
    Vector3.new(-54.93, -293.14, 8719.44),
    Vector3.new(-59.88, -360.43, 9488.70),
}

-- ==================== FLY ФУНКЦИИ ====================
local function startFly()
    if bv then return end
    bv = Instance.new("LinearVelocity")
    bv.Attachment0 = Instance.new("Attachment", root)
    bv.MaxForce = 50000000
    bv.VectorVelocity = Vector3.new(0, 0, 0)
    bv.Parent = root

    ao = Instance.new("AlignOrientation")
    ao.Attachment0 = bv.Attachment0
    ao.MaxTorque = 50000000
    ao.Responsiveness = 200
    ao.Parent = root
end

local function stopFly()
    if bv then bv:Destroy() bv = nil end
    if ao then ao:Destroy() ao = nil end
end

-- ==================== FLUX UI ====================
local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()

local win = Flux:Window(
    "⚡ BABFT Premium",
    "Auto Chest Fly",
    Color3.fromRGB(0, 120, 255),
    Enum.KeyCode.RightControl
)

-- ==================== TAB 1: ПОЛЁТ ====================
local flyTab = win:Tab("✈️ Полёт", "http://www.roblox.com/asset/?id=6023426915")

flyTab:Label("— Управление полётом —")
flyTab:Line()

flyTab:Toggle("Ручной Полёт", "WASD + Space/Ctrl для полёта", function(state)
    flying = state
    if state then
        startFly()
        Flux:Notification("Полёт включён!", "Используй WASD + Space/Ctrl")
    else
        if not followPath then
            stopFly()
        end
        Flux:Notification("Полёт выключен!", "OK")
    end
end)

flyTab:Slider("Скорость Полёта", "Изменить скорость ручного полёта", 50, 300, 80, function(val)
    flySpeed = val
end)

flyTab:Toggle("Noclip", "Пролетать сквозь стены и землю", function(state)
    noclipEnabled = state
    if state then
        Flux:Notification("Noclip включён!", "Теперь ты призрак 👻")
    else
        Flux:Notification("Noclip выключен!", "OK")
    end
end)

flyTab:Line()
flyTab:Label("— Горячие клавиши —")
flyTab:Label("W/A/S/D — Движение")
flyTab:Label("Space — Вверх")
flyTab:Label("Left Ctrl — Вниз")
flyTab:Label("Right Ctrl — Открыть/Закрыть GUI")

-- ==================== TAB 2: АВТО СУНДУК ====================
local chestTab = win:Tab("🏆 Авто Сундук", "http://www.roblox.com/asset/?id=6022668888")

chestTab:Label("— Автоматический полёт к сундуку —")
chestTab:Line()

chestTab:Toggle("Лететь к Сундуку", "Автоматически летит по 4 точкам к сундуку", function(state)
    followPath = state
    currentWaypointIndex = 1
    if state then
        flying = true
        startFly()
        Flux:Notification("Автолёт запущен!", "Лечу к точке 1...")
    else
        Flux:Notification("Автолёт остановлен!", "OK")
    end
end)

chestTab:Slider("Скорость к Сундуку", "Изменить скорость полёта к сундуку", 60, 400, 110, function(val)
    pathSpeed = val
end)

chestTab:Line()
chestTab:Label("— Маршрут —")
chestTab:Label("Точка 1: Старт карты")
chestTab:Label("Точка 2: Середина карты")
chestTab:Label("Точка 3: Глубокая зона")
chestTab:Label("Точка 4: Сундук 🏆")

chestTab:Line()

chestTab:Button("Перезапустить маршрут", "Начать лететь с точки 1 заново", function()
    currentWaypointIndex = 1
    followPath = true
    flying = true
    startFly()
    Flux:Notification("Маршрут перезапущен!", "Лечу к точке 1...")
end)

chestTab:Dropdown("Начать с точки", {"1", "2", "3", "4"}, function(selected)
    currentWaypointIndex = tonumber(selected)
    Flux:Notification("Начну с точки " .. selected, "OK")
end)

-- ==================== TAB 3: НАСТРОЙКИ ====================
local settingsTab = win:Tab("⚙️ Настройки", "http://www.roblox.com/asset/?id=6031071053")

settingsTab:Label("— Дополнительные функции —")
settingsTab:Line()

settingsTab:Toggle("Anti-AFK", "Не кикнет за бездействие", function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        Flux:Notification("Anti-AFK включён!", "Теперь тебя не кикнет")
    end
end)

settingsTab:Button("Телепорт на Старт", "Мгновенно переместиться на точку 1", function()
    root.CFrame = CFrame.new(waypoints[1])
    Flux:Notification("Телепорт!", "Ты на старте карты")
end)

settingsTab:Button("Телепорт к Сундуку", "Мгновенно переместиться к сундуку", function()
    root.CFrame = CFrame.new(waypoints[4])
    Flux:Notification("Телепорт!", "Ты у сундука 🏆")
end)

settingsTab:Line()

settingsTab:Button("Уничтожить GUI", "Полностью удалить скрипт", function()
    flying = false
    followPath = false
    noclipEnabled = false
    stopFly()
    Flux:Notification("GUI уничтожен!", "Пока 👋")
end)

-- ==================== NOCLIP ЦИКЛ ====================
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, p in pairs(character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

-- ==================== ОСНОВНОЙ ЦИКЛ ПОЛЁТА ====================
RunService.Heartbeat:Connect(function()
    if not flying or not bv then return end

    if followPath and #waypoints > 0 then
        local target = waypoints[currentWaypointIndex]
        local dir = target - root.Position
        local dist = dir.Magnitude

        if dist > 12 then
            bv.VectorVelocity = dir.Unit * pathSpeed
            ao.CFrame = CFrame.lookAt(root.Position, target)
        else
            if currentWaypointIndex < #waypoints then
                currentWaypointIndex += 1
                Flux:Notification("✅ Точка " .. (currentWaypointIndex - 1) .. " пройдена!", "Лечу к точке " .. currentWaypointIndex)
            else
                bv.VectorVelocity = Vector3.new(0, 0, 0)
                followPath = false
                Flux:Notification("🏆 СУНДУК ДОСТИГНУТ!", "Все точки пройдены!")
            end
        end
    else
        local cam = Workspace.CurrentCamera
        local move = Vector3.new(0, 0, 0)

        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end

        if move.Magnitude > 0 then
            bv.VectorVelocity = move.Unit * flySpeed
        else
            bv.VectorVelocity = Vector3.new(0, 0, 0)
        end
        ao.CFrame = cam.CFrame
    end
end)

print("⚡ BABFT Premium Fly загружен на Flux UI!")
