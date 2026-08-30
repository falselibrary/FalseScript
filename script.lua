-- [[
-- Script: KIT HUB
-- Developer: falseempty & Sakura Hub
-- Tiktok: Catnap Crush
-- ]]
if getgenv().__KIT_HUB_LOADED then
    warn("[KIT Hub] Already running. Destroying old instance.")
    if getgenv().__KIT_HUB_CLEANUP then getgenv().__KIT_HUB_CLEANUP() end
end
getgenv().__KIT_HUB_LOADED = true

local NeverLose = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau"))()
local Notification = NeverLose:CreateNotification()
local Logging = NeverLose:CreateLogger()
local Indicator = NeverLose:CreateIndicator()

local Svc = {
    Players = game:GetService("Players"),
    WS = game:GetService("Workspace"),
    RS = game:GetService("RunService"),
    RPS = game:GetService("ReplicatedStorage"),
    TS = game:GetService("TweenService"),
    Lighting = game:GetService("Lighting"),
    UIS = game:GetService("UserInputService"),
    SS = game:GetService("SoundService"),
    TCS = game:GetService("TextChatService"),
    Http = game:GetService("HttpService"),
    TP = game:GetService("TeleportService"),
    MaterialService = game:GetService("MaterialService"),
    ContentProvider = game:GetService("ContentProvider"),
}

local Players = Svc.Players
local WS = Svc.WS
local RS = Svc.RS
local RPS = Svc.RPS
local TS = Svc.TS
local Lighting = Svc.Lighting
local UIS = Svc.UIS
local SS = Svc.SS
local TCS = Svc.TCS
local HttpService = Svc.Http
local TeleportService = Svc.TP
local MaterialService = Svc.MaterialService
local ContentProvider = Svc.ContentProvider
local Terrain = WS.Terrain
local LP = Players.LocalPlayer
local Camera = WS.CurrentCamera

local Audio = {
    Gunshots = {
        ["RPGS Candy"] = "rbxassetid://83995181532586",
        ["MineHit"] = "rbxassetid://111481862692779",
        ["RPGE Beary"] = "rbxassetid://112424028680133",
        ["DB Bloss"] = "rbxassetid://97681259004692",
        ["Rev Blossom"] = "rbxassetid://118868788824782",
        ["Kawaii DG"] = "rbxassetid://135458839245691",
        ["Hit Basic 3"] = "rbxassetid://90160800327080"
    },
    KnifeKills = {
        ["Golden Knife Kill"] = "rbxassetid://6066375795",
        ["S3 Coin Hit"] = "rbxassetid://139857881082762",
        ["Custom Hit 1"] = "rbxassetid://138592514473573",
        ["Among Us"] = "rbxassetid://130456049552264",
        ["Jeff Laugh"] = "rbxassetid://140445930084397",
        ["Pelmeni"] = "rbxassetid://130226230760992",
        ["Horror Kill"] = "rbxassetid://128741351184513",
        ["Jeff Stab"] = "rbxassetid://81483362340487"
    }
}

local ColorPresets = {
    ["Cyan"] = Color3.fromRGB(0, 255, 255),
    ["Red"] = Color3.fromRGB(255, 30, 70),
    ["Green"] = Color3.fromRGB(0, 255, 120),
    ["Blue"] = Color3.fromRGB(30, 120, 255),
    ["Purple"] = Color3.fromRGB(180, 50, 255),
    ["Yellow"] = Color3.fromRGB(255, 220, 0),
    ["White"] = Color3.fromRGB(255, 255, 255),
    ["Pink"] = Color3.fromRGB(255, 105, 180)
}
local ColorKeys = {"Cyan", "Red", "Green", "Blue", "Purple", "Yellow", "White", "Pink"}

local GunshotKeys = {}
for k in pairs(Audio.Gunshots) do table.insert(GunshotKeys, k) end
local KnifeKillKeys = {}
for k in pairs(Audio.KnifeKills) do table.insert(KnifeKillKeys, k) end

local S = {
    SheriffLock = false, LockSmoothness = 0.25, LockTargetPart = "HumanoidRootPart",
    ForceShiftLock = true, KnifeAimbot = false, AutoGrabGun = false,
    KillAura = false, KillAuraDist = 15, KillAllLoop = false,
    AntiStab = false, AntiStabDist = 20, TrapImmunity = false,
    AimbotEnabled = false, SilentAim = false, Wallbang = false,
    ShowFOV = false, SilentAimFOV = 150, AntiWater = true,
    HitboxEnabled = false, HitboxSize = 5, HitboxPart = "Head",
    ShotTrajectory = false, AutoRejoin = true, TradeValueChecker = true,
    RoleOdds = false, AutoUnbox = false, AutoUnboxCrate = "Mystery Box 1",
    SmartStopGodly = true, CustomGunSounds = true, SelectedGunshot = "RPGS Candy",
    CustomKnifeSounds = true, SelectedKnifeKill = "Golden Knife Kill",
    MurderWarning = true, SheriffDeathAlert = true, RoleAlerts = true,
    AnnounceRoles = false, AutoFarmCoins = false, FarmSpeed = 22,
    SakuraAutoFarm = false, SakuraFarmSpeed = 22, SakuraSafeHeight = 14,
    AutoPickupGun = false, ESP = false, Boxes = false, Tracers = false,
    TracerOrigin = "Bottom", Names = false, Distances = false,
    HeldWeapon = false, Chams = false, ChamsTrans = 0.4, RainbowChams = false,
    GunESP = false, TrapESP = false, CoinESP = false, Crosshair = false,
    CrosshairColor = Color3.fromRGB(0, 255, 200), CrosshairSize = 10,
    XRay = false, XRayTrans = 0.6, Radar = false, RadarSize = 140, RadarZoom = 1.5,
    Spectating = "None", Fullbright = false, ShaderPreset = "None",
    CustomSkybox = "Default", TimeOfDay = 14, CustomFOV = 90,
    RemoveFog = false, ShadersEnabled = false, ShaderMode = "Bloom",
    SpeedHack = false, WalkSpeedVal = 16, JumpPowerHack = false,
    JumpPowerVal = 50, AirSpeedGlitch = false, AirSpeedBoost = 2.5,
    InfiniteJump = false, Noclip = false, Fly = false, FlySpeed = 50,
    AntiFling = false, SafePlatform = false, SpinBot = false,
    SpinSpeed = 40, BHop = false, WalkFling = false, FakeLag = false,
    FakeLagLimit = 15, SpeedGlitch = false, AutoGG = false,
    AutoGGMode = "Toxic", AutoToxic = false, DisableParticles = false,
    LowGraphics = false, AntiAFK = false, GhostMode = false,
    AutoDodge = false, AutoDodgeDist = 18, SmartAutoPlay = false,
    InstantKill = false, SilentKnife = false, TargetLock = false,
    TargetLockPlayer = "None", AutoCollectGun = false, PlayerTracker = false,
    CoinMagnet = false, CoinMagnetRange = 50,
    ChinaHatEnabled = false, ChinaHatStyle = "Classic", ChinaHatRainbow = false,
    ChinaHatRadius = 2.4, ChinaHatHeight = 1.6, ChinaHatRainbowSpeed = 5,
    ChinaHatTransparency = 0.3, ChinaHatColor = Color3.fromRGB(0, 255, 255),
    ChinaHatReflectance = 0, ChinaHatSides = 25,
    ClassicAuraEnabled = false, SelectedClassicAuras = {},
    ParticleAuraEnabled = false, SelectedParticleAuras = {},
    ParticleAuraColor = Color3.fromRGB(133, 220, 255), DanceAura = false,
    AngelRing = false, JumpRipple = false, LayeredCape = false,
    PinkGlass = false, TrailEffect = false, PlayerModelEnabled = false,
    PlayerModelId = "", TrollTarget = "None", TrollMode = "Off",
    MobileMenuEnabled = false, AutoShoot = false, AutoShootMode = "Smart",
    BodyTrailEnabled = false, BodyTrailGradient = false, BodyTrailLifetime = 0.5,
    BodyTrailTransparency = 0, BodyTrailRainbow = false,
    BodyTrailColor = Color3.fromRGB(0, 255, 255),
    BodyTrailGrad1 = Color3.fromRGB(0, 86, 255), BodyTrailGrad2 = Color3.fromRGB(255, 0, 0),
    AuraTrailerEnabled = false, AuraTrailerColor = Color3.fromRGB(255, 0, 0), AuraTrailerLife = 0.5,
    ForceFieldEnabled = false, ForceFieldColor = Color3.fromRGB(128, 128, 128), ForceFieldRainbow = false,
    ScreenEffect = false, ScreenIntensity = 0,
    SkyboxEnabled = false, SkyboxName = "HD",
    AtmosphereEnabled = false, AtmDensity = 0.35, AtmOffset = 0, AtmHaze = 1, AtmGlare = 10,
    AtmColor = Color3.fromRGB(199, 212, 255), AtmDecay = Color3.fromRGB(106, 112, 125),
    MinecraftTextures = false, NebulaEnabled = false, NebulaColor = Color3.fromRGB(173, 216, 230),
    TimeChanger = false, TimeValue = 12, WorldFullBright = false,
    HeadDot = false, HeadDotSize = 0.4, HeadDotColor = Color3.fromRGB(255, 50, 100),
    OutlineESP = false, HealthBar = false, SkeletonESP = false,
    ThirdPerson = false, ThirdPersonDist = 8, AutoEmote = false,
    SelectedEmote = "Dab", NoClipSpectate = false, InstantRespawn = false,
    AutoEquipKnife = false, AutoEquipGun = false, FOVChanger = true,
    AmbientColor = Color3.fromRGB(255, 255, 255), CustomAmbient = false,
    Desync = false, DesyncAmount = 5, OrbitPlayers = false, OrbitSpeed = 3, OrbitRadius = 5,
    ChatSpam = false, ChatSpamMsg = "KIT HUB ON TOP", ChatSpamDelay = 3,
    Invisible = false, GodModeVisual = false, Wireframe = false,
    RainbowBody = false, BodyGlow = false, BodyGlowColor = Color3.fromRGB(0, 255, 255),
    Footprints = false, FootprintColor = Color3.fromRGB(255, 105, 180),
    BeamESP = false, BeamColor = Color3.fromRGB(0, 255, 200),
    NameTags3D = false, HitSounds = false, HitSoundId = "rbxassetid://6066375795",
    KillEffect = false, KillEffectType = "Explosion",
    CameraShake = false, CameraShakeIntensity = 0.5,
    ZoomHack = false, ZoomAmount = 0.5, FreeCam = false, FreeCamSpeed = 2,
    WeatherRain = false, WeatherSnow = false, LightningFlash = false,
    DayNightCycle = false, DayNightSpeed = 0.1,
    LowGravity = false, GravityValue = 50, SuperJump = false,
    ClickTP = false, ClickTPKey = Enum.KeyCode.T,
    SwimAnywhere = false, WalkOnWater = false,
    AntiVoid = false, VoidTPHeight = -50,
    SpectateNext = false, LockFirstPerson = false,
    HideNames = false, HideOwnBody = false,
    ParticleTrail = false, ParticleTrailColor = Color3.fromRGB(255, 182, 193),
    CrownHat = false, WingsEffect = false, HaloEffect = false,
    BubbleChat = false, CustomWalkAnim = false,
    SpamEmote = false, EmoteSpeed = 1,
    AutoReload = false, RapidFire = false,
    BulletTracers = false, BulletTracerColor = Color3.fromRGB(255, 255, 0),
    DamageNumbers = false, KillFeed = true,
    ServerHop = false, RejoinSame = false,
    CopyPos = false, SavePos = false, SavedCFrame = nil,
    FPSBoost = false, RemoveTextures = false,
    MuteMusic = false, MuteAllSounds = false,
    NightVision = false, ThermalVision = false,
    WallhackParts = false, HighlightItems = false,
    AutoSprint = false, CrouchSpam = false,
    Backflip = false, Frontflip = false,
    SitWalk = false, Seizure = false,
    Vibrate = false, VibrateIntensity = 5,
    AntiAFKAdvanced = false, AntiKick = false,
    PrintRoles = false, LogKills = false,
    CustomCrosshairStyle = "Cross",
    AspectRatio = false, AspectRatioValue = 1.5,
    MotionBlur = false, MotionBlurSize = 8,
    ChromaticAberration = false, Vignette = false,
    FilmGrain = false, DepthOfField = false,
    ColorGrading = false, ColorGradePreset = "None"
}

local ItemValues = {
    ["Chroma Swirly Gun"] = 12000, ["Chroma Candleflame"] = 3500, ["Chroma Lightbringer"] = 300,
    ["Chroma Darkbringer"] = 310, ["Chroma Luger"] = 220, ["Chroma Laser"] = 180,
    ["Chroma Shark"] = 160, ["Chroma Slasher"] = 130, ["Chroma Heat"] = 140,
    ["Chroma Fang"] = 150, ["Chroma Deathshard"] = 110, ["Chroma Tides"] = 120,
    ["Chroma Saw"] = 80, ["Chroma Seer"] = 70, ["Chroma Gingerblade"] = 90,
    ["Chroma Boneblade"] = 75, ["Chroma Gemstone"] = 280, ["Swirly Axe"] = 3200,
    ["Harvester"] = 4500, ["Icebreaker"] = 160, ["Icewing"] = 2, ["Logchopper"] = 90,
    ["Batwing"] = 65, ["Hallowscythe"] = 80, ["Elderwood Scythe"] = 145,
    ["Candleflame"] = 1600, ["Dark Shot"] = 5000, ["Dark Sword"] = 4800,
    ["Luger"] = 85, ["Laser"] = 70, ["Shark"] = 65, ["Slasher"] = 45, ["Heat"] = 50,
    ["Fang"] = 40, ["Deathshard"] = 35, ["Tides"] = 45, ["Saw"] = 20, ["Seer"] = 10,
    ["Gingerblade"] = 25, ["Boneblade"] = 15, ["Gemstone"] = 30, ["Lightbringer"] = 95,
    ["Darkbringer"] = 100, ["Heartblade"] = 75, ["Icebeam"] = 40, ["Iceblaster"] = 110,
    ["Corrupt"] = 3800, ["Elderwood Revolver"] = 145, ["Hallows Blade"] = 80,
    ["Hallows Edge"] = 85, ["Peppermint"] = 30, ["Amerilaser"] = 70, ["Old Glory"] = 65,
    ["Minty"] = 15, ["Chill"] = 20, ["Eternal"] = 85, ["Eternal II"] = 75,
    ["Eternal III"] = 65, ["Eternal IV"] = 55, ["Eternalcane"] = 50,
    ["Cookieblade"] = 45, ["JD"] = 500, ["Sugar"] = 300, ["Handsaw"] = 55,
    ["Spider"] = 30, ["Ghostblade"] = 100, ["Battle Axe"] = 60, ["Battle Axe II"] = 50,
    ["Bioblade"] = 25, ["Elderwood"] = 145, ["Ice Dragon"] = 40, ["Flames"] = 15,
    ["Virtual"] = 20, ["Pixel"] = 10, ["Xmas"] = 18, ["Phaser"] = 25,
    ["Green Luger"] = 200, ["Red Luger"] = 180, ["Jack"] = 30, ["Cane Set"] = 35, ["Log Set"] = 50
}

local EmoteIDs = {
    Ninja = "rbxassetid://656117400", Dab = "rbxassetid://248263260",
    Floss = "rbxassetid://5915773155", Zen = "rbxassetid://6092882527",
    Zombie = "rbxassetid://183294396", Sit = "rbxassetid://179224234",
    Wave = "rbxassetid://507770239", Laugh = "rbxassetid://507770818",
    Point = "rbxassetid://507770453", Dance1 = "rbxassetid://507771019",
    Dance2 = "rbxassetid://507776043", Dance3 = "rbxassetid://507777268"
}

local State = {
    Roles = {}, Murder = nil, Sheriff = nil, Hero = nil,
    lastAnnouncedMurder = nil, AnnouncedRound = false,
    Drawings = {}, RadarDots = {}, SafePlatformPart = nil,
    FlyBV = nil, FlyBG = nil, lastShootTick = 0, lastKillTick = 0,
    isFarming = false, frameCount = 0, hitboxCache = {},
    roundKills = {}, playerDeathPositions = {}, panicActive = false,
    hookedSounds = {}, xrayCache = {}, alertQueue = {},
    trailParts = {}, trailFolders = {}, angelRingParts = {},
    trollingThread = nil, currentTrollingTween = nil, trollingActive = false,
    TradeGuiLabel = nil, DanceAnimationTrack = nil,
    loadedParticleAuras = {}, activeParticleAuras = {}, activeClassicAuras = {},
    zonasDeAguaActivas = {}, bodyTrailParts = {}, bodyTrailConn = nil,
    forceFieldOriginal = {}, forceFieldConn = nil, screenConn = nil,
    hatDrawings = {}, hatParts = {}, hatConn = nil,
    auraTrailerActive = false, footprintParts = {}, beamDrawings = {},
    skeletonDrawings = {}, healthBarDrawings = {}, headDotParts = {},
    particleTrailEmitters = {}, freeCamConn = nil, freeCamPos = nil,
    weatherParts = {}, glowLights = {}, orbitAngle = 0,
    chatSpamThread = nil, savedPositions = {}, footprintIndex = 0,
    killEffectParts = {}, bulletTracerParts = {}, desyncConn = nil,
    originalGravity = WS.Gravity, originalAmbient = Lighting.Ambient,
    originalOutdoorAmbient = Lighting.OutdoorAmbient,
    LarpticAtmosphere = nil, textureState = setmetatable({}, {__mode = "k"}),
    materialVariantsBuilt = false, defaultSkySettings = {},
    defaultLighting = {}, crownPart = nil, wingParts = {}, haloParts = {},
    thirdPersonConn = nil, nameTagBillboards = {},
    weatherConn = nil, dayNightConn = nil, vibrateConn = nil,
    seizureConn = nil, rainbowBodyConn = nil, particleTrailConn = nil,
    aspectRatioConn = nil, motionBlurFx = nil, chromaticFx = nil,
    vignetteGui = nil, filmGrainGui = nil, dofFx = nil, colorGradeFx = nil
}

local Drawings = State.Drawings
local RadarDots = State.RadarDots

