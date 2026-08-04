-- BABFT Premium Fly | Flux UI | Auto Restart + Territory Detect
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local followPath = false
local noclipEnabled = false
local autoRestart = true
local flySpeed = 80
local pathSpeed = 110
local bv, ao
local currentWaypointIndex = 1
local openingChest = false
local waitingForTerritory = false
local lastPosition = Vector3.new(0,0,0)
local territoryDetected = false

-- ==================== КООРДИНАТЫ ====================
local waypoints = {
    Vector3.new(-43.86, -2.08, 345.46),
    Vector3.new(-56.43, 42.69, 8703.92),
    Vector3.new(-54.93, -293.14, 8719.44),
    Vector3.new(-59.88, -360.43, 9488.70),
}

-- Территория игрока (начало карты где стоит лодка)
-- Скрипт сам определяет территорию при запуске
local territoryPosition = nil
local territoryRadius = 150 -- Радиус детекта территории в studs

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

local function restartFarm()
    task.wait(2)
    currentWaypointIndex = 1
    followPath = true
    flying = true
    waitingForTerritory = false
    territoryDetected = false
    startFly()
    Flux:Notification("🔄 Фарм перезапущен!", "Лечу к точке 1...")
end

-- ==================== АВТОНАЖАТИЕ КНОПОК ====================
local function simulateWalking()
    local keys = {
        Enum.KeyCode.W,
        Enum.KeyCode.A,
        Enum.KeyCode.S,
        Enum.KeyCode.D
    }

    local startTime = tick()
    while tick() - startTime < 7 and openingChest do
        local randomKey = keys[math.random(1, #keys)]
        VirtualInputManager:SendKeyEvent(true, randomKey, false, game)
        task.wait(0.3)
        VirtualInputManager:SendKeyEvent(false, randomKey, false, game)
        task.wait(0.2)
    end
end

-- ==================== АВТООТКРЫТИЕ СУНДУКА ====================
local function autoOpenChest()
    openingChest = true

    if bv then
        bv.VectorVelocity = Vector3.new(0, 0, 0)
    end

    Flux:Notification("🏆 Сундук достигнут!", "Открываю сундук (7 сек)...")
    simulateWalking()
    openingChest = false

    Flux:Notification("✅ Сундук открыт!", "Жду телепорт на территорию...")

    -- Ждём пока игра телепортирует нас на территорию
    waitingForTerritory = true
    followPath = false
    flying = false
    stopFly()
end

-- ==================== FLUX UI ====================
local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()

local win = Flux:Window(
    "⚡ BABFT Premium",
    "Auto Chest Fly v4",
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
    end
end)

flyTab:Slider("Скорость Полёта", "Изменить скорость ручного полёта", 50, 300, 80, function(val)
    flySpeed = val
end)

flyTab:Toggle("Noclip", "Пролетать сквозь стены и землю", function(state)
    noclipEnabled = state
    if state then
        Flux:Notification("Noclip включён!", "Призрак 👻")
    else
        Flux:Notification("Noclip выключен!", "OK")
    end
end)

flyTab:Line()
flyTab:Label("W/A/S/D — Движение")
flyTab:Label("Space — Вверх | Ctrl — Вниз")
flyTab:Label("Right Ctrl — Открыть/Закрыть GUI")

-- ==================== TAB 2: АВТО СУНДУК ====================
local chestTab = win:Tab("🏆 Авто Сундук", "http://www.roblox.com/asset/?id=6022668888")

chestTab:Label("— Автоматический полёт к сундуку —")
chestTab:Line()

chestTab:Toggle("Лететь к Сундуку", "Автоматически летит по 4 точкам", function(state)
    followPath = state
    currentWaypointIndex = 1
    if state then
        flying = true
        startFly()

        -- Запоминаем территорию при первом запуске
        if not territoryPosition then
            territoryPosition = root.Position
            Flux:Notification("📍 Территория сохранена!", "Радиус: " .. territoryRadius .. " studs")
        end

        Flux:Notification("Автолёт запущен!", "Лечу к точке 1...")
    else
        waitingForTerritory = false
        Flux:Notification("Автолёт остановлен!", "OK")
    end
end)

chestTab:Slider("Скорость к Сундуку", "Скорость полёта к сундуку", 60, 400, 110, function(val)
    pathSpeed = val
end)

chestTab:Slider("Радиус территории", "Радиус детекта возврата на лодку", 50, 400, 150, function(val)
    territoryRadius = val
end)

chestTab:Line()

chestTab:Toggle("Авто-перезапуск", "После возврата на территорию снова летит", function(state)
    autoRestart = state
    if state then
        Flux:Notification("🔄 Авто-перезапуск ВКЛ!", "После телепорта фарм продолжится")
    else
        Flux:Notification("Авто-перезапуск ВЫКЛ!", "OK")
    end
end)

chestTab:Button("Сохранить позицию территории", "Сохранить текущую позицию как территорию", function()
    territoryPosition = root.Position
    Flux:Notification("📍 Территория сохранена!", 
        "X:" .. math.floor(root.Position.X) .. 
        " Y:" .. math.floor(root.Position.Y) .. 
        " Z:" .. math.floor(root.Position.Z))
end)

chestTab:Line()
chestTab:Label("— Маршрут —")
chestTab:Label("Точка 1 → Точка 2 → Точка 3 → Сундук 🏆")
chestTab:Label("→ Авто-открытие (7 сек рандом кнопки)")
chestTab:Label("→ Ждём телепорт на территорию")
chestTab:Label("→ Детект территории → Фарм снова ♻️")

chestTab:Line()

chestTab:Button("Перезапустить маршрут", "Начать с точки 1", function()
    currentWaypointIndex = 1
    followPath = true
    flying = true
    waitingForTerritory = false
    territoryDetected = false
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
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        Flux:Notification("Anti-AFK включён!", "Тебя не кикнет 😎")
    end
end)

settingsTab:Line()
settingsTab:Label("— Телепорты —")

settingsTab:Button("ТП на Старт", "Мгновенно на точку 1", function()
    root.CFrame = CFrame.new(waypoints[1])
    Flux:Notification("Телепорт!", "Ты на старте")
end)

settingsTab:Button("ТП к Сундуку", "Мгновенно к сундуку", function()
    root.CFrame = CFrame.new(waypoints[4])
    Flux:Notification("Телепорт!", "Ты у сундука 🏆")
end)

settingsTab:Line()
settingsTab:Label("— Информация —")
settingsTab:Label("Версия: 4.0")
settingsTab:Label("Полёт: LinearVelocity")
settingsTab:Label("Авто-открытие: 7 сек рандом кнопки")
settingsTab:Label("Детект: Радиус территории")

settingsTab:Line()

settingsTab:Button("Уничтожить скрипт", "Полностью удалить всё", function()
    flying = false
    followPath = false
    noclipEnabled = false
    openingChest = false
    waitingForTerritory = false
    stopFly()
    Flux:Notification("Скрипт уничтожен!", "Пока 👋")
end)

-- ==================== NOCLIP ====================
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, p in pairs(character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

-- ==================== ДЕТЕКТ ТЕРРИТОРИИ ====================
-- Каждые 0.5 секунды проверяем вернулся ли игрок на территорию
task.spawn(function()
    while task.wait(0.5) do
        if waitingForTerritory and territoryPosition and autoRestart then
            local dist = (root.Position - territoryPosition).Magnitude

            -- Если игрок в радиусе своей территории
            if dist < territoryRadius and not territoryDetected then
                territoryDetected = true
                Flux:Notification("🏠 Территория обнаружена!", "Запускаю фарм снова через 2 сек...")

                task.spawn(function()
                    restartFarm()
                end)
            end
        end
    end
end)

-- ==================== АВТО ДЕТЕКТ СПАВНА ====================
-- Когда игра телепортирует после сундука позиция резко меняется
task.spawn(function()
    while task.wait(0.1) do
        if waitingForTerritory then
            local currentPos = root.Position
            local moved = (currentPos - lastPosition).Magnitude

            -- Если позиция резко изменилась (телепорт игры)
            if moved > 200 and not territoryDetected then
                Flux:Notification("⚡ Телепорт обнаружен!", "Проверяю территорию...")
                task.wait(1)

                -- Проверяем территорию после телепорта
                if territoryPosition then
                    local dist = (root.Position - territoryPosition).Magnitude
                    if dist < territoryRadius and not territoryDetected then
                        territoryDetected = true
                        Flux:Notification("🏠 На территории!", "Запускаю фарм...")
                        task.spawn(function()
                            restartFarm()
                        end)
                    else
                        -- Если не на территории то просто ждём
                        Flux:Notification("📍 Не на территории", "Жду возврата...")
                    end
                else
                    -- Территория не сохранена, просто перезапускаем
                    task.spawn(function()
                        restartFarm()
                    end)
                end
            end
            lastPosition = currentPos
        end
    end
end)

-- ==================== ОСНОВНОЙ ЦИКЛ ПОЛЁТА ====================
RunService.Heartbeat:Connect(function()
    if not flying or not bv or openingChest then return end

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
                Flux:Notification(
                    "✅ Точка " .. (currentWaypointIndex - 1) .. " пройдена!",
                    "Лечу к точке " .. currentWaypointIndex
                )
            else
                followPath = false
                task.spawn(function()
                    autoOpenChest()
                end)
            end
        end
    else
        if not followPath and not waitingForTerritory then
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
    end
end)

-- ==================== АВТО РЕСПАВН ====================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    root = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    bv, ao = nil, nil

    task.wait(2)

    if autoRestart then
        startFly()
        currentWaypointIndex = 1
        followPath = true
        flying = true
        waitingForTerritory = false
        territoryDetected = false
        Flux:Notification("🔄 Респавн!", "Маршрут перезапущен")
    end
end)

print("⚡ BABFT Premium v4 загружен!")
print("Детект территории + Авто перезапуск фарма")
