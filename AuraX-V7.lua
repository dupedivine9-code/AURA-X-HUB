--========================================================
-- AURA X V6.5 | PREMIUM SHINE EDITION (WITH COMBAT HUB)
-- Electric Violet | Transparent Glass | Mobile + PC
-- Fixed Header | Diagonal Shine | Live Monitor
--========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CLEANUP
local Old = PlayerGui:FindFirstChild("AuraX")
if Old then Old:Destroy() end

--========================================================
-- THEME
--========================================================

local C = {
    Base = Color3.fromRGB(13,10,22),
    Glass = Color3.fromRGB(25,17,42),
    Surface = Color3.fromRGB(39,25,65),
    Surface2 = Color3.fromRGB(55,35,88),

    Lavender = Color3.fromRGB(221,207,255),
    Purple = Color3.fromRGB(94,30,241),
    Glow = Color3.fromRGB(94,30,241),
    LightPurple = Color3.fromRGB(164,126,255),

    White = Color3.fromRGB(250,247,255),
    Muted = Color3.fromRGB(163,148,190),
    Green = Color3.fromRGB(130,205,166),
    Red = Color3.fromRGB(255,100,125)
}

local FONT = Enum.Font.SciFi
local BOLD = Enum.Font.GothamBold

--========================================================
-- HELPERS
--========================================================

local function tw(obj,duration,properties,style,direction)
    if not obj or not obj.Parent then return end

    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or .25,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )

    t:Play()
    return t
end

local function new(class,parent,properties)
    local obj = Instance.new(class)

    for k,v in pairs(properties or {}) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

local function round(obj,r)
    new("UICorner",obj,{
        CornerRadius = UDim.new(0,r)
    })
end

local function outline(obj,color,transparency,thickness)
    return new("UIStroke",obj,{
        Color = color or C.Lavender,
        Transparency = transparency or .7,
        Thickness = thickness or 1
    })
end

local function label(parent,value,size,color,font)
    return new("TextLabel",parent,{
        BackgroundTransparency = 1,
        Text = value,
        TextSize = size or 12,
        TextColor3 = color or C.White,
        Font = font or FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = false
    })
end

local function formatTime(seconds)
    local n = math.floor(seconds)
    return string.format("%02d:%02d",math.floor(n/60),n%60)
end

local function formatHP(val)
    if val ~= val then return "NaN" end
    if val == math.huge then return "INF" end
    return tostring(math.floor(val))
end

--========================================================
-- SCREEN GUI
--========================================================

local GUI = new("ScreenGui",PlayerGui,{
    Name = "AuraX",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100
})

--========================================================
-- LOGO
--========================================================

local function CreateLogo(parent,size)
    local holder = new("Frame",parent,{
        Name = "AuraSymbol",
        Size = UDim2.fromOffset(size,size),
        BackgroundTransparency = 1
    })

    local halo = new("Frame",holder,{
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),
        Size = UDim2.fromScale(.95,.95),
        BackgroundColor3 = C.Glow,
        BackgroundTransparency = .84
    })
    round(halo,100)

    local ring = new("Frame",holder,{
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),
        Size = UDim2.fromScale(.85,.85),
        BackgroundTransparency = 1
    })
    round(ring,100)
    outline(ring,C.Lavender,.08,1.5)

    local inner = new("Frame",holder,{
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),
        Size = UDim2.fromScale(.59,.59),
        BackgroundTransparency = 1
    })
    round(inner,100)
    outline(inner,C.Purple,.12,1)

    local core = new("Frame",holder,{
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),
        Size = UDim2.fromScale(.31,.31),
        BackgroundColor3 = C.Lavender
    })
    round(core,100)

    new("UIGradient",core,{
        Rotation = 45,
        Color = ColorSequence.new(C.White,C.Purple)
    })

    local shards = {}

    for i=1,4 do
        local shard = new("Frame",holder,{
            AnchorPoint = Vector2.new(.5,.5),
            Position = UDim2.fromScale(.5,.5),
            Size = UDim2.fromScale(.10,.34),
            BackgroundColor3 = C.LightPurple,
            Rotation = (i-1)*90
        })
        round(shard,5)
        shards[i] = shard
    end

    task.spawn(function()
        while holder.Parent and GUI.Parent do
            local t = tw(ring,8,{
                Rotation = ring.Rotation+360
            },Enum.EasingStyle.Linear)
            if not t then break end
            t.Completed:Wait()
        end
    end)

    task.spawn(function()
        while holder.Parent and GUI.Parent do
            local t = tw(inner,12,{
                Rotation = inner.Rotation-360
            },Enum.EasingStyle.Linear)
            if not t then break end
            t.Completed:Wait()
        end
    end)

    task.spawn(function()
        while holder.Parent and GUI.Parent do
            for i,s in ipairs(shards) do
                tw(s,4,{Rotation=(i-1)*90+120},Enum.EasingStyle.Sine)
            end
            task.wait(4)
            if not holder.Parent then break end

            for i,s in ipairs(shards) do
                tw(s,4,{Rotation=(i-1)*90+240},Enum.EasingStyle.Sine)
            end
            task.wait(4)
        end
    end)

    task.spawn(function()
        while holder.Parent and GUI.Parent do
            tw(core,.9,{Size=UDim2.fromScale(.37,.37)},Enum.EasingStyle.Sine)
            task.wait(.9)
            if not holder.Parent then break end

            tw(core,.9,{Size=UDim2.fromScale(.31,.31)},Enum.EasingStyle.Sine)
            task.wait(.9)
        end
    end)

    return holder
end

--========================================================
-- STARTUP
--========================================================

local Intro = new("Frame",GUI,{
    Name = "Startup",
    Size = UDim2.fromScale(1,1),
    BackgroundColor3 = C.Base,
    BorderSizePixel = 0,
    ZIndex = 100,
    ClipsDescendants = true
})

new("UIGradient",Intro,{
    Rotation = 45,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.Base),
        ColorSequenceKeypoint.new(.5,Color3.fromRGB(38,20,72)),
        ColorSequenceKeypoint.new(1,C.Base)
    })
})

local IntroLogoHolder = new("Frame",Intro,{
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.fromScale(.5,.42),
    Size = UDim2.fromOffset(100,100),
    BackgroundTransparency = 1,
    ZIndex = 102
})

local IntroLogo = CreateLogo(IntroLogoHolder,100)
IntroLogo.Size = UDim2.fromScale(1,1)

