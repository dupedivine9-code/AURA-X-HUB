--========================================================
-- AURA X | CRIMSON GLASS V8 - FEATURE MERGE
-- Enhanced Hollow Purple Intro | Sharp Premium A Emblem
-- Standalone UI Preview
--========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CONFIG
local SOUND_ID = "rbxassetid://139276942590722"
local PURPLE = Color3.fromRGB(170, 65, 255)
local BLUE = Color3.fromRGB(40, 120, 255)
local RED = Color3.fromRGB(255, 40, 75)
local WHITE = Color3.fromRGB(255, 245, 255)

local old = PlayerGui:FindFirstChild("AURA_X_CRIMSON")
if old then old:Destroy() end

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local function Stroke(parent, color, thickness, transparency)
    return New("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, parent)
end

local function Gradient(parent, colors, rotation)
    local points = {}
    for i, color in ipairs(colors) do
        points[#points + 1] = ColorSequenceKeypoint.new(
            (i - 1) / math.max(#colors - 1, 1), color
        )
    end
    return New("UIGradient", {
        Color = ColorSequence.new(points),
        Rotation = rotation or 45
    }, parent)
end

local function Play(object, duration, properties, style, direction)
    local tween = TweenService:Create(object, TweenInfo.new(
        duration,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    ), properties)
    tween:Play()
    return tween
end

local Gui = New("ScreenGui", {
    Name = "AURA_X_CRIMSON",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

--========================================================
-- INTRO
--========================================================
local Intro = New("Frame", {
    Name = "HollowPurpleIntro",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(3, 2, 9),
    BorderSizePixel = 0,
    ZIndex = 100
}, Gui)

local IntroTitle = New("TextLabel", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .20),
    Size = UDim2.new(.9, 0, 0, 38),
    BackgroundTransparency = 1,
    Text = "CURSED TECHNIQUE",
    TextColor3 = Color3.fromRGB(210, 185, 255),
    TextSize = 15,
    Font = Enum.Font.GothamBlack,
    TextTransparency = 1,
    ZIndex = 110
}, Intro)

local IntroSubtitle = New("TextLabel", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .27),
    Size = UDim2.new(.95, 0, 0, 25),
    BackgroundTransparency = 1,
    Text = "REVERSAL RED  ×  LAPSE BLUE",
    TextColor3 = Color3.fromRGB(165, 145, 220),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextTransparency = 1,
    ZIndex = 110
}, Intro)

local function MakeOrb(color, position, size)
    local orb = New("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = position,
        Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = color,
        BackgroundTransparency = .08,
        BorderSizePixel = 0,
        ZIndex = 104
    }, Intro)
    Corner(orb, 100)
    Stroke(orb, color, 2.5, .08)

    local glow = New("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .5),
        Size = UDim2.fromScale(1.8, 1.8),
        BackgroundColor3 = color,
        BackgroundTransparency = .78,
        BorderSizePixel = 0,
        ZIndex = 103
    }, orb)
    Corner(glow, 100)

    local core = New("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .5),
        Size = UDim2.fromScale(.38, .38),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = .12,
        BorderSizePixel = 0,
        ZIndex = 105
    }, orb)
    Corner(core, 100)
    return orb
end

local BlueOrb = MakeOrb(BLUE, UDim2.fromScale(.27, .51), 28)
local RedOrb = MakeOrb(RED, UDim2.fromScale(.73, .51), 28)
local PurpleOrb = MakeOrb(PURPLE, UDim2.fromScale(.5, .51), 0)

local PurpleCore = New("Frame", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .5),
    Size = UDim2.fromScale(.48, .48),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = .08,
    BorderSizePixel = 0,
    ZIndex = 106
}, PurpleOrb)
Corner(PurpleCore, 100)

local Rings = {}
for i = 1, 4 do
    local ring = New("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .51),
        Size = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 105
    }, Intro)
    Corner(ring, 100)
    Rings[i] = {
        Frame = ring,
        Stroke = Stroke(ring, PURPLE, i == 1 and 3 or 1.6, .08)
    }
