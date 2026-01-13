-- DanielHub | Rival Edition v1.0
-- Coded by Daniel

-- Khởi tạo thư viện giao diện (Sử dụng Rayfield để mượt trên cả Mobile/PC)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rival Hub | Daniel Edition",
   LoadingTitle = "Đang tải Script...",
   LoadingSubtitle = "by Daniel",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DanielHub",
      FileName = "RivalConfig"
   }
})

local MainTab = Window:CreateTab("Chức năng", 4483362458) -- Icon Home: 4483362458 (id ảnh)

-- BIẾN TOÀN CỤC
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local flyEnabled = false
local flySpeed = 50
local aimbotEnabled = false
local aimbotFOV = 90 -- Field of View cho aimbot (ngắm trong phạm vi bao nhiêu độ)

--- [ CHỨC NĂNG FLY ] ---
MainTab:CreateToggle({
   Name = "Bật Bay (Fly)",
   CurrentValue = false,
   Callback = function(Value)
      flyEnabled = Value
      local char = player.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local root = char.HumanoidRootPart

      if flyEnabled then
         local bv = Instance.new("BodyVelocity")
         bv.Name = "DanielFly"
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Velocity = Vector3.new(0,0,0)
         bv.Parent = root
         
         task.spawn(function()
            while flyEnabled and root.Parent do -- Đảm bảo rootpart còn tồn tại
               -- Bay theo hướng camera
               local moveDirection = Vector3.new(0,0,0)
               if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
               if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
               
               if moveDirection.Magnitude > 0 then
                   bv.Velocity = moveDirection.Unit * flySpeed
               else
                   bv.Velocity = Vector3.new(0,0,0) -- Giữ nguyên vị trí nếu không di chuyển
               end
               task.wait()
            end
            if bv.Parent then bv:Destroy() end -- Hủy BodyVelocity khi tắt bay
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Tốc độ bay",
   Range = {10, 200},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 50,
   Callback = function(Value)
      flySpeed = Value
   end,
})

--- [ CHỨC NĂNG AIMBOT ] ---
MainTab:CreateToggle({
   Name = "Aimbot (Giữ chuột phải)",
   CurrentValue = false,
   Callback = function(Value)
      aimbotEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "FOV Aimbot (Phạm vi ngắm)",
   Range = {10, 360},
   Increment = 5,
   Suffix = "Degrees",
   CurrentValue = 90,
   Callback = function(Value)
      aimbotFOV = Value
   end,
})

-- Hàm tìm kẻ địch gần nhất trong FOV
local function getClosestTargetInFOV()
    local closestTarget = nil
    local smallestAngle = aimbotFOV
    local headPosition = player.Character and player.Character:FindFirstChild("Head") and player.Character.Head.Position
    if not headPosition then return nil end

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local targetHead = p.Character.Head
            
            local directionToTarget = (targetHead.Position - headPosition).Unit
            local angle = math.deg(math.acos(camera.CFrame.LookVector:Dot(directionToTarget)))
            
            if angle < smallestAngle then
                smallestAngle = angle
                closestTarget = targetHead
            end
        end
    end
    return closestTarget
end

-- Vòng lặp cập nhật Aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestTargetInFOV()
        if target then
            -- Làm mượt góc quay camera hướng về mục tiêu
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)

Rayfield:Notify({
   Title = "Thành công!",
   Content = "Rival Hub đã sẵn sàng. Chúc bạn chơi game vui vẻ!",
   Duration = 5,
   Image = 4483362458,
})