local IntroTitle = label(Intro,"A U R A   X",23,C.Lavender,FONT)
IntroTitle.AnchorPoint = Vector2.new(.5,.5)
IntroTitle.Position = UDim2.fromScale(.5,.61)
IntroTitle.Size = UDim2.fromOffset(300,35)
IntroTitle.TextXAlignment = Enum.TextXAlignment.Center
IntroTitle.ZIndex = 102

local IntroSub = label(Intro,"INITIALIZING INTERFACE",10,C.Muted,FONT)
IntroSub.AnchorPoint = Vector2.new(.5,.5)
IntroSub.Position = UDim2.fromScale(.5,.68)
IntroSub.Size = UDim2.fromOffset(300,20)
IntroSub.TextXAlignment = Enum.TextXAlignment.Center
IntroSub.ZIndex = 102

local Track = new("Frame",Intro,{
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.fromScale(.5,.75),
    Size = UDim2.fromOffset(210,3),
    BackgroundColor3 = C.Surface2,
    BorderSizePixel = 0,
    ZIndex = 102
})
round(Track,10)

local Fill = new("Frame",Track,{
    Size = UDim2.new(0,0,1,0),
    BackgroundColor3 = C.Purple,
    BorderSizePixel = 0,
    ZIndex = 103
})
round(Fill,10)

local Percent = label(Intro,"0%",9,C.Muted,FONT)
Percent.AnchorPoint = Vector2.new(.5,.5)
Percent.Position = UDim2.fromScale(.5,.79)
Percent.Size = UDim2.fromOffset(100,18)
Percent.TextXAlignment = Enum.TextXAlignment.Center
Percent.ZIndex = 102

local Rings = {}

for i=1,3 do
    local ring = new("Frame",Intro,{
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.42),
        Size = UDim2.fromOffset(90+i*45,90+i*45),
        BackgroundTransparency = 1,
        ZIndex = 101
    })
    round(ring,100)
    outline(ring,C.Purple,.35,1)
    Rings[i] = ring
end

local function RunStartup()
    for i,ring in ipairs(Rings) do
        ring.Size = UDim2.fromOffset(0,0)
        tw(ring,.7,{
            Size = UDim2.fromOffset(90+i*45,90+i*45)
        },Enum.EasingStyle.Quart)
    end

    tw(IntroLogoHolder,.6,{
        Size = UDim2.fromOffset(110,110)
    },Enum.EasingStyle.Back)

    local messages = {
        "INITIALIZING INTERFACE",
        "CALIBRATING ENERGY CORE",
        "LOADING GLASS SYSTEM",
        "AURA X ONLINE"
    }

    for i=1,4 do
        IntroSub.Text = messages[i]
        tw(Fill,.55,{Size=UDim2.new(i/4,0,1,0)})
        Percent.Text = tostring(i*25).."%"
        task.wait(.55)
    end

    tw(IntroTitle,.3,{TextColor3=C.White})
    task.wait(.25)
    tw(Intro,.4,{BackgroundTransparency=1})

    for _,obj in ipairs(Intro:GetDescendants()) do
        if obj:IsA("GuiObject") then
            local props = {}

            if obj:IsA("TextLabel") then
                props.TextTransparency = 1
            elseif obj:IsA("Frame") then
                props.BackgroundTransparency = 1
            end

            if next(props) then tw(obj,.3,props) end
        end
    end

    task.wait(.45)
    Intro:Destroy()
end

--========================================================
-- MAIN WINDOW
--========================================================

local Root = new("Frame",GUI,{
    Name = "Window",
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.fromScale(.5,.5),
    Size = UDim2.fromOffset(390,330),
    BackgroundTransparency = 1,
    Visible = false
})

local Glow = new("Frame",Root,{
    Position = UDim2.fromOffset(-14,-14),
    Size = UDim2.new(1,28,1,28),
    BackgroundColor3 = C.Glow,
    BackgroundTransparency = .86,
    BorderSizePixel = 0,
    ZIndex = 0
})
round(Glow,25)

local Main = new("Frame",Root,{
    Size = UDim2.fromScale(1,1),
    BackgroundColor3 = C.Base,
    BackgroundTransparency = .28,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 1
})
round(Main,20)

local MainStroke = outline(Main,C.Purple,.12,1.4)

local BorderGradient = new("UIGradient",MainStroke,{
    Color = ColorSequence.new(C.Lavender,C.Purple)
})

task.spawn(function()
    while GUI.Parent do
        local t = tw(BorderGradient,5,{Rotation=180},Enum.EasingStyle.Linear)
        if not t then break end
        t.Completed:Wait()

        if not GUI.Parent then break end

        local t2 = tw(BorderGradient,5,{Rotation=360},Enum.EasingStyle.Linear)
        if not t2 then break end
        t2.Completed:Wait()
    end
end)

new("UIGradient",Main,{
    Rotation = 135,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(44,27,73)),
        ColorSequenceKeypoint.new(.5,Color3.fromRGB(19,13,31)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(31,19,50))
    })
})

--========================================================
-- PREMIUM DIAGONAL SHINE
--========================================================

local ShineLayer = new("Frame",Main,{
    Name = "PremiumShineLayer",
    Size = UDim2.fromScale(1,1),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 2
})

local ShineGlow = new("Frame",ShineLayer,{
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(-.35,0,-.35,0),
    Size = UDim2.new(.42,0,1.8,0),
    Rotation = 35,
    BackgroundColor3 = C.Lavender,
    BackgroundTransparency = .94,
    BorderSizePixel = 0,
    ZIndex = 2
})

new("UIGradient",ShineGlow,{
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(.5,.25),
        NumberSequenceKeypoint.new(1,1)
    })
})

local Shine = new("Frame",ShineLayer,{
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(-.35,0,-.35,0),
    Size = UDim2.new(.16,0,1.8,0),
    Rotation = 35,
    BackgroundColor3 = C.White,
    BackgroundTransparency = .90,
    BorderSizePixel = 0,
    ZIndex = 3
})

new("UIGradient",Shine,{
    Color = ColorSequence.new(C.Lavender,C.White),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(.5,.15),
        NumberSequenceKeypoint.new(1,1)
    })
})

local ShineSecondary = new("Frame",ShineLayer,{
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(-.55,0,-.45,0),
    Size = UDim2.new(.07,0,1.8,0),
    Rotation = 35,
    BackgroundColor3 = C.LightPurple,
    BackgroundTransparency = .88,
    BorderSizePixel = 0,
    ZIndex = 2
})

new("UIGradient",ShineSecondary,{
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(.5,.2),
        NumberSequenceKeypoint.new(1,1)
    })
})