end

local Flash = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(225, 190, 255),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 120
}, Intro)

local PurpleText = New("TextLabel", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .77),
    Size = UDim2.new(.95, 0, 0, 55),
    BackgroundTransparency = 1,
    Text = "HOLLOW PURPLE",
    TextColor3 = WHITE,
    TextSize = 27,
    Font = Enum.Font.GothamBlack,
    TextTransparency = 1,
    ZIndex = 115
}, Intro)

local IntroTag = New("TextLabel", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .85),
    Size = UDim2.new(.9, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "AURA X  •  CRIMSON GLASS",
    TextColor3 = Color3.fromRGB(205, 165, 255),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextTransparency = 1,
    ZIndex = 115
}, Intro)

local Voice = New("Sound", {
    Name = "HollowPurpleVoice",
    SoundId = SOUND_ID,
    Volume = 1,
    PlaybackSpeed = 1
}, Intro)

-- Floating energy particles
local Particles = {}
for i = 1, 22 do
    local dot = New("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(math.random(15, 85) / 100, math.random(30, 75) / 100),
        Size = UDim2.fromOffset(math.random(2, 5), math.random(2, 5)),
        BackgroundColor3 = i % 2 == 0 and BLUE or PURPLE,
        BackgroundTransparency = .15,
        BorderSizePixel = 0,
        ZIndex = 103
    }, Intro)
    Corner(dot, 100)
    Particles[#Particles + 1] = dot
end

--========================================================
-- MAIN MENU SHELL
--========================================================
local Main = New("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .52),
    Size = UDim2.fromOffset(0, 0),
    BackgroundColor3 = Color3.fromRGB(15, 5, 10),
    BackgroundTransparency = .10,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Visible = false,
    ZIndex = 2
}, Gui)
Corner(Main, 18)

local MainBorder = Stroke(Main, Color3.fromRGB(255, 75, 95), 1.5, .15)
local MainGradient = Gradient(Main, {
    Color3.fromRGB(13, 3, 8),
    Color3.fromRGB(52, 7, 19),
    Color3.fromRGB(112, 13, 32),
    Color3.fromRGB(190, 28, 51)
}, 45)

local Shade = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = .58,
    BorderSizePixel = 0,
    ZIndex = 2
}, Main)
Corner(Shade, 18)
Gradient(Shade, {
    Color3.fromRGB(0, 0, 0),
    Color3.fromRGB(0, 0, 0),
    Color3.fromRGB(255, 255, 255)
}, 45)

local RedGlow = New("Frame", {
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.fromScale(1, 1),
    Size = UDim2.fromScale(.75, .75),
    BackgroundColor3 = RED,
    BackgroundTransparency = .72,
    BorderSizePixel = 0,
    ZIndex = 2
}, Main)
Corner(RedGlow, 18)
Gradient(RedGlow, {Color3.fromRGB(255, 255, 255), RED}, 45)

New("Frame", {
    Position = UDim2.fromOffset(1, 1),
    Size = UDim2.new(1, -2, 0, 2),
    BackgroundColor3 = Color3.fromRGB(255, 210, 220),
    BackgroundTransparency = .42,
    BorderSizePixel = 0,
    ZIndex = 8
}, Main)

local Shine = New("Frame", {
    Position = UDim2.new(-.55, 0, -.5, 0),
    Size = UDim2.new(0, 95, 2, 0),
    Rotation = 25,
    BackgroundColor3 = Color3.fromRGB(255, 180, 190),
    BackgroundTransparency = .83,
    BorderSizePixel = 0,
    ZIndex = 7
}, Main)
Gradient(Shine, {
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(255, 95, 115),
    Color3.fromRGB(255, 255, 255)
}, 0)

--========================================================
-- HEADER + PREMIUM A EMBLEM
--========================================================
local Header = New("Frame", {
    Size = UDim2.new(1, 0, 0, 78),
    BackgroundTransparency = 1,
    ZIndex = 10
}, Main)

