-- AuraUI Premium - clean Black & Gold interface
local AuraUI = {}
AuraUI.__index = AuraUI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local player = Players.LocalPlayer

local C = {
    gold = Color3.fromRGB(246,198,91),
    gold2 = Color3.fromRGB(167,119,43),
    bg = Color3.fromRGB(8,9,12),
    header = Color3.fromRGB(16,15,14),
    panel = Color3.fromRGB(22,22,27),
    row = Color3.fromRGB(22,23,28),
    rowHover = Color3.fromRGB(31,29,25),
    text = Color3.fromRGB(247,244,236),
    muted = Color3.fromRGB(153,153,157),
    off = Color3.fromRGB(37,38,43),
    on = Color3.fromRGB(77,58,27)
}
local function make(class, props, parent)
    local o=Instance.new(class)
    for k,v in pairs(props or {}) do o[k]=v end
    o.Parent=parent
    return o
end
local function round(o,n)
    make("UICorner",{CornerRadius=UDim.new(0,n or 10)},o)
end
local function outline(o,color,thick,trans)
    return make("UIStroke",{Color=color or C.gold2,Thickness=thick or 1,Transparency=trans or .25},o)
end
local function text(parent,value,size,color,font)
    return make("TextLabel",{BackgroundTransparency=1,Text=tostring(value or ""),TextColor3=color or C.text,
        Font=font or Enum.Font.Gotham,TextSize=size or 14,TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center,Size=UDim2.fromScale(1,1)},parent)
end
local function tween(o,props)
    TweenService:Create(o,TweenInfo.new(.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end
local function actionButton(parent,value,w)
    local b=make("TextButton",{AutoButtonColor=false,Text=tostring(value or ""),TextColor3=C.gold,
        TextSize=13,Font=Enum.Font.GothamSemibold,BackgroundColor3=C.off,
        Size=UDim2.fromOffset(w or 104,34),BorderSizePixel=0},parent)
    round(b,9)
    b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=C.on}) end)
    b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=C.off}) end)
    return b
end