task.spawn(function()
    task.wait(1)

    while GUI.Parent and ShineLayer.Parent do
        Shine.Position = UDim2.new(-.35,0,-.35,0)
        ShineGlow.Position = UDim2.new(-.35,0,-.35,0)
        ShineSecondary.Position = UDim2.new(-.55,0,-.45,0)

        local t = tw(Shine,3.2,{
            Position = UDim2.new(1.35,0,1.35,0)
        },Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)

        tw(ShineGlow,3.2,{
            Position = UDim2.new(1.35,0,1.35,0)
        },Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)

        tw(ShineSecondary,3.2,{
            Position = UDim2.new(1.15,0,1.25,0)
        },Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)

        if not t then break end
        t.Completed:Wait()

        if not GUI.Parent then break end
        task.wait(2.2)
    end
end)

--========================================================
-- HEADER | FIXED LAYOUT
--========================================================

local Header = new("Frame",Main,{
    Position = UDim2.fromOffset(14,10),
    Size = UDim2.new(1,-28,0,49),
    BackgroundTransparency = 1,
    ZIndex = 4
})

local BrandLogo = new("Frame",Header,{
    Position = UDim2.fromOffset(0,5),
    Size = UDim2.fromOffset(38,38),
    BackgroundColor3 = C.Purple,
    BackgroundTransparency = .48
})
round(BrandLogo,11)
outline(BrandLogo,C.Lavender,.28)

local BrandSymbol = CreateLogo(BrandLogo,34)
BrandSymbol.Position = UDim2.fromOffset(2,2)

local Brand = label(Header,"AURA X",16,C.White,BOLD)
Brand.Position = UDim2.fromOffset(48,4)
Brand.Size = UDim2.fromOffset(105,21)

local Sub = label(Header,"SCI-FI INTERFACE",9,C.Muted,FONT)
Sub.Position = UDim2.fromOffset(49,26)
Sub.Size = UDim2.fromOffset(110,15)

local Status = new("Frame",Header,{
    Position = UDim2.new(1,-145,0,11),
    Size = UDim2.fromOffset(65,24),
    BackgroundColor3 = C.Green,
    BackgroundTransparency = .88,
    ZIndex = 5
})
round(Status,20)

local StatusDot = new("Frame",Status,{
    Position = UDim2.fromOffset(9,9),
    Size = UDim2.fromOffset(6,6),
    BackgroundColor3 = C.Green
})
round(StatusDot,10)

local StatusText = label(Status,"READY",8,C.Green,BOLD)
StatusText.Position = UDim2.fromOffset(20,0)
StatusText.Size = UDim2.fromOffset(40,24)

local function headerButton(symbol,x)
    local b = new("TextButton",Header,{
        Position = UDim2.new(1,x,0,8),
        Size = UDim2.fromOffset(29,29),
        BackgroundColor3 = C.Surface,
        BackgroundTransparency = .28,
        Text = symbol,
        TextColor3 = C.Lavender,
        TextSize = 16,
        Font = BOLD,
        AutoButtonColor = false,
        ZIndex = 6
    })
    round(b,9)
    outline(b,C.Purple,.55)
    return b
end

local Min = headerButton("−",-70)
local Close = headerButton("×",-35)

new("Frame",Main,{
    Position = UDim2.fromOffset(15,68),
    Size = UDim2.new(1,-30,0,1),
    BackgroundColor3 = C.Purple,
    BackgroundTransparency = .55,
    BorderSizePixel = 0,
    ZIndex = 4
})

--========================================================
-- DRAGGING
--========================================================

local dragging = false
local dragStart
local startPosition

local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Root.Position
    end
end

BrandLogo.InputBegan:Connect(startDrag)
Brand.InputBegan:Connect(startDrag)
Sub.InputBegan:Connect(startDrag)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local d = input.Position-dragStart

        Root.Position = UDim2.new(
            startPosition.X.Scale,startPosition.X.Offset+d.X,
            startPosition.Y.Scale,startPosition.Y.Offset+d.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--========================================================
-- BODY / SIDEBAR
--========================================================

local Body = new("Frame",Main,{
    Position = UDim2.fromOffset(14,80),
    Size = UDim2.new(1,-28,1,-94),
    BackgroundTransparency = 1,
    ZIndex = 4
})

local Sidebar = new("Frame",Body,{
    Size = UDim2.new(0,91,1,0),
    BackgroundColor3 = C.Surface,
    BackgroundTransparency = .48,
    BorderSizePixel = 0
})
round(Sidebar,13)
outline(Sidebar,C.LightPurple,.65)

local SideTitle = label(Sidebar,"NAVIGATION",8,C.Muted,BOLD)
SideTitle.Position = UDim2.fromOffset(10,11)
SideTitle.Size = UDim2.fromOffset(75,18)

local Content = new("Frame",Body,{
    Position = UDim2.fromOffset(102,0),
    Size = UDim2.new(1,-102,1,0),
    BackgroundTransparency = 1,
    ClipsDescendants = true
})

local Pages = {}
local Buttons = {}
local ActivePage
local animationEnabled = true

local function createPage(name)
    local page = new("ScrollingFrame",Content,{
        Name = name,
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = C.Purple,
        CanvasSize = UDim2.fromOffset(0,0),
        Visible = false
    })

    new("UIPadding",page,{
        PaddingTop = UDim.new(0,3),
        PaddingBottom = UDim.new(0,10),
        PaddingLeft = UDim.new(0,2),
        PaddingRight = UDim.new(0,7)
    })

    local layout = new("UIListLayout",page,{
        Padding = UDim.new(0,9),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+20)
    end)

    Pages[name] = page
    return page
end

--========================================================
-- BUTTON EFFECTS
--========================================================

local function AddButtonEffect(b)
    if not b:IsA("TextButton") then return end
    if b:GetAttribute("AuraEffectAdded") then return end

    b:SetAttribute("AuraEffectAdded",true)

    local scale = new("UIScale",b,{Scale=1})
    local glow = outline(b,C.Purple,.45,1.5)
    local pressed = false

    local function press()
        if pressed or not animationEnabled then return end
        pressed = true

        tw(scale,.09,{Scale=.93},Enum.EasingStyle.Quad)
        tw(glow,.12,{Transparency=.05,Thickness=2.8})
    end

    local function release()
        if not pressed then return end
        pressed = false

        tw(scale,.22,{Scale=1},Enum.EasingStyle.Back)
        tw(glow,.22,{Transparency=.45,Thickness=1.5})
    end

    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            press()
        end
    end)

    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            release()
        end
    end)

    b.Activated:Connect(function()
        if not animationEnabled or pressed then return end
        press()
        task.delay(.12,release)
    end)

    b.MouseEnter:Connect(function()
        if not animationEnabled then return end
        tw(glow,.18,{Transparency=.05,Thickness=2.4})
        tw(scale,.18,{Scale=1.025})
    end)

    b.MouseLeave:Connect(function()
        release()
        tw(glow,.18,{Transparency=.45,Thickness=1.5})
        tw(scale,.18,{Scale=1})
    end)
