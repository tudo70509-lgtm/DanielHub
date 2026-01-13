local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("DanielHub | Rival", "Midnight")

local Main = Window:NewTab("Chức năng")
local Section = Main:NewSection("Chỉnh sửa nhân vật")

-- BIẾN HỖ TRỢ
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local flySpeed = 50
local flyEnabled = false

Section:NewToggle("Bật Bay (Fly)", "Giúp bạn bay trên không", function(state)
    flyEnabled = state
    local char = player.Character
    if flyEnabled and char then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Name = "FlyVelo"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while flyEnabled do
                bv.Velocity = camera.CFrame.LookVector * flySpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

Section:NewSlider("Tốc độ bay", "Chỉnh nhanh chậm", 200, 10, function(s)
    flySpeed = s
end)

local Aim = Window:NewTab("Aimbot")
local AimSection = Aim:NewSection("Hỗ trợ ngắm")

AimSection:NewToggle("Aimbot", "Tự động khóa mục tiêu", function(state)
    _G.Aimbot = state
end)

-- LOGIC AIMBOT
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.Aimbot and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = 1000
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if m < dist then dist = m target = v.Character.Head end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end
end)
