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