end

--========================================================
-- UI COMPONENTS
--========================================================

local function section(page,title,description)
    local f = new("Frame",page,{
        Size = UDim2.new(1,0,0,43),
        BackgroundTransparency = 1
    })

    local t = label(f,title,15,C.White,FONT)
    t.Size = UDim2.new(1,0,0,23)

    local d = label(f,description,9,C.Muted,FONT)
    d.Position = UDim2.fromOffset(0,24)
    d.Size = UDim2.new(1,0,0,15)

    return f
end

local function hero(page,title,description)
    local f = new("Frame",page,{
        Size = UDim2.new(1,0,0,95),
        BackgroundColor3 = C.Surface2,
        BackgroundTransparency = .48,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })

    round(f,13)
    outline(f,C.LightPurple,.52)

    new("UIGradient",f,{
        Rotation = 25,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(86,48,151)),
            ColorSequenceKeypoint.new(1,C.Surface)
        })
    })

    local orb = new("Frame",f,{
        Size = UDim2.fromOffset(95,95),
        Position = UDim2.new(1,-63,0,-22),
        BackgroundColor3 = C.Purple,
        BackgroundTransparency = .83
    })
    round(orb,100)
    outline(orb,C.Lavender,.55,2)

    local t = label(f,title,13,C.White,FONT)
    t.Position = UDim2.fromOffset(12,17)
    t.Size = UDim2.new(1,-25,0,22)

    local d = label(f,description,9,C.Muted,FONT)
    d.Position = UDim2.fromOffset(12,43)
    d.Size = UDim2.new(1,-22,0,32)
    d.TextWrapped = true

    return f
end

local function stat(parent,title,value)
    local f = new("Frame",parent,{
        Size = UDim2.new(1,0,0,58),
        BackgroundColor3 = C.Surface,
        BackgroundTransparency = .48,
        BorderSizePixel = 0
    })

    round(f,11)
    outline(f,C.LightPurple,.82)

    local t = label(f,title,9,C.Muted,FONT)
    t.Position = UDim2.fromOffset(10,7)
    t.Size = UDim2.new(1,-15,0,16)

    local v = label(f,value,14,C.Lavender,FONT)
    v.Position = UDim2.fromOffset(10,27)
    v.Size = UDim2.new(1,-15,0,20)

    return f,v
end

local function button(parent,text)
    local b = new("TextButton",parent,{
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = C.Surface,
        BackgroundTransparency = .35,
        Text = text,
        TextColor3 = C.Lavender,
        TextSize = 10,
        Font = BOLD,
        AutoButtonColor = false
    })

    round(b,10)
    outline(b,C.Purple,.55)
    return b
end

local function toggle(page,name,callback)
    local f = new("TextButton",page,{
        Size = UDim2.new(1,0,0,43),
        BackgroundColor3 = C.Surface,
        BackgroundTransparency = .48,
        Text = "",
        AutoButtonColor = false
    })

    round(f,10)
    outline(f,C.LightPurple,.78)

    local t = label(f,name,10,C.White,FONT)
    t.Position = UDim2.fromOffset(11,0)
    t.Size = UDim2.new(1,-63,1,0)

    local sw = new("Frame",f,{
        Position = UDim2.new(1,-44,.5,-9),
        Size = UDim2.fromOffset(33,18),
        BackgroundColor3 = C.Surface2
    })
    round(sw,20)

    local dot = new("Frame",sw,{
        Position = UDim2.fromOffset(2,2),
        Size = UDim2.fromOffset(14,14),
        BackgroundColor3 = C.White
    })
    round(dot,20)

    local enabled = false

    local function update()
        tw(sw,.2,{
            BackgroundColor3 = enabled and C.Purple or C.Surface2
        })

        tw(dot,.2,{
            Position = enabled and UDim2.fromOffset(17,2)
                or UDim2.fromOffset(2,2),
            BackgroundColor3 = enabled and C.White or C.Muted
        })
    end

    f.Activated:Connect(function()
        enabled = not enabled
        update()
        if callback then callback(enabled) end
    end)

    return {
        Get = function() return enabled end,
        Set = function(value,fireCallback)
            enabled = value
            update()
            if fireCallback ~= false and callback then
                callback(value)
            end
        end
    }
end

--========================================================
-- CREATE PAGES
--========================================================

local Home = createPage("Home")
local CombatPage = createPage("Combat")
local PlayerPage = createPage("Player")
local Settings = createPage("Settings")

--========================================================
-- NAVIGATION
--========================================================

local function selectPage(name)
    local page = Pages[name]
    if not page or ActivePage == page then return end

    ActivePage = page

    for _,p in pairs(Pages) do
        p.Visible = false
    end

    page.Visible = true
    page.Position = UDim2.fromOffset(10,0)

    if animationEnabled then
        tw(page,.24,{
            Position = UDim2.fromOffset(0,0)
        },Enum.EasingStyle.Quint)
    else
        page.Position = UDim2.fromOffset(0,0)
    end

    for tabName,b in pairs(Buttons) do
        local active = tabName == name

        tw(b,.20,{
            BackgroundColor3 = active and C.Purple or C.Surface2,
            BackgroundTransparency = active and .02 or .58
        })

        b.TextColor3 = active and C.White or C.Muted

        local scale = b:FindFirstChildOfClass("UIScale")
        if scale and animationEnabled then
            tw(scale,.20,{
                Scale = active and 1.04 or 1
            },Enum.EasingStyle.Back)
        end
    end
end

local function createNav(name,symbol,y)
    local b = new("TextButton",Sidebar,{
        Position = UDim2.fromOffset(7,y),
        Size = UDim2.new(1,-14,0,34),
        BackgroundColor3 = C.Surface2,
        BackgroundTransparency = .58,
        Text = symbol.."  "..name,
        TextColor3 = C.Muted,
        TextSize = 10,
        Font = FONT,
        AutoButtonColor = false
    })

    round(b,9)
    Buttons[name] = b

    b.Activated:Connect(function()
        selectPage(name)
    end)
end

createNav("Home","⌂",34)
createNav("Combat","⚡",72)
createNav("Player","◉",110)
createNav("Settings","⚙",148)

