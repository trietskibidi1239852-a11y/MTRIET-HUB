-- M TRIET HUB - CORE BYPASS
local p = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- TỰ ĐỘNG TÌM NƠI HIỂN THỊ (PLAYERGUI HOẶC COREGUI)
local function GetParent()
local success, target = pcall(function() return game:GetService("CoreGui") end)
if success and target then return target end
return p:WaitForChild("PlayerGui")
end

local sg = Instance.new("ScreenGui", GetParent())
sg.Name = "MTRIET_HUB_FINAL"
sg.ResetOnSpawn = false

-- BIẾN HỆ THỐNG
local S, J, H = 16, 50, 2
local IJ, ESP = false, false

-- 1. LOGO M TRIET (BẬT/TẮT MENU)
local Logo = Instance.new("TextButton", sg)
Logo.Size = UDim2.new(0, 55, 0, 55)
Logo.Position = UDim2.new(0, 15, 0.4, 0)
Logo.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
Logo.Text = "M\nTRIET"
Logo.TextColor3 = Color3.new(0, 0, 0)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 13
Logo.Draggable = true
Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 10)

-- 2. MENU CHÍNH (NẰM NGANG)
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 480, 0, 120)
Main.Position = UDim2.new(0.5, -240, 0.5, -60)
Main.BackgroundColor3 = Color3.fromRGB(0, 110, 200)
Main.Visible = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "M TRIET HUB"
Title.TextColor3 = Color3.new(0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = "GothamBold"
Title.TextSize = 16

-- Ô NHẬP SPD, JMP, HB
local function AddInp(name, def, x, call)
local i = Instance.new("TextBox", Main)
i.Size = UDim2.new(0, 145, 0, 30)
i.Position = UDim2.new(0, x, 0, 35)
i.BackgroundColor3 = Color3.new(1, 1, 1)
i.Text = name..": "..def
i.TextColor3 = Color3.new(0, 0, 0)
i.ClearTextOnFocus = true
Instance.new("UICorner", i)
i.FocusLost:Connect(function()
local v = tonumber(i.Text) or def
i.Text = name..": "..v
call(v)
end)
end

AddInp("SPEED", 16, 10, function(v) S = v end)
AddInp("JUMP", 50, 165, function(v) J = v end)
AddInp("HITBOX", 2, 320, function(v) H = v end)

-- NÚT BẬT TẮT RIÊNG BIỆT
local function AddToggle(name, x, call)
local b = Instance.new("TextButton", Main)
b.Size = UDim2.new(0, 225, 0, 35)
b.Position = UDim2.new(0, x, 0, 75)
b.BackgroundColor3 = Color3.new(1, 1, 1)
b.Text = name..": TẮT"
b.TextColor3 = Color3.new(0, 0, 0)
b.Font = "GothamBold"
Instance.new("UICorner", b)

local st = false  
b.MouseButton1Click:Connect(function()  
    st = not st  
    b.Text = name..": "..(st and "BẬT" or "TẮT")  
    b.BackgroundColor3 = st and Color3.fromRGB(150, 255, 150) or Color3.new(1, 1, 1)  
    call(st)  
end)

end

AddToggle("NHẢY VÔ HẠN", 10, function(v) IJ = v end)
AddToggle("ĐỊNH VỊ (Tên/m)", 245, function(v) ESP = v end)

-- VÒNG LẶP HỆ THỐNG
RS.Heartbeat:Connect(function()
pcall(function()
local char = p.Character
if char and char:FindFirstChild("Humanoid") then
char.Humanoid.WalkSpeed = S
char.Humanoid.JumpPower = J
char.Humanoid.UseJumpPower = true
end

for _, v in pairs(game.Players:GetPlayers()) do  
        if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then  
            -- Hitbox  
            v.Character.HumanoidRootPart.Size = Vector3.new(H, H, H)  
            v.Character.HumanoidRootPart.Transparency = 0.7  
              
            -- ESP  
            local head = v.Character:FindFirstChild("Head")  
            if head then  
                local bill = head:FindFirstChild("M_ESP")  
                if ESP then  
                    if not bill then  
                        bill = Instance.new("BillboardGui", head)  
                        bill.Name = "M_ESP"  
                        bill.AlwaysOnTop = true  
                        bill.Size = UDim2.new(0, 100, 0, 50)  
                        local lbl = Instance.new("TextLabel", bill)  
                        lbl.Name = "L"; lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1  
                        lbl.TextColor3 = Color3.new(1, 1, 1); lbl.TextStrokeTransparency = 0; lbl.Font = "GothamBold"  
                    end  
                    local dist = math.floor((p.Character.HumanoidRootPart.Position - head.Position).Magnitude)  
                    bill.L.Text = v.Name .. "\n[" .. dist .. "m]"  
                else  
                    if bill then bill:Destroy() end  
                end  
            end  
        end  
    end  
end)

end)

-- Nhảy vô hạn logic
UIS.JumpRequest:Connect(function()
if IJ and p.Character then p.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- Logo ẩn hiện Menu
Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
Script M TRIET HUB
