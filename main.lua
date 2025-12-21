--// M TRIET HUB - STABLE FULL FIX
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
pcall(function() gui.Parent = game.CoreGui end)
if not gui.Parent then gui.Parent = plr.PlayerGui end
gui.Name = "M_TRIET_HUB"

-- LOGO
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.fromOffset(55,55)
logo.Position = UDim2.fromScale(0.02,0.4)
logo.Text = "M\nTRIET"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 13
logo.BackgroundColor3 = Color3.fromRGB(0,160,255)
logo.TextColor3 = Color3.new(0,0,0)
logo.Active = true
logo.Draggable = true
Instance.new("UICorner",logo).CornerRadius = UDim.new(1,0)

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(540,330)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(0,120,190)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

logo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "M TRIET HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- COLUMNS
local left = Instance.new("Frame", main)
left.Position = UDim2.fromOffset(15,50)
left.Size = UDim2.fromOffset(250,260)
left.BackgroundTransparency = 1

local right = Instance.new("Frame", main)
right.Position = UDim2.fromOffset(275,50)
right.Size = UDim2.fromOffset(250,260)
right.BackgroundTransparency = 1

local function addList(p)
    local l = Instance.new("UIListLayout",p)
    l.Padding = UDim.new(0,8)
end
addList(left)
addList(right)

-- VARIABLES
local speed = 16
local jump = 50
local infJump = false
local noclip = false
local hitbox = false
local hitboxSize = 2
local esp = false

-- TEXTBOX
local function box(parent,text,default,callback)
    local b = Instance.new("TextBox",parent)
    b.Size = UDim2.fromOffset(250,32)
    b.Text = text..": "..default
    b.ClearTextOnFocus = true
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BackgroundColor3 = Color3.new(1,1,1)
    b.TextColor3 = Color3.new(0,0,0)
    Instance.new("UICorner",b)
    b.FocusLost:Connect(function()
        local v = tonumber(b.Text)
        if v then
            callback(v)
            b.Text = text..": "..v
        else
            b.Text = text..": "..default
        end
    end)
end

-- TOGGLE
local function toggle(parent,text,callback)
    local t = Instance.new("TextButton",parent)
    t.Size = UDim2.fromOffset(250,32)
    t.Text = text..": OFF"
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.BackgroundColor3 = Color3.new(1,1,1)
    t.TextColor3 = Color3.new(0,0,0)
    Instance.new("UICorner",t)
    local on = false
    t.MouseButton1Click:Connect(function()
        on = not on
        t.Text = text..": "..(on and "ON" or "OFF")
        t.BackgroundColor3 = on and Color3.fromRGB(150,255,150) or Color3.new(1,1,1)
        callback(on)
    end)
end

-- LEFT
box(left,"SPEED",speed,function(v) speed=v end)
box(left,"JUMP",jump,function(v) jump=v end)
toggle(left,"INF JUMP",function(v) infJump=v end)
toggle(left,"NOCLIP",function(v) noclip=v end)
toggle(left,"HITBOX",function(v) hitbox=v end)
box(left,"HITBOX SIZE",hitboxSize,function(v) hitboxSize=v end)

-- RIGHT
toggle(right,"ESP (NAME/DIST)",function(v) esp=v end)
toggle(right,"NIGHT VISION",function(v)
    game.Lighting.Brightness = v and 5 or 1
end)
toggle(right,"FAST INTERACT",function(v)
    for _,p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration = v and 0 or 1
        end
    end
end)

-- APPLY SPEED & JUMP (KHÔNG ĐÈ)
RS.Heartbeat:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        local h = plr.Character.Humanoid
        h.UseJumpPower = true
        h.WalkSpeed = speed
        h.JumpPower = jump
    end
end)

-- INF JUMP (FIXED)
UIS.JumpRequest:Connect(function()
    if infJump and plr.Character then
        local h = plr.Character:FindFirstChildOfClass("Humanoid")
        if h and h.FloorMaterial == Enum.Material.Air then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- NOCLIP
RS.Stepped:Connect(function()
    if noclip and plr.Character then
        for _,v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

-- HITBOX (FIXED LOOP)
RS.Heartbeat:Connect(function()
    if hitbox then
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = v.Character.HumanoidRootPart
                hrp.Size = Vector3.new(hitboxSize,hitboxSize,hitboxSize)
                hrp.Transparency = 0.6
                hrp.CanCollide = false
            end
        end
    end
end)

-- ESP NAME + DISTANCE
RS.RenderStepped:Connect(function()
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local tag = head:FindFirstChild("MTRIET_ESP")
            if esp then
                if not tag then
                    tag = Instance.new("BillboardGui",head)
                    tag.Name = "MTRIET_ESP"
                    tag.Size = UDim2.fromOffset(150,40)
                    tag.AlwaysOnTop = true
                    local t = Instance.new("TextLabel",tag)
                    t.Size = UDim2.fromScale(1,1)
                    t.BackgroundTransparency = 1
                    t.TextColor3 = Color3.new(0,1,1)
                    t.TextScaled = true
                    t.Font = Enum.Font.GothamBold
                end
                local d = math.floor((plr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude)
                tag.TextLabel.Text = v.Name.." ["..d.."m]"
            elseif tag then
                tag:Destroy()
            end
        end
    end
end)