local LogoBox = New("Frame", {
    Position = UDim2.fromOffset(13, 8),
    Size = UDim2.fromOffset(66, 62),
    BackgroundColor3 = Color3.fromRGB(70, 5, 22),
    BackgroundTransparency = .12,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 11
}, Header)
Corner(LogoBox, 13)
local LogoBorder = Stroke(LogoBox, Color3.fromRGB(255, 100, 120), 1.5, .08)
Gradient(LogoBox, {
    Color3.fromRGB(145, 10, 38),
    Color3.fromRGB(35, 3, 15),
    Color3.fromRGB(105, 8, 29)
}, 135)

local LogoRing = New("Frame", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .5),
    Size = UDim2.fromScale(.90, .90),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 12
}, LogoBox)
Corner(LogoRing, 100)
local LogoRingStroke = Stroke(LogoRing, Color3.fromRGB(255, 115, 145), 1.2, .18)

-- Angular A: two tapered-looking legs, crossbar, inner cut and apex gem
local function ABar(position, size, rotation, color, z)
    local bar = New("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        Position = position,
        Size = size,
        Rotation = rotation,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        ZIndex = z or 14
    }, LogoBox)
    Corner(bar, 2)
    return bar
end

-- Layered angular A: crimson outer strokes + bright inner strokes
ABar(UDim2.fromScale(.37, .52), UDim2.fromOffset(8, 43), 18, Color3.fromRGB(255, 55, 95), 13)
ABar(UDim2.fromScale(.64, .52), UDim2.fromOffset(8, 43), -18, Color3.fromRGB(255, 55, 95), 13)
ABar(UDim2.fromScale(.37, .51), UDim2.fromOffset(3, 39), 18, WHITE, 14)
ABar(UDim2.fromScale(.64, .51), UDim2.fromOffset(3, 39), -18, WHITE, 14)
ABar(UDim2.fromScale(.50, .67), UDim2.fromOffset(22, 4), 0, Color3.fromRGB(255, 85, 120), 15)
ABar(UDim2.fromScale(.50, .67), UDim2.fromOffset(13, 1), 0, WHITE, 16)

local Apex = New("Frame", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .19),
    Size = UDim2.fromOffset(6, 6),
    Rotation = 45,
    BackgroundColor3 = Color3.fromRGB(255, 225, 235),
    BorderSizePixel = 0,
    ZIndex = 16
}, LogoBox)
Corner(Apex, 1)

local LogoShine = New("Frame", {
    Position = UDim2.new(-.5, 0, 0, 0),
    Size = UDim2.new(0, 10, 1, 0),
    Rotation = 15,
    BackgroundColor3 = WHITE,
    BackgroundTransparency = .5,
    BorderSizePixel = 0,
    ZIndex = 17
}, LogoBox)
Gradient(LogoShine, {WHITE, WHITE}, 0)

local Brand = New("TextLabel", {
    Position = UDim2.fromOffset(89, 10),
    Size = UDim2.fromOffset(190, 31),
    BackgroundTransparency = 1,
    Text = "A U R A  X",
    TextColor3 = WHITE,
    TextSize = 21,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12
}, Header)
local BrandGlow = Stroke(Brand, RED, .6, .75)

New("TextLabel", {
    Position = UDim2.fromOffset(91, 42),
    Size = UDim2.fromOffset(190, 16),
    BackgroundTransparency = 1,
    Text = "C R I M S O N   /   P R E M I U M",
    TextColor3 = Color3.fromRGB(255, 130, 145),
    TextSize = 8,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12
}, Header)

local StatusDot = New("Frame", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -59, 0, 30),
    Size = UDim2.fromOffset(6, 6),
    BackgroundColor3 = Color3.fromRGB(255, 85, 100),
    BorderSizePixel = 0,
    ZIndex = 12
}, Header)
Corner(StatusDot, 20)