local Cache = {
    ChinaHatParts = {}, ChinaHatConnection = nil, ChinaHatDrawings = {}, KillAllRemote = nil
}

local DefLight = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    FogStart = Lighting.FogStart, FogColor = Lighting.FogColor
}

State.defaultLighting = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows, OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient, FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd, FogColor = Lighting.FogColor
}

do
    local ds = Lighting:FindFirstChildOfClass("Sky")
    if ds then
        State.defaultSkySettings = {
            SkyboxBk = ds.SkyboxBk, SkyboxDn = ds.SkyboxDn, SkyboxFt = ds.SkyboxFt,
            SkyboxLf = ds.SkyboxLf, SkyboxRt = ds.SkyboxRt, SkyboxUp = ds.SkyboxUp
        }
    end
end

local SFX = {}

local function GetOrCreate(parent, class, name)
    local obj = parent:FindFirstChild(name)
    if not obj then obj = Instance.new(class, parent) obj.Name = name end
    return obj
end

local PE = {
    CC = GetOrCreate(Lighting, "ColorCorrectionEffect", "HubCC"),
    Bloom = GetOrCreate(Lighting, "BloomEffect", "HubBloom"),
    SR = GetOrCreate(Lighting, "SunRaysEffect", "HubSR"),
    Atmo = GetOrCreate(Lighting, "Atmosphere", "HubAtmo"),
}

local Connections = {}
local function AddConnection(conn)
    table.insert(Connections, conn)
    return conn
end

local AuraModels = {
    "Godly", "Super Sayien", "North Star", "Blue Lord",
    "Pink Aura", "Angel Wing", "Sweet Heart", "Ethereal Aura"
}
local AuraModelIDs = {
    ["Godly"] = "rbxassetid://16699750981",
    ["Super Sayien"] = "rbxassetid://116109508364297",
    ["North Star"] = "rbxassetid://83945069652732",
    ["Blue Lord"] = "rbxassetid://10974316799",
    ["Pink Aura"] = "rbxassetid://115980859615239",
    ["Angel Wing"] = "rbxassetid://90022969696073",
    ["Sweet Heart"] = "rbxassetid://91724768175470",
    ["Ethereal Aura"] = "rbxassetid://97041568674250",
}

local PARTICLE_AURA_DATA = {
    {"starlight", "rbxassetid://134645216613107"},
    {"heavenly", "rbxassetid://139300897520961"},
    {"ribbon", "rbxassetid://132069507632161"},
    {"sakura", "rbxassetid://81755778619404"},
    {"angel", "rbxassetid://97658130917593"},
    {"wind", "rbxassetid://80694081850877"},
    {"flow", "rbxassetid://119913533725648"},
    {"star", "rbxassetid://73754563740680"},
    {"neon", "rbxassetid://18498709246"},
}
local PARTICLE_AURA_NAMES = {}
local particleAuraIdByName = {}
for _, row in ipairs(PARTICLE_AURA_DATA) do
    table.insert(PARTICLE_AURA_NAMES, row[1])
    particleAuraIdByName[row[1]] = row[2]
end

local MINECRAFT_VARIANTS = {
    Brick = {BaseMaterial = Enum.Material.Brick, Texture = "rbxassetid://10777285622"},
    Concrete = {BaseMaterial = Enum.Material.Concrete, Texture = "rbxassetid://15622710576"},
    CorrodedMetal = {BaseMaterial = Enum.Material.CorrodedMetal, Texture = "rbxassetid://78612695839404"},
    Grass = {BaseMaterial = Enum.Material.Grass, Texture = "rbxassetid://9267183930"},
    Metal = {BaseMaterial = Enum.Material.Metal, Texture = "rbxassetid://121650613091353"},
    Sand = {BaseMaterial = Enum.Material.Sand, Texture = "rbxassetid://12624140843"},
    Slate = {BaseMaterial = Enum.Material.Slate, Texture = "rbxassetid://8676746437"},
    Wood = {BaseMaterial = Enum.Material.Wood, Texture = "rbxassetid://3258599312"},
    WoodPlanks = {BaseMaterial = Enum.Material.WoodPlanks, Texture = "rbxassetid://8676581022"},
}

local MATERIAL_VARIANT_BY_MATERIAL = {
    [Enum.Material.Brick] = "Brick",
    [Enum.Material.Concrete] = "Concrete",
    [Enum.Material.CorrodedMetal] = "CorrodedMetal",
    [Enum.Material.Grass] = "Grass",
    [Enum.Material.Metal] = "Metal",
    [Enum.Material.Sand] = "Sand",
    [Enum.Material.Slate] = "Slate",
    [Enum.Material.Wood] = "Wood",
    [Enum.Material.WoodPlanks] = "WoodPlanks",
}

local MINECRAFT_TERRAIN_COLORS = {
    [Enum.Material.Grass] = Color3.fromRGB(106, 170, 64),
    [Enum.Material.Ground] = Color3.fromRGB(134, 96, 67),
    [Enum.Material.Mud] = Color3.fromRGB(102, 76, 51),
    [Enum.Material.Sand] = Color3.fromRGB(219, 211, 160),
    [Enum.Material.Rock] = Color3.fromRGB(122, 122, 122),
    [Enum.Material.Slate] = Color3.fromRGB(90, 90, 90),
    [Enum.Material.Snow] = Color3.fromRGB(245, 245, 245),
    [Enum.Material.Water] = Color3.fromRGB(63, 118, 228),
}

local SkyboxAssets = {
    ["Black Storm"] = {Bk="rbxassetid://15502511288",Dn="rbxassetid://15502508460",Ft="rbxassetid://15502510289",Lf="rbxassetid://15502507918",Rt="rbxassetid://15502509398",Up="rbxassetid://15502511911"},
    ["HD"] = {Bk="http://www.roblox.com/asset/?id=16553658937",Dn="http://www.roblox.com/asset/?id=16553660713",Ft="http://www.roblox.com/asset/?id=16553662144",Lf="http://www.roblox.com/asset/?id=16553664042",Rt="http://www.roblox.com/asset/?id=16553665766",Up="http://www.roblox.com/asset/?id=16553667750"},
    ["Snow"] = {Bk="http://www.roblox.com/asset/?id=155657655",Dn="http://www.roblox.com/asset/?id=155674246",Ft="http://www.roblox.com/asset/?id=155657609",Lf="http://www.roblox.com/asset/?id=155657671",Rt="http://www.roblox.com/asset/?id=155657619",Up="http://www.roblox.com/asset/?id=155674931"},
    ["Blue Space"] = {Bk="rbxassetid://15536110634",Dn="rbxassetid://15536112543",Ft="rbxassetid://15536116141",Lf="rbxassetid://15536114370",Rt="rbxassetid://15536118762",Up="rbxassetid://15536117282"},
    ["Realistic"] = {Bk="rbxassetid://653719502",Dn="rbxassetid://653718790",Ft="rbxassetid://653719067",Lf="rbxassetid://653719190",Rt="rbxassetid://653718931",Up="rbxassetid://653719321"},
    ["Stormy"] = {Bk="http://www.roblox.com/asset/?id=18703245834",Dn="http://www.roblox.com/asset/?id=18703243349",Ft="http://www.roblox.com/asset/?id=18703240532",Lf="http://www.roblox.com/asset/?id=18703237556",Rt="http://www.roblox.com/asset/?id=18703235430",Up="http://www.roblox.com/asset/?id=18703232671"},
    ["Pink"] = {Bk="rbxassetid://12216109205",Dn="rbxassetid://12216109875",Ft="rbxassetid://12216109489",Lf="rbxassetid://12216110170",Rt="rbxassetid://12216110471",Up="rbxassetid://12216108877"},
    ["Sunset"] = {Bk="rbxassetid://600830446",Dn="rbxassetid://600831635",Ft="rbxassetid://600832720",Lf="rbxassetid://600886090",Rt="rbxassetid://600833862",Up="rbxassetid://600835177"},
    ["Arctic"] = {Bk="http://www.roblox.com/asset/?id=225469390",Dn="http://www.roblox.com/asset/?id=225469395",Ft="http://www.roblox.com/asset/?id=225469403",Lf="http://www.roblox.com/asset/?id=225469450",Rt="http://www.roblox.com/asset/?id=225469471",Up="http://www.roblox.com/asset/?id=225469481"},
    ["Space"] = {Bk="http://www.roblox.com/asset/?id=166509999",Dn="http://www.roblox.com/asset/?id=166510057",Ft="http://www.roblox.com/asset/?id=166510116",Lf="http://www.roblox.com/asset/?id=166510092",Rt="http://www.roblox.com/asset/?id=166510131",Up="http://www.roblox.com/asset/?id=166510114"},
    ["Roblox Default"] = {Bk="rbxasset://textures/sky/sky512_bk.tex",Dn="rbxasset://textures/sky/sky512_dn.tex",Ft="rbxasset://textures/sky/sky512_ft.tex",Lf="rbxasset://textures/sky/sky512_lf.tex",Rt="rbxasset://textures/sky/sky512_rt.tex",Up="rbxasset://textures/sky/sky512_up.tex"},
    ["Red Night"] = {Bk="http://www.roblox.com/asset/?id=401664839",Dn="http://www.roblox.com/asset/?id=401664862",Ft="http://www.roblox.com/asset/?id=401664960",Lf="http://www.roblox.com/asset/?id=401664881",Rt="http://www.roblox.com/asset/?id=401664901",Up="http://www.roblox.com/asset/?id=401664936"},
    ["Deep Space 1"] = {Bk="http://www.roblox.com/asset/?id=149397692",Dn="http://www.roblox.com/asset/?id=149397686",Ft="http://www.roblox.com/asset/?id=149397697",Lf="http://www.roblox.com/asset/?id=149397684",Rt="http://www.roblox.com/asset/?id=149397688",Up="http://www.roblox.com/asset/?id=149397702"},
    ["Pink Skies"] = {Bk="http://www.roblox.com/asset/?id=151165214",Dn="http://www.roblox.com/asset/?id=151165197",Ft="http://www.roblox.com/asset/?id=151165224",Lf="http://www.roblox.com/asset/?id=151165191",Rt="http://www.roblox.com/asset/?id=151165206",Up="http://www.roblox.com/asset/?id=151165227"},
    ["Purple Sunset"] = {Bk="rbxassetid://264908339",Dn="rbxassetid://264907909",Ft="rbxassetid://264909420",Lf="rbxassetid://264909758",Rt="rbxassetid://264908886",Up="rbxassetid://264907379"},
    ["Blue Night"] = {Bk="http://www.roblox.com/asset/?id=12064107",Dn="http://www.roblox.com/asset/?id=12064152",Ft="http://www.roblox.com/asset/?id=12064121",Lf="http://www.roblox.com/asset/?id=12063984",Rt="http://www.roblox.com/asset/?id=12064115",Up="http://www.roblox.com/asset/?id=12064131"},
    ["Blossom Daylight"] = {Bk="http://www.roblox.com/asset/?id=271042516",Dn="http://www.roblox.com/asset/?id=271077243",Ft="http://www.roblox.com/asset/?id=271042556",Lf="http://www.roblox.com/asset/?id=271042310",Rt="http://www.roblox.com/asset/?id=271042467",Up="http://www.roblox.com/asset/?id=271077958"},
    ["Blue Nebula"] = {Bk="http://www.roblox.com/asset?id=135207744",Dn="http://www.roblox.com/asset?id=135207662",Ft="http://www.roblox.com/asset?id=135207770",Lf="http://www.roblox.com/asset?id=135207615",Rt="http://www.roblox.com/asset?id=135207695",Up="http://www.roblox.com/asset?id=135207794"},
    ["Blue Planet"] = {Bk="rbxassetid://218955819",Dn="rbxassetid://218953419",Ft="rbxassetid://218954524",Lf="rbxassetid://218958493",Rt="rbxassetid://218957134",Up="rbxassetid://218950090"},
    ["Deep Space 2"] = {Bk="http://www.roblox.com/asset/?id=159248188",Dn="http://www.roblox.com/asset/?id=159248183",Ft="http://www.roblox.com/asset/?id=159248187",Lf="http://www.roblox.com/asset/?id=159248173",Rt="http://www.roblox.com/asset/?id=159248192",Up="http://www.roblox.com/asset/?id=159248176"},
    ["Summer"] = {Bk="rbxassetid://16648590964",Dn="rbxassetid://16648617436",Ft="rbxassetid://16648595424",Lf="rbxassetid://16648566370",Rt="rbxassetid://16648577071",Up="rbxassetid://16648598180"},
    ["Galaxy"] = {Bk="rbxassetid://15983968922",Dn="rbxassetid://15983966825",Ft="rbxassetid://15983965025",Lf="rbxassetid://15983967420",Rt="rbxassetid://15983966246",Up="rbxassetid://15983964246"},
    ["Stylized"] = {Bk="rbxassetid://18351376859",Dn="rbxassetid://18351374919",Ft="rbxassetid://18351376800",Lf="rbxassetid://18351376469",Rt="rbxassetid://18351376457",Up="rbxassetid://18351377189"},
    ["Minecraft"] = {Bk="rbxassetid://8735166756",Dn="http://www.roblox.com/asset/?id=8735166707",Ft="http://www.roblox.com/asset/?id=8735231668",Lf="http://www.roblox.com/asset/?id=8735166755",Rt="http://www.roblox.com/asset/?id=8735166751",Up="http://www.roblox.com/asset/?id=8735166729"},
    ["Cloudy Rain"] = {Bk="http://www.roblox.com/asset/?id=4498828382",Dn="http://www.roblox.com/asset/?id=4498828812",Ft="http://www.roblox.com/asset/?id=4498829917",Lf="http://www.roblox.com/asset/?id=4498830911",Rt="http://www.roblox.com/asset/?id=4498830417",Up="http://www.roblox.com/asset/?id=4498831746"},
    ["Black Cloudy Rain"] = {Bk="http://www.roblox.com/asset/?id=149679669",Dn="http://www.roblox.com/asset/?id=149681979",Ft="http://www.roblox.com/asset/?id=149679690",Lf="http://www.roblox.com/asset/?id=149679709",Rt="http://www.roblox.com/asset/?id=149679722",Up="http://www.roblox.com/asset/?id=149680199"},
    ["Purple Nebula"] = {Bk="rbxassetid://159454299",Dn="rbxassetid://159454296",Ft="rbxassetid://159454293",Lf="rbxassetid://159454286",Rt="rbxassetid://159454300",Up="rbxassetid://159454288"},
    ["Night Stars"] = {Bk="rbxassetid://12064107",Dn="rbxassetid://12064152",Ft="rbxassetid://12064121",Lf="rbxassetid://12064115",Rt="rbxassetid://12064127",Up="rbxassetid://12064147"},
}

local SkyboxList = {}
for k in pairs(SkyboxAssets) do table.insert(SkyboxList, k) end
table.sort(SkyboxList)

local DanceAnimInstance = Instance.new("Animation")
DanceAnimInstance.AnimationId = "rbxassetid://104539498095025"

local AlertGui = Instance.new("ScreenGui")
AlertGui.Name = "KitHub_Alerts"
AlertGui.ResetOnSpawn = false
AlertGui.Parent = game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")

local AlertLabel = Instance.new("TextLabel", AlertGui)
AlertLabel.Size = UDim2.new(0.6, 0, 0, 40)
AlertLabel.Position = UDim2.new(0.2, 0, 0.06, 0)
AlertLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
AlertLabel.BackgroundTransparency = 0.3
AlertLabel.Text = ""
AlertLabel.Font = Enum.Font.GothamBold
AlertLabel.TextSize = 20
AlertLabel.TextColor3 = Color3.fromRGB(255, 30, 70)
AlertLabel.TextStrokeTransparency = 0
AlertLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
AlertLabel.Visible = false
Instance.new("UICorner", AlertLabel).CornerRadius = UDim.new(0, 8)

local OddsLabel = Instance.new("TextLabel", AlertGui)
OddsLabel.Size = UDim2.new(0, 260, 0, 50)
OddsLabel.Position = UDim2.new(0.02, 0, 0.82, 0)
OddsLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OddsLabel.BackgroundTransparency = 0.35
OddsLabel.Text = ""
OddsLabel.Font = Enum.Font.GothamBold
OddsLabel.TextSize = 13
OddsLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
OddsLabel.TextWrapped = true
OddsLabel.Visible = false
Instance.new("UICorner", OddsLabel).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", OddsLabel).Color = Color3.fromRGB(0, 255, 200)

local TrackerLabel = Instance.new("TextLabel", AlertGui)
TrackerLabel.Size = UDim2.new(0, 260, 0, 200)
TrackerLabel.Position = UDim2.new(0.02, 0, 0.35, 0)
TrackerLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TrackerLabel.BackgroundTransparency = 0.35
TrackerLabel.Text = ""
TrackerLabel.Font = Enum.Font.GothamBold
TrackerLabel.TextSize = 12
TrackerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TrackerLabel.TextWrapped = true
TrackerLabel.TextYAlignment = Enum.TextYAlignment.Top
TrackerLabel.Visible = false
Instance.new("UICorner", TrackerLabel).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", TrackerLabel).Color = Color3.fromRGB(100, 100, 255)

local function ShowAlert(text, color, duration)
    AlertLabel.Text = text
    AlertLabel.TextColor3 = color or Color3.fromRGB(255, 30, 70)
    AlertLabel.Visible = true
    local id = tick()
    State.alertQueue[id] = true
    task.delay(duration or 3, function()
        if State.alertQueue[id] then
            State.alertQueue[id] = nil
            if not next(State.alertQueue) then AlertLabel.Visible = false end
        end
    end)
end

