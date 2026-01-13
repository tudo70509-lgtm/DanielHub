-- DanielHub Rival Edition (Phiên bản sửa lỗi hiển thị)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Lucid%20Lib/Lib.lua"))()
local Window = Library:CreateWindow("DanielHub Rival")

-- Tạo một bảng điều khiển hiện ngay các nút
local Main = Window:CreateTab("Chức năng")

-- BIẾN HỖ TRỢ
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local flyEnabled = false
local aimEnabled = false

-- 1. CHỨC NĂNG FLY
Main:CreateToggle("Bật Bay (Fly)", function(state)
    flyEnabled = state
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if flyEnabled then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "DanielFly"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while flyEnabled do
                bv.Velocity = camera.CFrame.LookVector * 60
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- 2. CHỨC NĂNG AIMBOT
Main:CreateToggle("Aimbot (Giữ chuột phải/Ngắm)", function(state)
    aimEnabled = state
end)

-- LOGIC AIMBOT CHẠY NGẦM
game:GetService("RunService").RenderStepped:Connect(function()
    if aimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, visible = camera:WorldToViewportPoint(v.Character.Head.Position)
                if visible then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then
                        dist = mag
                        target = v.Character.Head
                    end
                end
            end
        end
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)

print("DanielHub Loaded!")