new("Frame",Sidebar,{
    Position = UDim2.new(0,10,1,-36),
    Size = UDim2.new(1,-20,0,1),
    BackgroundColor3 = C.Purple,
    BackgroundTransparency = .45
})

local SideFooter = label(Sidebar,"V6.5",8,C.Muted,FONT)
SideFooter.Position = UDim2.new(0,12,1,-28)
SideFooter.Size = UDim2.new(1,-20,0,18)

--========================================================
-- HOME
--========================================================

section(Home,"OVERVIEW","Your personal control center")

hero(Home,"Welcome back, "..Player.DisplayName,
    "Experience the next generation of AURA X.")

local Stats = new("Frame",Home,{
    Size = UDim2.new(1,0,0,64),
    BackgroundTransparency = 1
})

new("UIGridLayout",Stats,{
    CellSize = UDim2.new(.5,-5,1,0),
    CellPadding = UDim2.fromOffset(8,0),
    FillDirectionMaxCells = 2
})

stat(Stats,"INTERFACE","AURA X")
stat(Stats,"VERSION","V6.5")

section(Home,"QUICK CONTROLS","Interface preferences")

toggle(Home,"UI Animations",function(v)
    animationEnabled = v
end)

--========================================================
-- COMBAT LOGIC (GOD MODE, FLING, ANTI-FLING, TP STICK)
--========================================================

-- 1. GOD MODE
local GOD_USE_NAN = false
local godOn = false
local godToken = 0
local godSaved = {}

local function godValue()
    if GOD_USE_NAN then return 0 / 0 end
    return math.huge
end

local function restoreGod()
    local hum = godSaved.hum
    if hum and hum.Parent then
        hum.MaxHealth = godSaved.max or 100
        hum.Health = hum.MaxHealth
    end
    godSaved.hum = nil
    godSaved.max = nil
end

