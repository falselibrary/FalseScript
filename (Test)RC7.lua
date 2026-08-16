-- RC7 Backdoor Scanner + Script Hub + Classic Cheat Features
local player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

if CoreGui:FindFirstChild("RC7_Scanner") then CoreGui.RC7_Scanner:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "RC7_Scanner"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = CoreGui

local C = {
    DarkBG = Color3.fromRGB(75, 25, 30),
    MidRed = Color3.fromRGB(110, 40, 45),
    LightRed = Color3.fromRGB(160, 70, 75),
    BtnRed = Color3.fromRGB(175, 100, 105),
    InputBG = Color3.fromRGB(140, 55, 60),
    TitleBar = Color3.fromRGB(240, 215, 215),
    TextCredit = Color3.fromRGB(200, 160, 165),
    CodeBG = Color3.fromRGB(255, 250, 248),
    CodeText = Color3.fromRGB(30, 30, 30),
    SideBG = Color3.fromRGB(100, 35, 40),
    SideIcon = Color3.fromRGB(150, 65, 70),
    Border = Color3.fromRGB(85, 30, 35),
    TabBG = Color3.fromRGB(210, 185, 185),
    BottomBar = Color3.fromRGB(95, 35, 40),
    Green = Color3.fromRGB(80, 180, 80),
    Yellow = Color3.fromRGB(220, 180, 50),
    Red = Color3.fromRGB(220, 60, 60),
    White = Color3.fromRGB(255, 255, 255),
}

-- ============ CLASSIC CHEAT GLOBALS ============
local flyEnabled = false
local flyBody = nil
local flyGyro = nil
local noClipEnabled = false
local noClipConn = nil
local espEnabled = false
local espObjects = {}
local godModeEnabled = false
local invisEnabled = false
local rainbowConn = nil
local rainbowEnabled = false
local matrixRain = false
local matrixObjects = {}
local seizureConn = nil
local seizureEnabled = false

local function createCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 4)
    c.Parent = parent
end

local function createStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Border
    s.Thickness = thickness or 1
    s.Parent = parent
end

local function createGradient(parent, c1, c2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rotation or 90
    g.Parent = parent
end

local function makeTitleBar(parent)
    local tb = Instance.new("Frame")
    tb.Size = UDim2.new(1, 0, 0, 28)
    tb.BackgroundColor3 = C.TitleBar
    tb.BorderSizePixel = 0
    tb.ZIndex = 10
    tb.Parent = parent

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 5, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031097903"
    icon.ImageColor3 = C.LightRed
    icon.ZIndex = 11
    icon.Parent = tb

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Position = UDim2.new(0, 28, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "RC7 v2.1 — Backdoor Scanner"
    titleText.TextColor3 = Color3.fromRGB(100, 40, 45)
    titleText.Font = Enum.Font.SourceSansSemibold
    titleText.TextSize = 13
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = 11
    titleText.Parent = tb

    local function winBtn(text, pos, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 35, 0, 28)
        b.Position = UDim2.new(1, pos, 0, 0)
        b.BackgroundTransparency = 1
        b.Text = text
        b.Font = Enum.Font.SourceSans
        b.TextSize = 18
        b.TextColor3 = Color3.fromRGB(80, 80, 80)
        b.ZIndex = 11
        b.Parent = tb
        b.MouseButton1Click:Connect(callback)
    end

    winBtn("X", -35, function() SG:Destroy() end)
    winBtn("[]", -70, function() end)
    winBtn("_", -105, function()
        parent.Visible = not parent.Visible
    end)
end

local function makeSidebar(parent, width)
    local side = Instance.new("Frame")
    side.Size = UDim2.new(0, width or 45, 1, -28)
    side.Position = UDim2.new(1, -(width or 45), 0, 28)
    side.BackgroundColor3 = C.SideBG
    side.BorderSizePixel = 0
    side.ZIndex = 5
    side.Parent = parent

    createGradient(side, C.SideBG, Color3.fromRGB(80, 28, 33), 90)

    local letters = {"R", "C", "7"}
    for i, letter in ipairs(letters) do
        local r = Instance.new("TextLabel")
        r.Size = UDim2.new(1, 0, 0, 40)
        r.Position = UDim2.new(0, 0, 0, 10 + (i-1)*32)
        r.BackgroundTransparency = 1
        r.Text = letter
        r.TextColor3 = Color3.fromRGB(60, 20, 25)
        r.Font = Enum.Font.SourceSansBold
        r.TextSize = 38
        r.ZIndex = 6
        r.Parent = side
    end

    return side
end

local function addSideIcons(sidebar, icons)
    local startY = 130
    for i, data in ipairs(icons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 34, 0, 34)
        btn.Position = UDim2.new(0.5, -17, 0, startY + (i - 1) * 42)
        btn.BackgroundColor3 = C.SideIcon
        btn.Text = data.Text or ""
        btn.TextColor3 = Color3.fromRGB(50, 18, 22)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 16
        btn.ZIndex = 6
        btn.Parent = sidebar
        createCorner(btn, 3)
        createStroke(btn, Color3.fromRGB(70, 25, 30), 1)

        if data.Callback then
            btn.MouseButton1Click:Connect(data.Callback)
        end
    end
end

-- ============ NOTIFICATION SYSTEM ============
local function notify(title, text, duration, color)
    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(0, 280, 0, 70)
    nf.Position = UDim2.new(1, 300, 1, -90)
    nf.BackgroundColor3 = Color3.fromRGB(35, 12, 15)
    nf.BorderSizePixel = 0
    nf.ZIndex = 100
    nf.Parent = SG
    createCorner(nf, 6)
    createStroke(nf, color or C.LightRed, 2)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, -10)
    bar.Position = UDim2.new(0, 8, 0, 5)
    bar.BackgroundColor3 = color or C.LightRed
    bar.BorderSizePixel = 0
    bar.ZIndex = 101
    bar.Parent = nf
    createCorner(bar, 2)

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -25, 0, 22)
    tl.Position = UDim2.new(0, 20, 0, 8)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = color or C.LightRed
    tl.Font = Enum.Font.SourceSansBold
    tl.TextSize = 16
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.ZIndex = 101
    tl.Parent = nf

    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, -25, 0, 30)
    dl.Position = UDim2.new(0, 20, 0, 30)
    dl.BackgroundTransparency = 1
    dl.Text = text
    dl.TextColor3 = Color3.fromRGB(200, 180, 182)
    dl.Font = Enum.Font.SourceSans
    dl.TextSize = 13
    dl.TextXAlignment = Enum.TextXAlignment.Left
    dl.TextWrapped = true
    dl.ZIndex = 101
    dl.Parent = nf

    TweenService:Create(nf, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -295, 1, -90)
    }):Play()

    task.delay(duration or 3, function()
        TweenService:Create(nf, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
            Position = UDim2.new(1, 300, 1, -90)
        }):Play()
        task.wait(0.5)
        pcall(function() nf:Destroy() end)
    end)
end

-- ============ CLASSIC CHEAT FUNCTIONS ============

local function toggleFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyEnabled = not flyEnabled

    if flyEnabled then
        flyBody = Instance.new("BodyVelocity")
        flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBody.Velocity = Vector3.new(0, 0, 0)
        flyBody.Parent = hrp

        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.P = 9e4
        flyGyro.Parent = hrp

        local cam = workspace.CurrentCamera
        local speed = 80

        RunService:BindToRenderStep("RC7Fly", 1, function()
            if not flyEnabled then return end
            local cf = cam.CFrame
            local vel = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cf.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cf.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cf.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cf.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, speed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0, speed, 0) end

            flyBody.Velocity = vel
            flyGyro.CFrame = cf
        end)

        notify("FLY", "Полёт включён! (WASD + Space/Shift)", 3, C.Green)
    else
        pcall(function() RunService:UnbindFromRenderStep("RC7Fly") end)
        pcall(function() flyBody:Destroy() end)
        pcall(function() flyGyro:Destroy() end)
        notify("FLY", "Полёт выключен", 2, C.Yellow)
    end
end

local function toggleNoclip()
    noClipEnabled = not noClipEnabled
    if noClipEnabled then
        noClipConn = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end
        end)
        notify("NOCLIP", "Проход сквозь стены включён!", 3, C.Green)
    else
        if noClipConn then noClipConn:Disconnect() end
        notify("NOCLIP", "Ноклип выключен", 2, C.Yellow)
    end
end