local function IsAlive(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil
end

local function GetHRP(plr)
    return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

local function GetHead(plr)
    return plr and plr.Character and plr.Character:FindFirstChild("Head")
end

local function GetHumanoid(plr)
    return plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
end

local function Dist(a, b)
    return (a - b).Magnitude
end

local function GetRole(plr)
    if not plr then return "Innocent" end
    if plr.Name == State.Murder then return "Murderer" end
    if plr.Name == State.Sheriff then return "Sheriff" end
    if plr.Name == State.Hero then return "Hero" end
    local char = plr.Character
    local bp = plr:FindFirstChild("Backpack")
    if char then
        if char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
        if char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
    end
    return "Innocent"
end

local RoleColors = {
    Murderer = Color3.fromRGB(255, 45, 85),
    Sheriff = Color3.fromRGB(0, 155, 255),
    Hero = Color3.fromRGB(255, 215, 0),
    Innocent = Color3.fromRGB(46, 204, 113)
}

local function GetRoleColor(plr)
    if S.RainbowChams then return Color3.fromHSV(tick() % 5 / 5, 1, 1) end
    return RoleColors[GetRole(plr)] or RoleColors.Innocent
end

local function SendChat(msg)
    task.spawn(function()
        pcall(function()
            if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
                local ch = TCS:FindFirstChild("TextChannels")
                if ch then
                    local gen = ch:FindFirstChild("RBXGeneral")
                    if gen then gen:SendAsync(msg) end
                end
            else
                local ev = RPS:FindFirstChild("DefaultChatSystemChatEvents")
                if ev and ev:FindFirstChild("SayMessageRequest") then
                    ev.SayMessageRequest:FireServer(msg, "All")
                end
            end
        end)
    end)
end

local function PlayPreviewSound(soundId)
    task.spawn(function()
        if not soundId or soundId == "" then return end
        local snd = Instance.new("Sound")
        snd.SoundId = soundId
        snd.Volume = 2
        snd.Parent = SS
        snd:Play()
        snd.Ended:Once(function() snd:Destroy() end)
        task.delay(3, function() if snd and snd.Parent then snd:Destroy() end end)
    end)
end

local function PlayEmote(name)
    if not IsAlive(LP) then return end
    local hum = GetHumanoid(LP)
    local id = EmoteIDs[name]
    if hum and id then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
        local anim = Instance.new("Animation")
        anim.AnimationId = id
        hum:LoadAnimation(anim):Play()
    end
end

-- MOBILE GUI
local mobileMenuGui = Instance.new("ScreenGui")
mobileMenuGui.Name = "SakuraMobileButtons"
mobileMenuGui.ResetOnSpawn = false
mobileMenuGui.Parent = game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 380)
mainFrame.Position = UDim2.new(0, 20, 0, 150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = mobileMenuGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mStroke = Instance.new("UIStroke", mainFrame)
mStroke.Color = Color3.fromRGB(255, 182, 193)
mStroke.Thickness = 2

do
    local dragging, dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame
local mbl = Instance.new("UIListLayout", scrollFrame)
mbl.HorizontalAlignment = Enum.HorizontalAlignment.Center
mbl.SortOrder = Enum.SortOrder.LayoutOrder
mbl.Padding = UDim.new(0, 8)
Instance.new("UIPadding", scrollFrame).PaddingTop = UDim.new(0, 10)

local function createMobileToggle(text, getState, setState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 155, 0, 35)
    btn.BackgroundColor3 = getState() and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(255, 105, 180)
    btn.BackgroundTransparency = 0.3
    btn.Text = text .. (getState() and ": ON" or ": OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = scrollFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        local newState = not getState()
        setState(newState)
        btn.BackgroundColor3 = newState and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(255, 105, 180)
        btn.Text = text .. (newState and ": ON" or ": OFF")
    end)
    return btn
end

createMobileToggle("Auto Farm", function() return S.SakuraAutoFarm end, function(v) S.SakuraAutoFarm = v end)
createMobileToggle("Kill All", function() return S.KillAllLoop end, function(v) S.KillAllLoop = v end)
createMobileToggle("Spinbot", function() return S.SpinBot end, function(v) S.SpinBot = v end)
createMobileToggle("Aimbot", function() return S.SheriffLock end, function(v) S.SheriffLock = v end)
createMobileToggle("Silent Aim", function() return S.SilentAim end, function(v) S.SilentAim = v end)
createMobileToggle("Wallbang", function() return S.Wallbang end, function(v) S.Wallbang = v end)
createMobileToggle("Auto Pickup Gun", function() return S.AutoGrabGun end, function(v) S.AutoGrabGun = v end)
createMobileToggle("Speed Glitch", function() return S.SpeedGlitch end, function(v) S.SpeedGlitch = v end)
createMobileToggle("Anti-Fling", function() return S.AntiFling end, function(v) S.AntiFling = v end)
createMobileToggle("Visual ESP", function() return S.ESP end, function(v) S.ESP = v end)
createMobileToggle("ForceField", function() return S.ForceFieldEnabled end, function(v) S.ForceFieldEnabled = v end)
createMobileToggle("Body Trail", function() return S.BodyTrailEnabled end, function(v) S.BodyTrailEnabled = v end)
createMobileToggle("Fly", function() return S.Fly end, function(v) S.Fly = v end)
createMobileToggle("Noclip", function() return S.Noclip end, function(v) S.Noclip = v end)

-- DANCE AURA
local function StopDanceAura()
    if State.DanceAnimationTrack then
        pcall(function()
            State.DanceAnimationTrack:Stop()
            State.DanceAnimationTrack:Destroy()
        end)
        State.DanceAnimationTrack = nil
    end
end

local function ApplyDanceAura()
    if not S.DanceAura then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local animator = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5)
    if not animator then return end
    StopDanceAura()
    pcall(function()
        State.DanceAnimationTrack = animator:LoadAnimation(DanceAnimInstance)
        State.DanceAnimationTrack.Priority = Enum.AnimationPriority.Action4
        State.DanceAnimationTrack.Looped = true
        State.DanceAnimationTrack:Play()
        State.DanceAnimationTrack:AdjustSpeed(0.7)
    end)
end

local function ToggleDanceAura(val)
    S.DanceAura = val
    if val then ApplyDanceAura() else StopDanceAura() end
end

-- CLASSIC AURA
local function ClassicAura_LoadModel(id)
    local ok, result = pcall(function() return game:GetObjects(id)[1] end)
    return ok and result or nil
end

local function ClassicAura_DisableOne(auraName)
    if State.activeClassicAuras[auraName] then
        for _, v in pairs(State.activeClassicAuras[auraName]) do
            if v and v.Parent then pcall(function() v:Destroy() end) end
        end
        State.activeClassicAuras[auraName] = nil
    end
end

local function ClassicAura_EnableOne(char, auraName)
    if not char or not char.Parent then return end
    ClassicAura_DisableOne(auraName)
    local id = AuraModelIDs[auraName]
    if not id then return end
    local model = ClassicAura_LoadModel(id)
    if not model then return end
    local effects = {}
    for _, obj in pairs(model:GetDescendants()) do
        if not obj:IsA("BasePart") then
            pcall(function()
                local clone = obj:Clone()
                local target = char:FindFirstChild(obj.Parent and obj.Parent.Name)
                    or char:FindFirstChild("HumanoidRootPart")
                    or char:FindFirstChildWhichIsA("BasePart")
                if target then
                    clone.Parent = target
                    table.insert(effects, clone)
                end
            end)
        end
    end
    pcall(function() model:Destroy() end)
    if #effects > 0 then State.activeClassicAuras[auraName] = effects end
end

local function ClassicAura_RefreshAll()
    local char = LP.Character
    if not char then return end
    for _, n in ipairs(AuraModels) do ClassicAura_DisableOne(n) end
    if not S.ClassicAuraEnabled then return end
    for auraName, isSelected in pairs(S.SelectedClassicAuras) do
        if isSelected then
            task.spawn(function() ClassicAura_EnableOne(char, auraName) end)
        end
    end
end

-- PARTICLE AURA
local function mapCharacterParts(character)
    local parts = {}
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("BasePart") then parts[child.Name] = child end
    end
    return parts
end

local function getParticleAuraTemplate(name)
    if State.loadedParticleAuras[name] then return State.loadedParticleAuras[name] end
    local id = particleAuraIdByName[name]
    if not id then return nil end
    local ok, result = pcall(function() return game:GetObjects(id)[1] end)
    if ok and result then
        State.loadedParticleAuras[name] = result
        return result
    end
    return nil
end

local function tintParticleSubtree(root, color)
    if not color or not root then return end
    local seq = ColorSequence.new(color)
    local function tintOne(obj)
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                obj.Color = seq
            elseif obj:IsA("PointLight") then
                obj.Color = color
            end
        end)
    end
    tintOne(root)
    for _, d in ipairs(root:GetDescendants()) do tintOne(d) end
end

local function setParticleEmittersEnabled(root, enabled)
    if not root then return end
    pcall(function()
        if root:IsA("ParticleEmitter") then root.Enabled = enabled end
    end)
    for _, d in ipairs(root:GetDescendants()) do
        pcall(function()
            if d:IsA("ParticleEmitter") then d.Enabled = enabled end
        end)
    end
end

local function applyParticleAuraToCharacter(character, auraName, color)
    local auraObj = getParticleAuraTemplate(auraName)
    if not auraObj then return {} end
    local localParts = mapCharacterParts(character)
    local cloned = auraObj:Clone()
    local created = {}
    for _, part in ipairs(cloned:GetChildren()) do
        local targetPart = localParts[part.Name]
        if targetPart then
            for _, child in ipairs(part:GetChildren()) do
                pcall(function()
                    local inst = child:Clone()
                    inst.Name = "LarpticAuraParticle"
                    inst.Parent = targetPart
                    if color then tintParticleSubtree(inst, color) end
                    table.insert(created, inst)
                end)
            end
        end
    end
    pcall(function() cloned:Destroy() end)
    for _, p in ipairs(created) do setParticleEmittersEnabled(p, true) end
    return created
end

local function ParticleAura_DisableOne(auraName)
    if State.activeParticleAuras[auraName] then
        for _, p in ipairs(State.activeParticleAuras[auraName]) do
            if p then pcall(function() p:Destroy() end) end
        end
        State.activeParticleAuras[auraName] = nil
    end
end

local function ParticleAura_RefreshAll()
    local char = LP.Character
    if not char then return end
    for _, n in ipairs(PARTICLE_AURA_NAMES) do ParticleAura_DisableOne(n) end
    if not S.ParticleAuraEnabled then return end
    local col = S.ParticleAuraColor or Color3.fromRGB(133, 220, 255)
    for auraName, isSelected in pairs(S.SelectedParticleAuras) do
        if isSelected then
            task.spawn(function()
                State.activeParticleAuras[auraName] = applyParticleAuraToCharacter(char, auraName, col)
            end)
        end
    end
end

-- BODY TRAIL
local function Trail_RemoveFromCharacter(char)
    if State.bodyTrailParts[char] then
        pcall(function() State.bodyTrailParts[char]:Destroy() end)
        State.bodyTrailParts[char] = nil
    end
    if char and char:FindFirstChild("HumanoidRootPart") then
        local torso = char.HumanoidRootPart
        if torso:FindFirstChild("TrailAttach0") then torso.TrailAttach0:Destroy() end
        if torso:FindFirstChild("TrailAttach1") then torso.TrailAttach1:Destroy() end
    end
end

local function Trail_AddToCharacter(character)
    local torso = character:WaitForChild("HumanoidRootPart", 5)
    if not torso then return end
    Trail_RemoveFromCharacter(character)
    local a0 = Instance.new("Attachment")
    a0.Name = "TrailAttach0"
    a0.Position = Vector3.new(0, 2, 0)
    a0.Parent = torso
    local a1 = Instance.new("Attachment")
    a1.Name = "TrailAttach1"
    a1.Position = Vector3.new(0, -2, 0)
    a1.Parent = torso
    local trail = Instance.new("Trail")
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Lifetime = S.BodyTrailLifetime
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, S.BodyTrailTransparency),
        NumberSequenceKeypoint.new(1, 1)
    })
    if S.BodyTrailGradient then
        trail.Color = ColorSequence.new(S.BodyTrailGrad1, S.BodyTrailGrad2)
    else
        trail.Color = ColorSequence.new(S.BodyTrailColor)
    end
    trail.LightEmission = 0.2
    trail.Enabled = true
    trail.Parent = character
    State.bodyTrailParts[character] = trail
end

local function Trail_UpdateAll()
    for char, trail in pairs(State.bodyTrailParts) do
        if trail and trail.Parent and char == LP.Character then
            trail.Lifetime = S.BodyTrailLifetime
            trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, S.BodyTrailTransparency),
                NumberSequenceKeypoint.new(1, 1)
            })
            if S.BodyTrailGradient then
                trail.Color = ColorSequence.new(S.BodyTrailGrad1, S.BodyTrailGrad2)
            else
                if S.BodyTrailRainbow then
                    trail.Color = ColorSequence.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
                else
                    trail.Color = ColorSequence.new(S.BodyTrailColor)
                end
            end
        end
    end
end

local function Trail_ToggleEnabled(value)
    S.BodyTrailEnabled = value
    if value and LP.Character then
        Trail_AddToCharacter(LP.Character)
        if State.bodyTrailConn then State.bodyTrailConn:Disconnect() end
        State.bodyTrailConn = RS.Heartbeat:Connect(Trail_UpdateAll)
    else
        if LP.Character then Trail_RemoveFromCharacter(LP.Character) end
        if State.bodyTrailConn then
            State.bodyTrailConn:Disconnect()
            State.bodyTrailConn = nil
        end
    end
end

-- AURA TRAILER 
local function AuraTrailer_Toggle(enabled)
    S.AuraTrailerEnabled = enabled
    local character = LP.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, v in pairs(character:GetChildren()) do
        if v:IsA("BasePart") and v ~= hrp then
            if enabled then
                if not v:FindFirstChild("AuraTrailer") then
                    local trail = Instance.new("Trail")
                    trail.Name = "AuraTrailer"
                    trail.Texture = "rbxassetid://1390780157"
                    trail.Parent = v
                    local p1 = Instance.new("Attachment", v)
                    p1.Name = "AuraPointer1"
                    local p2 = Instance.new("Attachment", hrp)
                    p2.Name = "AuraPointer2"
                    trail.Attachment0 = p1
                    trail.Attachment1 = p2
                    trail.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, S.AuraTrailerColor),
                        ColorSequenceKeypoint.new(1, S.AuraTrailerColor)
                    })
                    trail.Lifetime = S.AuraTrailerLife
                end
            else
                if v:FindFirstChild("AuraTrailer") then v.AuraTrailer:Destroy() end
                if v:FindFirstChild("AuraPointer1") then v.AuraPointer1:Destroy() end
            end
        end
    end
    if not enabled then
        for _, obj in pairs(hrp:GetChildren()) do
            if obj.Name == "AuraPointer2" then obj:Destroy() end
        end
    end
end

local function AuraTrailer_Update()
    local character = LP.Character
    if not character then return end
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("Trail") and v.Name == "AuraTrailer" then
            v.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, S.AuraTrailerColor),
                ColorSequenceKeypoint.new(1, S.AuraTrailerColor)
            })
            v.Lifetime = S.AuraTrailerLife
        end
    end
end

-- FORCEFIELD 
local function ForceField_SaveOriginal(char)
    State.forceFieldOriginal[char] = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "ChineseHat" then
            State.forceFieldOriginal[char][part] = {Color = part.Color, Material = part.Material}
        end
    end
end