New("TextLabel", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -68, 0, 24),
    Size = UDim2.fromOffset(48, 18),
    BackgroundTransparency = 1,
    Text = "ONLINE",
    TextColor3 = Color3.fromRGB(255, 175, 185),
    TextSize = 8,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 12
}, Header)

local Close = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -14, 0, 18),
    Size = UDim2.fromOffset(31, 31),
    BackgroundColor3 = Color3.fromRGB(100, 15, 33),
    BackgroundTransparency = .2,
    BorderSizePixel = 0,
    Text = "×",
    TextColor3 = WHITE,
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 15
}, Header)
Corner(Close, 9)
Stroke(Close, Color3.fromRGB(255, 105, 125), 1, .4)

New("Frame", {
    Position = UDim2.new(0, 16, 0, 76),
    Size = UDim2.new(1, -32, 0, 1),
    BackgroundColor3 = Color3.fromRGB(255, 150, 165),
    BackgroundTransparency = .65,
    BorderSizePixel = 0,
    ZIndex = 10
}, Main)

--========================================================
-- SIDEBAR + CONTENT
--========================================================
local Sidebar = New("Frame", {
    Position = UDim2.fromOffset(13, 91),
    Size = UDim2.new(0, 116, 1, -105),
    BackgroundColor3 = Color3.fromRGB(18, 5, 12),
    BackgroundTransparency = .34,
    BorderSizePixel = 0,
    ZIndex = 4
}, Main)
Corner(Sidebar, 12)
Stroke(Sidebar, Color3.fromRGB(255, 105, 125), 1, .72)
Gradient(Sidebar, {Color3.fromRGB(25, 5, 12), Color3.fromRGB(90, 10, 28)}, 135)
New("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
}, Sidebar)
New("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

local Content = New("Frame", {
    Position = UDim2.fromOffset(141, 91),
    Size = UDim2.new(1, -154, 1, -105),
    BackgroundColor3 = Color3.fromRGB(20, 6, 13),
    BackgroundTransparency = .35,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 4
}, Main)
Corner(Content, 12)
Stroke(Content, Color3.fromRGB(255, 115, 135), 1, .73)
Gradient(Content, {Color3.fromRGB(20, 5, 12), Color3.fromRGB(75, 8, 24)}, 135)

--========================================================
-- PAGE SYSTEM
--========================================================
local Pages, Buttons = {}, {}
local ActivePage, ActiveName

local function CreatePage(name, description)
    local page = New("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = RED,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 5
    }, Content)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 15)
    }, page)

    local layout = New("UIListLayout", {
        Padding = UDim.new(0, 11),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 35)
    end)

    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 29),
        BackgroundTransparency = 1,
        Text = name:upper(),
        TextColor3 = WHITE,
        TextSize = 18,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = 6
    }, page)

    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Color3.fromRGB(195, 153, 163),
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        ZIndex = 6
    }, page)

    Pages[name] = page
    return page
end