local function setGod(on)
    godOn = on and true or false
    godToken += 1
    local my = godToken
    if not godOn then
        restoreGod()
        return
    end
    task.spawn(function()
        while godOn and godToken == my and GUI.Parent do
            local char = Player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if godSaved.hum ~= hum then
                    local m = hum.MaxHealth
                    godSaved.hum = hum
                    godSaved.max = (m ~= m or m == math.huge) and 100 or m
                end
                local v = godValue()
                hum.MaxHealth = v
                hum.Health = v
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

-- 2. TOUCH FLING
local flingOn = false
local flingRunning = false

local function wantFling() return flingOn and GUI.Parent ~= nil end

local function flingLoop()
    local c, hrp, vel, movel = nil, nil, nil, 0.1
    while wantFling() do
        RunService.Heartbeat:Wait()
        c = Player.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 999999999999999999999999999999 + Vector3.new(0, 9999999999999999999999, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

local function ensureFling()
    if flingRunning then return end
    flingRunning = true
    task.spawn(function()
        flingLoop()
        flingRunning = false
        if wantFling() then ensureFling() end
    end)
end

local function setFling(on)
    flingOn = on and true or false
    if flingOn then ensureFling() end
end

-- 3. ANTI-FLING
local antiflingOn = false
local restoreAntiFling

do
    local RESCAN_INTERVAL = 2
    local originals = {}
    local characterParts = {}
    local characterConns = {}
    local removeCharacter

    local function addCharacter(character)
        if not character or not character:IsA("Model") then return end
        if character == Player.Character then return end
        if characterParts[character] then return end

        local parts = {}
        characterParts[character] = parts
        local function collect(d)
            if d:IsA("BasePart") then parts[#parts + 1] = d end
        end
        for _, d in ipairs(character:GetDescendants()) do collect(d) end

        characterConns[character] = {
            character.DescendantAdded:Connect(collect),
            character.DescendantRemoving:Connect(function(d)
                if d:IsA("BasePart") then
                    local i = table.find(parts, d)
                    if i then table.remove(parts, i) end
                    originals[d] = nil
                end
            end),
            character.AncestryChanged:Connect(function()
                if not character.Parent then removeCharacter(character) end
            end),
        }
    end

    removeCharacter = function(character)
        local conns = characterConns[character]
        if conns then
            for i = 1, #conns do conns[i]:Disconnect() end
            characterConns[character] = nil
        end
        local parts = characterParts[character]
        if parts then
            for i = 1, #parts do originals[parts[i]] = nil end
            characterParts[character] = nil
        end
    end

    local function enforceAntiFling()
        for _, parts in pairs(characterParts) do
            for i = 1, #parts do
                local p = parts[i]
                if p.CanCollide then
                    originals[p] = true
                    p.CanCollide = false
                elseif originals[p] == nil then
                    originals[p] = false
                end
            end
        end
    end

    restoreAntiFling = function()
        for part, orig in pairs(originals) do
            if part.Parent and part.CanCollide ~= orig then part.CanCollide = orig end
        end
        table.clear(originals)
    end

    RunService.Stepped:Connect(function()
        if antiflingOn and GUI.Parent then enforceAntiFling() end
    end)

    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Humanoid") then addCharacter(d.Parent) end
    end
    workspace.DescendantAdded:Connect(function(d)
        if d:IsA("Humanoid") then addCharacter(d.Parent) end
    end)

    task.spawn(function()
        while GUI.Parent do
            task.wait(RESCAN_INTERVAL)
            if not GUI.Parent then break end
            local dead
            for c in pairs(characterParts) do
                if not c.Parent then
                    dead = dead or {}
                    dead[#dead + 1] = c
                end
            end
            if dead then
                for i = 1, #dead do removeCharacter(dead[i]) end
            end
            for _, ch in ipairs(workspace:GetChildren()) do
                if ch:IsA("Model") and ch:FindFirstChildOfClass("Humanoid") then addCharacter(ch) end
            end
        end
    end)
end

--========================================================
-- COMBAT PAGE UI
--========================================================

section(CombatPage,"COMBAT & UTILITY","Fling, protection, and target sticking")

toggle(CombatPage,"⚡  Touch Fling",function(state)
    setFling(state)
end)

toggle(CombatPage,"👑  God Mode",function(state)
    setGod(state)
end)

toggle(CombatPage,"🛡️  Anti-Fling",function(state)
    antiflingOn = state
    if not antiflingOn then restoreAntiFling() end
end)

section(CombatPage,"TP PLAYER","Stick to any player in the server")

local tpOpen = false
local currentTarget = nil
local trackingTarget = nil

local tpCard = new("Frame",CombatPage,{
    Size = UDim2.new(1,0,0,76),
    BackgroundColor3 = C.Surface,
    BackgroundTransparency = .48,
    BorderSizePixel = 0,
    ClipsDescendants = true
})
round(tpCard,11)
outline(tpCard,C.LightPurple,.78)

local tpTitle = label(tpCard,"📍  TARGET SELECTOR",10,C.White,BOLD)
tpTitle.Position = UDim2.fromOffset(11,9)
tpTitle.Size = UDim2.new(1,-160,0,18)

local stickBtn = new("TextButton",tpCard,{
    Position = UDim2.new(1,-144,0,7),
    Size = UDim2.fromOffset(64,22),
    BackgroundColor3 = C.Green,
    BackgroundTransparency = .12,
    Text = "STICK",
    TextColor3 = C.Base,
    Font = BOLD,
    TextSize = 9,
    AutoButtonColor = false,
    Visible = false
})
round(stickBtn,6)

local stopBtn = new("TextButton",tpCard,{
    Position = UDim2.new(1,-74,0,7),
    Size = UDim2.fromOffset(64,22),
    BackgroundColor3 = C.Red,
    BackgroundTransparency = .15,
    Text = "UNSTICK",
    TextColor3 = C.White,
    Font = BOLD,
    TextSize = 9,
    AutoButtonColor = false,
    Visible = false
})
round(stopBtn,6)

local trackStatus = label(CombatPage,"TRACKER: Select a player, then press STICK",9,C.Muted,FONT)
trackStatus.Size = UDim2.new(1,0,0,20)
trackStatus.TextXAlignment = Enum.TextXAlignment.Left

local dropBtn = new("TextButton",tpCard,{
    Position = UDim2.fromOffset(10,36),
    Size = UDim2.new(1,-20,0,30),
    BackgroundColor3 = C.Surface2,
    BackgroundTransparency = .25,
    Text = "Select Player... ▾",
    TextColor3 = C.Lavender,
    Font = BOLD,
    TextSize = 10,
    AutoButtonColor = false
})
round(dropBtn,8)
outline(dropBtn,C.Purple,.55)

local searchBox = new("TextBox",tpCard,{
    Position = UDim2.fromOffset(10,72),
    Size = UDim2.new(1,-20,0,24),
    BackgroundColor3 = C.Base,
    BackgroundTransparency = .15,
    Text = "",
    PlaceholderText = "Search username or display name...",
    PlaceholderColor3 = C.Muted,
    TextColor3 = C.White,
    Font = BOLD,
    TextSize = 9,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left
})
round(searchBox,7)
outline(searchBox,C.Purple,.5)
new("UIPadding",searchBox,{
    PaddingLeft = UDim.new(0,8),
    PaddingRight = UDim.new(0,8)
})

local scrollList = new("ScrollingFrame",tpCard,{
    Position = UDim2.fromOffset(10,102),
    Size = UDim2.new(1,-20,0,112),
    BackgroundColor3 = C.Base,
    BackgroundTransparency = .25,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = C.Purple,
    CanvasSize = UDim2.fromOffset(0,0),
    Visible = false
})
round(scrollList,8)
outline(scrollList,C.Purple,.45)

new("UIPadding",scrollList,{
    PaddingTop = UDim.new(0,4),
    PaddingBottom = UDim.new(0,4),
    PaddingLeft = UDim.new(0,4),
    PaddingRight = UDim.new(0,6)
})

local listLayout = new("UIListLayout",scrollList,{
    Padding = UDim.new(0,4),
    SortOrder = Enum.SortOrder.LayoutOrder
})

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollList.CanvasSize = UDim2.fromOffset(0,listLayout.AbsoluteContentSize.Y+8)
end)

local function setDropdownOpen(open)
    tpOpen = open
    scrollList.Visible = open
    searchBox.Visible = open
    local targetHeight = open and 224 or 76
    if animationEnabled then
        tw(tpCard,.22,{Size = UDim2.new(1,0,0,targetHeight)})
    else
        tpCard.Size = UDim2.new(1,0,0,targetHeight)
    end
end

dropBtn.Activated:Connect(function()
    setDropdownOpen(not tpOpen)
end)

stickBtn.Activated:Connect(function()
    if not currentTarget or currentTarget.Parent ~= Players then
        trackStatus.Text = "TRACKER: Select a player first"
        trackStatus.TextColor3 = C.Red
        return
    end
    trackingTarget = currentTarget
    trackStatus.Text = "TRACKING: "..trackingTarget.DisplayName.." | 0-stud offset"
    trackStatus.TextColor3 = C.Green
end)

stopBtn.Activated:Connect(function()
    trackingTarget = nil
    currentTarget = nil
    stopBtn.Visible = false
    stickBtn.Visible = false
    dropBtn.Text = "Select Player... ▾"
    trackStatus.Text = "TRACKER: Follow stopped"
    trackStatus.TextColor3 = C.Muted
    updatePlayerList()
end)

local function updatePlayerList()
    for _, child in ipairs(scrollList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local query = string.lower(searchBox.Text or "")
    local matches = 0

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player then
            local username = string.lower(p.Name)
            local displayName = string.lower(p.DisplayName)
            if query == "" or string.find(username,query,1,true) or string.find(displayName,query,1,true) then
                matches += 1
                local selected = currentTarget == p
                local btn = new("TextButton",scrollList,{
                    Size = UDim2.new(1,0,0,30),
                    BackgroundColor3 = selected and C.Purple or C.Surface,
                    BackgroundTransparency = selected and .12 or .35,
                    TextColor3 = C.White,
                    Font = FONT,
                    TextSize = 9,
                    Text = "  "..p.DisplayName.."  @"..p.Name,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false
                })
                round(btn,6)

                btn.Activated:Connect(function()
                    currentTarget = p
                    trackingTarget = nil
                    stopBtn.Visible = false
                    stickBtn.Visible = true
                    setDropdownOpen(false)
                    local shortName = #p.Name > 16 and string.sub(p.Name,1,14)..".." or p.Name
                    dropBtn.Text = shortName.." ▾"
                    trackStatus.Text = "SELECTED: "..p.DisplayName.." | Press STICK to follow"
                    trackStatus.TextColor3 = C.Lavender
                    updatePlayerList()
                end)
            end
        end
    end

    if matches == 0 then
        local empty = label(scrollList,"No matching players",9,C.Muted,FONT)
        empty.Size = UDim2.new(1,0,0,28)
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)

local trackerAccumulator = 0
RunService.RenderStepped:Connect(function(dt)
    if not GUI.Parent then return end

    local target = trackingTarget
    local targetChar = target and target.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
    local myChar = Player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if target and target.Parent == Players and targetRoot and myRoot then
        -- Exact-position follow: keep the local character at the selected target's root.
        myChar:PivotTo(targetChar:GetPivot())

        trackerAccumulator += dt
        if trackerAccumulator >= .15 then
            trackerAccumulator = 0
            local distance = (myRoot.Position-targetRoot.Position).Magnitude
            local hp = targetHum and math.floor(targetHum.Health) or 0
            local maxHp = targetHum and math.floor(targetHum.MaxHealth) or 0
            trackStatus.Text = string.format("TRACKING: %s  |  HP %d/%d  |  DIST %.1f",target.DisplayName,hp,maxHp,distance)
            trackStatus.TextColor3 = C.Green
        end
    elseif target then
        trackStatus.Text = "TRACKER: Waiting for "..target.DisplayName.."'s character..."
        trackStatus.TextColor3 = C.Lavender
    end
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p)
    if currentTarget == p then
        currentTarget = nil
        stickBtn.Visible = false
        dropBtn.Text = "Select Player... ▾"
    end
    if trackingTarget == p then
        trackingTarget = nil
        stopBtn.Visible = false
        trackStatus.Text = "TRACKER: Target left the server"
        trackStatus.TextColor3 = C.Red
    end
    updatePlayerList()
end)
updatePlayerList()

--========================================================
-- PLAYER
--========================================================

section(PlayerPage,"PLAYER","Your profile information")
hero(PlayerPage,"Player Profile",Player.DisplayName)

local _,healthValue = stat(PlayerPage,"HEALTH","Loading...")
local _,speedValue = stat(PlayerPage,"WALK SPEED","Loading...")
local _,positionValue = stat(PlayerPage,"POSITION","Loading...")

section(PlayerPage,"LIVE MONITOR","Real-time character information")

local monitorEnabled = false
local MonitorToggle = button(PlayerPage,"◈  ENABLE LIVE MONITOR")

section(PlayerPage,"MOVEMENT","Local character movement controls")

local speedLabel = label(PlayerPage,"WALK SPEED: DEFAULT",10,C.Lavender,BOLD)
speedLabel.Size = UDim2.new(1,0,0,22)

local SpeedRow = new("Frame",PlayerPage,{
    Size = UDim2.new(1,0,0,40),
    BackgroundTransparency = 1
})

new("UIGridLayout",SpeedRow,{
    CellSize = UDim2.new(.25,-5,1,0),
    CellPadding = UDim2.fromOffset(5,0)
})

local currentSpeed = 16

local function applySpeed(value)
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.WalkSpeed = value
    currentSpeed = value
    speedLabel.Text = "WALK SPEED: "..value
end

for _,value in ipairs({16,24,32,40}) do
    local b = button(SpeedRow,tostring(value))
    b.Activated:Connect(function()
        applySpeed(value)
    end)
end

local jumpLabel = label(PlayerPage,"JUMP POWER: DEFAULT",10,C.Lavender,BOLD)
jumpLabel.Size = UDim2.new(1,0,0,22)

local JumpRow = new("Frame",PlayerPage,{
    Size = UDim2.new(1,0,0,40),
    BackgroundTransparency = 1
})

new("UIGridLayout",JumpRow,{
    CellSize = UDim2.new(.25,-5,1,0),
    CellPadding = UDim2.fromOffset(5,0)
})

local currentJump = 50

local function applyJump(value)
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.UseJumpPower = true
    humanoid.JumpPower = value
    currentJump = value
    jumpLabel.Text = "JUMP POWER: "..value
end

for _,value in ipairs({50,65,80,100}) do
    local b = button(JumpRow,tostring(value))
    b.Activated:Connect(function()
        applyJump(value)
    end)
end

local ResetMovement = button(PlayerPage,"↺  RESET MOVEMENT")

ResetMovement.Activated:Connect(function()
    applySpeed(16)
    applyJump(50)
end)

--========================================================
-- SETTINGS
--========================================================

section(Settings,"SETTINGS","Personalize your experience")
hero(Settings,"Customization","Manage your interface.")

toggle(Settings,"Dark Theme",function(v)
    print("Dark Theme:",v)
end)

toggle(Settings,"Compact Mode",function(v)
    print("Compact Mode:",v)
end)

local _,sessionValue = stat(Settings,"SESSION TIME","00:00")
local _,fpsValue = stat(Settings,"FPS","--")

selectPage("Home")

--========================================================
-- LIVE MONITOR
--========================================================

local Monitor = new("Frame",GUI,{
    Name = "AuraLiveMonitor",
    AnchorPoint = Vector2.new(1,0),
    Position = UDim2.new(1,-14,0,14),
    Size = UDim2.fromOffset(205,116),
    BackgroundColor3 = C.Base,
    BackgroundTransparency = .20,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50
})

round(Monitor,13)
outline(Monitor,C.Purple,.12,1.4)

new("UIGradient",Monitor,{
    Rotation = 135,
    Color = ColorSequence.new(C.Surface,C.Base)
})

local function monitorLabel(text,y,size,color)
    local t = label(Monitor,text,size,color,FONT)
    t.Position = UDim2.fromOffset(10,y)
    t.Size = UDim2.new(1,-20,0,17)
    t.ZIndex = 51
    return t
end

monitorLabel("◈ AURA LIVE MONITOR",8,10,C.Lavender)
local MonitorData = monitorLabel("HP: --  |  SPEED: --",32,9,C.White)
local MonitorPosition = monitorLabel("XYZ: --, --, --",52,8,C.Muted)
local MonitorStats = monitorLabel("FPS: --  |  STATE: --",72,8,C.LightPurple)
local MonitorSession = monitorLabel("SESSION: 00:00",92,8,C.Muted)

local function setMonitor(value)
    monitorEnabled = value
    Monitor.Visible = value

    MonitorToggle.Text = value
        and "◈  LIVE MONITOR: ON"
        or "◈  ENABLE LIVE MONITOR"
end

MonitorToggle.Activated:Connect(function()
    setMonitor(not monitorEnabled)
end)

--========================================================
-- LIVE DATA
--========================================================

local sessionStart = os.clock()
local fps = 0
local frameCount = 0
local fpsElapsed = 0
local updateElapsed = 0

RunService.Heartbeat:Connect(function(dt)
    if not GUI.Parent then return end

    frameCount += 1
    fpsElapsed += dt
    updateElapsed += dt

    if fpsElapsed >= 1 then
        fps = math.floor(frameCount/fpsElapsed)
        frameCount = 0
        fpsElapsed = 0
    end

    if updateElapsed < .25 then return end
    updateElapsed = 0

    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid then
        healthValue.Text = "RESPAWNING"
        speedValue.Text = "--"
        positionValue.Text = "--"
        return
    end

    local hpStr = formatHP(humanoid.Health).."/"..formatHP(humanoid.MaxHealth)
    healthValue.Text = hpStr
    speedValue.Text = tostring(math.floor(humanoid.WalkSpeed))

    if rootPart then
        local p = rootPart.Position
        positionValue.Text = string.format("%.1f, %.1f, %.1f",p.X,p.Y,p.Z)
    else
        positionValue.Text = "--"
    end

    fpsValue.Text = tostring(fps)
    sessionValue.Text = formatTime(os.clock()-sessionStart)

    if monitorEnabled then
        MonitorData.Text = string.format(
            "HP: %s  |  SPEED: %d",
            hpStr,
            math.floor(humanoid.WalkSpeed)
        )

        if rootPart then
            local p = rootPart.Position
            MonitorPosition.Text = string.format(
                "XYZ: %.1f, %.1f, %.1f",p.X,p.Y,p.Z
            )
        else
            MonitorPosition.Text = "XYZ: --"
        end

        MonitorStats.Text = string.format(
            "FPS: %d  |  STATE: %s",
            fps,humanoid:GetState().Name
        )

        MonitorSession.Text = "SESSION: "..formatTime(os.clock()-sessionStart)
    end
end)

--========================================================
-- RESPAWN
--========================================================

Player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid",10)
    if not humanoid then return end

    task.wait(.25)

    humanoid.WalkSpeed = currentSpeed
    humanoid.UseJumpPower = true
    humanoid.JumpPower = currentJump
end)

--========================================================
-- RESPONSIVE SIZE
--========================================================

local normalSize = UDim2.fromOffset(390,330)
local minimizedState = false

local function responsive()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local v = camera.ViewportSize

    normalSize = UDim2.fromOffset(
        math.clamp(v.X-24,310,410),
        math.clamp(v.Y-85,275,355)
    )

    if Root.Visible and not minimizedState then
        Root.Size = normalSize
    end
end

responsive()

local function connectCamera()
    local camera = workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(responsive)
    end
end

connectCamera()

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    task.defer(connectCamera)
    task.defer(responsive)
end)