local function ForceField_Apply(char)
    ForceField_SaveOriginal(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "ChineseHat" then
            part.Color = S.ForceFieldColor
            part.Material = Enum.Material.ForceField
        end
    end
end

local function ForceField_Update()
    if LP.Character and S.ForceFieldEnabled then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "ChineseHat" and part.Material == Enum.Material.ForceField then
                if S.ForceFieldRainbow then
                    part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                else
                    part.Color = S.ForceFieldColor
                end
            end
        end
    end
end

local function ForceField_Remove(char)
    if State.forceFieldOriginal[char] then
        for part, data in pairs(State.forceFieldOriginal[char]) do
            if part and part.Parent and part:IsA("BasePart") then
                part.Color = data.Color
                part.Material = data.Material
            end
        end
        State.forceFieldOriginal[char] = {}
    end
end

local function ForceField_ToggleEnabled(value)
    S.ForceFieldEnabled = value
    if LP.Character then
        if value then
            ForceField_Apply(LP.Character)
            if State.forceFieldConn then State.forceFieldConn:Disconnect() end
            State.forceFieldConn = RS.Heartbeat:Connect(ForceField_Update)
        else
            if State.forceFieldConn then
                State.forceFieldConn:Disconnect()
                State.forceFieldConn = nil
            end
            ForceField_Remove(LP.Character)
        end
    end
end

-- SKYBOX
local function Skybox_Apply(name)
    local sb = SkyboxAssets[name]
    if not sb then return end
    task.spawn(function()
        pcall(function()
            ContentProvider:PreloadAsync({sb.Bk, sb.Dn, sb.Ft, sb.Lf, sb.Rt, sb.Up})
        end)
    end)
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Name = "HubSky"
        sky.Parent = Lighting
    end
    sky.SkyboxBk = sb.Bk
    sky.SkyboxDn = sb.Dn
    sky.SkyboxFt = sb.Ft
    sky.SkyboxLf = sb.Lf
    sky.SkyboxRt = sb.Rt
    sky.SkyboxUp = sb.Up
end

local function Skybox_RestoreDefault()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky and State.defaultSkySettings.SkyboxBk then
        sky.SkyboxBk = State.defaultSkySettings.SkyboxBk
        sky.SkyboxDn = State.defaultSkySettings.SkyboxDn
        sky.SkyboxFt = State.defaultSkySettings.SkyboxFt
        sky.SkyboxLf = State.defaultSkySettings.SkyboxLf
        sky.SkyboxRt = State.defaultSkySettings.SkyboxRt
        sky.SkyboxUp = State.defaultSkySettings.SkyboxUp
    elseif sky then
        sky:Destroy()
    end
end

-- ATMOSPHERE 
local function applyAtmosphere()
    if not S.AtmosphereEnabled then
        if State.LarpticAtmosphere then
            pcall(function() State.LarpticAtmosphere:Destroy() end)
            State.LarpticAtmosphere = nil
        end
        return
    end
    local atm = State.LarpticAtmosphere
    if not (atm and atm.Parent) then
        atm = Instance.new("Atmosphere")
        atm.Name = "LarpticAtmosphere"
        atm.Parent = Lighting
        State.LarpticAtmosphere = atm
    end
    pcall(function()
        atm.Density = S.AtmDensity
        atm.Offset = S.AtmOffset
        atm.Haze = S.AtmHaze
        atm.Glare = S.AtmGlare
        atm.Color = S.AtmColor
        atm.Decay = S.AtmDecay
    end)
end

-- MINECRAFT TEXTURES (CandyZone)
local function ensureMinecraftVariants()
    if State.materialVariantsBuilt then return end
    for name, data in pairs(MINECRAFT_VARIANTS) do
        local variant = MaterialService:FindFirstChild(name)
        if not variant then
            variant = Instance.new("MaterialVariant")
            variant.Name = name
            variant.Parent = MaterialService
        end
        pcall(function()
            variant.BaseMaterial = data.BaseMaterial
            variant.ColorMap = data.Texture
            variant.MetalnessMap = data.Texture
            variant.NormalMap = data.Texture
            variant.RoughnessMap = data.Texture
            variant.MaterialPattern = Enum.MaterialPattern.Regular
            variant.StudsPerTile = 5
        end)
    end
    State.materialVariantsBuilt = true
end

local function rememberPartState(part)
    if not State.textureState[part] then
        State.textureState[part] = {
            Color = part.Color,
            Material = part.Material,
            MaterialVariant = part.MaterialVariant
        }
    end
    return State.textureState[part]
end

local function shouldSkipTexturePart(part)
    if not part:IsDescendantOf(WS) then return true end
    if part.Name == "LarpticWeather" then return true end
    local parent = part.Parent
    if parent and (parent:IsA("Tool") or parent:IsA("Accessory")) then return true end
    local model = part:FindFirstAncestorOfClass("Model")
    if model and Players:GetPlayerFromCharacter(model) then return true end
    return false
end

local function applyPartTexturePack()
    ensureMinecraftVariants()
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("BasePart") and not shouldSkipTexturePart(obj) then
            rememberPartState(obj)
            local variantName = MATERIAL_VARIANT_BY_MATERIAL[obj.Material]
            if variantName then
                pcall(function() obj.MaterialVariant = variantName end)
            end
        end
    end
end

local function clearPartTexturePack()
    for part, state in pairs(State.textureState) do
        if part and part.Parent and state then
            pcall(function()
                part.Color = state.Color
                part.Material = state.Material
                part.MaterialVariant = state.MaterialVariant or ""
            end)
        end
    end
end

local function clearMinecraftVariants()
    for name in pairs(MINECRAFT_VARIANTS) do
        local variant = MaterialService:FindFirstChild(name)
        if variant and variant:IsA("MaterialVariant") then
            pcall(function() variant:Destroy() end)
        end
    end
    State.materialVariantsBuilt = false
end

local function applyTexturePack()
    local terr = WS:FindFirstChildOfClass("Terrain")
    if terr then
        for mat, col in pairs(MINECRAFT_TERRAIN_COLORS) do
            pcall(function() terr:SetMaterialColor(mat, col) end)
        end
    end
    applyPartTexturePack()
end

local function clearTexturePack()
    clearPartTexturePack()
    clearMinecraftVariants()
end

-- NEBULA (CandyZone)
local function Nebula_Enable()
    local b = Instance.new("BloomEffect", Lighting)
    b.Intensity = 0.7
    b.Size = 24
    b.Threshold = 1
    b.Name = "NebulaBloom"
    local c = Instance.new("ColorCorrectionEffect", Lighting)
    c.Saturation = 0.5
    c.Contrast = 0.2
    c.TintColor = S.NebulaColor
    c.Name = "NebulaColorCorrection"
    local a = Instance.new("Atmosphere", Lighting)
    a.Density = 0.4
    a.Offset = 0.25
    a.Glare = 1
    a.Haze = 2
    a.Color = S.NebulaColor
    a.Decay = Color3.fromRGB(173, 216, 230)
    a.Name = "NebulaAtmosphere"
    Lighting.Ambient = S.NebulaColor
    Lighting.OutdoorAmbient = S.NebulaColor
    Lighting.FogStart = 100
    Lighting.FogEnd = 500
    Lighting.FogColor = S.NebulaColor
end

local function Nebula_Disable()
    for _, name in pairs({"NebulaBloom", "NebulaColorCorrection", "NebulaAtmosphere"}) do
        local obj = Lighting:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
    Lighting.Ambient = State.defaultLighting.Ambient
    Lighting.OutdoorAmbient = State.defaultLighting.OutdoorAmbient
    Lighting.FogStart = State.defaultLighting.FogStart
    Lighting.FogEnd = State.defaultLighting.FogEnd
    Lighting.FogColor = State.defaultLighting.FogColor
end

local function Nebula_UpdateColor()
    if S.NebulaEnabled then
        local nc = Lighting:FindFirstChild("NebulaColorCorrection")
        if nc then nc.TintColor = S.NebulaColor end
        local na = Lighting:FindFirstChild("NebulaAtmosphere")
        if na then na.Color = S.NebulaColor end
        Lighting.Ambient = S.NebulaColor
        Lighting.OutdoorAmbient = S.NebulaColor
        Lighting.FogColor = S.NebulaColor
    end
end

-- SCREEN EFFECT (CandyZone)
local function Screen_Toggle(value)
    S.ScreenEffect = value
    if value then
        if State.screenConn then State.screenConn:Disconnect() end
        State.screenConn = RS.RenderStepped:Connect(function()
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, (0.65 + S.ScreenIntensity), 0, 0, 0, 1)
        end)
    else
        if State.screenConn then
            State.screenConn:Disconnect()
            State.screenConn = nil
        end
    end
end

-- // KILL ALL
local function FindKillRemote()
    for _, child in ipairs(RPS:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            local name = child.Name:lower()
            if name:find("kill") or name:find("attack") or name:find("damage") or name:find("murder") or name:find("slash") or name:find("stab") then
                Cache.KillAllRemote = child
                return child
            end
        end
    end
    for _, child in ipairs(RPS:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            Cache.KillAllRemote = child
            return child
        end
    end
end
FindKillRemote()

local function KillAllPlayers()
    if not Cache.KillAllRemote then FindKillRemote() end
    if not Cache.KillAllRemote then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            pcall(function() Cache.KillAllRemote:FireServer(player) end)
            pcall(function() Cache.KillAllRemote:FireServer(player.Character) end)
            pcall(function() Cache.KillAllRemote:FireServer(player.Character.HumanoidRootPart) end)
        end
    end
end

-- // ANTI-WATER
local function hacerNadable(nombreMapa, bloqueFalso, scriptCliente)
    if not S.AntiWater then return end
    if not bloqueFalso or not bloqueFalso:IsA("BasePart") then return end
    if scriptCliente and scriptCliente:IsA("LocalScript") then scriptCliente.Enabled = false end
    bloqueFalso.CanTouch = false
    if bloqueFalso:GetAttribute("AguaTransformada") then return end
    bloqueFalso:SetAttribute("AguaTransformada", true)
    local cframeAgua = bloqueFalso.CFrame
    local tamanoAgua = bloqueFalso.Size
    pcall(function() Terrain:FillBlock(cframeAgua, tamanoAgua, Enum.Material.Water) end)
    local visualWater = Instance.new("Part")
    visualWater.Name = "CustomWaterTexture"
    visualWater.Size = Vector3.new(tamanoAgua.X + 0.1, tamanoAgua.Y + 0.05, tamanoAgua.Z + 0.1)
    visualWater.CFrame = cframeAgua
    visualWater.Anchored = true
    visualWater.CanCollide = false
    visualWater.CanQuery = false
    visualWater.CanTouch = false
    visualWater.CastShadow = false
    visualWater.Material = Enum.Material.Granite
    visualWater.Color = Color3.fromRGB(85, 227, 255)
    visualWater.Transparency = 0.85
    visualWater.Parent = bloqueFalso.Parent
    bloqueFalso.Transparency = 1
    table.insert(State.zonasDeAguaActivas, {
        mapa = nombreMapa, cframe = cframeAgua, size = tamanoAgua,
        parteFalsa = bloqueFalso, parteVisual = visualWater
    })
end

local function analizarMapas()
    if not S.AntiWater then return end
    local yacht = WS:FindFirstChild("Yacht")
    if yacht then hacerNadable("Yacht", yacht:FindFirstChild("WaterPart", true), yacht:FindFirstChild("WaterClient", true)) end
    local pier = WS:FindFirstChild("Pier")
    if pier then hacerNadable("Pier", pier:FindFirstChild("Respawn", true), pier:FindFirstChild("WaterClient", true)) end
    for _, v in pairs(WS:GetDescendants()) do
        if v:IsA("BasePart") then
            local name = string.lower(v.Name)
            if name:find("water") or name:find("lava") or name:find("acid") or name:find("kill") or name:find("death") then
                pcall(function() v.CanTouch = false end)
            end
        end
    end
end

AddConnection(WS.ChildRemoved:Connect(function(child)
    if child.Name == "Yacht" or child.Name == "Pier" or child:IsA("Model") then
        for i = #State.zonasDeAguaActivas, 1, -1 do
            local zona = State.zonasDeAguaActivas[i]
            if zona.mapa == child.Name or not zona.parteFalsa or not zona.parteFalsa.Parent then
                pcall(function() Terrain:FillBlock(zona.cframe, zona.size, Enum.Material.Air) end)
                if zona.parteVisual and zona.parteVisual.Parent then zona.parteVisual:Destroy() end
                table.remove(State.zonasDeAguaActivas, i)
            end
        end
    end
end))
AddConnection(WS.ChildAdded:Connect(function(child)
    if S.AntiWater and (child.Name == "Yacht" or child.Name == "Pier") then task.delay(1, analizarMapas) end
end))
task.spawn(function() while task.wait(3) do pcall(analizarMapas) end end)
task.spawn(function() task.wait(2); analizarMapas() end)

-- // AUDIO HOOK
local function hookSound(sound)
    if not sound:IsA("Sound") or State.hookedSounds[sound] then return end
    State.hookedSounds[sound] = true
    AddConnection(sound.Played:Connect(function()
        if sound.Name == "Gunshot" and S.CustomGunSounds then
            local soundId = Audio.Gunshots[S.SelectedGunshot]
            if soundId and sound.SoundId ~= soundId then sound.SoundId = soundId; sound.TimePosition = 0; sound:Play() end
        elseif sound.Name == "Kill" and S.CustomKnifeSounds then
            local soundId = Audio.KnifeKills[S.SelectedKnifeKill]
            if soundId and sound.SoundId ~= soundId then sound.SoundId = soundId; sound.TimePosition = 0; sound:Play() end
        end
    end))
end
AddConnection(WS.DescendantAdded:Connect(function(d)
    if d:IsA("Sound") and (d.Name == "Gunshot" or d.Name == "Kill") then hookSound(d) end
end))
for _, d in ipairs(WS:GetDescendants()) do
    if d:IsA("Sound") and (d.Name == "Gunshot" or d.Name == "Kill") then hookSound(d) end
end

-- // SILENT AIM & NAMECALL HOOK
local function getTargetMurderer()
    local bestTarget, shortestDistance = nil, S.SilentAimFOV
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and GetRole(player) == "Murderer" then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if distance < shortestDistance then shortestDistance = distance; bestTarget = char.HumanoidRootPart end
                end
            end
        end
    end
    return bestTarget
end

local function DrawShotTrajectory(from, to)
    if not S.ShotTrajectory then return end
    task.spawn(function()
        local segments = 12
        local gravity = Vector3.new(0, -30, 0)
        local direction = (to - from)
        local timeTotal = direction.Magnitude / 150
        local velocity = direction / timeTotal
        local parts = {}
        for i = 0, segments - 1 do
            local t1 = (i / segments) * timeTotal; local t2 = ((i + 1) / segments) * timeTotal
            local p1 = from + velocity * t1 + 0.5 * gravity * t1 * t1
            local p2 = from + velocity * t2 + 0.5 * gravity * t2 * t2
            local mid = (p1 + p2) / 2; local dist = (p1 - p2).Magnitude
            local beam = Instance.new("Part")
            beam.Size = Vector3.new(0.08, 0.08, dist); beam.CFrame = CFrame.new(mid, p2)
            beam.Color = Color3.fromHSV(i / segments, 1, 1); beam.Material = Enum.Material.Neon
            beam.Anchored = true; beam.CanCollide = false; beam.Parent = WS
            parts[#parts + 1] = beam
        end
        task.wait(1.8)
        for _, p in ipairs(parts) do if p and p.Parent then p:Destroy() end end
    end)
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if not checkcaller() then
        if S.SilentAim and method == "FireServer" and (self.Name == "Shoot" or self.Name:lower():find("shoot")) then
            local target = getTargetMurderer()
            if target and LP.Character and (LP.Character:FindFirstChild("Gun") or LP.Backpack:FindFirstChild("Gun")) then
                for i = 1, #args do
                    local v = args[i]
                    if typeof(v) == "Vector3" then args[i] = target.Position
                    elseif typeof(v) == "CFrame" then args[i] = CFrame.new(target.Position) end
                end
                return oldNamecall(self, unpack(args))
            end
        end
        if S.Wallbang and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist") then
            return nil, nil, nil, nil
        end
        if method == "FireServer" and self.Name == "Shoot" and args[2] then
            task.spawn(function()
                local origin = GetHRP(LP) and GetHRP(LP).Position or Vector3.zero
                DrawShotTrajectory(origin, args[2])
            end)
        end
    end
    return oldNamecall(self, ...)
end)

-- // GAME EVENT HOOKS
local function HookGameEvents()
    local function HookHumanoid(plr)
        local function setup(char)
            local hum = char:WaitForChild("Humanoid", 10)
            if hum then
                hum.Died:Connect(function()
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then State.playerDeathPositions[plr.Name] = hrp.Position end
                    if IsAlive(LP) then
                        local weapon = LP.Character:FindFirstChild("Knife") or LP.Character:FindFirstChild("Gun")
                        if weapon then
                            if weapon.Name == "Knife" and hrp and Dist(hrp.Position, GetHRP(LP).Position) < 22 then
                                State.roundKills[LP.Name] = (State.roundKills[LP.Name] or 0) + 1
                                if S.AutoToxic then SendChat("EZ 💥 Kill #" .. State.roundKills[LP.Name]) end
                            elseif weapon.Name == "Gun" and plr.Name == State.Murder then
                                if S.AutoToxic then SendChat("MURDERER DOWN! 🔫") end
                            end
                        end
                    end
                end)
            end
        end
        if plr.Character then task.spawn(setup, plr.Character) end
        plr.CharacterAdded:Connect(setup)
    end
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then HookHumanoid(p) end end
    Players.PlayerAdded:Connect(HookHumanoid)
end
task.spawn(HookGameEvents)

-- // ROLE UPDATER
local function UpdateRoles()
    local gpd = RPS:FindFirstChild("GetPlayerData", true)
    if not gpd then return end
    local ok, res = pcall(function() return gpd:InvokeServer() end)
    if not ok or type(res) ~= "table" then return end
    State.Roles = res
    local oldMurder, oldSheriff = State.Murder, State.Sheriff
    State.Murder, State.Sheriff, State.Hero = nil, nil, nil
    for name, data in pairs(State.Roles) do
        if data.Role == "Murderer" then State.Murder = name
        elseif data.Role == "Sheriff" then State.Sheriff = name
        elseif data.Role == "Hero" then State.Hero = name end
    end
    if not State.Murder then
        for _, plr in ipairs(Players:GetPlayers()) do
            local r = GetRole(plr)
            if r == "Murderer" then State.Murder = plr.Name end
            if r == "Sheriff" then State.Sheriff = plr.Name end
        end
    end
    if S.RoleAlerts and State.Murder and State.Murder ~= State.lastAnnouncedMurder then
        State.lastAnnouncedMurder = State.Murder
        local dp = Players:FindFirstChild(State.Murder)
        local dn = dp and dp.DisplayName or State.Murder
        Logging.new("crosshairs", "🚨 MURDER FOUND: " .. dn .. " is the Murderer!", 5)
    end
    if S.AnnounceRoles and State.Murder and State.Murder ~= oldMurder and not State.AnnouncedRound then
        State.AnnouncedRound = true
        local mD = Players:FindFirstChild(State.Murder)
        local mN = mD and mD.DisplayName or State.Murder
        local sN = "None"
        if State.Sheriff then local sD = Players:FindFirstChild(State.Sheriff); sN = sD and sD.DisplayName or State.Sheriff end
        SendChat("🚨 Murderer: " .. mN .. " | Sheriff: " .. sN)
    elseif not State.Murder then State.AnnouncedRound = false end
    if oldSheriff and not State.Sheriff and S.SheriffDeathAlert then
        ShowAlert("⚠️ SHERIFF KILLED! GUN IS ON THE GROUND!", Color3.fromRGB(255, 200, 0), 4)
    end
end

-- // COMBAT FUNCTIONS
local function ExecSheriffLock()
    if not S.SheriffLock or not IsAlive(LP) or State.panicActive then return end
    local char = LP.Character
    local isHoldingGun = char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
    if not isHoldingGun then return end
    if S.ForceShiftLock then pcall(function() LP.DevEnableMouseLock = true end) end
    local targetChar = nil
    if State.Murder then
        local mPlr = Players:FindFirstChild(State.Murder)
        if mPlr and IsAlive(mPlr) then targetChar = mPlr.Character end
    end
    if not targetChar then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and IsAlive(plr) then
                local c = plr.Character; local bp = plr:FindFirstChild("Backpack")
                if c:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then targetChar = c; break end
            end
        end
    end
    if targetChar then
        local targetPart = targetChar:FindFirstChild(S.LockTargetPart) or targetChar:FindFirstChild("HumanoidRootPart")
        if targetPart then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), math.clamp(S.LockSmoothness, 0.01, 1))
        end
    end
end

local function ExecKillAura()
    if not S.KillAura or not IsAlive(LP) or State.panicActive then return end
    if tick() - State.lastKillTick < 0.18 then return end
    local myC = LP.Character
    local knife = myC:FindFirstChild("Knife") or LP.Backpack:FindFirstChild("Knife")
    if not knife then return end
    if knife.Parent ~= myC then knife.Parent = myC end
    local myPos = GetHRP(LP).Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and IsAlive(plr) then
            local hrp = GetHRP(plr)
            if hrp and Dist(hrp.Position, myPos) <= S.KillAuraDist then
                local srv = knife:FindFirstChild("KnifeServer") or knife:FindFirstChildWhichIsA("RemoteEvent", true)
                if srv then srv:FireServer(hrp.Position); State.lastKillTick = tick(); break end
            end
        end
    end