local function toggleESP()
    espEnabled = not espEnabled

    if espEnabled then
        local function addESP(plr)
            if plr == player then return end
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local bb = Instance.new("BillboardGui")
            bb.Name = "RC7_ESP"
            bb.Size = UDim2.new(0, 200, 0, 50)
            bb.AlwaysOnTop = true
            bb.Adornee = hrp
            bb.Parent = hrp

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = plr.Name
            nameLabel.TextColor3 = C.Red
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextSize = 16
            nameLabel.Parent = bb

            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.TextColor3 = C.Yellow
            distLabel.TextStrokeTransparency = 0.5
            distLabel.Font = Enum.Font.SourceSans
            distLabel.TextSize = 14
            distLabel.Parent = bb

            local hl = Instance.new("Highlight")
            hl.Name = "RC7_HL"
            hl.FillColor = C.Red
            hl.FillTransparency = 0.7
            hl.OutlineColor = C.Red
            hl.OutlineTransparency = 0.3
            hl.Parent = char

            table.insert(espObjects, {bb = bb, hl = hl, dist = distLabel, plr = plr})
        end

        for _, plr in pairs(game.Players:GetPlayers()) do
            pcall(function() addESP(plr) end)
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                pcall(function() addESP(plr) end)
            end)
        end

        game.Players.PlayerAdded:Connect(function(plr)
            if not espEnabled then return end
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                pcall(function() addESP(plr) end)
            end)
        end)

        task.spawn(function()
            while espEnabled do
                for _, obj in pairs(espObjects) do
                    pcall(function()
                        if obj.plr and obj.plr.Character and obj.plr.Character:FindFirstChild("HumanoidRootPart") then
                            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if myHRP then
                                local dist = (myHRP.Position - obj.plr.Character.HumanoidRootPart.Position).Magnitude
                                obj.dist.Text = math.floor(dist) .. " studs"
                            end
                        end
                    end)
                end
                task.wait(0.5)
            end
        end)

        notify("ESP", "ESP включён — видны все игроки!", 3, C.Green)
    else
        for _, obj in pairs(espObjects) do
            pcall(function() obj.bb:Destroy() end)
            pcall(function() obj.hl:Destroy() end)
        end
        espObjects = {}
        notify("ESP", "ESP выключен", 2, C.Yellow)
    end
end

local function toggleGodMode()
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end
        notify("GOD MODE", "Бессмертие включено!", 3, C.Green)
    else
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = 100
                hum.Health = 100
            end
        end
        notify("GOD MODE", "Бессмертие выключено", 2, C.Yellow)
    end
end

local function teleportToPlayer(targetName)
    local target = game.Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            notify("TELEPORT", "Телепортирован к " .. targetName, 2, C.Green)
        end
    else
        notify("TELEPORT", "Игрок не найден!", 2, C.Red)
    end
end

local function spamChat(msg, count)
    local chatRemote
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v.Name == "SayMessageRequest" or v.Name == "DefaultChatSystemChatEvents" then
            if v:FindFirstChild("SayMessageRequest") then
                chatRemote = v.SayMessageRequest
                break
            end
        end
    end
    if chatRemote then
        for i = 1, (count or 5) do
            pcall(function() chatRemote:FireServer(msg .. " [" .. i .. "]", "All") end)
            task.wait(0.3)
        end
        notify("SPAM", "Отправлено " .. (count or 5) .. " сообщений", 2, C.Yellow)
    else
        notify("SPAM", "Чат не найден", 2, C.Red)
    end
end

local function toggleRainbow()
    rainbowEnabled = not rainbowEnabled
    if rainbowEnabled then
        rainbowConn = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char then
                local t = tick()
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                        p.Color = Color3.fromHSV((t + p.Position.X * 0.1) % 1, 1, 1)
                    end
                end
            end
        end)
        notify("RAINBOW", "Радужный персонаж!", 2, C.Green)
    else
        if rainbowConn then rainbowConn:Disconnect() end
        notify("RAINBOW", "Радуга выключена", 2, C.Yellow)
    end
end

local function flingPlayer()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.Velocity = Vector3.new(math.random(-500, 500), 500, math.random(-500, 500))
        hrp.RotVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
        notify("FLING", "YEET!", 2, C.Yellow)
    end
end

local function spinCharacter()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local spin = Instance.new("BodyAngularVelocity")
        spin.MaxTorque = Vector3.new(0, math.huge, 0)
        spin.AngularVelocity = Vector3.new(0, 50, 0)
        spin.Parent = hrp
        task.delay(5, function() pcall(function() spin:Destroy() end) end)
        notify("SPIN", "Крутись-вертись!", 2, C.Yellow)
    end
end

local function seizureMode()
    seizureEnabled = not seizureEnabled
    if seizureEnabled then
        seizureConn = RunService.Heartbeat:Connect(function()
            Lighting.Ambient = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
            Lighting.FogColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
            Lighting.FogEnd = math.random(50, 500)
            Lighting.Brightness = math.random(0, 10)
            Lighting.ClockTime = math.random(0, 24)
        end)
        notify("SEIZURE", "⚠ Эпилепсия! (осторожно)", 2, C.Red)
    else
        if seizureConn then seizureConn:Disconnect() end
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.FogEnd = 100000
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogColor = Color3.fromRGB(191, 191, 191)
        notify("SEIZURE", "Нормальный режим", 2, C.Green)
    end
end

local function matrixEffect()
    matrixRain = not matrixRain
    if matrixRain then
        task.spawn(function()
            while matrixRain do
                for i = 1, 3 do
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(0, 14, 0, 600)
                    lbl.Position = UDim2.new(0, math.random(0, SG.AbsoluteSize.X), 0, -600)
                    lbl.BackgroundTransparency = 1
                    local chars = ""
                    for j = 1, 40 do
                        chars = chars .. string.char(math.random(33, 126)) .. "\n"
                    end
                    lbl.Text = chars
                    lbl.TextColor3 = Color3.fromRGB(0, math.random(150, 255), 0)
                    lbl.Font = Enum.Font.Code
                    lbl.TextSize = 14
                    lbl.TextTransparency = math.random(2, 7) / 10
                    lbl.ZIndex = 0
                    lbl.Parent = SG
                    table.insert(matrixObjects, lbl)

                    TweenService:Create(lbl, TweenInfo.new(math.random(20, 50) / 10, Enum.EasingStyle.Linear), {
                        Position = UDim2.new(0, lbl.Position.X.Offset, 1, 200)
                    }):Play()

                    task.delay(6, function() pcall(function() lbl:Destroy() end) end)
                end
                task.wait(0.15)
            end
        end)
        notify("MATRIX", "Welcome to the Matrix...", 3, Color3.fromRGB(0, 200, 0))
    else
        for _, obj in pairs(matrixObjects) do pcall(function() obj:Destroy() end) end
        matrixObjects = {}
        notify("MATRIX", "Вернулся в реальность", 2, C.Yellow)
    end
end

local function bigHead()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                head.Size = Vector3.new(5, 5, 5)
                local mesh = head:FindFirstChildOfClass("SpecialMesh")
                if mesh then mesh.Scale = Vector3.new(2.5, 2.5, 2.5) end
            end
        end
    end
    notify("BIG HEAD", "Головы увеличены! Теперь легче попасть!", 3, C.Yellow)
end

local function removeFog()
    Lighting.FogEnd = 9999999
    Lighting.FogStart = 9999999
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    notify("FULLBRIGHT", "Туман убран, полная яркость", 2, C.Green)
end

local function antiAFK()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    notify("ANTI-AFK", "Анти-АФК активирован навсегда!", 3, C.Green)
end

-- ============ LOGIN WINDOW ============
local LoginFrame = Instance.new("Frame")
LoginFrame.Size = UDim2.new(0, 400, 0, 460)
LoginFrame.Position = UDim2.new(0.5, -200, 0.5, -230)
LoginFrame.BackgroundColor3 = C.DarkBG
LoginFrame.BorderSizePixel = 0
LoginFrame.Active = true
LoginFrame.Draggable = true
LoginFrame.ZIndex = 2
LoginFrame.Parent = SG
createStroke(LoginFrame, Color3.fromRGB(60, 20, 25), 2)
createGradient(LoginFrame, Color3.fromRGB(85, 30, 35), Color3.fromRGB(65, 22, 27), 90)

makeTitleBar(LoginFrame)
makeSidebar(LoginFrame, 35)

local loginLabel = Instance.new("TextLabel")
loginLabel.Size = UDim2.new(1, -35, 0, 90)
loginLabel.Position = UDim2.new(0, 0, 0, 85)
loginLabel.BackgroundTransparency = 1
loginLabel.Text = "LOGIN"
loginLabel.TextColor3 = Color3.fromRGB(140, 45, 50)
loginLabel.Font = Enum.Font.SourceSansBold
loginLabel.TextSize = 72
loginLabel.ZIndex = 6
loginLabel.Parent = LoginFrame