local function AddCard(page, title, description)
    local card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(55, 10, 25),
        BackgroundTransparency = .25,
        BorderSizePixel = 0,
        LayoutOrder = 3 + #page:GetChildren(),
        ZIndex = 6
    }, page)
    Corner(card, 10)
    Stroke(card, Color3.fromRGB(255, 100, 120), 1, .76)
    Gradient(card, {Color3.fromRGB(80, 12, 31), Color3.fromRGB(28, 6, 15)}, 0)

    New("Frame", {
        Position = UDim2.fromOffset(0, 12),
        Size = UDim2.new(0, 2, 0, 45),
        BackgroundColor3 = RED,
        BorderSizePixel = 0,
        ZIndex = 7
    }, card)

    New("TextLabel", {
        Position = UDim2.fromOffset(13, 11),
        Size = UDim2.new(1, -25, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, card)

    New("TextLabel", {
        Position = UDim2.fromOffset(13, 35),
        Size = UDim2.new(1, -25, 0, 20),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Color3.fromRGB(195, 153, 163),
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, card)
end

local function SwitchPage(name)
    if ActiveName == name then return end
    if ActivePage then ActivePage.Visible = false end

    ActiveName = name
    ActivePage = Pages[name]
    if ActivePage then
        ActivePage.Visible = true
        ActivePage.Position = UDim2.fromOffset(15, 0)
        Play(ActivePage, .25, {Position = UDim2.fromOffset(0, 0)})
    end

    for pageName, button in pairs(Buttons) do
        local selected = pageName == name
        Play(button, .18, {
            BackgroundColor3 = selected and Color3.fromRGB(135, 15, 42)
                or Color3.fromRGB(35, 8, 17)
        })
        button.TextColor3 = selected and WHITE or Color3.fromRGB(195, 153, 163)
    end
end

local function AddTab(name, symbol)
    local button = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(35, 8, 17),
        BackgroundTransparency = .12,
        BorderSizePixel = 0,
        Text = "   " .. symbol .. "    " .. name,
        TextColor3 = Color3.fromRGB(195, 153, 163),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        ZIndex = 6
    }, Sidebar)
    Corner(button, 8)
    Buttons[name] = button
    button.MouseButton1Click:Connect(function() SwitchPage(name) end)
    button.MouseEnter:Connect(function()
        if ActiveName ~= name then
            Play(button, .15, {BackgroundColor3 = Color3.fromRGB(80, 12, 29)})
        end
    end)
    button.MouseLeave:Connect(function()
        if ActiveName ~= name then
            Play(button, .15, {BackgroundColor3 = Color3.fromRGB(35, 8, 17)})
        end
    end)
end

local Home = CreatePage("Home", "WELCOME TO THE AURA X EXPERIENCE")
AddCard(Home, "CRIMSON GLASS", "A new premium interface experience.")
AddCard(Home, "VISUAL ENGINE", "Animated lighting and glass surfaces.")
AddCard(Home, "INTERFACE STATUS", "All visual components are active.")

local Combat = CreatePage("Combat", "COMBAT CONTROL CENTER")
AddCard(Combat, "AURA X COMBAT HUB", "Touch Fling • God Mode • Anti-Fling • TP Player")

local Visuals = CreatePage("Visuals", "VISUAL CUSTOMIZATION")
AddCard(Visuals, "VISUAL SETTINGS", "Your visual controls can go here.")
AddCard(Visuals, "FEATURE SLOT", "Ready for feature integration.")

local Settings = CreatePage("Settings", "PERSONALIZE YOUR EXPERIENCE")
AddCard(Settings, "CRIMSON THEME", "Dark crimson to bright red gradient.")
AddCard(Settings, "ANIMATION SYSTEM", "Premium motion effects enabled.")

AddTab("Home", "◆")
AddTab("Combat", "⚔")
AddTab("Visuals", "◈")

AddTab("Settings", "⚙")
SwitchPage("Home")

--========================================================
-- IMPORTED COMBAT FEATURES (from uploaded AuraX-V7.lua)
-- Live Monitor, WalkSpeed, Jump Power and Reset Movement
-- are intentionally excluded.
--========================================================
local combatEnabled = {
    fling = false,
    god = false,
    antiFling = false
}
local selectedTarget = nil
local godSaved = nil
local antiFlingOriginals = {}
local antiFlingConnections = {}

local function makeCombatToggle(title, subtitle, key, callback)
    local card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 72),
        LayoutOrder = 100 + ({fling = 1, god = 2, antiFling = 3})[key],
        BackgroundColor3 = Color3.fromRGB(55, 10, 25),
        BackgroundTransparency = .18,
        BorderSizePixel = 0,
        ZIndex = 6
    }, Combat)
    Corner(card, 10)
    Stroke(card, Color3.fromRGB(255, 100, 120), 1, .72)
    Gradient(card, {Color3.fromRGB(88, 12, 32), Color3.fromRGB(28, 6, 15)}, 0)

    New("TextLabel", {
        Position = UDim2.fromOffset(13, 8),
        Size = UDim2.new(1, -92, 0, 22),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        TextSize = 10,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, card)

    New("TextLabel", {
        Position = UDim2.fromOffset(13, 35),
        Size = UDim2.new(1, -92, 0, 25),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Color3.fromRGB(195, 153, 163),
        TextSize = 8,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, card)

    local button = New("TextButton", {
        AnchorPoint = Vector2.new(1, .5),
        Position = UDim2.new(1, -10, .5, 0),
        Size = UDim2.fromOffset(58, 28),
        BackgroundColor3 = Color3.fromRGB(75, 20, 34),
        BorderSizePixel = 0,
        Text = "OFF",
        TextColor3 = WHITE,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 8
    }, card)
    Corner(button, 8)
    Stroke(button, RED, 1, .35)

    local enabled = false
    button.Activated:Connect(function()
        enabled = not enabled
        combatEnabled[key] = enabled
        button.Text = enabled and "ON" or "OFF"
        Play(button, .16, {
            BackgroundColor3 = enabled
                and Color3.fromRGB(155, 15, 48)
                or Color3.fromRGB(75, 20, 34)
        })
        callback(enabled)
    end)
end

-- God Mode: local Humanoid health override; game/server may reject it.
local godToken = 0
local function setGodMode(on)
    combatEnabled.god = on
    godToken += 1
    local token = godToken
    if not on then
        if godSaved and godSaved.humanoid and godSaved.humanoid.Parent then
            godSaved.humanoid.MaxHealth = godSaved.maxHealth
            godSaved.humanoid.Health = math.min(godSaved.health, godSaved.maxHealth)
        end
        godSaved = nil
        return
    end
    task.spawn(function()
        while combatEnabled.god and godToken == token and Gui.Parent do
            local character = Player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if not godSaved or godSaved.humanoid ~= humanoid then
                    godSaved = {
                        humanoid = humanoid,
                        maxHealth = humanoid.MaxHealth,
                        health = humanoid.Health
                    }
                end
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

-- Touch Fling: applies extreme local character velocity; network ownership/game rules
-- determine whether other clients observe any effect.
local flingLoopToken = 0
local function setTouchFling(on)
    combatEnabled.fling = on
    flingLoopToken += 1
    local token = flingLoopToken
    if not on then return end
    task.spawn(function()
        local pulse = .1
        while combatEnabled.fling and flingLoopToken == token and Gui.Parent do
            RunService.Heartbeat:Wait()
            local character = Player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                local velocity = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity =
                    velocity * 100000 + Vector3.new(0, 100000, 0)
                RunService.RenderStepped:Wait()
                if root.Parent then
                    root.AssemblyLinearVelocity = velocity + Vector3.new(0, pulse, 0)
                end
                pulse = -pulse
            end
        end
    end)
end

-- Anti-Fling: disable collision on other character parts locally while enabled,
-- then restore their original collision states when switched off.
local function applyAntiFlingToCharacter(character)
    if not character or character == Player.Character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if antiFlingOriginals[descendant] == nil then
                antiFlingOriginals[descendant] = descendant.CanCollide
            end
            descendant.CanCollide = false
        end
    end
end

local function restoreAntiFling()
    for part, original in pairs(antiFlingOriginals) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end
    table.clear(antiFlingOriginals)
end

local function setAntiFling(on)
    combatEnabled.antiFling = on
    if not on then
        restoreAntiFling()
        return
    end
    task.spawn(function()
        while combatEnabled.antiFling and Gui.Parent do
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= Player and other.Character then
                    applyAntiFlingToCharacter(other.Character)
                end
            end
            task.wait(.35)
        end
    end)
end

makeCombatToggle("⚡  TOUCH FLING", "Toggle the local fling velocity routine", "fling", setTouchFling)
makeCombatToggle("👑  GOD MODE", "Local health override (game dependent)", "god", setGodMode)
makeCombatToggle("🛡️  ANTI-FLING", "Locally disable other characters' collision", "antiFling", setAntiFling)

-- TP PLAYER: choose a player and follow their root until UNSTICK is pressed.
local tpCard = New("Frame", {
    LayoutOrder = 104,
    Size = UDim2.new(1, 0, 0, 112),
    BackgroundColor3 = Color3.fromRGB(55, 10, 25),
    BackgroundTransparency = .18,
    BorderSizePixel = 0,
    ZIndex = 6
}, Combat)
Corner(tpCard, 10)
Stroke(tpCard, Color3.fromRGB(255, 100, 120), 1, .72)
Gradient(tpCard, {Color3.fromRGB(88, 12, 32), Color3.fromRGB(28, 6, 15)}, 0)

New("TextLabel", {
    Position = UDim2.fromOffset(13, 8),
    Size = UDim2.new(1, -26, 0, 20),
    BackgroundTransparency = 1,
    Text = "📍  TP PLAYER / TARGET SELECTOR",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7
}, tpCard)

local targetDropdown = New("TextButton", {
    Position = UDim2.fromOffset(10, 37),
    Size = UDim2.new(1, -100, 0, 30),
    BackgroundColor3 = Color3.fromRGB(78, 12, 31),
    BorderSizePixel = 0,
    Text = "Select Player  ▾",
    TextColor3 = WHITE,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 8
}, tpCard)
Corner(targetDropdown, 7)
Stroke(targetDropdown, RED, 1, .4)

local unstickButton = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -10, 0, 37),
    Size = UDim2.fromOffset(78, 30),
    BackgroundColor3 = Color3.fromRGB(130, 12, 38),
    BorderSizePixel = 0,
    Text = "UNSTICK",
    TextColor3 = WHITE,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 8
}, tpCard)
Corner(unstickButton, 7)