end

local function ExecSilentKnife()
    if not S.SilentKnife or not IsAlive(LP) or State.panicActive then return end
    local myC = LP.Character
    local knife = myC:FindFirstChild("Knife") or LP.Backpack:FindFirstChild("Knife")
    if not knife then return end
    if knife.Parent ~= myC then knife.Parent = myC end
    local myPos = GetHRP(LP).Position
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and IsAlive(plr) then
            local hrp = GetHRP(plr)
            if hrp then local d = Dist(hrp.Position, myPos); if d < bestDist and d < 20 then bestDist = d; best = plr end end
        end
    end
    if best then
        local hrp = GetHRP(best)
        local srv = knife:FindFirstChild("KnifeServer") or knife:FindFirstChildWhichIsA("RemoteEvent", true)
        if srv and hrp then srv:FireServer(hrp.Position) end
    end
end

local function ExecInstantKill()
    if not IsAlive(LP) then return end
    local myC = LP.Character
    local knife = myC:FindFirstChild("Knife") or LP.Backpack:FindFirstChild("Knife")
    if not knife then Logging.new("crosshairs-slash", "Knife not found!", 3); return end
    if knife.Parent ~= myC then knife.Parent = myC end
    local oldCF = GetHRP(LP).CFrame
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and IsAlive(plr) then
            local hrp = GetHRP(plr)
            if hrp then
                GetHRP(LP).CFrame = hrp.CFrame * CFrame.new(0, 0, 1.2); task.wait(0.05)
                local srv = knife:FindFirstChild("KnifeServer") or knife:FindFirstChildWhichIsA("RemoteEvent", true)
                if srv then srv:FireServer(hrp.Position) end; task.wait(0.03)
            end
        end
    end
    task.wait(0.08)
    if IsAlive(LP) then GetHRP(LP).CFrame = oldCF end
end

local function ExecAntiStab()
    if not S.AntiStab or not IsAlive(LP) or not State.Murder then return end
    local mPlr = Players:FindFirstChild(State.Murder)
    if not mPlr or not IsAlive(mPlr) or mPlr == LP then return end
    local mHrp, myHrp = GetHRP(mPlr), GetHRP(LP)
    if not mHrp or not myHrp then return end
    if Dist(mHrp.Position, myHrp.Position) < S.AntiStabDist then
        local dir = (myHrp.Position - mHrp.Position).Unit
        myHrp.AssemblyLinearVelocity = dir * 85 + Vector3.new(0, 35, 0)
    end
end

local function ExecAutoDodge()
    if not S.AutoDodge or not IsAlive(LP) or not State.Murder then return end
    local mPlr = Players:FindFirstChild(State.Murder)
    if not mPlr or not IsAlive(mPlr) or mPlr == LP then return end
    local mHrp, myHrp = GetHRP(mPlr), GetHRP(LP)
    if not mHrp or not myHrp then return end
    if Dist(mHrp.Position, myHrp.Position) < S.AutoDodgeDist then
        if mPlr.Character:FindFirstChild("Knife") then
            local dirToMe = (myHrp.Position - mHrp.Position).Unit
            local sideDir = dirToMe:Cross(Vector3.yAxis).Unit
            if math.random() > 0.5 then sideDir = -sideDir end
            myHrp.AssemblyLinearVelocity = sideDir * 60 + Vector3.new(0, 25, 0) + dirToMe * 30
        end
    end
end

local function ExecTrapImmunity()
    if not S.TrapImmunity then return end
    for _, obj in ipairs(WS:GetDescendants()) do
        if (obj.Name == "Trap" or obj.Name == "FakeTrap") and obj:IsA("BasePart") then obj:Destroy() end
    end
end

local function ExecGunGrab()
    if not S.AutoGrabGun or not IsAlive(LP) then return end
    local gd = WS:FindFirstChild("GunDrop", true)
    if not gd or not gd:IsA("BasePart") then return end
    local hrp = GetHRP(LP); if not hrp then return end
    if typeof(firetouchinterest) == "function" then
        firetouchinterest(hrp, gd, 0); task.wait(); firetouchinterest(hrp, gd, 1)
    else
        local old = hrp.CFrame; hrp.CFrame = gd.CFrame; task.wait(0.08); hrp.CFrame = old
    end
end

local function ExecAutoCollectGun()
    if not S.AutoCollectGun or not IsAlive(LP) then return end
    if GetRole(LP) == "Murderer" then return end
    local myC = LP.Character
    if myC:FindFirstChild("Gun") or LP.Backpack:FindFirstChild("Gun") then return end
    local gd = WS:FindFirstChild("GunDrop", true)
    if not gd or not gd:IsA("BasePart") then return end
    local hrp = GetHRP(LP); if not hrp then return end
    local d = Dist(gd.Position, hrp.Position)
    if d < 80 then
        local tw = TS:Create(hrp, TweenInfo.new(d / 45, Enum.EasingStyle.Linear), {CFrame = CFrame.new(gd.Position + Vector3.new(0, 2, 0))})
        tw:Play(); tw.Completed:Wait()
        if typeof(firetouchinterest) == "function" then firetouchinterest(hrp, gd, 0); task.wait(); firetouchinterest(hrp, gd, 1) end
    end
end

local function ExecGhostMode()
    if not S.GhostMode or not IsAlive(LP) then return end
    local char = LP.Character
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Transparency = 0.95 end
        if part:IsA("Decal") then part.Transparency = 0.95 end
    end
end

local function ExecCoinMagnet()
    if not S.CoinMagnet or not IsAlive(LP) then return end
    local hrp = GetHRP(LP); if not hrp then return end
    local container = WS:FindFirstChild("CoinContainer", true) or WS:FindFirstChild("Normal")
    if not container then return end
    for _, obj in ipairs(container:GetDescendants()) do
        if (obj.Name == "Coin_Server" or obj.Name == "Coin") and obj:IsA("BasePart") then
            if Dist(obj.Position, hrp.Position) <= S.CoinMagnetRange then obj.CFrame = hrp.CFrame end
        end
    end
end

local function ExecHitboxExtender()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and IsAlive(plr) then
            local root = plr.Character:FindFirstChild(S.HitboxPart)
            if root and root:IsA("BasePart") then
                if S.HitboxEnabled then
                    if not State.hitboxCache[plr] then
                        State.hitboxCache[plr] = {OriginalSize = root.Size, OriginalColl = root.CanCollide, OriginalTrans = root.Transparency}
                    end
                    root.Size = Vector3.new(S.HitboxSize, S.HitboxSize, S.HitboxSize); root.CanCollide = false; root.Transparency = 0.6
                else
                    if State.hitboxCache[plr] then
                        root.Size = State.hitboxCache[plr].OriginalSize
                        root.CanCollide = State.hitboxCache[plr].OriginalColl
                        root.Transparency = State.hitboxCache[plr].OriginalTrans
                        State.hitboxCache[plr] = nil
                    end
                end
            end
        end
    end
end

local function ExecSmartAutoPlay()
    if not S.SmartAutoPlay or not IsAlive(LP) then return end
    local myRole = GetRole(LP); local myHrp = GetHRP(LP); if not myHrp then return end
    if myRole == "Sheriff" or myRole == "Hero" then
        if State.Murder then
            local mPlr = Players:FindFirstChild(State.Murder)
            if mPlr and IsAlive(mPlr) then
                local mHrp = GetHRP(mPlr)
                if mHrp and Dist(mHrp.Position, myHrp.Position) < 50 then S.AutoShoot = true; S.AutoShootMode = "Smart" end
            end
        end
    elseif myRole == "Murderer" then
        S.KillAura = true; S.SilentKnife = true
        local best, bestDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and IsAlive(plr) then
                local hrp = GetHRP(plr)
                if hrp then local d = Dist(hrp.Position, myHrp.Position); if d < bestDist then bestDist = d; best = plr end end
            end
        end
        if best and bestDist > 15 then
            local hrp = GetHRP(best)
            if hrp then local hum = GetHumanoid(LP); local dir = (hrp.Position - myHrp.Position).Unit; if hum then hum:Move(Vector3.new(dir.X, 0, dir.Z)) end end
        end
    else
        if State.Murder then
            local mPlr = Players:FindFirstChild(State.Murder)
            if mPlr and IsAlive(mPlr) then
                local mHrp = GetHRP(mPlr)
                if mHrp and Dist(mHrp.Position, myHrp.Position) < 30 then
                    local dir = (myHrp.Position - mHrp.Position).Unit; local hum = GetHumanoid(LP)
                    if hum then hum:Move(Vector3.new(dir.X, 0, dir.Z)) end
                end
            end
        end
    end
end

-- // FLY & PLATFORM
local function ToggleFly(on)
    if not IsAlive(LP) then return end
    local hrp = GetHRP(LP)
    if on then
        State.FlyBV = Instance.new("BodyVelocity"); State.FlyBV.Velocity = Vector3.zero
        State.FlyBV.MaxForce = Vector3.one * 9e9; State.FlyBV.Parent = hrp
        State.FlyBG = Instance.new("BodyGyro"); State.FlyBG.MaxTorque = Vector3.one * 9e9
        State.FlyBG.CFrame = hrp.CFrame; State.FlyBG.Parent = hrp
    else
        if State.FlyBV then State.FlyBV:Destroy(); State.FlyBV = nil end
        if State.FlyBG then State.FlyBG:Destroy(); State.FlyBG = nil end
    end
end

local function ToggleSafePlatform(on)
    if on then
        if not State.SafePlatformPart then
            State.SafePlatformPart = Instance.new("Part")
            State.SafePlatformPart.Size = Vector3.new(30, 2, 30); State.SafePlatformPart.Anchored = true
            State.SafePlatformPart.Transparency = 0.5; State.SafePlatformPart.Material = Enum.Material.ForceField
            State.SafePlatformPart.Color = Color3.fromRGB(0, 170, 255)
            State.SafePlatformPart.CFrame = CFrame.new(0, 450, 0); State.SafePlatformPart.Parent = WS
        end
        if IsAlive(LP) then GetHRP(LP).CFrame = State.SafePlatformPart.CFrame + Vector3.new(0, 4, 0) end
    else
        if State.SafePlatformPart then State.SafePlatformPart:Destroy(); State.SafePlatformPart = nil end
    end
end

-- // X-RAY
local function UpdateXRay()
    for _, part in ipairs(WS:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude > 2 then
            local parent = part.Parent
            if parent and not parent:FindFirstChildOfClass("Humanoid") and (not parent.Parent or not parent.Parent:FindFirstChildOfClass("Humanoid")) then
                if S.XRay then
                    if State.xrayCache[part] == nil then State.xrayCache[part] = part.Transparency end
                    if part.Transparency < 0.8 then part.Transparency = S.XRayTrans end
                else
                    if State.xrayCache[part] ~= nil then part.Transparency = State.xrayCache[part]; State.xrayCache[part] = nil end
                end
            end
        end
    end
end

-- // AUTO REJOIN
local function HandleAutoRejoin()
    pcall(function()
        AddConnection(game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function()
            if S.AutoRejoin then task.wait(3); TeleportService:Teleport(game.PlaceId, LP) end
        end))
    end)
end
task.spawn(HandleAutoRejoin)

-- // PANIC
local function EmitPanicNotification()
    ShowAlert("🛑 PANIC MODE ACTIVE!", Color3.fromRGB(255, 0, 0), 5)
end

local function ActivatePanic()
    State.panicActive = true
    S.AutoShoot = false; S.KillAura = false; S.KillAllLoop = false; S.SilentKnife = false
    S.SmartAutoPlay = false; S.HitboxEnabled = false; S.SpeedHack = false
    S.AirSpeedGlitch = false; S.Noclip = false; S.Fly = false; S.SafePlatform = false
    S.SpinBot = false; S.WalkFling = false; S.GhostMode = false; S.CoinMagnet = false
    S.ESP = false; S.Chams = false; S.Boxes = false; S.Tracers = false; S.Names = false
    S.FakeLag = false; S.DanceAura = false
    StopDanceAura()
    if State.FlyBV then State.FlyBV:Destroy(); State.FlyBV = nil end
    if State.FlyBG then State.FlyBG:Destroy(); State.FlyBG = nil end
    if State.SafePlatformPart then State.SafePlatformPart:Destroy(); State.SafePlatformPart = nil end
    if IsAlive(LP) then
        local hum = GetHumanoid(LP)
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50 end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hl = plr.Character:FindFirstChild("_MHL"); if hl then hl:Destroy() end
        end
        if Drawings[plr] then
            for _, d in pairs(Drawings[plr]) do if d and d.Remove then d:Remove() end end
            Drawings[plr] = nil
        end
    end
    EmitPanicNotification()
end

-- // HUD LOOPS
task.spawn(function()
    while true do task.wait(1)
        if S.RoleOdds then
            OddsLabel.Visible = true
            local total = #Players:GetPlayers()
            local chance = total > 0 and math.floor((1 / total) * 100) or 0
            OddsLabel.Text = string.format("🎲 Role Odds Tracker:\nMurderer: %d%% | Sheriff: %d%%\nPlayers Online: %d", chance, chance, total)
        else OddsLabel.Visible = false end
    end
end)

task.spawn(function()
    while true do task.wait(0.5)
        if S.PlayerTracker then
            TrackerLabel.Visible = true
            local lines = {"📊 REALTIME PLAYER TRACKER:\n"}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    local role = GetRole(plr); local alive = IsAlive(plr) and "🟢" or "💀"
                    local dist = "-"
                    if IsAlive(plr) and IsAlive(LP) then dist = tostring(math.floor(Dist(GetHRP(plr).Position, GetHRP(LP).Position))) .. "m" end
                    local weapon = ""
                    if plr.Character then
                        if plr.Character:FindFirstChild("Knife") then weapon = "🔪"
                        elseif plr.Character:FindFirstChild("Gun") then weapon = "🔫" end
                    end
                    lines[#lines + 1] = string.format("%s %s [%s] %s %s", alive, plr.DisplayName, role, dist, weapon)
                end
            end
            TrackerLabel.Text = table.concat(lines, "\n")
        else TrackerLabel.Visible = false end
    end
end)

-- // TRADE VALUE CHECKER
task.spawn(function()
    while true do task.wait(0.8)
        if S.TradeValueChecker then
            local tradeGui = LP.PlayerGui:FindFirstChild("Trade") or LP.PlayerGui:FindFirstChild("TradeGUI") or LP.PlayerGui:FindFirstChild("TradeGui")
            if tradeGui then
                local enabled = true; pcall(function() enabled = tradeGui.Enabled end)
                if enabled then
                    if not State.TradeGuiLabel then
                        State.TradeGuiLabel = Instance.new("TextLabel")
                        State.TradeGuiLabel.Size = UDim2.new(0, 340, 0, 80)
                        State.TradeGuiLabel.Position = UDim2.new(0.5, -170, 0.08, 0)
                        State.TradeGuiLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                        State.TradeGuiLabel.BackgroundTransparency = 0.2
                        State.TradeGuiLabel.Font = Enum.Font.GothamBold; State.TradeGuiLabel.TextSize = 14
                        State.TradeGuiLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        State.TradeGuiLabel.TextWrapped = true; State.TradeGuiLabel.Parent = tradeGui; State.TradeGuiLabel.ZIndex = 100
                        Instance.new("UICorner", State.TradeGuiLabel).CornerRadius = UDim.new(0, 8)
                        Instance.new("UIStroke", State.TradeGuiLabel).Color = Color3.fromRGB(0, 255, 200)
                    end
                    local yourVal, theirVal = 0, 0
                    local function scanSide(container)
                        local val = 0; if not container then return val end
                        for _, child in ipairs(container:GetDescendants()) do
                            if child:IsA("TextLabel") or child:IsA("TextButton") then
                                for item, itemVal in pairs(ItemValues) do
                                    if string.find(string.lower(child.Text), string.lower(item)) then val = val + itemVal end
                                end
                            end
                        end
                        return val
                    end
                    for _, child in ipairs(tradeGui:GetDescendants()) do
                        if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                            local n = string.lower(child.Name)
                            if n:find("your") or n:find("left") or n:find("my") then yourVal = yourVal + scanSide(child)
                            elseif n:find("their") or n:find("right") or n:find("other") then theirVal = theirVal + scanSide(child) end
                        end
                    end
                    local diff = theirVal - yourVal
                    local state = "⚖️ FAIR TRADE"; local col = Color3.fromRGB(255, 255, 255)
                    if diff > 0 then state = "📈 +" .. tostring(diff) .. " PROFIT!"; col = Color3.fromRGB(0, 255, 100)
                    elseif diff < 0 then state = "📉 " .. tostring(diff) .. " LOSS!"; col = Color3.fromRGB(255, 50, 50) end
                    State.TradeGuiLabel.Text = string.format("💰 Your Value: %d\n💎 Their Value: %d\n%s", yourVal, theirVal, state)
                    State.TradeGuiLabel.TextColor3 = col; State.TradeGuiLabel.Visible = true
                else if State.TradeGuiLabel then State.TradeGuiLabel.Visible = false end end
            else if State.TradeGuiLabel then State.TradeGuiLabel.Visible = false end end
        else if State.TradeGuiLabel then State.TradeGuiLabel.Visible = false end end
    end
end)

-- // AUTO UNBOX
task.spawn(function()
    while true do task.wait(1.5)
        if S.AutoUnbox then
            pcall(function()
                local remote = RPS:FindFirstChild("UnboxCrate", true) or RPS:FindFirstChild("BuyCrate", true) or RPS:FindFirstChild("Unbox", true)
                if remote then
                    local res = nil
                    if remote:IsA("RemoteFunction") then res = remote:InvokeServer(S.AutoUnboxCrate)
                    elseif remote:IsA("RemoteEvent") then remote:FireServer(S.AutoUnboxCrate) end
                    if res and S.SmartStopGodly then
                        local itemName = tostring(res); local parsedValue = ItemValues[itemName] or 0
                        local isRare = parsedValue >= 70 or itemName:lower():find("chroma") or itemName:lower():find("godly") or itemName:lower():find("ancient")
                        if isRare then S.AutoUnbox = false; Logging.new("crown", "👑 GODLY FOUND! " .. itemName, 15) end
                    end
                end
            end)
        end
    end
end)

-- // COIN FARM
task.spawn(function()
    while true do task.wait(0.12)
        if S.AutoFarmCoins and IsAlive(LP) and not State.isFarming then
            local container = WS:FindFirstChild("CoinContainer", true) or WS:FindFirstChild("Normal")
            if container then
                local coins = {}
                for _, obj in ipairs(container:GetDescendants()) do
                    if (obj.Name == "Coin_Server" or obj.Name == "Coin" or obj:FindFirstChild("TouchInterest")) and obj:IsA("BasePart") then
                        coins[#coins + 1] = obj
                    end
                end
                if #coins > 0 then
                    State.isFarming = true
                    local hrp = GetHRP(LP)
                    if hrp then
                        table.sort(coins, function(a, b) return Dist(a.Position, hrp.Position) < Dist(b.Position, hrp.Position) end)
                        local target = coins[1]
                        if target and target.Parent then
                            local tw = TS:Create(hrp, TweenInfo.new(Dist(target.Position, hrp.Position) / S.FarmSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(target.Position)})
                            tw:Play()
                            local conn; conn = target.AncestryChanged:Connect(function() tw:Cancel(); conn:Disconnect() end)
                            tw.Completed:Wait(); if conn.Connected then conn:Disconnect() end
                        end
                    end
                    State.isFarming = false
                end
            end
        end
    end
end)

-- // SAKURA FARM
local function getAllCoinsSakura()
    local coins = {}
    local coinContainer = WS:FindFirstChild("CoinContainer") or WS:FindFirstChild("Coins") or WS:FindFirstChild("CoinArea")
    if coinContainer then
        for _, coin in ipairs(coinContainer:GetChildren()) do
            local part = coin:IsA("BasePart") and coin or coin:FindFirstChild("CoinVisual") or coin:FindFirstChildOfClass("BasePart")
            if part and part:IsA("BasePart") then table.insert(coins, part) end
        end
    else
        for _, obj in ipairs(WS:GetDescendants()) do
            if (obj.Name == "CoinVisual" or obj.Name == "Coin_Server" or obj.Name == "Coin") and obj:IsA("BasePart") then table.insert(coins, obj) end
        end
    end
    return coins
end

task.spawn(function()
    while true do task.wait(0.5)
        if S.SakuraAutoFarm then
            local waitTime = 0
            while waitTime < 9 and S.SakuraAutoFarm do task.wait(1); waitTime = waitTime + 1 end
            while S.SakuraAutoFarm do
                pcall(function()
                    local myChar = LP.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                    local rootPart = myChar.HumanoidRootPart
                    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
                    local bv = rootPart:FindFirstChild("FarmVelocity") or Instance.new("BodyVelocity")
                    bv.Name = "FarmVelocity"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bv.Velocity = Vector3.zero; bv.Parent = rootPart
                    if humanoid then humanoid.PlatformStand = true end
                    local coinsList = getAllCoinsSakura()
                    if #coinsList > 0 then
                        for _, coinPart in ipairs(coinsList) do
                            if not S.SakuraAutoFarm then break end
                            if coinPart and coinPart.Parent then
                                local targetPos = coinPart.Position
                                local hoverPos = targetPos + Vector3.new(0, S.SakuraSafeHeight, 0)
                                local distance = (rootPart.Position - hoverPos).Magnitude
                                local tweenTime = math.clamp(distance / S.SakuraFarmSpeed, 0.2, 2.0)
                                TS:Create(rootPart, TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(hoverPos)}):Play()
                                task.wait(tweenTime)
                                if not S.SakuraAutoFarm then break end
                                TS:Create(rootPart, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)}):Play()
                                task.wait(0.3)
                                TS:Create(rootPart, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(hoverPos)}):Play()
                                task.wait(0.2)
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
            pcall(function()
                local myChar = LP.Character
                if myChar then
                    local rootPart = myChar:FindFirstChild("HumanoidRootPart")
                    if rootPart and rootPart:FindFirstChild("FarmVelocity") then rootPart.FarmVelocity:Destroy() end
                    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
                    if humanoid then humanoid.PlatformStand = false end
                end
            end)
        end
    end