-- Animated subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -35, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 165)
subtitle.BackgroundTransparency = 1
subtitle.Text = "[ BACKDOOR SCANNER + CHEAT HUB ]"
subtitle.TextColor3 = Color3.fromRGB(180, 90, 95)
subtitle.Font = Enum.Font.Code
subtitle.TextSize = 12
subtitle.ZIndex = 6
subtitle.Parent = LoginFrame

task.spawn(function()
    while LoginFrame.Parent do
        for i = 0, 1, 0.02 do
            pcall(function()
                subtitle.TextColor3 = Color3.fromHSV(i, 0.5, 0.8)
            end)
            task.wait(0.05)
        end
    end
end)

local userFrame = Instance.new("Frame")
userFrame.Size = UDim2.new(0, 240, 0, 30)
userFrame.Position = UDim2.new(0.5, -135, 0, 210)
userFrame.BackgroundColor3 = C.InputBG
userFrame.BorderSizePixel = 0
userFrame.ZIndex = 6
userFrame.Parent = LoginFrame
createCorner(userFrame, 2)
createStroke(userFrame, Color3.fromRGB(60, 20, 25), 1)

local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(1, -10, 1, 0)
userBox.Position = UDim2.new(0, 5, 0, 0)
userBox.BackgroundTransparency = 1
userBox.Text = ""
userBox.PlaceholderText = "Username"
userBox.PlaceholderColor3 = Color3.fromRGB(180, 130, 135)
userBox.TextColor3 = Color3.fromRGB(255, 220, 222)
userBox.Font = Enum.Font.SourceSans
userBox.TextSize = 16
userBox.ZIndex = 7
userBox.Parent = userFrame

local passFrame = Instance.new("Frame")
passFrame.Size = UDim2.new(0, 240, 0, 30)
passFrame.Position = UDim2.new(0.5, -135, 0, 250)
passFrame.BackgroundColor3 = C.InputBG
passFrame.BorderSizePixel = 0
passFrame.ZIndex = 6
passFrame.Parent = LoginFrame
createCorner(passFrame, 2)
createStroke(passFrame, Color3.fromRGB(60, 20, 25), 1)

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(1, -10, 1, 0)
passBox.Position = UDim2.new(0, 5, 0, 0)
passBox.BackgroundTransparency = 1
passBox.Text = ""
passBox.PlaceholderText = "Password"
passBox.PlaceholderColor3 = Color3.fromRGB(180, 130, 135)
passBox.TextColor3 = Color3.fromRGB(255, 220, 222)
passBox.Font = Enum.Font.SourceSans
passBox.TextSize = 16
passBox.ZIndex = 7
passBox.Parent = passFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0, 180, 0, 38)
submitBtn.Position = UDim2.new(0.5, -105, 0, 300)
submitBtn.BackgroundColor3 = C.BtnRed
submitBtn.BorderSizePixel = 0
submitBtn.Text = "Submit"
submitBtn.TextColor3 = Color3.fromRGB(80, 28, 32)
submitBtn.Font = Enum.Font.SourceSansBold
submitBtn.TextSize = 22
submitBtn.ZIndex = 6
submitBtn.Parent = LoginFrame
createCorner(submitBtn, 3)
createStroke(submitBtn, Color3.fromRGB(100, 35, 40), 1)

local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, -35, 0, 75)
credits.Position = UDim2.new(0, 0, 1, -85)
credits.BackgroundTransparency = 1
credits.Text = "Lead Coder: PrinceOfOblivion\nLead GFX: KrystalTeam.\nGFX Help: Mannequin."
credits.TextColor3 = C.TextCredit
credits.Font = Enum.Font.SourceSansItalic
credits.TextSize = 14
credits.ZIndex = 6
credits.Parent = LoginFrame