--========================================================
-- FLOATING LAUNCHER
--========================================================

local Launcher = new("TextButton",GUI,{
    Name = "AuraLauncher",
    Position = UDim2.new(0,20,.5,-29),
    Size = UDim2.fromOffset(58,58),
    BackgroundColor3 = C.Glass,
    BackgroundTransparency = .24,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 20
})

round(Launcher,19)
local LauncherStroke = outline(Launcher,C.Purple,.08,1.5)

new("UIGradient",Launcher,{
    Rotation = 135,
    Color = ColorSequence.new(C.Surface2,C.Base)
})

local LauncherGlow = new("Frame",GUI,{
    Position = UDim2.new(0,13,.5,-36),
    Size = UDim2.fromOffset(72,72),
    BackgroundColor3 = C.Purple,
    BackgroundTransparency = .82,
    BorderSizePixel = 0,
    ZIndex = 19
})
round(LauncherGlow,25)

local LauncherLogo = CreateLogo(Launcher,54)
LauncherLogo.Position = UDim2.fromOffset(2,2)
LauncherLogo.ZIndex = 21

task.spawn(function()
    while GUI.Parent do
        tw(LauncherGlow,.9,{BackgroundTransparency=.74})
        task.wait(.9)
        if not GUI.Parent then break end

        tw(LauncherGlow,.9,{BackgroundTransparency=.86})
        task.wait(.9)
    end
end)