end)

-- // AUTO PICKUP GUN
task.spawn(function()
    while true do task.wait(0.2)
        if S.AutoPickupGun then
            pcall(function()
                local myChar = LP.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                if myChar:FindFirstChild("Gun") or (LP.Backpack and LP.Backpack:FindFirstChild("Gun")) then return end
                for _, obj in ipairs(WS:GetChildren()) do
                    if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                        myChar.HumanoidRootPart.CFrame = obj.CFrame; task.wait(0.1); break
                    end
                end
            end)
        end
    end
end)

-- // CROSSHAIR & RADAR DRAWINGS
local CHL = {
    L = Drawing.new("Line"), R = Drawing.new("Line"),
    T = Drawing.new("Line"), B = Drawing.new("Line"),
    C = Drawing.new("Circle"), FOV = Drawing.new("Circle")
}

local function UpdateCrosshair()
    if S.ShowFOV and S.SilentAim then
        CHL.FOV.Visible = true; CHL.FOV.Radius = S.SilentAimFOV; CHL.FOV.Color = S.CrosshairColor
        CHL.FOV.Thickness = 1; CHL.FOV.Filled = false; CHL.FOV.Position = UIS:GetMouseLocation()
    else CHL.FOV.Visible = false end
    if not S.Crosshair then
        for _, d in pairs(CHL) do d.Visible = false end; return
    end
    local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
    local sz, col = S.CrosshairSize, S.CrosshairColor
    local center = Vector2.new(cx, cy)
    CHL.C.Visible, CHL.C.Position, CHL.C.Radius, CHL.C.Color, CHL.C.Filled = true, center, 2, col, true
    CHL.L.Visible, CHL.L.From, CHL.L.To, CHL.L.Color = true, Vector2.new(cx - sz - 4, cy), Vector2.new(cx - 4, cy), col
    CHL.R.Visible, CHL.R.From, CHL.R.To, CHL.R.Color = true, Vector2.new(cx + 4, cy), Vector2.new(cx + sz + 4, cy), col
    CHL.T.Visible, CHL.T.From, CHL.T.To, CHL.T.Color = true, Vector2.new(cx, cy - sz - 4), Vector2.new(cx, cy - 4), col
    CHL.B.Visible, CHL.B.From, CHL.B.To, CHL.B.Color = true, Vector2.new(cx, cy + 4), Vector2.new(cx, cy + sz + 4), col
end

local RadarDraw = {
    BG = Drawing.new("Square"),
    Outline = Drawing.new("Square")
}
RadarDraw.BG.Visible = false; RadarDraw.BG.Filled = true; RadarDraw.BG.Color = Color3.fromRGB(20, 20, 25); RadarDraw.BG.Transparency = 0.75
RadarDraw.Outline.Visible = false; RadarDraw.Outline.Filled = false; RadarDraw.Outline.Color = Color3.fromRGB(0, 255, 200); RadarDraw.Outline.Thickness = 1.5

local function UpdateRadar()
    if not S.Radar or not IsAlive(LP) then
        RadarDraw.BG.Visible = false; RadarDraw.Outline.Visible = false
        for _, d in pairs(RadarDots) do d.Visible = false end; return
    end
    local sz = S.RadarSize
    local pos = Vector2.new(Camera.ViewportSize.X - sz - 30, 60)
    local center = pos + Vector2.new(sz / 2, sz / 2)
    RadarDraw.BG.Size, RadarDraw.BG.Position, RadarDraw.BG.Visible = Vector2.new(sz, sz), pos, true
    RadarDraw.Outline.Size, RadarDraw.Outline.Position, RadarDraw.Outline.Visible = Vector2.new(sz, sz), pos, true
    local myCF = GetHRP(LP).CFrame
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            if not RadarDots[plr] then local d = Drawing.new("Circle"); d.Radius, d.Filled = 4, true; RadarDots[plr] = d end
            local dot = RadarDots[plr]
            if IsAlive(plr) then
                local rel = myCF:PointToObjectSpace(GetHRP(plr).Position)
                local rx = math.clamp(rel.X / S.RadarZoom, -sz / 2 + 6, sz / 2 - 6)
                local ry = math.clamp(rel.Z / S.RadarZoom, -sz / 2 + 6, sz / 2 - 6)
                dot.Position, dot.Color, dot.Visible = center + Vector2.new(rx, ry), GetRoleColor(plr), true
            else dot.Visible = false end
        end
    end
end

local function CleanDrawings(plr)
    if Drawings[plr] then
        for _, d in pairs(Drawings[plr]) do if d and d.Remove then d:Remove() end end
        Drawings[plr] = nil
    end
    if RadarDots[plr] then RadarDots[plr]:Remove(); RadarDots[plr] = nil end
    if State.hitboxCache[plr] then State.hitboxCache[plr] = nil end
end

local function UpdateESP()
    local gd = WS:FindFirstChild("GunDrop", true)
    if gd and gd:IsA("BasePart") then
        local hl = gd:FindFirstChild("_GHL") or Instance.new("Highlight", gd)
        hl.Name = "_GHL"; hl.FillColor, hl.Enabled = Color3.fromRGB(255, 230, 0), S.GunESP
    end
    if S.TrapESP then
        for _, t in ipairs(WS:GetDescendants()) do
            if t.Name == "Trap" and t:IsA("BasePart") then
                local hl = t:FindFirstChild("_THL") or Instance.new("Highlight", t)
                hl.Name = "_THL"; hl.FillColor, hl.Enabled = Color3.fromRGB(255, 0, 100), true
            end
        end
    end
    local myHrp = GetHRP(LP); local myPos = myHrp and myHrp.Position or Vector3.zero
    local vpX, vpY = Camera.ViewportSize.X, Camera.ViewportSize.Y
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            if IsAlive(plr) then
                local char = plr.Character; local hrp = GetHRP(plr); local head = GetHead(plr)
                if not hrp or not head then continue end
                local col = GetRoleColor(plr)
                local hl = char:FindFirstChild("_MHL") or Instance.new("Highlight", char)
                hl.Name = "_MHL"; hl.FillColor, hl.OutlineColor = col, Color3.new(1, 1, 1)
                hl.FillTransparency = S.Chams and S.ChamsTrans or 1
                hl.OutlineTransparency = S.ESP and 0 or 1; hl.Enabled = S.ESP or S.Chams
                local hrpSc, onScr = Camera:WorldToViewportPoint(hrp.Position)
                local headSc = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local footSc = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                if not Drawings[plr] then
                    Drawings[plr] = {Box = Drawing.new("Square"), Tracer = Drawing.new("Line"), Name = Drawing.new("Text"), Info = Drawing.new("Text")}
                end
                local d = Drawings[plr]
                if onScr and (S.Boxes or S.Tracers or S.Names or S.Distances) then
                    local h = footSc.Y - headSc.Y; local w = h / 2
                    d.Box.Visible, d.Box.Size = S.Boxes, Vector2.new(w, h)
                    d.Box.Position, d.Box.Color, d.Box.Thickness = Vector2.new(hrpSc.X - w / 2, headSc.Y), col, 1.5
                    d.Tracer.Visible, d.Tracer.Color, d.Tracer.Thickness = S.Tracers, col, 1.2
                    d.Tracer.To = Vector2.new(hrpSc.X, footSc.Y)
                    if S.TracerOrigin == "Bottom" then d.Tracer.From = Vector2.new(vpX / 2, vpY)
                    elseif S.TracerOrigin == "Center" then d.Tracer.From = Vector2.new(vpX / 2, vpY / 2)
                    else d.Tracer.From = UIS:GetMouseLocation() end
                    local dist = math.floor(Dist(hrp.Position, myPos))
                    d.Name.Visible, d.Name.Center, d.Name.Outline = S.Names, true, true
                    d.Name.Text = string.format("%s [%s]", plr.DisplayName, GetRole(plr))
                    d.Name.Position, d.Name.Color, d.Name.Size = Vector2.new(hrpSc.X, headSc.Y - 18), col, 13
                    local info = ""
                    if S.Distances then info = dist .. "m " end
                    if S.HeldWeapon then local wp = char:FindFirstChild("Knife") or char:FindFirstChild("Gun"); if wp then info = info .. "[" .. wp.Name .. "]" end end
                    d.Info.Visible, d.Info.Center, d.Info.Outline = (S.Distances or S.HeldWeapon), true, true
                    d.Info.Text, d.Info.Position = info, Vector2.new(hrpSc.X, footSc.Y + 2)
                    d.Info.Color, d.Info.Size = Color3.fromRGB(240, 240, 240), 12
                else
                    d.Box.Visible, d.Tracer.Visible, d.Name.Visible, d.Info.Visible = false, false, false, false
                end
            else
                if Drawings[plr] then for _, dd in pairs(Drawings[plr]) do dd.Visible = false end end
            end
        end
    end
end

AddConnection(Players.PlayerRemoving:Connect(CleanDrawings))

-- // SAKURA AESTHETICS (CAPE, RIPPLE, TRAIL)
local function createTrail(char)
    local rootPart = char:FindFirstChild("HumanoidRootPart"); if not rootPart then return end
    local trailFolder = Instance.new("Folder"); trailFolder.Name = "SakuraTrail"; trailFolder.Parent = char
    table.insert(State.trailFolders, trailFolder)
    local trailCount = 30; local trailPositions = {}
    for i = 1, trailCount do
        local part = Instance.new("Part"); part.Name = "TrailPart_" .. i
        part.Size = Vector3.new(0.8, 0.8, 0.8); part.Shape = Enum.PartType.Ball
        part.Material = Enum.Material.Neon; part.Color = Color3.fromRGB(255, 105, 180)
        part.Transparency = 1 - (i / trailCount); part.CanCollide = false; part.Anchored = true
        part.Parent = trailFolder; part.Position = rootPart.Position
        local tp = {Position = rootPart.Position, Part = part}
        table.insert(trailPositions, tp); table.insert(State.trailParts, part)
    end
    task.spawn(function()
        local index = 1
        while S.TrailEffect and char and char.Parent do
            if char:FindFirstChild("HumanoidRootPart") and trailFolder.Parent == char then
                local currentPos = char.HumanoidRootPart.Position
                if #trailPositions > 0 then
                    local posData = trailPositions[index]
                    if posData and posData.Part then posData.Part.Position = currentPos; posData.Position = currentPos end
                    index = index % #trailPositions + 1
                end
            end
            task.wait(0.05)
        end
    end)
end

local function cleanupTrails()
    for _, folder in ipairs(State.trailFolders) do
        if folder and folder.Parent then pcall(function() folder:Destroy() end) end
    end
    State.trailFolders = {}; State.trailParts = {}
end

local function createAngelRing(char)
    local head = char:FindFirstChild("Head"); if not head then return end
    for _, part in ipairs(State.angelRingParts) do
        if part and part.Parent then pcall(function() part:Destroy() end) end
    end
    State.angelRingParts = {}
    if not S.AngelRing then return end
    local ringFolder = Instance.new("Folder"); ringFolder.Name = "SakuraAngelRing"; ringFolder.Parent = char
    local segments, radius = 24, 1.2
    local ringParts = {}
    for i = 1, segments do
        local angle = (i / segments) * math.pi * 2
        local part = Instance.new("Part"); part.Name = "RingSegment_" .. i
        part.Size = Vector3.new(0.3, 0.1, 0.3); part.Shape = Enum.PartType.Ball
        part.Material = Enum.Material.Neon; part.Color = Color3.fromRGB(255, 105, 180)
        part.Transparency = 0.2; part.CanCollide = false; part.Anchored = true; part.Parent = ringFolder
        part.CFrame = head.CFrame * CFrame.new(math.cos(angle) * radius, 0.8, math.sin(angle) * radius) * CFrame.Angles(0, angle, 0)
        table.insert(ringParts, part); table.insert(State.angelRingParts, part)
    end
    for i = 1, 12 do
        local angle = (i / 12) * math.pi * 2; local r2 = 0.4
        local glowPart = Instance.new("Part"); glowPart.Name = "GlowParticle_" .. i
        glowPart.Size = Vector3.new(0.15, 0.15, 0.15); glowPart.Shape = Enum.PartType.Ball
        glowPart.Material = Enum.Material.Neon; glowPart.Color = Color3.fromRGB(255, 182, 193)
        glowPart.Transparency = 0.3; glowPart.CanCollide = false; glowPart.Anchored = true; glowPart.Parent = ringFolder
        glowPart.CFrame = head.CFrame * CFrame.new(math.cos(angle) * r2, 1.2, math.sin(angle) * r2)
        table.insert(State.angelRingParts, glowPart)
    end
    task.spawn(function()
        local tk = 0
        while S.AngelRing and ringFolder.Parent == char do
            tk = tk + 0.03
            if char:FindFirstChild("Head") then
                local headPos = char.Head.CFrame
                for i, part in ipairs(ringParts) do
                    if part and part.Parent then
                        local angle = (i / segments) * math.pi * 2 + tk * 2
                        part.CFrame = headPos * CFrame.new(math.cos(angle) * radius, 0.8 + math.sin(tk * 3 + i) * 0.1, math.sin(angle) * radius) * CFrame.Angles(0, angle, 0)
                        part.Transparency = 0.2 + math.sin(tk * 2 + i * 0.5) * 0.1
                    end
                end
                local gi = 0
                for _, part in ipairs(State.angelRingParts) do
                    if part and part.Name:find("GlowParticle") then
                        gi = gi + 1
                        local angle = (gi / 12) * math.pi * 2 + tk * 1.5; local r2 = 0.4 + math.sin(tk * 2 + gi) * 0.1
                        part.CFrame = headPos * CFrame.new(math.cos(angle) * r2, 1.2 + math.sin(tk * 2.5 + gi * 0.7) * 0.1, math.sin(angle) * r2)
                        part.Transparency = 0.3 + math.sin(tk * 3 + gi) * 0.15
                    end
                end
            end
            task.wait(0.03)
        end
    end)
end

