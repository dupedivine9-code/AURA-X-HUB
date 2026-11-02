-- AuraUI - original lightweight UI library for AURA X HUB
-- Built with Roblox Instance APIs; no Fluent/Dawid dependency.
local AuraUI = {}
AuraUI.__index = AuraUI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local GOLD = Color3.fromRGB(238, 190, 82)
local GOLD_DARK = Color3.fromRGB(130, 88, 28)
local BG = Color3.fromRGB(10, 10, 13)
local PANEL = Color3.fromRGB(18, 18, 22)
local ROW = Color3.fromRGB(25, 25, 30)
local TEXT = Color3.fromRGB(245, 240, 225)
local MUTED = Color3.fromRGB(165, 158, 143)

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(obj, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, obj)
end
local function stroke(obj, color, thickness)
    return make("UIStroke", {Color = color or GOLD_DARK, Thickness = thickness or 1, Transparency = 0.15}, obj)
end
local function label(parent, text, size, color, font)
    return make("TextLabel", {BackgroundTransparency=1, Text=tostring(text or ""), TextColor3=color or TEXT,
        Font=font or Enum.Font.Gotham, TextSize=size or 13, TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center, Size=UDim2.new(1,0,1,0)}, parent)
end
local function button(parent, text, width)
    local b=make("TextButton", {AutoButtonColor=false, Text=text or "", TextColor3=TEXT, TextSize=12,
        Font=Enum.Font.GothamSemibold, BackgroundColor3=Color3.fromRGB(42,35,23), Size=UDim2.new(0,width or 90,0,28)}, parent)
    corner(b,7); stroke(b,GOLD_DARK,1)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(63,49,27)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(42,35,23)}):Play() end)
    return b
end