--========================================================
-- BUTTON EFFECTS
--========================================================

local function ApplyAllButtonEffects()
    for _,obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("TextButton") then
            AddButtonEffect(obj)
        end
    end
end

ApplyAllButtonEffects()

GUI.DescendantAdded:Connect(function(obj)
    if obj:IsA("TextButton") then
        task.defer(AddButtonEffect,obj)
    end
end)

--========================================================
-- MENU CONTROLLER
--========================================================

local menuVisible = false
local transitionBusy = false
local transitionId = 0

local function hideMenu()
    if transitionBusy or not menuVisible then return end

    transitionBusy = true
    transitionId += 1
    local id = transitionId

    setDropdownOpen(false)

    local t = tw(Root,.22,{
        Size = UDim2.fromOffset(0,0),
        Rotation = 2
    })

    if t then t.Completed:Wait() end
    if transitionId ~= id then return end

    Root.Visible = false
    Root.Size = normalSize
    Root.Rotation = 0

    menuVisible = false
    transitionBusy = false
end

local function showMenu()
    if transitionBusy or menuVisible then return end

    transitionBusy = true
    transitionId += 1
    local id = transitionId

    Root.Visible = true
    Root.Size = UDim2.fromOffset(0,0)
    Root.Rotation = -2

    local target = minimizedState
        and UDim2.fromOffset(normalSize.X.Offset,72)
        or normalSize

    local t = tw(Root,.38,{
        Size = target,
        Rotation = 0
    },Enum.EasingStyle.Back)

    if t then t.Completed:Wait() end
    if transitionId ~= id then return end

    menuVisible = true
    transitionBusy = false
end

Launcher.Activated:Connect(function()
    if transitionBusy then return end

    if menuVisible then
        hideMenu()
    else
        showMenu()
    end
end)

Close.Activated:Connect(hideMenu)

Min.Activated:Connect(function()
    if transitionBusy or not menuVisible then return end

    minimizedState = not minimizedState

    if minimizedState then
        Body.Visible = false
        setDropdownOpen(false)
        Min.Text = "+"
        tw(Root,.22,{
            Size = UDim2.fromOffset(normalSize.X.Offset,72)
        })
    else
        Body.Visible = true
        Min.Text = "−"
        tw(Root,.22,{Size=normalSize})
    end
end)

--========================================================
-- STARTUP FINISH
--========================================================

Root.Visible = false
Launcher.Visible = true

task.spawn(function()
    RunStartup()

    if not GUI.Parent then return end

    Root.Visible = true
    Root.Size = UDim2.fromOffset(0,0)
    Root.Rotation = -3

    local t = tw(Root,.55,{
        Size = normalSize,
        Rotation = 0
    },Enum.EasingStyle.Back)

    if t then t.Completed:Wait() end

    menuVisible = true
end)

print("AURA X V6.5 | PREMIUM SHINE EDITION + COMBAT HUB LOADED")