local function setupCape(char)
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"); if not torso then return end
    local capeModel = char:FindFirstChild("SakuraLayeredCapeModel"); if capeModel then capeModel:Destroy() end
    if not S.LayeredCape then return end
    local model = Instance.new("Model"); model.Name = "SakuraLayeredCapeModel"; model.Parent = char
    local layersCount = 16
    local basePart = Instance.new("Part"); basePart.Name = "CapeRoot"
    basePart.Size = Vector3.new(1.8, 0.2, 0.2); basePart.Transparency = 1; basePart.CanCollide = false; basePart.Parent = model
    local weld = Instance.new("WeldConstraint"); weld.Part0 = torso; weld.Part1 = basePart
    basePart.CFrame = torso.CFrame * CFrame.new(0, 0.8, 0.6) * CFrame.Angles(math.rad(15), 0, 0); weld.Parent = basePart
    local previousPart = basePart; local capeParts = {}
    for i = 1, layersCount do
        local segment = Instance.new("Part"); segment.Name = "CapeLayer_" .. i
        segment.Size = Vector3.new(1.8, 0.15, 0.08); segment.Color = Color3.fromRGB(255, 105, 180)
        segment.Material = Enum.Material.SmoothPlastic; segment.CanCollide = false; segment.Parent = model
        local sWeld = Instance.new("Weld"); sWeld.Part0 = previousPart; sWeld.Part1 = segment
        sWeld.C0 = CFrame.new(0, -0.12, 0.02); sWeld.C1 = CFrame.new(0, 0.12, -0.02); sWeld.Parent = segment
        table.insert(capeParts, segment); previousPart = segment
    end
    task.spawn(function()
        local tickCount = 0
        while model.Parent == char and S.LayeredCape do
            tickCount = tickCount + 0.15
            local velocity = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.AssemblyLinearVelocity.Magnitude or 0
            local waveFactor = math.sin(tickCount * 4) * (0.05 + (velocity * 0.002))
            for index, part in ipairs(capeParts) do
                local sWeld = part:FindFirstChildOfClass("Weld")
                if sWeld then sWeld.C0 = CFrame.new(0, -0.12, 0.02) * CFrame.Angles(waveFactor * (index / layersCount), 0, 0) end
            end
            task.wait(0.03)
        end
    end)
end

local function setupJumpEffect(char)
    local humanoid = char:WaitForChild("Humanoid", 5); local rootPart = char:WaitForChild("HumanoidRootPart", 5)
    if not humanoid or not rootPart then return end
    local lastState = humanoid:GetState()
    humanoid.StateChanged:Connect(function(_, newState)
        if not S.JumpRipple then return end
        if newState == Enum.HumanoidStateType.Jumping or (lastState == Enum.HumanoidStateType.Freefall and newState == Enum.HumanoidStateType.Running) then
            pcall(function()
                local part = Instance.new("Part"); part.Name = "JumpRippleEffect"
                part.Anchored = true; part.CanCollide = false; part.Transparency = 0.3
                part.Size = Vector3.new(0.5, 0.1, 0.5)
                part.CFrame = CFrame.new(rootPart.Position - Vector3.new(0, 3, 0)) * CFrame.Angles(math.rad(90), 0, 0)
                part.Color = Color3.fromRGB(255, 105, 180); part.Material = Enum.Material.Neon; part.Parent = WS
                Instance.new("CylinderMesh", part)
                TS:Create(part, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(0.5, 12, 12), Transparency = 1}):Play()
                task.delay(0.6, function() if part then part:Destroy() end end)
            end)
        end
        lastState = newState
    end)
end

local function makePlayerGlassPink(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Material = Enum.Material.Glass; part.Color = Color3.fromRGB(255, 105, 180); part.Transparency = 0.4 end
    end
end

local function restorePlayerBody(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Material = Enum.Material.SmoothPlastic; part.Transparency = 0 end
    end
end

local function ApplyCustomModel()
    if not S.PlayerModelEnabled or S.PlayerModelId == "" then return end
    pcall(function()
        local targetUserId = tonumber(S.PlayerModelId)
        if not targetUserId then targetUserId = Players:GetUserIdFromNameAsync(S.PlayerModelId) end
        if targetUserId then
            local desc = Players:GetHumanoidDescriptionFromUserId(targetUserId)
            local char = LP.Character
            if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ApplyDescriptionReset(desc) end
        end
    end)
end

-- // TROLLING SYSTEM
local function stopTrolling()
    if State.trollingThread then task.cancel(State.trollingThread); State.trollingThread = nil end
    if State.currentTrollingTween then State.currentTrollingTween:Cancel(); State.currentTrollingTween = nil end
    State.trollingActive = false
    local myChar = LP.Character
    if myChar then
        local track = myChar:FindFirstChild("SakuraDanceAnim")
        if track then pcall(function() track:Stop() end); track:Destroy() end
    end
end

local function startTrolling()
    stopTrolling()
    if S.TrollMode == "Off" or S.TrollTarget == "None" then return end
    State.trollingActive = true
    State.trollingThread = task.spawn(function()
        while State.trollingActive and S.TrollMode ~= "Off" do
            task.wait()
            pcall(function()
                local myChar = LP.Character; if not myChar then return end
                local myRoot = myChar:FindFirstChild("HumanoidRootPart"); if not myRoot then return end
                local humanoid = myChar:FindFirstChildOfClass("Humanoid"); if not humanoid then return end
                local targetPlayer = Players:FindFirstChild(S.TrollTarget)
                if not targetPlayer or not targetPlayer.Character then State.trollingActive = false; return end
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetHead = targetPlayer.Character:FindFirstChild("Head")
                if not targetRoot then return end
                for _, part in ipairs(myChar:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
                if S.TrollMode == "Jerk Mode" then myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -1, 1.2) * CFrame.Angles(math.rad(45), 0, 0)
                elseif S.TrollMode == "Sit on Head" and targetHead then myRoot.CFrame = CFrame.new(targetHead.Position + Vector3.new(0, 1.5, 0))
                elseif S.TrollMode == "Stand Nearby" then myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(2, 0, 2))
                elseif S.TrollMode == "Dance Nearby" then
                    myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(2, 0, 2))
                    if not myChar:FindFirstChild("SakuraDanceAnim") then
                        local animator = humanoid:FindFirstChildOfClass("Animator")
                        if animator then
                            local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://507771019"; anim.Name = "SakuraDanceAnim"
                            local track = animator:LoadAnimation(anim); track:Play(); myChar.SakuraDanceAnim = track
                        end
                    end
                elseif S.TrollMode == "Follow" then
                    if (myRoot.Position - targetRoot.Position).Magnitude > 3 then myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0, 3)) end
                elseif S.TrollMode == "Climb" then myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 3, 0)) end
            end)
            task.wait(0.05)
        end
    end)
end

local function onTrollingChange()
    if S.TrollMode == "Off" then stopTrolling() else startTrolling() end
end

local function ToggleWalkFling(enable)
    S.WalkFling = enable
    if enable then
        task.spawn(function()
            while S.WalkFling do
                local char = LP.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local oldV = hrp.Velocity
                        hrp.Velocity = Vector3.new(100000, 100000, 100000)
                        RS.RenderStepped:Wait(); hrp.Velocity = oldV
                    end
                end
                RS.Heartbeat:Wait()
            end
        end)
    else
        if IsAlive(LP) then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true); hum.MaxHealth = 100; hum.Health = 100 end
        end
    end
end

-- // CHARACTER ADDED REAPPLY
AddConnection(LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if S.WalkFling then ToggleWalkFling(true) end
    if S.ClassicAuraEnabled then ClassicAura_RefreshAll() end
    if S.ParticleAuraEnabled then ParticleAura_RefreshAll() end
    if S.DanceAura then ApplyDanceAura() end
    setupJumpEffect(char); setupCape(char)
    if S.PinkGlass then makePlayerGlassPink(char) end
    if S.TrailEffect then createTrail(char) end
    if S.AngelRing then createAngelRing(char) end
    if S.PlayerModelEnabled then ApplyCustomModel() end
    if S.TrollMode ~= "Off" then startTrolling() end
end))