function AuraUI:CreateWindow(options)
    options = options or {}
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local gui = make("ScreenGui", {Name="AuraUI", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999}, nil)
    local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not ok or not gui.Parent then gui.Parent=playerGui end
    self.GUI = gui
    local size = options.Size or UDim2.fromOffset(460,400)
    local main = make("Frame", {Name="Main", AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromScale(.5,.5),
        Size=size, BackgroundColor3=BG, BorderSizePixel=0, ClipsDescendants=true}, gui)
    corner(main,12); stroke(main,GOLD,1.5)
    local top = make("Frame", {Size=UDim2.new(1,0,0,56), BackgroundColor3=Color3.fromRGB(15,14,13), BorderSizePixel=0}, main)
    local title = label(top, options.Title or "AURA X HUB", 18, GOLD, Enum.Font.GothamBlack)
    title.Position=UDim2.fromOffset(16,3); title.Size=UDim2.new(1,-32,0,27)
    local sub = label(top, options.SubTitle or "", 10, MUTED, Enum.Font.GothamMedium)
    sub.Position=UDim2.fromOffset(17,29); sub.Size=UDim2.new(1,-32,0,18)
    local tabsBar = make("ScrollingFrame", {Name="Tabs", Position=UDim2.fromOffset(10,62), Size=UDim2.new(1,-20,0,34),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=2, CanvasSize=UDim2.new(0,0,0,0)}, main)
    local tabLayout=make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, tabsBar)
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tabsBar.CanvasSize=UDim2.new(0,tabLayout.AbsoluteContentSize.X,0,0) end)
    local content=make("Frame", {Name="Content", Position=UDim2.fromOffset(10,104), Size=UDim2.new(1,-20,1,-114), BackgroundTransparency=1}, main)
    local win={GUI=gui, Main=main, Content=content, Tabs={}, MinimizeKey=options.MinimizeKey or Enum.KeyCode.LeftControl}
    self.Window=win
    function win:SelectTab(index)
        for i,t in ipairs(self.Tabs) do
            t.Frame.Visible=(i==index)
            t.Button.BackgroundColor3=(i==index) and Color3.fromRGB(77,57,25) or ROW
            t.Button.TextColor3=(i==index) and GOLD or MUTED
        end
    end
    local dragging, dragStart, startPos=false,nil,nil
    top.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=main.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-dragStart
            main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode==win.MinimizeKey and not UserInputService:GetFocusedTextBox() then main.Visible=not main.Visible end
    end)
    function win:AddTab(tabOptions)
        tabOptions=tabOptions or {}
        local frame=make("ScrollingFrame", {Name=tostring(tabOptions.Title or "Tab"), Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
            BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=GOLD, CanvasSize=UDim2.new(0,0,0,0), Visible=false}, content)
        local layout=make("UIListLayout", {Padding=UDim.new(0,7), SortOrder=Enum.SortOrder.LayoutOrder}, frame)
        local pad=make("UIPadding", {PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,3),PaddingRight=UDim.new(0,5)}, frame)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() frame.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+14) end)
        local tabBtn=button(tabsBar, tostring(tabOptions.Title or "Tab"), 96); tabBtn.Size=UDim2.fromOffset(96,30)
        local tab={Frame=frame, Button=tabBtn}
        table.insert(self.Tabs,tab)
        tabBtn.MouseButton1Click:Connect(function() self:SelectTab(table.find(self.Tabs,tab)) end)
        local function row(height)
            return make("Frame", {Size=UDim2.new(1,-4,0,height or 42), BackgroundColor3=ROW, BorderSizePixel=0}, frame)
        end
        function tab:AddSection(name)
            local r=row(27); r.BackgroundTransparency=1
            local l=label(r,string.upper(name),11,GOLD,Enum.Font.GothamBold); l.Position=UDim2.fromOffset(4,0); l.Size=UDim2.new(1,-8,1,0)
            make("Frame",{Position=UDim2.new(0,4,1,-1),Size=UDim2.new(1,-8,0,1),BackgroundColor3=GOLD_DARK,BorderSizePixel=0},r)
        end
        function tab:AddToggle(id, cfg)
            cfg=cfg or {}; local r=row(42); corner(r,8)
            local l=label(r,cfg.Title or id,12,TEXT,Enum.Font.GothamMedium); l.Position=UDim2.fromOffset(12,0); l.Size=UDim2.new(1,-82,1,0)
            local state=cfg.Default==true
            local sw=button(r,state and "ON" or "OFF",48); sw.AnchorPoint=Vector2.new(1,.5); sw.Position=UDim2.new(1,-9,.5,0)
            local control={Value=state}
            local function set(v, fire) state=(v==true); control.Value=state; sw.Text=state and "ON" or "OFF"; sw.BackgroundColor3=state and Color3.fromRGB(93,68,27) or Color3.fromRGB(42,35,23); if fire and cfg.Callback then task.spawn(cfg.Callback,state) end end
            sw.MouseButton1Click:Connect(function() set(not state,true) end); control.SetValue=function(_,v) set(v,true) end
            return control
        end
        function tab:AddDropdown(id,cfg)
            cfg=cfg or {}; local r=row(44); corner(r,8)
            local l=label(r,cfg.Title or id,12,TEXT,Enum.Font.GothamMedium); l.Position=UDim2.fromOffset(12,0); l.Size=UDim2.new(.48,0,1,0)
            local values=cfg.Values or {}; local selected=cfg.Default
            local b=button(r,tostring(selected or "Select").." ▾",150); b.AnchorPoint=Vector2.new(1,.5); b.Position=UDim2.new(1,-9,.5,0)
            local control={}
            local function refresh() b.Text=tostring(selected or "Select").." ▾" end
            local popup=nil
            b.MouseButton1Click:Connect(function()
                if popup then popup:Destroy(); popup=nil; return end
                popup=make("Frame",{Position=UDim2.new(1,-162,1,4),Size=UDim2.fromOffset(154,math.min(150,math.max(34,#values*30))),BackgroundColor3=PANEL,ZIndex=20},r); corner(popup,7); stroke(popup,GOLD_DARK,1)
                local sf=make("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(0,0,0,#values*30),ZIndex=21},popup)
                local lay=make("UIListLayout",{Padding=UDim.new(0,2)},sf)
                for _,v in ipairs(values) do local opt=button(sf,tostring(v),138); opt.Size=UDim2.new(1,-8,0,28); opt.ZIndex=22; opt.MouseButton1Click:Connect(function() selected=v; refresh(); popup:Destroy(); popup=nil; if cfg.Callback then cfg.Callback(v) end end) end
            end)
            function control:SetValues(v) values=v or {} end
            function control:SetValue(v) selected=v; refresh(); if cfg.Callback then cfg.Callback(v) end end
            refresh(); return control
        end
        function tab:AddSlider(id,cfg)
            cfg=cfg or {}; local r=row(55); corner(r,8)
            local min,max=cfg.Min or 0,cfg.Max or 100; local value=math.clamp(tonumber(cfg.Default) or min,min,max)
            local l=label(r,(cfg.Title or id).."  ·  "..tostring(value),12,TEXT,Enum.Font.GothamMedium); l.Position=UDim2.fromOffset(12,2); l.Size=UDim2.new(1,-24,0,22)
            local track=make("Frame",{Position=UDim2.new(0,12,0,34),Size=UDim2.new(1,-24,0,8),BackgroundColor3=Color3.fromRGB(55,49,39),BorderSizePixel=0},r); corner(track,5)
            local fill=make("Frame",{Size=UDim2.new((value-min)/math.max(1,max-min),0,1,0),BackgroundColor3=GOLD,BorderSizePixel=0},track); corner(fill,5)
            local knob=make("TextButton",{Text="",AutoButtonColor=false,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new((value-min)/math.max(1,max-min),0,.5,0),Size=UDim2.fromOffset(16,16),BackgroundColor3=TEXT,BorderSizePixel=0},track); corner(knob,8)
            local control={Value=value}; local sliding=false
            local function setFromX(x)
                local a=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1); value=min+(max-min)*a
                local round=10^(cfg.Rounding or 0); value=math.floor(value*round+.5)/round; control.Value=value
                fill.Size=UDim2.new(a,0,1,0); knob.Position=UDim2.new(a,0,.5,0); l.Text=(cfg.Title or id).."  ·  "..tostring(value)
                if cfg.Callback then cfg.Callback(value) end
            end
            knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true end end)
            UserInputService.InputChanged:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setFromX(i.Position.X) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end end)
            track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then setFromX(i.Position.X); sliding=true end end)
            return control
        end
        function tab:AddKeybind(id,cfg)
            cfg=cfg or {}; local r=row(42); corner(r,8)
            local l=label(r,cfg.Title or id,12,TEXT,Enum.Font.GothamMedium); l.Position=UDim2.fromOffset(12,0); l.Size=UDim2.new(1,-115,1,0)
            local current=cfg.Default or "None"; local b=button(r,tostring(current),92); b.AnchorPoint=Vector2.new(1,.5); b.Position=UDim2.new(1,-9,.5,0)
            local listening=false
            b.MouseButton1Click:Connect(function() listening=true; b.Text="Press key" end)
            UserInputService.InputBegan:Connect(function(input,processed)
                if listening and input.UserInputType==Enum.UserInputType.Keyboard then
                    listening=false; current=input.KeyCode.Name; b.Text=current
                    if cfg.ChangedCallback then cfg.ChangedCallback(current) end
                end
            end)
            return {GetValue=function() return current end}
        end
        return tab
    end
    return win
end
return setmetatable(AuraUI,AuraUI)