local targetList = New("ScrollingFrame", {
    Position = UDim2.fromOffset(10, 73),
    Size = UDim2.new(1, -20, 0, 0),
    BackgroundColor3 = Color3.fromRGB(24, 5, 12),
    BackgroundTransparency = .1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = RED,
    CanvasSize = UDim2.fromOffset(0, 0),
    Visible = false,
    ZIndex = 9
}, tpCard)
Corner(targetList, 7)
local targetLayout = New("UIListLayout", {
    Padding = UDim.new(0, 3),
    SortOrder = Enum.SortOrder.Name
}, targetList)
targetLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    targetList.CanvasSize = UDim2.fromOffset(0, targetLayout.AbsoluteContentSize.Y + 6)
end)

local dropdownOpen = false
local function refreshTargets()
    for _, child in ipairs(targetList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= Player then
            local item = New("TextButton", {
                Name = targetPlayer.Name,
                Size = UDim2.new(1, -4, 0, 27),
                BackgroundColor3 = Color3.fromRGB(68, 10, 27),
                BorderSizePixel = 0,
                Text = "  " .. targetPlayer.Name,
                TextColor3 = WHITE,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 10
            }, targetList)
            Corner(item, 5)
            item.Activated:Connect(function()
                selectedTarget = targetPlayer
                targetDropdown.Text = targetPlayer.Name
                dropdownOpen = false
                targetList.Visible = false
                tpCard.Size = UDim2.new(1, 0, 0, 112)
            end)
        end
    end
end

targetDropdown.Activated:Connect(function()
    dropdownOpen = not dropdownOpen
    targetList.Visible = dropdownOpen
    targetList.Size = UDim2.new(1, -20, 0, dropdownOpen and 100 or 0)
    tpCard.Size = UDim2.new(1, 0, 0, dropdownOpen and 220 or 112)
    if dropdownOpen then refreshTargets() end
end)

unstickButton.Activated:Connect(function()
    selectedTarget = nil
    targetDropdown.Text = "Select Player  ▾"