-- ============ MAIN WINDOW ============
local function OpenMainWindow()
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 560, 0, 580)
    Main.Position = UDim2.new(0.5, -280, 0.5, -290)
    Main.BackgroundColor3 = C.DarkBG
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ZIndex = 2
    Main.Parent = SG
    createStroke(Main, Color3.fromRGB(60, 20, 25), 2)
    createGradient(Main, Color3.fromRGB(85, 30, 35), Color3.fromRGB(65, 22, 27), 90)

    makeTitleBar(Main)
    local sidebar = makeSidebar(Main, 48)

    local currentPage = "editor"
    local runScan

    -- Status bar at top
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, -58, 0, 18)
    statusBar.Position = UDim2.new(0, 8, 0, 29)
    statusBar.BackgroundColor3 = Color3.fromRGB(50, 18, 22)
    statusBar.BorderSizePixel = 0
    statusBar.ZIndex = 5
    statusBar.Parent = Main

    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 1, 0)
    statusText.Position = UDim2.new(0, 5, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Ready — PlaceId: " .. tostring(game.PlaceId) .. " | " .. #game.Players:GetPlayers() .. " players"
    statusText.TextColor3 = Color3.fromRGB(180, 120, 125)
    statusText.Font = Enum.Font.Code
    statusText.TextSize = 11
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.ZIndex = 6
    statusText.Parent = statusBar

    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(1, -58, 0, 24)
    tabHolder.Position = UDim2.new(0, 8, 0, 50)
    tabHolder.BackgroundTransparency = 1
    tabHolder.ZIndex = 5
    tabHolder.Parent = Main

    local tabNames = {"Editor", "Scanner", "Hub", "Cheats"}
    local tabButtons = {}
    local pages = {}

    for i, name in ipairs(tabNames) do
        local tb = Instance.new("TextButton")
        tb.Size = UDim2.new(0, 80, 1, 0)
        tb.Position = UDim2.new(0, (i-1) * 85, 0, 0)
        tb.BackgroundColor3 = i == 1 and C.TabBG or Color3.fromRGB(180, 155, 158)
        tb.BorderSizePixel = 0
        tb.Text = name
        tb.Font = Enum.Font.SourceSansBold
        tb.TextSize = 13
        tb.TextColor3 = Color3.fromRGB(60, 22, 25)
        tb.ZIndex = 6
        tb.Parent = tabHolder
        createCorner(tb, 3)
        tabButtons[name] = tb
    end

    local function switchPage(pageName)
        currentPage = pageName
        for n, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = n == pageName and C.TabBG or Color3.fromRGB(180, 155, 158)
        end
        for n, frame in pairs(pages) do
            frame.Visible = (n == pageName)
        end
    end

    for _, name in ipairs(tabNames) do
        tabButtons[name].MouseButton1Click:Connect(function()
            switchPage(name)
        end)
    end

    -- ============ EDITOR PAGE ============
    local editorFrame = Instance.new("Frame")
    editorFrame.Size = UDim2.new(1, -66, 1, -118)
    editorFrame.Position = UDim2.new(0, 8, 0, 78)
    editorFrame.BackgroundColor3 = C.CodeBG
    editorFrame.BorderSizePixel = 0
    editorFrame.ZIndex = 5
    editorFrame.Parent = Main
    createStroke(editorFrame, Color3.fromRGB(80, 30, 35), 1)
    pages["Editor"] = editorFrame

    local lineFrame = Instance.new("Frame")
    lineFrame.Size = UDim2.new(0, 28, 1, 0)
    lineFrame.BackgroundColor3 = Color3.fromRGB(245, 238, 238)
    lineFrame.BorderSizePixel = 0
    lineFrame.ZIndex = 6
    lineFrame.Parent = editorFrame

    local lineNums = Instance.new("TextLabel")
    lineNums.Size = UDim2.new(1, 0, 1, 0)
    lineNums.Position = UDim2.new(0, 0, 0, 5)
    lineNums.BackgroundTransparency = 1
    lineNums.Text = " 1\n 2\n 3"
    lineNums.TextColor3 = Color3.fromRGB(150, 130, 130)
    lineNums.Font = Enum.Font.Code
    lineNums.TextSize = 13
    lineNums.TextXAlignment = Enum.TextXAlignment.Right
    lineNums.TextYAlignment = Enum.TextYAlignment.Top
    lineNums.ZIndex = 7
    lineNums.Parent = lineFrame

    local codeScroll = Instance.new("ScrollingFrame")
    codeScroll.Size = UDim2.new(1, -32, 1, -5)
    codeScroll.Position = UDim2.new(0, 30, 0, 2)
    codeScroll.BackgroundTransparency = 1
    codeScroll.BorderSizePixel = 0
    codeScroll.ScrollBarThickness = 6
    codeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    codeScroll.ZIndex = 6
    codeScroll.Parent = editorFrame

    local codeBox = Instance.new("TextBox")
    codeBox.Size = UDim2.new(1, -10, 1, 0)
    codeBox.Position = UDim2.new(0, 5, 0, 3)
    codeBox.BackgroundTransparency = 1
    codeBox.Text = "-- RC7 Script Editor\n-- Введите код и нажмите Execute\n-- Или выберите скрипт из хаба\n\nprint('Hello from RC7!')"
    codeBox.TextColor3 = C.CodeText
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 13
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    codeBox.MultiLine = true
    codeBox.ClearTextOnFocus = false
    codeBox.ZIndex = 7
    codeBox.Parent = codeScroll

    local function updateLines()
        local text = codeBox.Text
        local count = 1
        for _ in text:gmatch("\n") do count = count + 1 end
        local nums = ""
        for i = 1, math.max(count, 30) do
            nums = nums .. " " .. i .. "\n"
        end
        lineNums.Text = nums
        codeScroll.CanvasSize = UDim2.new(0, 0, 0, count * 16 + 50)
    end

    codeBox:GetPropertyChangedSignal("Text"):Connect(updateLines)
    updateLines()

    -- ============ SCANNER PAGE ============
    local scannerFrame = Instance.new("Frame")
    scannerFrame.Size = UDim2.new(1, -66, 1, -118)
    scannerFrame.Position = UDim2.new(0, 8, 0, 78)
    scannerFrame.BackgroundColor3 = C.CodeBG
    scannerFrame.BorderSizePixel = 0
    scannerFrame.Visible = false
    scannerFrame.ZIndex = 5
    scannerFrame.Parent = Main
    createStroke(scannerFrame, Color3.fromRGB(80, 30, 35), 1)
    pages["Scanner"] = scannerFrame

    local scanTitle = Instance.new("TextLabel")
    scanTitle.Size = UDim2.new(1, 0, 0, 30)
    scanTitle.Position = UDim2.new(0, 0, 0, 5)
    scanTitle.BackgroundTransparency = 1
    scanTitle.Text = "🔍 BACKDOOR SCANNER"
    scanTitle.TextColor3 = Color3.fromRGB(120, 40, 45)
    scanTitle.Font = Enum.Font.SourceSansBold
    scanTitle.TextSize = 20
    scanTitle.ZIndex = 7
    scanTitle.Parent = scannerFrame

    -- Scan options
    local scanOptionsFrame = Instance.new("Frame")
    scanOptionsFrame.Size = UDim2.new(1, -20, 0, 110)
    scanOptionsFrame.Position = UDim2.new(0, 10, 0, 38)
    scanOptionsFrame.BackgroundColor3 = Color3.fromRGB(240, 230, 232)
    scanOptionsFrame.BorderSizePixel = 0
    scanOptionsFrame.ZIndex = 6
    scanOptionsFrame.Parent = scannerFrame
    createCorner(scanOptionsFrame, 5)
    createStroke(scanOptionsFrame, Color3.fromRGB(180, 140, 145), 1)

    local scanTypes = {
        {Name = "Full Scan", Desc = "Полное сканирование (Remote + Module + Script)", Type = "FULL"},
        {Name = "Remote Scan", Desc = "Только RemoteEvent/RemoteFunction", Type = "REMOTE"},
        {Name = "Module Scan", Desc = "Только ModuleScript", Type = "MODULE"},
        {Name = "Deep Scan", Desc = "Глубокий анализ с паттернами", Type = "DEEP"},
    }

    for i, st in ipairs(scanTypes) do
        local row = math.ceil(i / 2)
        local col = (i - 1) % 2

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.48, 0, 0, 42)
        btn.Position = UDim2.new(col * 0.5 + 0.01, 0, 0, 5 + (row-1) * 52)
        btn.BackgroundColor3 = C.LightRed
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.ZIndex = 7
        btn.Parent = scanOptionsFrame
        createCorner(btn, 5)

        local btnName = Instance.new("TextLabel")
        btnName.Size = UDim2.new(1, -10, 0, 20)
        btnName.Position = UDim2.new(0, 5, 0, 3)
        btnName.BackgroundTransparency = 1
        btnName.Text = st.Name
        btnName.TextColor3 = C.White
        btnName.Font = Enum.Font.SourceSansBold
        btnName.TextSize = 14
        btnName.TextXAlignment = Enum.TextXAlignment.Left
        btnName.ZIndex = 8
        btnName.Parent = btn

        local btnDesc = Instance.new("TextLabel")
        btnDesc.Size = UDim2.new(1, -10, 0, 16)
        btnDesc.Position = UDim2.new(0, 5, 0, 22)
        btnDesc.BackgroundTransparency = 1
        btnDesc.Text = st.Desc
        btnDesc.TextColor3 = Color3.fromRGB(255, 200, 205)
        btnDesc.Font = Enum.Font.SourceSans
        btnDesc.TextSize = 11
        btnDesc.TextXAlignment = Enum.TextXAlignment.Left
        btnDesc.ZIndex = 8
        btnDesc.Parent = btn

        btn.MouseButton1Click:Connect(function()
            task.spawn(function() runScan(st.Type) end)
        end)
    end

    -- Scan results area
    local scanResultsScroll = Instance.new("ScrollingFrame")
    scanResultsScroll.Size = UDim2.new(1, -20, 1, -165)
    scanResultsScroll.Position = UDim2.new(0, 10, 0, 155)
    scanResultsScroll.BackgroundColor3 = Color3.fromRGB(20, 8, 10)
    scanResultsScroll.BorderSizePixel = 0
    scanResultsScroll.ScrollBarThickness = 6
    scanResultsScroll.ZIndex = 6
    scanResultsScroll.Parent = scannerFrame
    createCorner(scanResultsScroll, 5)

    local scanResultsLabel = Instance.new("TextLabel")
    scanResultsLabel.Size = UDim2.new(1, -15, 1, 0)
    scanResultsLabel.Position = UDim2.new(0, 8, 0, 5)
    scanResultsLabel.BackgroundTransparency = 1
    scanResultsLabel.Text = "Нажмите кнопку выше для начала сканирования...\n\n"
    scanResultsLabel.TextColor3 = Color3.fromRGB(0, 220, 0)
    scanResultsLabel.Font = Enum.Font.Code
    scanResultsLabel.TextSize = 12
    scanResultsLabel.TextXAlignment = Enum.TextXAlignment.Left
    scanResultsLabel.TextYAlignment = Enum.TextYAlignment.Top
    scanResultsLabel.TextWrapped = true
    scanResultsLabel.ZIndex = 7
    scanResultsLabel.Parent = scanResultsScroll

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 0, 4)
    progressBar.Position = UDim2.new(0, 10, 0, 149)
    progressBar.BackgroundColor3 = C.Green
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 7
    progressBar.Parent = scannerFrame
    createCorner(progressBar, 2)

    local function setProgress(pct)
        local maxW = scannerFrame.AbsoluteSize.X - 20
        TweenService:Create(progressBar, TweenInfo.new(0.3), {
            Size = UDim2.new(0, maxW * pct, 0, 4)
        }):Play()
    end

    local function addScanLine(text, color)
        scanResultsLabel.Text = scanResultsLabel.Text .. text .. "\n"
        local lines = select(2, scanResultsLabel.Text:gsub("\n", "")) + 1
        scanResultsScroll.CanvasSize = UDim2.new(0, 0, 0, lines * 14 + 20)
        scanResultsScroll.CanvasPosition = Vector2.new(0, scanResultsScroll.CanvasSize.Y.Offset)
    end

    -- ============ ENHANCED SCANNER ============
    local suspiciousRemoteNames = {
        "loadstring", "execute", "backdoor", "hook", "mainevent",
        "banana", "c00l", "kohls", "inject", "hack", "admin",
        "cmd", "command", "run", "eval", "httpget", "require",
        "exploit", "cheat", "bypass", "remote", "fire", "server",
        "console", "terminal", "shell", "payload", "obfuscate"
    }

    local suspiciousModuleNames = {
        "backdoor", "loader", "inject", "hook", "exec",
        "admin", "cmd", "handler", "controller", "main",
        "bypass", "exploit", "payload", "obfuscated"
    }

    local suspiciousPatterns = {
        "loadstring%s*%(", "game:HttpGet", "HttpService:GetAsync",
        "require%s*%(%s*%d+%s*%)", "getfenv", "setfenv",
        "rawset%s*%(%s*_G", "rawset%s*%(%s*shared",
        "Instance%.new%s*%(%s*[\"']RemoteEvent",
        "coroutine%.wrap%s*%(%s*function",
        "game%.Players%..-%.Chatted",
        ":FireServer%s*%(", ":InvokeServer%s*%(",
    }

    runScan = function(scanType)
        scanResultsLabel.Text = ""
        progressBar.BackgroundColor3 = C.Green
        setProgress(0)

        statusText.Text = "Scanning..."
        statusText.TextColor3 = C.Yellow

        local totalFound = 0
        local totalScanned = 0
        local findings = {}

        addScanLine("╔═══════════════════════════════════════╗")
        addScanLine("║     RC7 BACKDOOR SCANNER v2.1         ║")
        addScanLine("╠═══════════════════════════════════════╣")
        addScanLine("║ Scan Type: " .. scanType)
        addScanLine("║ PlaceId: " .. tostring(game.PlaceId))
        addScanLine("║ Game: " .. tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown"))
        addScanLine("║ Players: " .. #game.Players:GetPlayers())
        addScanLine("║ Time: " .. os.date("%H:%M:%S"))
        addScanLine("╚═══════════════════════════════════════╝")
        addScanLine("")
        task.wait(0.3)

        local descendants = game:GetDescendants()
        local totalObjects = #descendants

        -- ---- REMOTE SCAN ----
        if scanType == "FULL" or scanType == "REMOTE" or scanType == "DEEP" then
            addScanLine("┌─── REMOTE SCAN ───────────────────────")
            addScanLine("│ Scanning RemoteEvents & RemoteFunctions...")
            addScanLine("│")
            task.wait(0.2)

            local remoteCount = 0
            local suspCount = 0

            for idx, obj in pairs(descendants) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    remoteCount = remoteCount + 1
                    local lname = obj.Name:lower()
                    local matched = false
                    local matchWord = ""

                    for _, bad in ipairs(suspiciousRemoteNames) do
                        if lname:find(bad) then
                            matched = true
                            matchWord = bad
                            break
                        end
                    end

                    -- Проверяем обфускированные имена
                    if not matched then
                        if #obj.Name > 30 or obj.Name:match("^[%w]+$") and #obj.Name > 15 then
                            matched = true
                            matchWord = "obfuscated_name"
                        end
                        if obj.Name:match("[^%w%s%-_]") then
                            matched = true
                            matchWord = "special_chars"
                        end
                    end

                    -- Проверяем расположение
                    if not matched then
                        local path = obj:GetFullName():lower()
                        if path:find("serverscriptservice") or path:find("serverstorage") then
                            -- нормально
                        elseif path:find("replicatedstorage") and lname:match("^[a-z]$") then
                            matched = true
                            matchWord = "single_letter_remote"
                        end
                    end

                    if matched then
                        suspCount = suspCount + 1
                        totalFound = totalFound + 1
                        local risk = "MEDIUM"
                        local riskColor = "⚠"

                        if matchWord == "backdoor" or matchWord == "loadstring" or matchWord == "execute" or matchWord == "inject" then
                            risk = "HIGH"
                            riskColor = "🔴"
                        elseif matchWord == "obfuscated_name" or matchWord == "special_chars" then
                            risk = "LOW"
                            riskColor = "🟡"
                        end

                        table.insert(findings, {
                            Type = obj.ClassName,
                            Name = obj.Name,
                            Path = obj:GetFullName(),
                            Match = matchWord,
                            Risk = risk
                        })

                        addScanLine("│ " .. riskColor .. " [" .. risk .. "] " .. obj.ClassName .. ": " .. obj.Name)
                        addScanLine("│    Path: " .. obj:GetFullName())
                        addScanLine("│    Match: " .. matchWord)
                        addScanLine("│")
                    end
                end

                if idx % 500 == 0 then
                    setProgress(idx / totalObjects * 0.3)
                    task.wait()
                end
            end

            addScanLine("│ Total Remotes: " .. remoteCount)
            addScanLine("│ Suspicious: " .. suspCount)
            addScanLine("└───────────────────────────────────────")
            addScanLine("")
            task.wait(0.2)
        end

        -- ---- MODULE SCAN ----
        if scanType == "FULL" or scanType == "MODULE" or scanType == "DEEP" then
            addScanLine("┌─── MODULE SCAN ──────────────────────")
            addScanLine("│ Scanning ModuleScripts...")
            addScanLine("│")
            task.wait(0.2)

            local moduleCount = 0
            local suspModules = 0

            for idx, obj in pairs(descendants) do
                if obj:IsA("ModuleScript") then
                    moduleCount = moduleCount + 1
                    local lname = obj.Name:lower()
                    local matched = false
                    local matchWord = ""

                    for _, bad in ipairs(suspiciousModuleNames) do
                        if lname:find(bad) then
                            matched = true
                            matchWord = bad
                            break
                        end
                    end

                    -- Проверяем по require ID
                    if not matched then
                        pcall(function()
                            local src = obj.Source
                            if src and #src > 0 then
                                if src:lower():find("loadstring") or src:lower():find("httpget") then
                                    matched = true
                                    matchWord = "source_contains_loader"
                                end
                            end
                        end)
                    end

                    -- Проверяем обфускацию имени
                    if not matched then
                        if #obj.Name > 25 and not obj.Name:match("%s") then
                            matched = true
                            matchWord = "obfuscated_module"
                        end
                    end

                    if matched then
                        suspModules = suspModules + 1
                        totalFound = totalFound + 1

                        addScanLine("│ 🔴 MODULE: " .. obj.Name)
                        addScanLine("│    Path: " .. obj:GetFullName())
                        addScanLine("│    Match: " .. matchWord)

                        -- Попробуем получить require ID
                        pcall(function()
                            if obj:FindFirstChild("RequireId") then
                                addScanLine("│    RequireId: " .. tostring(obj.RequireId.Value))
                            end
                        end)

                        addScanLine("│")
                    end
                end

                if idx % 500 == 0 then
                    setProgress(0.3 + idx / totalObjects * 0.3)
                    task.wait()
                end
            end

            addScanLine("│ Total Modules: " .. moduleCount)
            addScanLine("│ Suspicious: " .. suspModules)
            addScanLine("└───────────────────────────────────────")
            addScanLine("")
            task.wait(0.2)
        end

        -- ---- SCRIPT SCAN ----
        if scanType == "FULL" or scanType == "DEEP" then
            addScanLine("┌─── SCRIPT SCAN ──────────────────────")
            addScanLine("│ Analyzing Scripts...")
            addScanLine("│")
            task.wait(0.2)

            local scriptCount = 0
            local suspScripts = 0

            for idx, obj in pairs(descendants) do
                if obj:IsA("Script") or obj:IsA("LocalScript") then
                    scriptCount = scriptCount + 1
                    pcall(function()
                        local src = obj.Source
                        if src and src ~= "" then
                            local low = src:lower()
                            local foundPatterns = {}

                            for _, pattern in ipairs(suspiciousPatterns) do
                                if low:find(pattern:lower()) then
                                    table.insert(foundPatterns, pattern)
                                end
                            end

                            if #foundPatterns > 0 then
                                suspScripts = suspScripts + 1
                                totalFound = totalFound + 1

                                local risk = #foundPatterns >= 3 and "HIGH" or (#foundPatterns >= 2 and "MEDIUM" or "LOW")

                                addScanLine("│ 🔴 [" .. risk .. "] " .. obj.ClassName .. ": " .. obj.Name)
                                addScanLine("│    Path: " .. obj:GetFullName())
                                addScanLine("│    Patterns: " .. table.concat(foundPatterns, ", "))
                                addScanLine("│    Source length: " .. #src .. " chars")
                                addScanLine("│")
                            end
                        end
                    end)
                end

                if idx % 500 == 0 then
                    setProgress(0.6 + idx / totalObjects * 0.3)
                    task.wait()
                end
            end

            addScanLine("│ Total Scripts: " .. scriptCount)
            addScanLine("│ Suspicious: " .. suspScripts)
            addScanLine("└───────────────────────────────────────")
            addScanLine("")
        end

        -- ---- DEEP ANALYSIS ----
        if scanType == "DEEP" then
            addScanLine("┌─── DEEP ANALYSIS ────────────────────")
            addScanLine("│ Checking game structure...")
            addScanLine("│")
            task.wait(0.2)

            -- Проверяем _G и shared
            pcall(function()
                local gCount = 0
                for k, v in pairs(_G) do
                    gCount = gCount + 1
                    if type(v) == "function" then
                        addScanLine("│ ⚠ _G function found: " .. tostring(k))
                        totalFound = totalFound + 1
                    end
                end
                addScanLine("│ _G entries: " .. gCount)
            end)

            pcall(function()
                local sCount = 0
                for k, v in pairs(shared) do
                    sCount = sCount + 1
                    if type(v) == "function" then
                        addScanLine("│ ⚠ shared function found: " .. tostring(k))
                        totalFound = totalFound + 1
                    end
                end
                addScanLine("│ shared entries: " .. sCount)
            end)

            -- Проверяем необычные сервисы
            local suspServices = {"HttpService", "TeleportService", "DataStoreService"}
            for _, sName in ipairs(suspServices) do
                local exists = pcall(function() return game:GetService(sName) end)
                if exists then
                    addScanLine("│ ✓ " .. sName .. " accessible")
                end
            end

            -- Проверяем Bindable
            local bindableCount = 0
            for _, obj in pairs(descendants) do
                if obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                    bindableCount = bindableCount + 1
                    local lname = obj.Name:lower()
                    for _, bad in ipairs({"execute", "run", "cmd", "backdoor", "hook"}) do
                        if lname:find(bad) then
                            addScanLine("│ ⚠ Suspicious Bindable: " .. obj.Name)
                            addScanLine("│    Path: " .. obj:GetFullName())
                            totalFound = totalFound + 1
                            break
                        end
                    end
                end
            end
            addScanLine("│ Total Bindables: " .. bindableCount)

            -- Проверяем StringValues с подозрительным содержимым
            for _, obj in pairs(descendants) do
                if obj:IsA("StringValue") then
                    pcall(function()
                        local val = obj.Value:lower()
                        if val:find("loadstring") or val:find("httpget") or val:find("require") then
                            addScanLine("│ 🔴 Suspicious StringValue: " .. obj.Name)
                            addScanLine("│    Path: " .. obj:GetFullName())
                            addScanLine("│    Contains: loader code")
                            totalFound = totalFound + 1
                        end
                    end)
                end
            end

            addScanLine("│")
            addScanLine("└───────────────────────────────────────")
            addScanLine("")
        end

        setProgress(1)

        -- ---- SUMMARY ----
        addScanLine("╔═══════════════════════════════════════╗")
        if totalFound > 0 then
            addScanLine("║  ⚠ THREATS FOUND: " .. totalFound)
            addScanLine("║")

            local highCount = 0
            for _, f in ipairs(findings) do
                if f.Risk == "HIGH" then highCount = highCount + 1 end
            end

            if highCount > 0 then
                addScanLine("║  🔴 HIGH RISK: " .. highCount)
                addScanLine("║  GAME MAY HAVE ACTIVE BACKDOORS!")
                progressBar.BackgroundColor3 = C.Red
            else
                addScanLine("║  ⚠ MODERATE RISK DETECTED")
                addScanLine("║  Investigate findings manually")
                progressBar.BackgroundColor3 = C.Yellow
            end
        else
            addScanLine("║  ✅ NO BACKDOORS FOUND")
            addScanLine("║  Game appears safe")
            progressBar.BackgroundColor3 = C.Green
        end
        addScanLine("║  Scanned: " .. #descendants .. " objects")
        addScanLine("╚═══════════════════════════════════════╝")

        statusText.Text = "Scan complete — " .. totalFound .. " threats found | " .. #descendants .. " objects scanned"
        statusText.TextColor3 = totalFound > 0 and C.Red or C.Green

        if totalFound > 0 then
            notify("SCAN COMPLETE", totalFound .. " подозрительных объектов найдено!", 5, C.Red)
        else
            notify("SCAN COMPLETE", "Бэкдоры не найдены. Игра чистая.", 4, C.Green)
        end
    end

    -- ============ HUB PAGE ============
    local hubFrame = Instance.new("Frame")
    hubFrame.Size = UDim2.new(1, -66, 1, -118)
    hubFrame.Position = UDim2.new(0, 8, 0, 78)
    hubFrame.BackgroundColor3 = C.CodeBG
    hubFrame.BorderSizePixel = 0
    hubFrame.Visible = false
    hubFrame.ZIndex = 5
    hubFrame.Parent = Main
    createStroke(hubFrame, Color3.fromRGB(80, 30, 35), 1)
    pages["Hub"] = hubFrame

    local hubTitle = Instance.new("TextLabel")
    hubTitle.Size = UDim2.new(1, 0, 0, 30)
    hubTitle.Position = UDim2.new(0, 0, 0, 5)
    hubTitle.BackgroundTransparency = 1
    hubTitle.Text = "📜 SCRIPT HUB"
    hubTitle.TextColor3 = Color3.fromRGB(120, 40, 45)
    hubTitle.Font = Enum.Font.SourceSansBold
    hubTitle.TextSize = 22
    hubTitle.ZIndex = 7
    hubTitle.Parent = hubFrame

    -- Search bar
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -20, 0, 28)
    searchFrame.Position = UDim2.new(0, 10, 0, 38)
    searchFrame.BackgroundColor3 = Color3.fromRGB(235, 225, 228)
    searchFrame.BorderSizePixel = 0
    searchFrame.ZIndex = 7
    searchFrame.Parent = hubFrame
    createCorner(searchFrame, 4)
    createStroke(searchFrame, Color3.fromRGB(180, 140, 145), 1)

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -10, 1, 0)
    searchBox.Position = UDim2.new(0, 5, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = "🔍 Поиск скриптов..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 120, 125)
    searchBox.TextColor3 = Color3.fromRGB(60, 20, 25)
    searchBox.Font = Enum.Font.SourceSans
    searchBox.TextSize = 14
    searchBox.ZIndex = 8
    searchBox.Parent = searchFrame

    local hubScroll = Instance.new("ScrollingFrame")
    hubScroll.Size = UDim2.new(1, -20, 1, -80)
    hubScroll.Position = UDim2.new(0, 10, 0, 72)
    hubScroll.BackgroundTransparency = 1
    hubScroll.BorderSizePixel = 0
    hubScroll.ScrollBarThickness = 5
    hubScroll.ZIndex = 6
    hubScroll.Parent = hubFrame

    local hubLayout = Instance.new("UIListLayout")
    hubLayout.Padding = UDim.new(0, 5)
    hubLayout.Parent = hubScroll

    local hubScripts = {
        {Name = "Infinite Yield", Desc = "Популярный админ скрипт", Category = "Admin", Code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()'},
        {Name = "Dark Dex", Desc = "Проводник игры (Explorer)", Category = "Dev", Code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()'},
        {Name = "Spy Remote", Desc = "Отслеживание Remote вызовов", Category = "Dev", Code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/78/SimpleSpy/main/SimpleSpy.lua"))()'},
        {Name = "Speed Hack", Desc = "WalkSpeed = 100", Category = "Movement", Code = 'game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100'},
        {Name = "Jump Power", Desc = "JumpPower = 150", Category = "Movement", Code = 'game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150'},
        {Name = "Gravity", Desc = "Пониженная гравитация", Category = "Movement", Code = 'workspace.Gravity = 50'},
        {Name = "Rejoin", Desc = "Перезайти на сервер", Category = "Utility", Code = 'game:GetService("TeleportService"):Teleport(game.PlaceId)'},
        {Name = "Server Hop", Desc = "Сменить сервер", Category = "Utility", Code = [[
local Http = game:GetService("HttpService")
local TS = game:GetService("TeleportService")
local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
for _,v in pairs(servers.data) do
    if v.playing < v.maxPlayers and v.id ~= game.JobId then
        TS:TeleportToPlaceInstance(game.PlaceId, v.id)
        break
    end
end
]]},
        {Name = "ClickTP", Desc = "Телепорт по клику (Ctrl+Click)", Category = "Movement", Code = [[
local mouse = game.Players.LocalPlayer:GetMouse()
local uis = game:GetService("UserInputService")
mouse.Button1Down:Connect(function()
    if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
    end
end)
]]},
        {Name = "Chat Spy", Desc = "Видеть все чат-сообщения (включая /w)", Category = "Spy", Code = [[
for _,v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        v.Chatted:Connect(function(msg)
            print("[" .. v.Name .. "]: " .. msg)
            game.StarterGui:SetCore("SendNotification", {Title = v.Name, Text = msg, Duration = 4})
        end)
    end
end
game.Players.PlayerAdded:Connect(function(v)
    v.Chatted:Connect(function(msg)
        print("[" .. v.Name .. "]: " .. msg)
        game.StarterGui:SetCore("SendNotification", {Title = v.Name, Text = msg, Duration = 4})
    end)
end)
]]},
    }

    local scriptCards = {}

    for _, s in ipairs(hubScripts) do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -5, 0, 52)
        card.BackgroundColor3 = Color3.fromRGB(240, 228, 228)
        card.BorderSizePixel = 0
        card.ZIndex = 7
        card.Parent = hubScroll
        createCorner(card, 5)
        createStroke(card, Color3.fromRGB(180, 140, 145), 1)

        local catLabel = Instance.new("TextLabel")
        catLabel.Size = UDim2.new(0, 60, 0, 16)
        catLabel.Position = UDim2.new(1, -135, 0, 4)
        catLabel.BackgroundColor3 = C.MidRed
        catLabel.Text = s.Category
        catLabel.TextColor3 = C.White
        catLabel.Font = Enum.Font.SourceSansBold
        catLabel.TextSize = 10
        catLabel.ZIndex = 9
        catLabel.Parent = card
        createCorner(catLabel, 3)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -145, 0, 22)
        nameLabel.Position = UDim2.new(0, 10, 0, 3)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = s.Name
        nameLabel.TextColor3 = Color3.fromRGB(100, 35, 40)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 15
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 8
        nameLabel.Parent = card

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -145, 0, 16)
        descLabel.Position = UDim2.new(0, 10, 0, 26)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = s.Desc
        descLabel.TextColor3 = Color3.fromRGB(160, 120, 125)
        descLabel.Font = Enum.Font.SourceSans
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 8
        descLabel.Parent = card

        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 40, 0, 26)
        copyBtn.Position = UDim2.new(1, -115, 0.5, -13)
        copyBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 145)
        copyBtn.BorderSizePixel = 0
        copyBtn.Text = "📋"
        copyBtn.TextSize = 14
        copyBtn.ZIndex = 8
        copyBtn.Parent = card
        createCorner(copyBtn, 4)

        copyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(s.Code)
                notify("COPIED", s.Name .. " скопирован!", 2, C.Green)
            else
                codeBox.Text = s.Code
                switchPage("Editor")
                updateLines()
                notify("LOADED", s.Name .. " загружен в редактор", 2, C.Green)
            end
        end)

        local execBtn = Instance.new("TextButton")
        execBtn.Size = UDim2.new(0, 50, 0, 26)
        execBtn.Position = UDim2.new(1, -60, 0.5, -13)
        execBtn.BackgroundColor3 = C.LightRed
        execBtn.BorderSizePixel = 0
        execBtn.Text = "Run"
        execBtn.TextColor3 = Color3.fromRGB(255, 230, 232)
        execBtn.Font = Enum.Font.SourceSansBold
        execBtn.TextSize = 13
        execBtn.ZIndex = 8
        execBtn.Parent = card
        createCorner(execBtn, 4)

        execBtn.MouseButton1Click:Connect(function()
            codeBox.Text = s.Code
            switchPage("Editor")
            updateLines()

            local fn, err = loadstring(s.Code)
            if fn then
                local ok, e = pcall(fn)
                if ok then
                    notify("EXECUTED", s.Name .. " запущен!", 2, C.Green)
                else
                    notify("ERROR", tostring(e), 4, C.Red)
                end
            else
                notify("SYNTAX ERROR", tostring(err), 4, C.Red)
            end
        end)

        table.insert(scriptCards, {card = card, name = s.Name:lower(), desc = s.Desc:lower(), cat = s.Category:lower()})
    end

    hubScroll.CanvasSize = UDim2.new(0, 0, 0, #hubScripts * 57 + 10)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        local visCount = 0
        for _, sc in ipairs(scriptCards) do
            local vis = query == "" or sc.name:find(query) or sc.desc:find(query) or sc.cat:find(query)
            sc.card.Visible = vis
            if vis then visCount = visCount + 1 end
        end
        hubScroll.CanvasSize = UDim2.new(0, 0, 0, visCount * 57 + 10)
    end)

    -- ============ CHEATS PAGE ============
    local cheatsFrame = Instance.new("Frame")
    cheatsFrame.Size = UDim2.new(1, -66, 1, -118)
    cheatsFrame.Position = UDim2.new(0, 8, 0, 78)
    cheatsFrame.BackgroundColor3 = C.CodeBG
    cheatsFrame.BorderSizePixel = 0
    cheatsFrame.Visible = false
    cheatsFrame.ZIndex = 5
    cheatsFrame.Parent = Main
    createStroke(cheatsFrame, Color3.fromRGB(80, 30, 35), 1)
    pages["Cheats"] = cheatsFrame

    local cheatsTitle = Instance.new("TextLabel")
    cheatsTitle.Size = UDim2.new(1, 0, 0, 30)
    cheatsTitle.Position = UDim2.new(0, 0, 0, 5)
    cheatsTitle.BackgroundTransparency = 1
    cheatsTitle.Text = "🎮 CLASSIC CHEATS"
    cheatsTitle.TextColor3 = Color3.fromRGB(120, 40, 45)
    cheatsTitle.Font = Enum.Font.SourceSansBold
    cheatsTitle.TextSize = 22
    cheatsTitle.ZIndex = 7
    cheatsTitle.Parent = cheatsFrame

    local cheatsScroll = Instance.new("ScrollingFrame")
    cheatsScroll.Size = UDim2.new(1, -20, 1, -45)
    cheatsScroll.Position = UDim2.new(0, 10, 0, 40)
    cheatsScroll.BackgroundTransparency = 1
    cheatsScroll.BorderSizePixel = 0
    cheatsScroll.ScrollBarThickness = 5
    cheatsScroll.ZIndex = 6
    cheatsScroll.Parent = cheatsFrame

    local cheatsLayout = Instance.new("UIGridLayout")
    cheatsLayout.CellSize = UDim2.new(0.48, 0, 0, 60)
    cheatsLayout.CellPadding = UDim2.new(0.02, 0, 0, 6)
    cheatsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cheatsLayout.Parent = cheatsScroll

    local cheatsList = {
        {Name = "✈ FLY", Desc = "Полёт (WASD)", Toggle = true, Callback = toggleFly, State = function() return flyEnabled end},
        {Name = "👻 NOCLIP", Desc = "Сквозь стены", Toggle = true, Callback = toggleNoclip, State = function() return noClipEnabled end},
        {Name = "👁 ESP", Desc = "Видеть игроков", Toggle = true, Callback = toggleESP, State = function() return espEnabled end},
        {Name = "💪 GOD MODE", Desc = "Бессмертие", Toggle = true, Callback = toggleGodMode, State = function() return godModeEnabled end},
        {Name = "🌈 RAINBOW", Desc = "Радужный перс", Toggle = true, Callback = toggleRainbow, State = function() return rainbowEnabled end},
        {Name = "⚡ SPEED", Desc = "WalkSpeed = 100", Toggle = false, Callback = function()
            local char = player.Character
            if char then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
                notify("SPEED", "WalkSpeed = 100!", 2, C.Green)
            end
        end},
        {Name = "🦘 JUMP", Desc = "JumpPower = 200", Toggle = false, Callback = function()
            local char = player.Character
            if char then
                char:FindFirstChildOfClass("Humanoid").JumpPower = 200
                notify("JUMP", "JumpPower = 200!", 2, C.Green)
            end
        end},
        {Name = "🔆 FULLBRIGHT", Desc = "Убрать туман", Toggle = false, Callback = removeFog},
        {Name = "💀 FLING", Desc = "Подбросить себя", Toggle = false, Callback = flingPlayer},
        {Name = "🔄 SPIN", Desc = "Крутиться 5 сек", Toggle = false, Callback = spinCharacter},
        {Name = "🤯 SEIZURE", Desc = "Эпилепсия (свет)", Toggle = true, Callback = seizureMode, State = function() return seizureEnabled end},
        {Name = "💚 MATRIX", Desc = "Matrix rain", Toggle = true, Callback = matrixEffect, State = function() return matrixRain end},
        {Name = "🗿 BIG HEAD", Desc = "Большие головы", Toggle = false, Callback = bigHead},
        {Name = "🔒 ANTI-AFK", Desc = "Не кикнет за АФК", Toggle = false, Callback = antiAFK},
        {Name = "🔄 RESET", Desc = "Сброс персонажа", Toggle = false, Callback = function()
            player.Character:FindFirstChildOfClass("Humanoid").Health = 0
            notify("RESET", "Персонаж сброшен", 2, C.Yellow)
        end},
        {Name = "🌍 LOW GRAV", Desc = "Gravity = 40", Toggle = false, Callback = function()
            workspace.Gravity = 40
            notify("GRAVITY", "Gravity = 40!", 2, C.Green)
        end},
    }

    for i, cheat in ipairs(cheatsList) do
        local card = Instance.new("TextButton")
        card.Size = UDim2.new(0, 0, 0, 0)
        card.BackgroundColor3 = Color3.fromRGB(235, 222, 224)
        card.BorderSizePixel = 0
        card.Text = ""
        card.LayoutOrder = i
        card.ZIndex = 7
        card.Parent = cheatsScroll
        createCorner(card, 6)
        createStroke(card, Color3.fromRGB(180, 140, 145), 1)

        local nameL = Instance.new("TextLabel")
        nameL.Size = UDim2.new(1, -10, 0, 25)
        nameL.Position = UDim2.new(0, 5, 0, 5)
        nameL.BackgroundTransparency = 1
        nameL.Text = cheat.Name
        nameL.TextColor3 = Color3.fromRGB(80, 30, 35)
        nameL.Font = Enum.Font.SourceSansBold
        nameL.TextSize = 14
        nameL.TextXAlignment = Enum.TextXAlignment.Left
        nameL.ZIndex = 8
        nameL.Parent = card

        local descL = Instance.new("TextLabel")
        descL.Size = UDim2.new(1, -10, 0, 16)
        descL.Position = UDim2.new(0, 5, 0, 28)
        descL.BackgroundTransparency = 1
        descL.Text = cheat.Desc
        descL.TextColor3 = Color3.fromRGB(150, 110, 115)
        descL.Font = Enum.Font.SourceSans
        descL.TextSize = 12
        descL.TextXAlignment = Enum.TextXAlignment.Left
        descL.ZIndex = 8
        descL.Parent = card

        if cheat.Toggle then
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 10, 0, 10)
            indicator.Position = UDim2.new(1, -18, 0, 8)
            indicator.BackgroundColor3 = C.Red
            indicator.ZIndex = 9
            indicator.Parent = card
            createCorner(indicator, 5)

            card.MouseButton1Click:Connect(function()
                cheat.Callback()
                task.wait(0.1)
                indicator.BackgroundColor3 = cheat.State() and C.Green or C.Red
                card.BackgroundColor3 = cheat.State() and Color3.fromRGB(215, 240, 215) or Color3.fromRGB(235, 222, 224)
            end)
        else
            card.MouseButton1Click:Connect(function()
                cheat.Callback()
                -- Flash effect
                local orig = card.BackgroundColor3
                card.BackgroundColor3 = Color3.fromRGB(200, 240, 200)
                task.delay(0.3, function() card.BackgroundColor3 = orig end)
            end)
        end
    end

    local rows = math.ceil(#cheatsList / 2)
    cheatsScroll.CanvasSize = UDim2.new(0, 0, 0, rows * 66 + 20)

    -- ============ TELEPORT INPUT (in cheats) ============
    local tpFrame = Instance.new("Frame")
    tpFrame.Size = UDim2.new(1, 0, 0, 35)
    tpFrame.Position = UDim2.new(0, 0, 0, rows * 66 + 10)
    tpFrame.BackgroundColor3 = Color3.fromRGB(230, 218, 220)
    tpFrame.BorderSizePixel = 0
    tpFrame.ZIndex = 7
    tpFrame.LayoutOrder = 999
    tpFrame.Parent = cheatsScroll
    createCorner(tpFrame, 5)

    local tpBox = Instance.new("TextBox")
    tpBox.Size = UDim2.new(0.65, -5, 0, 26)
    tpBox.Position = UDim2.new(0, 5, 0, 4)
    tpBox.BackgroundColor3 = Color3.fromRGB(255, 245, 248)
    tpBox.Text = ""
    tpBox.PlaceholderText = "Player name for TP..."
    tpBox.PlaceholderColor3 = Color3.fromRGB(160, 130, 135)
    tpBox.TextColor3 = Color3.fromRGB(60, 20, 25)
    tpBox.Font = Enum.Font.SourceSans
    tpBox.TextSize = 13
    tpBox.ZIndex = 8
    tpBox.Parent = tpFrame
    createCorner(tpBox, 3)

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0.33, 0, 0, 26)
    tpBtn.Position = UDim2.new(0.66, 0, 0, 4)
    tpBtn.BackgroundColor3 = C.LightRed
    tpBtn.Text = "Teleport"
    tpBtn.TextColor3 = C.White
    tpBtn.Font = Enum.Font.SourceSansBold
    tpBtn.TextSize = 13
    tpBtn.ZIndex = 8
    tpBtn.Parent = tpFrame
    createCorner(tpBtn, 3)

    tpBtn.MouseButton1Click:Connect(function()
        teleportToPlayer(tpBox.Text)
    end)

    -- ============ BOTTOM BAR ============
    local bottomBar = Instance.new("Frame")
    bottomBar.Size = UDim2.new(1, -66, 0, 32)
    bottomBar.Position = UDim2.new(0, 8, 1, -38)
    bottomBar.BackgroundColor3 = C.BottomBar
    bottomBar.BorderSizePixel = 0
    bottomBar.ZIndex = 5
    bottomBar.Parent = Main
    createStroke(bottomBar, Color3.fromRGB(60, 20, 25), 1)

    local function makeBottomBtn(text, xOff, width, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, width, 1, -6)
        b.Position = UDim2.new(0, xOff, 0, 3)
        b.BackgroundColor3 = C.BtnRed
        b.BorderSizePixel = 0
        b.Text = text
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        b.TextColor3 = Color3.fromRGB(65, 22, 25)
        b.ZIndex = 6
        b.Parent = bottomBar
        createCorner(b, 3)
        b.MouseButton1Click:Connect(callback)
    end

    local barW = (Main.Size.X.Offset - 66 - 16 - 20) -- total usable
    local btnW = math.floor(barW / 5)

    makeBottomBtn("Execute", 3, btnW, function()
        if currentPage == "Editor" then
            local code = codeBox.Text
            local fn, err = loadstring(code)
            if fn then
                local ok, e = pcall(fn)
                if ok then
                    notify("EXECUTED", "Код выполнен успешно!", 2, C.Green)
                else
                    notify("RUNTIME ERROR", tostring(e), 4, C.Red)
                end
            else
                notify("SYNTAX ERROR", tostring(err), 4, C.Red)
            end
        end
    end)

    makeBottomBtn("Clear", btnW + 6, btnW, function()
        codeBox.Text = ""
        lineNums.Text = " 1"
    end)

    makeBottomBtn("Copy", btnW*2 + 9, btnW, function()
        if setclipboard then
            setclipboard(codeBox.Text)
            notify("COPIED", "Код скопирован!", 2, C.Green)
        else
            notify("ERROR", "setclipboard не поддерживается", 2, C.Red)
        end
    end)

    makeBottomBtn("Paste", btnW*3 + 12, btnW, function()
        -- Paste не работает без getclipboard
        notify("INFO", "Используйте Ctrl+V в редакторе", 2, C.Yellow)
    end)

    makeBottomBtn("Save", btnW*4 + 15, btnW, function()
        if writefile then
            writefile("RC7_saved_script.lua", codeBox.Text)
            notify("SAVED", "Сохранено в RC7_saved_script.lua", 2, C.Green)
        else
            notify("ERROR", "writefile не поддерживается", 2, C.Red)
        end
    end)

    -- Sidebar icons
    addSideIcons(sidebar, {
        {Text = "📝", Callback = function() switchPage("Editor") end},
        {Text = "🔍", Callback = function() switchPage("Scanner") end},
        {Text = "📜", Callback = function() switchPage("Hub") end},
        {Text = "🎮", Callback = function() switchPage("Cheats") end},
        {Text = "🔄", Callback = function()
            switchPage("Scanner")
            task.spawn(function() runScan("FULL") end)
        end},
    })

    -- Keybind hint
    notify("RC7 LOADED", "Интерфейс загружен! Используйте вкладки для навигации.", 4, C.LightRed)
end

-- ============ LOGIN HANDLER ============
submitBtn.MouseButton1Click:Connect(function()
    submitBtn.Text = "Loading..."
    submitBtn.BackgroundColor3 = Color3.fromRGB(140, 80, 85)

    -- Fake loading animation
    task.spawn(function()
        for i = 1, 3 do
            submitBtn.Text = "Loading" .. string.rep(".", i)
            task.wait(0.3)
        end

        TweenService:Create(LoginFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0.5, -200, -0.5, 0),
            BackgroundTransparency = 0.5
        }):Play()

        task.wait(0.5)
        LoginFrame:Destroy()
        OpenMainWindow()
    end)
end)

print("[RC7] Loaded successfully — v2.1")