local ToxicPhrases = {"ez 😴", "learn to play", "absolute domination", "what a lobby...", "too easy 💤", "nice try!"}
local FriendlyPhrases = {"GG everyone!", "Well played!", "Great round!", "Thanks for playing!", "Good luck!"}
local function SendAutoGG()
    if not S.AutoGG then return end
    task.delay(1.5, function()
        local pool = S.AutoGGMode == "Toxic" and ToxicPhrases or FriendlyPhrases
        SendChat(pool[math.random(#pool)])
    end)
end
pcall(function()
    local pm = RPS:FindFirstChild("PlayModel")
    if pm then
        local ro = pm:FindFirstChild("RoundOver") or pm:FindFirstChildWhichIsA("BindableEvent", true)
        if ro then AddConnection(ro.Event:Connect(function() SendAutoGG(); State.roundKills = {} end)) end
    end
end)

local function ApplyPerformance()
    if not S.LowGraphics and not S.DisableParticles then return end
    for _, v in ipairs(WS:GetDescendants()) do
        if S.DisableParticles then
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled = false end
        end
        if S.LowGraphics then
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
            if v:IsA("MeshPart") then v.RenderFidelity = Enum.RenderFidelity.Performance end
        end
    end
    if S.LowGraphics then settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end
end
task.spawn(function()
    while true do task.wait(60)
        if S.AntiAFK then
            local vu = game:GetService("VirtualUser")
            pcall(function() vu:CaptureController(); vu:ClickButton2(Vector2.zero) end)
        end
    end
end)

-- // MAIN LOOPS
AddConnection(RS.Stepped:Connect(function()
    if S.KillAllLoop and not State.panicActive then KillAllPlayers() end
    if not LP.Character then return end
    if S.Noclip then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
    if S.AntiFling then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                for _, p in ipairs(plr.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end
        local rootPart = LP.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local vel = rootPart.AssemblyLinearVelocity
            if math.abs(vel.X) > 150 or math.abs(vel.Z) > 150 then
                rootPart.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
                rootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
    if S.FakeLag and IsAlive(LP) then
        local hrp = GetHRP(LP)
        if hrp then hrp.Anchored = (State.frameCount % S.FakeLagLimit == 0) end
    end
    if S.SakuraAutoFarm and LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))

AddConnection(UIS.JumpRequest:Connect(function()
    if S.InfiniteJump and IsAlive(LP) then GetHumanoid(LP):ChangeState(Enum.HumanoidStateType.Jumping) end
end))

AddConnection(UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.F9 then ActivatePanic(); return end
    if S.KnifeAimbot and inp.KeyCode == Enum.KeyCode.E and IsAlive(LP) then
        local knife = LP.Character:FindFirstChild("Knife")
        if knife then
            local best, bestDist = nil, math.huge
            local myPos = GetHRP(LP).Position
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and IsAlive(plr) then
                    local d = Dist(GetHRP(plr).Position, myPos)
                    if d < bestDist then bestDist = d; best = plr end
                end
            end
            if best then
                local thrp, thead = GetHRP(best), GetHead(best)
                if thrp and thead then
                    local remote = knife:FindFirstChild("Throw") or knife:FindFirstChildWhichIsA("RemoteEvent", true)
                    if remote then
                        local pred = thead.Position + (thrp.AssemblyLinearVelocity * 0.12)
                        remote:FireServer(CFrame.new(GetHRP(LP).Position, pred))
                    end
                end
            end
        end
    end
end))

AddConnection(RS.RenderStepped:Connect(function(dt)
    State.frameCount = State.frameCount + 1
    local fc = State.frameCount

    if fc % 50 == 0 then UpdateRoles() end
    if fc % 120 == 0 and S.XRay then UpdateXRay() end
    if fc % 300 == 0 then ExecTrapImmunity() end
    if fc % 10 == 0 then ExecHitboxExtender() end
    if fc % 600 == 0 and (S.LowGraphics or S.DisableParticles) then ApplyPerformance() end

    ExecSheriffLock(); ExecKillAura(); ExecAntiStab(); ExecAutoDodge()

    if fc % 3 == 0 then ExecSilentKnife() end
    if fc % 5 == 0 then ExecGunGrab() end
    if fc % 15 == 0 then ExecAutoCollectGun() end
    if fc % 8 == 0 then ExecGhostMode() end
    if fc % 4 == 0 then ExecCoinMagnet() end
    if fc % 10 == 0 then ExecSmartAutoPlay() end
    if fc % 2 == 0 then UpdateESP(); UpdateRadar() end

    UpdateCrosshair()

    if S.Fly and IsAlive(LP) and State.FlyBV and State.FlyBG then
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.yAxis end
        State.FlyBV.Velocity = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.new(0, 0.1, 0)
        State.FlyBG.CFrame = Camera.CFrame
    end

    if S.Spectating == "Murderer" and State.Murder then
        local mp = Players:FindFirstChild(State.Murder)
        if mp and IsAlive(mp) then Camera.CameraSubject = GetHumanoid(mp) end
    elseif S.Spectating == "Sheriff" and State.Sheriff then
        local sp = Players:FindFirstChild(State.Sheriff)
        if sp and IsAlive(sp) then Camera.CameraSubject = GetHumanoid(sp) end
    end

    if S.MurderWarning and State.Murder and IsAlive(LP) then
        local mP = Players:FindFirstChild(State.Murder)
        if mP and IsAlive(mP) then
            local d = math.floor(Dist(GetHRP(mP).Position, GetHRP(LP).Position))
            local armed = mP.Character:FindFirstChild("Knife")
            if armed and d < 45 then ShowAlert("🚨 MURDERER WITH KNIFE! [" .. d .. "m]", Color3.fromRGB(255, 30, 70), 0.4)
            elseif d < 25 then ShowAlert("⚠️ MURDERER CLOSE! [" .. d .. "m]", Color3.fromRGB(255, 120, 0), 0.4) end
        end
    end

    if IsAlive(LP) then
        local hum = GetHumanoid(LP); local hrp = GetHRP(LP)
        if S.SpeedHack then hum.WalkSpeed = S.WalkSpeedVal end
        if S.JumpPowerHack then hum.JumpPower = S.JumpPowerVal end
        if S.AirSpeedGlitch then
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(md.X * hum.WalkSpeed * S.AirSpeedBoost, hrp.AssemblyLinearVelocity.Y, md.Z * hum.WalkSpeed * S.AirSpeedBoost)
                end
            end
        end
        if S.SpinBot then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.SpinSpeed), 0) end
        if S.BHop then
            if hum:GetState() == Enum.HumanoidStateType.Running and hum.MoveDirection.Magnitude > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        if S.SpeedGlitch then
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping or hum.Jump then
                hum.WalkSpeed = 120
            else
                hum.WalkSpeed = S.WalkSpeedVal or 16
            end
        end
    end

    if S.Fullbright then
        Lighting.Brightness = 2.5; Lighting.ClockTime = S.TimeOfDay
        Lighting.GlobalShadows = false; Lighting.FogEnd = 1e5
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
    Camera.FieldOfView = S.CustomFOV
end))

-- // CLEANUP
getgenv().__KIT_HUB_CLEANUP = function()
    for _, c in ipairs(Connections) do if c.Connected then c:Disconnect() end end
    for _, plr in ipairs(Players:GetPlayers()) do CleanDrawings(plr) end
    for _, l in pairs(CHL) do l:Remove() end
    RadarDraw.BG:Remove(); RadarDraw.Outline:Remove()
    for _, d in pairs(RadarDots) do d:Remove() end
    if AlertGui then AlertGui:Destroy() end
    if mobileMenuGui then mobileMenuGui:Destroy() end
    if State.FlyBV then State.FlyBV:Destroy() end
    if State.FlyBG then State.FlyBG:Destroy() end
    if State.SafePlatformPart then State.SafePlatformPart:Destroy() end
    for _, n in ipairs(AuraModels) do ClassicAura_DisableOne(n) end
    for _, n in ipairs(PARTICLE_AURA_NAMES) do ParticleAura_DisableOne(n) end
    StopDanceAura(); cleanupTrails(); stopTrolling()
    if State.bodyTrailConn then State.bodyTrailConn:Disconnect() end
    for _, t in pairs(State.bodyTrailParts) do if t then t:Destroy() end end
    if State.forceFieldConn then State.forceFieldConn:Disconnect() end
    if LP.Character then ForceField_Remove(LP.Character) end
    if State.screenConn then State.screenConn:Disconnect() end
    PE.CC:Destroy(); PE.Bloom:Destroy(); PE.SR:Destroy(); PE.Atmo:Destroy()
    getgenv().__KIT_HUB_LOADED = false
end

-- // UI NEVERLOSE SETUP
local window = NeverLose:CreateWindow({
    Logo = NeverLose.GlobalLogo, Name = "KIT HUB", Content = "Murder Mystery 2",
    Size = NeverLose.Scales.Default, ConfigFolder = "KitHubConfigs",
    Enable3DRenderer = false, Keybind = "Insert"
})

local Watermark = window:Watermark()
local pingBlock = Watermark:AddBlock("chart-four-vertical-bars", "0MS")
local uiBlock = Watermark:AddBlock("cube-vertexes", "KIT HUB")
uiBlock:Input(function() window:ToggleInterface() end)
task.spawn(function() while true do task.wait(1); pingBlock:SetText(tostring(math.random(15, 45)) .. 'MS') end end)

local ActiveExploits = Indicator.new({Name = "ACTIVE", Icon = 'crosshairs', Color = 'Green'})
ActiveExploits:SetRender(true); ActiveExploits:SetText("KIT HUB ACTIVE")

local T_Combat = window:AddTab({Icon = 'crosshairs', Name = "Rage"})
local T_Visuals = window:AddTab({Icon = 'eye', Name = "Visuals"})
local T_Cosmetics = window:AddTab({Icon = 'sparkles', Name = "Cosmetics"})
local T_Movement = window:AddTab({Icon = 'zap', Name = "Movement"})
local T_World = window:AddTab({Icon = 'sun', Name = "World"})
local T_Misc = window:AddTab({Icon = 'compass', Name = "Misc"})

-- == RAGE TAB ==
local S_Aimbot = T_Combat:AddSection({Name = "SHERIFF AIMBOT", Position = 'left'})
local S_Hitboxes = T_Combat:AddSection({Name = "HITBOX MODS", Position = 'left'})
local S_Sounds = T_Combat:AddSection({Name = "CUSTOM SOUNDS", Position = 'left'})
local S_Curas = T_Combat:AddSection({Name = "KILL AURAS", Position = 'right'})
local S_Defence = T_Combat:AddSection({Name = "DEFENSE", Position = 'right'})

S_Aimbot:AddLabel("Camera Lock"):AddToggle({Default = false, Callback = function(v) S.SheriffLock = v end})
S_Aimbot:AddLabel("Lock Target Part"):AddDropdown({Default = "HumanoidRootPart", Values = {"HumanoidRootPart", "Head"}, Callback = function(v) S.LockTargetPart = v end})
S_Aimbot:AddLabel("Camera Smoothness"):AddSlider({Min = 5, Max = 100, Rounding = 1, Default = 25, Callback = function(v) S.LockSmoothness = v / 100 end})
S_Aimbot:AddLabel("Silent Aim (Sheriff)"):AddToggle({Default = false, Callback = function(v) S.SilentAim = v end})
S_Aimbot:AddLabel("Show Silent Aim FOV"):AddToggle({Default = false, Callback = function(v) S.ShowFOV = v end})
S_Aimbot:AddLabel("Silent Aim FOV Size"):AddSlider({Min = 50, Max = 400, Rounding = 5, Default = 150, Callback = function(v) S.SilentAimFOV = v end})
S_Aimbot:AddLabel("Wallbang"):AddToggle({Default = false, Callback = function(v) S.Wallbang = v end})
S_Aimbot:AddLabel("Force Shiftlock"):AddToggle({Default = true, Callback = function(v) S.ForceShiftLock = v end})

S_Hitboxes:AddLabel("Hitbox Extender"):AddToggle({Default = false, Callback = function(v) S.HitboxEnabled = v end})
S_Hitboxes:AddLabel("Target Limb"):AddDropdown({Default = "Head", Values = {"Head", "HumanoidRootPart"}, Callback = function(v) S.HitboxPart = v end})
S_Hitboxes:AddLabel("Size Factor"):AddSlider({Min = 2, Max = 15, Rounding = 1, Default = 5, Callback = function(v) S.HitboxSize = v end})

S_Sounds:AddLabel("Custom Gun Sounds"):AddToggle({Default = true, Callback = function(v) S.CustomGunSounds = v end})
S_Sounds:AddLabel("Gunshot Preset"):AddDropdown({Default = "RPGS Candy", Values = GunshotKeys, Callback = function(v) S.SelectedGunshot = v end})
S_Sounds:AddButton({Icon = 'music', Name = "Test Gunshot Sound", Callback = function() PlayPreviewSound(Audio.Gunshots[S.SelectedGunshot]) end})
S_Sounds:AddLabel("Custom Knife Kills"):AddToggle({Default = true, Callback = function(v) S.CustomKnifeSounds = v end})
S_Sounds:AddLabel("Knife Kill Preset"):AddDropdown({Default = "Golden Knife Kill", Values = KnifeKillKeys, Callback = function(v) S.SelectedKnifeKill = v end})
S_Sounds:AddButton({Icon = 'music', Name = "Test Knife Sound", Callback = function() PlayPreviewSound(Audio.KnifeKills[S.SelectedKnifeKill]) end})

S_Curas:AddLabel("Knife Kill Aura"):AddToggle({Default = false, Callback = function(v) S.KillAura = v end})
S_Curas:AddLabel("Aura Distance"):AddSlider({Min = 5, Max = 30, Rounding = 1, Default = 15, Callback = function(v) S.KillAuraDist = v end})
S_Curas:AddLabel("Silent Knife"):AddToggle({Default = false, Callback = function(v) S.SilentKnife = v end})
S_Curas:AddLabel("Throw Aimbot [E]"):AddToggle({Default = false, Callback = function(v) S.KnifeAimbot = v end})
S_Curas:AddLabel("Kill All (Loop)"):AddToggle({Default = false, Callback = function(v) S.KillAllLoop = v end})
S_Curas:AddButton({Icon = 'sword', Name = "⚡ INSTANT KILL ALL", Callback = ExecInstantKill})

S_Defence:AddLabel("Anti-Water / Hazards"):AddToggle({Default = true, Callback = function(v) S.AntiWater = v; if v then pcall(analizarMapas) end end})
S_Defence:AddLabel("Anti-Stab Evade"):AddToggle({Default = false, Callback = function(v) S.AntiStab = v end})
S_Defence:AddLabel("Anti-Stab Limit"):AddSlider({Min = 10, Max = 40, Rounding = 1, Default = 20, Callback = function(v) S.AntiStabDist = v end})
S_Defence:AddLabel("Auto Dodge Sides"):AddToggle({Default = false, Callback = function(v) S.AutoDodge = v end})
S_Defence:AddLabel("Dodge Distance"):AddSlider({Min = 10, Max = 35, Rounding = 1, Default = 18, Callback = function(v) S.AutoDodgeDist = v end})
S_Defence:AddLabel("Trap Immunity"):AddToggle({Default = false, Callback = function(v) S.TrapImmunity = v end})

-- == VISUALS TAB ==
local S_Esp = T_Visuals:AddSection({Name = "PLAYER ESP", Position = 'left'})
local S_Spec = T_Visuals:AddSection({Name = "SPECTATE / OTHER", Position = 'left'})
local S_CzVis = T_Visuals:AddSection({Name = "VISUALS", Position = 'right'})

S_Esp:AddLabel("Highlight Fill ESP"):AddToggle({Default = false, Callback = function(v) S.ESP = v end})
S_Esp:AddLabel("Chams Solid Fill"):AddToggle({Default = false, Callback = function(v) S.Chams = v end})
S_Esp:AddLabel("Rainbow Chams"):AddToggle({Default = false, Callback = function(v) S.RainbowChams = v end})
S_Esp:AddLabel("Chams Opacity"):AddSlider({Min = 0, Max = 100, Rounding = 5, Default = 40, Callback = function(v) S.ChamsTrans = (100 - v) / 100 end})
S_Esp:AddLabel("2D Box ESP"):AddToggle({Default = false, Callback = function(v) S.Boxes = v end})
S_Esp:AddLabel("Screen Tracers"):AddToggle({Default = false, Callback = function(v) S.Tracers = v end})
S_Esp:AddLabel("Show NameTags"):AddToggle({Default = false, Callback = function(v) S.Names = v end})
S_Esp:AddLabel("Show Distances"):AddToggle({Default = false, Callback = function(v) S.Distances = v end})

S_Spec:AddLabel("Dropped Gun ESP"):AddToggle({Default = false, Callback = function(v) S.GunESP = v end})
S_Spec:AddLabel("Trap Placement ESP"):AddToggle({Default = false, Callback = function(v) S.TrapESP = v end})
S_Spec:AddLabel("Minimap Radar"):AddToggle({Default = false, Callback = function(v) S.Radar = v end})
S_Spec:AddLabel("Radar Range"):AddSlider({Min = 5, Max = 30, Rounding = 1, Default = 15, Callback = function(v) S.RadarZoom = v / 10 end})

S_CzVis:AddLabel("Enable Body Trail"):AddToggle({Default = false, Callback = function(v) Trail_ToggleEnabled(v) end})
S_CzVis:AddLabel("Trail Gradient Mode"):AddToggle({Default = false, Callback = function(v) S.BodyTrailGradient = v; if S.BodyTrailEnabled and LP.Character then Trail_AddToCharacter(LP.Character) end end})
S_CzVis:AddLabel("Trail Lifetime"):AddSlider({Min = 1, Max = 30, Rounding = 1, Default = 5, Callback = function(v) S.BodyTrailLifetime = v/10; Trail_UpdateAll() end})
S_CzVis:AddLabel("Enable ForceField"):AddToggle({Default = false, Callback = function(v) ForceField_ToggleEnabled(v) end})
S_CzVis:AddLabel("ForceField Rainbow"):AddToggle({Default = false, Callback = function(v) S.ForceFieldRainbow = v; ForceField_Update() end})
S_CzVis:AddLabel("Enable Aura Trailer"):AddToggle({Default = false, Callback = function(v) AuraTrailer_Toggle(v) end})
S_CzVis:AddLabel("Screen Stretch Effect"):AddToggle({Default = false, Callback = function(v) Screen_Toggle(v) end})
S_CzVis:AddLabel("Screen Stretch Intensity"):AddSlider({Min = 0, Max = 20, Rounding = 1, Default = 0, Callback = function(v) S.ScreenIntensity = v/100 end})

-- == COSMETICS TAB ==
local S_Dance = T_Cosmetics:AddSection({Name = "DANCE AURA", Position = 'left'})
local S_SakuraAes = T_Cosmetics:AddSection({Name = "SAKURA COSMETICS", Position = 'left'})
local S_ClassicAura = T_Cosmetics:AddSection({Name = "CLASSIC AURAS (GODLY)", Position = 'right'})
local S_ParticleAura = T_Cosmetics:AddSection({Name = "PARTICLE AURAS", Position = 'right'})

S_Dance:AddLabel("Infinite Dance Aura"):AddToggle({Default = false, Callback = ToggleDanceAura})

S_SakuraAes:AddLabel("Glowing Angel Ring"):AddToggle({Default = false, Callback = function(v) S.AngelRing = v; if v and LP.Character then createAngelRing(LP.Character) end end})
S_SakuraAes:AddLabel("Jump Ripple Effect"):AddToggle({Default = false, Callback = function(v) S.JumpRipple = v end})
S_SakuraAes:AddLabel("16-Layer Animated Cape"):AddToggle({Default = false, Callback = function(v) S.LayeredCape = v; if LP.Character then setupCape(LP.Character) end end})
S_SakuraAes:AddLabel("Pink Glass Body"):AddToggle({Default = false, Callback = function(v) S.PinkGlass = v; if LP.Character then if v then makePlayerGlassPink(LP.Character) else restorePlayerBody(LP.Character) end end end})

S_ClassicAura:AddLabel("Enable Classic Aura"):AddToggle({Default = false, Callback = function(v) S.ClassicAuraEnabled = v; ClassicAura_RefreshAll() end})
for _, name in ipairs(AuraModels) do
    S_ClassicAura:AddLabel(name):AddToggle({Default = false, Callback = function(v) S.SelectedClassicAuras[name] = v; ClassicAura_RefreshAll() end})
end

S_ParticleAura:AddLabel("Enable Particle Aura"):AddToggle({Default = false, Callback = function(v) S.ParticleAuraEnabled = v; ParticleAura_RefreshAll() end})
S_ParticleAura:AddLabel("Aura Color Preset"):AddDropdown({Default = "Cyan", Values = ColorKeys, Callback = function(v) S.ParticleAuraColor = ColorPresets[v]; ParticleAura_RefreshAll() end})
for _, name in ipairs(PARTICLE_AURA_NAMES) do
    S_ParticleAura:AddLabel(name:upper()):AddToggle({Default = false, Callback = function(v) S.SelectedParticleAuras[name] = v; ParticleAura_RefreshAll() end})
end

-- == MOVEMENT TAB ==
local S_Velocity = T_Movement:AddSection({Name = "VELOCITY", Position = 'left'})
local S_Physics = T_Movement:AddSection({Name = "PHYSICS", Position = 'right'})

S_Velocity:AddLabel("Speed Hack"):AddToggle({Default = false, Callback = function(v) S.SpeedHack = v; if not v and IsAlive(LP) then GetHumanoid(LP).WalkSpeed = 16 end end})
S_Velocity:AddLabel("WalkSpeed"):AddSlider({Min = 16, Max = 120, Rounding = 1, Default = 24, Callback = function(v) S.WalkSpeedVal = v end})
S_Velocity:AddLabel("Speed Glitch (Air)"):AddToggle({Default = false, Callback = function(v) S.SpeedGlitch = v end})
S_Velocity:AddLabel("Infinite Jump"):AddToggle({Default = false, Callback = function(v) S.InfiniteJump = v end})
S_Velocity:AddLabel("JumpPower Bypass"):AddToggle({Default = false, Callback = function(v) S.JumpPowerHack = v; if not v and IsAlive(LP) then GetHumanoid(LP).JumpPower = 50 end end})
S_Velocity:AddLabel("Jump Height"):AddSlider({Min = 50, Max = 200, Rounding = 1, Default = 50, Callback = function(v) S.JumpPowerVal = v end})

S_Physics:AddLabel("Fly [WASD]"):AddToggle({Default = false, Callback = function(v) S.Fly = v; ToggleFly(v) end})
S_Physics:AddLabel("Safe Platform (Sky)"):AddToggle({Default = false, Callback = function(v) S.SafePlatform = v; ToggleSafePlatform(v) end})
S_Physics:AddLabel("Noclip"):AddToggle({Default = false, Callback = function(v) S.Noclip = v end})
S_Physics:AddLabel("Spinbot"):AddToggle({Default = false, Callback = function(v) S.SpinBot = v end})
S_Physics:AddLabel("Spinbot Speed"):AddSlider({Min = 5, Max = 100, Rounding = 5, Default = 40, Callback = function(v) S.SpinSpeed = v end})
S_Physics:AddLabel("Anti-Fling Shield"):AddToggle({Default = false, Callback = function(v) S.AntiFling = v end})
S_Physics:AddLabel("Fling Walk"):AddToggle({Default = false, Callback = ToggleWalkFling})

-- == WORLD TAB ==
local S_Lighting = T_World:AddSection({Name = "LIGHTING ENGINE", Position = 'left'})
local S_Atmos = T_World:AddSection({Name = "ATMOSPHERE & TEXTURES", Position = 'right'})

S_Lighting:AddLabel("Custom Skybox"):AddDropdown({Default = "HD", Values = SkyboxList, Callback = function(v) S.SkyboxName = v; if S.SkyboxEnabled then Skybox_Apply(v) end end})
S_Lighting:AddLabel("Enable Skybox"):AddToggle({Default = false, Callback = function(v) S.SkyboxEnabled = v; if v then Skybox_Apply(S.SkyboxName) else Skybox_RestoreDefault() end end})
S_Lighting:AddLabel("Time Changer"):AddToggle({Default = false, Callback = function(v) S.TimeChanger = v end})
S_Lighting:AddLabel("Time (0-24h)"):AddSlider({Min = 0, Max = 24, Rounding = 1, Default = 12, Callback = function(v) S.TimeValue = v end})
S_Lighting:AddLabel("FullBright"):AddToggle({Default = false, Callback = function(v)
    S.WorldFullBright = v
    if not v then
        Lighting.Brightness = State.defaultLighting.Brightness
        Lighting.GlobalShadows = State.defaultLighting.GlobalShadows
        Lighting.OutdoorAmbient = State.defaultLighting.OutdoorAmbient
    end
end})
S_Lighting:AddLabel("Field of View"):AddSlider({Min = 70, Max = 120, Rounding = 1, Default = 90, Callback = function(v) S.CustomFOV = v end})

S_Atmos:AddLabel("Enable Atmosphere"):AddToggle({Default = false, Callback = function(v) S.AtmosphereEnabled = v; applyAtmosphere() end})
S_Atmos:AddLabel("Atm Density"):AddSlider({Min = 0, Max = 100, Rounding = 1, Default = 35, Callback = function(v) S.AtmDensity = v/100; applyAtmosphere() end})
S_Atmos:AddLabel("Minecraft Textures"):AddToggle({Default = false, Callback = function(v) S.MinecraftTextures = v; if v then applyTexturePack() else clearTexturePack() end end})
S_Atmos:AddLabel("Enable Nebula Theme"):AddToggle({Default = false, Callback = function(v) S.NebulaEnabled = v; if v then Nebula_Enable() else Nebula_Disable() end end})

-- == MISC TAB ==
local S_Farm = T_Misc:AddSection({Name = "AUTOFARM SYSTEM", Position = 'left'})
local S_Trolls = T_Misc:AddSection({Name = "SAKURA TROLLING", Position = 'left'})
local S_Premium = T_Misc:AddSection({Name = "PREMIUM SERVICES", Position = 'right'})

S_Farm:AddLabel("Fast Gun Grab"):AddToggle({Default = false, Callback = function(v) S.AutoGrabGun = v end})
S_Farm:AddLabel("Auto Collect Coins"):AddToggle({Default = false, Callback = function(v) S.AutoFarmCoins = v end})
S_Farm:AddLabel("Sakura Auto Farm"):AddToggle({Default = false, Callback = function(v) S.SakuraAutoFarm = v end})
S_Farm:AddLabel("Magnet Coins"):AddToggle({Default = false, Callback = function(v) S.CoinMagnet = v end})

local TrollTargetDropdown = S_Trolls:AddLabel("Select Target"):AddDropdown({
    Default = "None", Values = {"None"}, Callback = function(v) S.TrollTarget = v; onTrollingChange() end
})
task.spawn(function()
    while true do task.wait(3); pcall(function()
        local tbl = {"None"}; for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then table.insert(tbl, p.Name) end end
        TrollTargetDropdown:Refresh(tbl)
    end) end
end)
S_Trolls:AddLabel("Trolling Mode"):AddDropdown({
    Default = "Off", Values = {"Off", "Jerk Mode", "Sit on Head", "Dance Nearby", "Stand Nearby", "Follow", "Climb"},
    Callback = function(v) S.TrollMode = v; onTrollingChange() end
})

S_Premium:AddLabel("Smart Auto-Play Bot"):AddToggle({Default = false, Callback = function(v) S.SmartAutoPlay = v end})
S_Premium:AddLabel("Auto Unbox Crates"):AddToggle({Default = false, Callback = function(v) S.AutoUnbox = v end})
S_Premium:AddLabel("Role Odds HUD"):AddToggle({Default = false, Callback = function(v) S.RoleOdds = v end})
S_Premium:AddLabel("Realtime Player HUD"):AddToggle({Default = false, Callback = function(v) S.PlayerTracker = v end})
S_Premium:AddLabel("Show Mobile GUI Panel"):AddToggle({Default = false, Callback = function(v) S.MobileMenuEnabled = v; mainFrame.Visible = v end})
S_Premium:AddButton({Icon = 'shield-alert', Name = "🛑 EMERGENCY PANIC", Callback = ActivatePanic})

-- == SETTINGS ==
window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({Default = 'Insert', Callback = function(v) window.Keybind = v end})
window.UserSettings:AddLabel('Menu Scale'):AddDropdown({Default = "Default", Values = {"Default", 'Large', 'Mobile', 'Small'}, Callback = function(v) window:SetSize(NeverLose.Scales[v]) end})
window.UserSettings:AddButton({Icon = 'discord', Name = 'Copy Discord Invite', Callback = function() setclipboard("https://discord.gg/kithub") end})

Notification.new({Title = "KIT HUB", Content = "KIT HUB Master Script Loaded!", Duration = 8})