function AuraUI:CreateWindow(options)
    options=options or {}
    local pg=player:WaitForChild("PlayerGui")
    local gui=make("ScreenGui",{Name="AuraUI_Premium",ResetOnSpawn=false,IgnoreGuiInset=true,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=9999},nil)
    local ok=pcall(function() gui.Parent=game:GetService("CoreGui") end)
    if not ok or not gui.Parent then gui.Parent=pg end
    if pg:FindFirstChild("AuraUI_Premium") then pg.AuraUI_Premium:Destroy() end
    self.GUI=gui

    local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(900,700)
    local scale=math.min(1,viewport.X/650,viewport.Y/610)
    scale=math.max(.68,scale)
    local main=make("Frame",{Name="Main",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
        Size=UDim2.fromOffset(590,540),BackgroundColor3=C.bg,BorderSizePixel=0,ClipsDescendants=true},gui)
    round(main,17); outline(main,C.gold,1.35,.12)
    make("UIScale",{Scale=scale},main)
    make("UIGradient",{Rotation=135,Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(13,14,18)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(7,8,11))
    })},main)
    local topAccent=make("Frame",{Name="GoldAccent",Size=UDim2.new(1,0,0,3),
        BackgroundColor3=C.gold,BorderSizePixel=0,ZIndex=5},main)
    make("UIGradient",{Rotation=0,Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(112,75,25)),
        ColorSequenceKeypoint.new(.48,Color3.fromRGB(255,218,125)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(112,75,25))
    })},topAccent)

    local header=make("Frame",{Name="Header",Position=UDim2.fromOffset(0,3),
        Size=UDim2.new(1,0,0,82),BackgroundColor3=C.header,BorderSizePixel=0},main)
    make("UIGradient",{Rotation=0,Color=ColorSequence.new(Color3.fromRGB(24,22,18),Color3.fromRGB(13,13,15))},header)
    local title=text(header,options.Title or "AURA X HUB",22,C.gold,Enum.Font.GothamBlack)
    title.Position=UDim2.fromOffset(23,9); title.Size=UDim2.new(1,-46,0,34)
    local sub=text(header,options.SubTitle or "PREMIUM EDITION",11,C.muted,Enum.Font.GothamMedium)
    sub.Position=UDim2.fromOffset(24,45); sub.Size=UDim2.new(1,-48,0,20)
    local edition=make("TextLabel",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-22,.5,5),
        Size=UDim2.fromOffset(90,25),BackgroundColor3=Color3.fromRGB(43,34,20),
        Text="●  ELITE",TextColor3=C.gold,TextSize=10,Font=Enum.Font.GothamBold,
        BorderSizePixel=0},header)
    round(edition,8); outline(edition,C.gold2,1,.45)
    make("Frame",{Position=UDim2.new(0,20,1,-1),Size=UDim2.new(1,-40,0,1),
        BackgroundColor3=C.gold2,BackgroundTransparency=.45,BorderSizePixel=0},header)

    local tabsBar=make("Frame",{Name="Tabs",Position=UDim2.fromOffset(16,94),
        Size=UDim2.new(1,-32,0,42),BackgroundTransparency=1,BorderSizePixel=0},main)
    local tabLayout=make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},tabsBar)

    -- A dedicated clipped viewport keeps scrolling content below the fixed tabs.
    local content=make("Frame",{Name="ContentViewport",Position=UDim2.fromOffset(16,148),
        Size=UDim2.new(1,-32,1,-164),BackgroundColor3=C.bg,BorderSizePixel=0,
        ClipsDescendants=true},main)
    local win={GUI=gui,Main=main,Content=content,Tabs={},MinimizeKey=options.MinimizeKey or Enum.KeyCode.LeftControl}
    self.Window=win

    function win:SelectTab(index)
        for i,t in ipairs(self.Tabs) do
            t.Frame.Visible=(i==index)
            t.Button.BackgroundColor3=(i==index) and Color3.fromRGB(76,56,25) or C.panel
            t.Button.TextColor3=(i==index) and C.gold or C.muted
            t.ActiveLine.Visible=(i==index)
            if i==index then t.Frame.CanvasPosition=Vector2.zero end
        end
    end

    local drag,dragAt,startAt=false,nil,nil
    header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; dragAt=i.Position; startAt=main.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dragAt
            main.Position=UDim2.new(startAt.X.Scale,startAt.X.Offset+d.X,startAt.Y.Scale,startAt.Y.Offset+d.Y)
        end
    end)
    UIS.InputBegan:Connect(function(i,processed)
        if not processed and i.KeyCode==win.MinimizeKey and not UIS:GetFocusedTextBox() then
            main.Visible=not main.Visible
        end
    end)

    function win:AddTab(tabOptions)
        tabOptions=tabOptions or {}
        local frame=make("ScrollingFrame",{Name=tostring(tabOptions.Title or "Tab"),
            Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,
            ScrollBarThickness=3,ScrollBarImageColor3=C.gold,ScrollingDirection=Enum.ScrollingDirection.Y,
            AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(0,0,0,0),
            ClipsDescendants=true,Visible=false},content)
        make("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,12),
            PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,8)},frame)
        local layout=make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},frame)
        local tabBtn=make("TextButton",{Text=tostring(tabOptions.Title or "Tab"),AutoButtonColor=false,
            TextColor3=C.muted,TextSize=13,Font=Enum.Font.GothamBold,BackgroundColor3=C.panel,
            BorderSizePixel=0,Size=UDim2.new(1/4,-7,1,0)},tabsBar)
        round(tabBtn,9)
        local activeLine=make("Frame",{AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,1,-3),
            Size=UDim2.new(.38,0,0,2),BackgroundColor3=C.gold,BorderSizePixel=0,
            Visible=false},tabBtn)
        round(activeLine,2)
        local tab={Frame=frame,Button=tabBtn,ActiveLine=activeLine}
        table.insert(self.Tabs,tab)
        tabBtn.MouseButton1Click:Connect(function() self:SelectTab(table.find(self.Tabs,tab)) end)

        local function row(height)
            local r=make("Frame",{Size=UDim2.new(1,-4,0,height or 52),BackgroundColor3=C.row,
                BorderSizePixel=0,ClipsDescendants=false},frame)
            round(r,10)
            make("UIStroke",{Color=Color3.fromRGB(55,53,47),Thickness=1,Transparency=.72},r)
            local accent=make("Frame",{Position=UDim2.fromOffset(0,12),Size=UDim2.new(0,2,1,-24),
                BackgroundColor3=C.gold2,BackgroundTransparency=.48,BorderSizePixel=0},r)
            round(accent,2)
            r.MouseEnter:Connect(function()
                tween(r,{BackgroundColor3=C.rowHover})
                tween(accent,{BackgroundTransparency=0})
            end)
            r.MouseLeave:Connect(function()
                tween(r,{BackgroundColor3=C.row})
                tween(accent,{BackgroundTransparency=.48})
            end)
            return r
        end
        local function rowLabel(r,value)
            local l=text(r,value,14,C.text,Enum.Font.GothamMedium)
            l.Position=UDim2.fromOffset(16,0); l.Size=UDim2.new(1,-190,1,0)
            return l
        end
        function tab:AddSection(name)
            local r=make("Frame",{Size=UDim2.new(1,-4,0,30),BackgroundTransparency=1},frame)
            local dot=make("Frame",{Position=UDim2.fromOffset(7,10),Size=UDim2.fromOffset(5,5),
                BackgroundColor3=C.gold,BorderSizePixel=0},r); round(dot,3)
            local l=text(r,string.upper(name),11,C.gold,Enum.Font.GothamBold)
            l.Position=UDim2.fromOffset(20,0); l.Size=UDim2.new(1,-27,1,-4)
            make("Frame",{Position=UDim2.new(0,20,1,-1),Size=UDim2.new(1,-27,0,1),
                BackgroundColor3=C.gold2,BackgroundTransparency=.48,BorderSizePixel=0},r)
        end
        function tab:AddToggle(id,cfg)
            cfg=cfg or {}; local r=row(50); rowLabel(r,cfg.Title or id)
            local state=cfg.Default==true
            local sw=actionButton(r,state and "ON" or "OFF",68)
            sw.AnchorPoint=Vector2.new(1,.5); sw.Position=UDim2.new(1,-12,.5,0)
            local control={Value=state}
            local function set(v,fire)
                state=(v==true); control.Value=state
                sw.Text=state and "ON" or "OFF"; sw.BackgroundColor3=state and C.on or C.off
                sw.TextColor3=state and C.gold or C.muted
                if fire and cfg.Callback then task.spawn(cfg.Callback,state) end
            end
            sw.MouseButton1Click:Connect(function() set(not state,true) end)
            control.SetValue=function(_,v) set(v,true) end
            set(state,false); return control
        end
        function tab:AddDropdown(id,cfg)
            cfg=cfg or {}; local r=row(54); rowLabel(r,cfg.Title or id)
            local values=cfg.Values or {}; local selected=cfg.Default
            local b=actionButton(r,tostring(selected or "Select").."  ▾",190)
            b.AnchorPoint=Vector2.new(1,.5); b.Position=UDim2.new(1,-12,.5,0)
            local popup
            local control={}
            local function close() if popup then popup:Destroy(); popup=nil end end
            local function refresh() b.Text=tostring(selected or "Select").."  ▾" end
            b.MouseButton1Click:Connect(function()
                close()
                local abs=r.AbsolutePosition
                local rowH=math.min(190,math.max(38,#values*36))
                popup=make("Frame",{Name="DropdownPopup",Position=UDim2.fromOffset(
                    math.clamp(abs.X+r.AbsoluteSize.X-206,4,math.max(4,viewport.X-210)),
                    math.clamp(abs.Y+r.AbsoluteSize.Y+4,4,math.max(4,viewport.Y-rowH-8))),
                    Size=UDim2.fromOffset(194,rowH),BackgroundColor3=C.panel,
                    BorderSizePixel=0,ZIndex=100},gui)
                round(popup,10); outline(popup,C.gold2,1,.1)
                local sf=make("ScrollingFrame",{Size=UDim2.new(1,-8,1,-8),Position=UDim2.fromOffset(4,4),
                    BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,
                    ScrollBarImageColor3=C.gold,CanvasSize=UDim2.new(0,0,0,#values*36),
                    ZIndex=101},popup)
                make("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},sf)
                for _,v in ipairs(values) do
                    local opt=make("TextButton",{Size=UDim2.new(1,-4,0,32),Text=tostring(v),
                        TextColor3=C.text,TextSize=13,Font=Enum.Font.GothamMedium,
                        BackgroundColor3=C.row,AutoButtonColor=false,BorderSizePixel=0,ZIndex=102},sf)
                    round(opt,7)
                    opt.MouseButton1Click:Connect(function()
                        selected=v; refresh(); close()
                        if cfg.Callback then cfg.Callback(v) end
                    end)
                end
            end)
            function control:SetValues(v) values=v or {} end
            function control:SetValue(v) selected=v; refresh(); if cfg.Callback then cfg.Callback(v) end end
            refresh(); return control
        end
        function tab:AddSlider(id,cfg)
            cfg=cfg or {}; local r=row(66)
            local min,max=cfg.Min or 0,cfg.Max or 100
            local value=math.clamp(tonumber(cfg.Default) or min,min,max)
            local l=text(r,(cfg.Title or id).."  ·  "..tostring(value),13,C.text,Enum.Font.GothamMedium)
            l.Position=UDim2.fromOffset(16,4); l.Size=UDim2.new(1,-30,0,24)
            local track=make("Frame",{Position=UDim2.new(0,16,0,42),Size=UDim2.new(1,-32,0,7),
                BackgroundColor3=Color3.fromRGB(57,51,40),BorderSizePixel=0},r); round(track,5)
            local a=(value-min)/math.max(1,max-min)
            local fill=make("Frame",{Size=UDim2.new(a,0,1,0),BackgroundColor3=C.gold,BorderSizePixel=0},track); round(fill,5)
            local knob=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(a,0,.5,0),
                Size=UDim2.fromOffset(17,17),BackgroundColor3=C.text,BorderSizePixel=0},track); round(knob,9)
            local control={Value=value}; local sliding=false
            local function setX(x)
                local p=math.clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1)
                local raw=min+(max-min)*p; local mul=10^(cfg.Rounding or 0)
                value=math.floor(raw*mul+.5)/mul; control.Value=value
                fill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,0,.5,0)
                l.Text=(cfg.Title or id).."  ·  "..tostring(value)
                if cfg.Callback then cfg.Callback(value) end
            end
            knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true end end)
            track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true; setX(i.Position.X) end end)
            UIS.InputChanged:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setX(i.Position.X) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end end)
            return control
        end
        function tab:AddKeybind(id,cfg)
            cfg=cfg or {}; local r=row(50); rowLabel(r,cfg.Title or id)
            local current=cfg.Default or "None"
            local b=actionButton(r,current,100); b.AnchorPoint=Vector2.new(1,.5); b.Position=UDim2.new(1,-12,.5,0)
            local listening=false
            b.MouseButton1Click:Connect(function() listening=true; b.Text="Press key..." end)
            UIS.InputBegan:Connect(function(i,processed)
                if listening and i.UserInputType==Enum.UserInputType.Keyboard then
                    listening=false; current=i.KeyCode.Name; b.Text=current
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
