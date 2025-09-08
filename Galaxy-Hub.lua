local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local IMAGE_ID = 4483362458

local Window = Rayfield:CreateWindow({
    Name = "Galaxy Hub",
    LoadingTitle = "Galaxy Hub",
    LoadingSubtitle = "by Galaxy Team",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "GalaxyHub"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local platformsEnabled, currentPlatform, platformConnection = false, nil, nil
local waypoint, playerBase = nil, nil
local espEnabled = false
local rageTableEnabled = false
local autoCollectEnabled = false
local autoFarmEnabled = false
local autoRebirthEnabled = false
local supermanCapeEnabled = false
local autoSellEnabled = false
local antiVoidEnabled = false
local autoUpgradeEnabled = false
local autoPaintballEnabled = false
local autoLaserCapeEnabled = false

local function antiRagdoll()
    if player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce") then
                v:Destroy()
            end
        end
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:FindFirstChild("Ragdoll") then
            humanoid.Ragdoll:Destroy()
        end
    end
    Rayfield:Notify({
        Title = "Anti-Ragdoll",
        Content = "Anti-Ragdoll applied.",
        Duration = 2,
        Image = IMAGE_ID,
    })
end

local function enableESP()
    espEnabled = true
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("brainrot") then
            if not obj:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(163, 53, 238)
                highlight.OutlineColor = Color3.fromRGB(255,255,255)
                highlight.FillTransparency = 0.5
                highlight.Parent = obj
            end
        end
    end
    Rayfield:Notify({
        Title = "ESP Enabled",
        Content = "Collectibles are now highlighted.",
        Duration = 3,
        Image = IMAGE_ID,
    })
end

local function disableESP()
    espEnabled = false
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("brainrot") and obj:FindFirstChild("Highlight") then
            obj.Highlight:Destroy()
        end
    end
    Rayfield:Notify({
        Title = "ESP Disabled",
        Content = "Highlight removed from collectibles.",
        Duration = 3,
        Image = IMAGE_ID,
    })
end

local function instantSteal()
    local character = player.Character
    if not character then return end
    local stolen = false
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("brainrot") or obj.Name:lower():find("steal") then
            local success = pcall(function()
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                elseif obj:FindFirstChild("ProximityPrompt") then
                    fireproximityprompt(obj.ProximityPrompt)
                end
            end)
            if success then
                stolen = true
                Rayfield:Notify({
                    Title = "Instant Steal",
                    Content = "Successfully stole: " .. obj.Name,
                    Duration = 3,
                    Image = IMAGE_ID,
                })
                break
            end
        end
    end
    if not stolen then
        Rayfield:Notify({
            Title = "Instant Steal",
            Content = "No stealable item found.",
            Duration = 2,
            Image = IMAGE_ID,
        })
    end
end

local function findPlayerBase()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower():find(player.Name:lower()) and obj:FindFirstChild("BasePart") then
            playerBase = obj
            Rayfield:Notify({
                Title = "Base Found",
                Content = "Successfully located your base: " .. obj.Name,
                Duration = 3,
                Image = IMAGE_ID,
            })
            return
        end
    end
    Rayfield:Notify({
        Title = "Base Search",
        Content = "Base not found automatically - you can still use manual TP",
        Duration = 4,
        Image = IMAGE_ID,
    })
end

local function teleportToPlayerBase()
    findPlayerBase()
    if playerBase and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local basePart = playerBase:FindFirstChild("BasePart") or playerBase.PrimaryPart or playerBase:FindFirstChildWhichIsA("Part")
        if basePart then
            player.Character.HumanoidRootPart.CFrame = basePart.CFrame + Vector3.new(0, 5, 0)
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to your base.",
                Duration = 2,
                Image = IMAGE_ID,
            })
        end
    else
        Rayfield:Notify({
            Title = "Teleport Failed",
            Content = "Could not find base to teleport.",
            Duration = 2,
            Image = IMAGE_ID,
        })
    end
end

local function createMovingPlatform()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local platform = Instance.new("Part")
    platform.Name = "GalaxyMovingPlatform"
    platform.Size = Vector3.new(8, 1, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Royal purple")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Position = hrp.Position + Vector3.new(0, -3, 0)
    platform.Parent = Workspace
    currentPlatform = platform
    platformConnection = RunService.Heartbeat:Connect(function()
        if currentPlatform and currentPlatform.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local newPosition = player.Character.HumanoidRootPart.Position + Vector3.new(0, -3, 0)
            currentPlatform.Position = newPosition
        end
    end)
end

local function removePlatform()
    if platformConnection then
        platformConnection:Disconnect()
        platformConnection = nil
    end
    if currentPlatform and currentPlatform.Parent then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
end

local function setWaypoint()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        waypoint = player.Character.HumanoidRootPart.Position
        Rayfield:Notify({
            Title = "Waypoint Set",
            Content = "Waypoint saved at current location.",
            Duration = 2,
            Image = IMAGE_ID,
        })
    end
end

local function teleportToWaypoint()
    if not waypoint then
        Rayfield:Notify({
            Title = "No Waypoint",
            Content = "Set a waypoint first.",
            Duration = 2,
            Image = IMAGE_ID,
        })
        return
    end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(waypoint)
        Rayfield:Notify({
            Title = "Teleported",
            Content = "Teleported to waypoint.",
            Duration = 2,
            Image = IMAGE_ID,
        })
    end
end

local function setWalkSpeed(speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

local function setJumpPower(power)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = power
    end
end

local function rageTable()
    rageTableEnabled = true
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and Workspace:FindFirstChild(p.Name .. "'s Table") then
            local tableObj = Workspace[p.Name .. "'s Table"]
            for _, part in pairs(tableObj:GetChildren()) do
                if part:IsA("BasePart") then
                    part:Destroy()
                end
            end
        end
    end
    Rayfield:Notify({
        Title = "Rage Table",
        Content = "All enemy tables broken!",
        Duration = 3,
        Image = IMAGE_ID,
    })
end

local flying = false
local function supermanCape(enable)
    supermanCapeEnabled = enable
    if supermanCapeEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local flyVel = Instance.new("BodyVelocity")
        flyVel.Name = "SupermanCapeFly"
        flyVel.MaxForce = Vector3.new(100000, 100000, 100000)
        flyVel.Velocity = Vector3.new(0, 50, 0)
        flyVel.Parent = hrp
        Rayfield:Notify({
            Title = "Superman's Cape",
            Content = "Flying enabled!",
            Duration = 2,
            Image = IMAGE_ID,
        })
    else
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if hrp:FindFirstChild("SupermanCapeFly") then
                hrp.SupermanCapeFly:Destroy()
            end
        end
        Rayfield:Notify({
            Title = "Superman's Cape",
            Content = "Flying disabled.",
            Duration = 2,
            Image = IMAGE_ID,
        })
    end
end

local function fireLaserCape(targetPosition)
    if player.Character then
        local cape = player.Character:FindFirstChild("SupermansCape") or player.Character:FindFirstChild("Cape")
        if cape then
            local remote = ReplicatedStorage:FindFirstChild("LaserCapeRemote")
            if remote then
                remote:FireServer(targetPosition)
                Rayfield:Notify({
                    Title = "Superman's Cape",
                    Content = "Laser fired!",
                    Duration = 2,
                    Image = IMAGE_ID,
                })
            end
        end
    end
end

local function aimbotLaserCape()
    local nearestPlayer, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).magnitude
            if dist < minDist then
                minDist = dist
                nearestPlayer = p
            end
        end
    end
    if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
        fireLaserCape(targetPos)
        Rayfield:Notify({
            Title = "Cape Aimbot",
            Content = "Laser auto-aimed at " .. nearestPlayer.Name,
            Duration = 2,
            Image = IMAGE_ID,
        })
    end
end

local function autoLaserCape()
    autoLaserCapeEnabled = not autoLaserCapeEnabled
    Rayfield:Notify({
        Title = "Auto Laser Cape",
        Content = autoLaserCapeEnabled and "Auto Laser Cape enabled!" or "Auto Laser Cape disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while autoLaserCapeEnabled and wait(1) do
        aimbotLaserCape()
    end
end

local function aimbotWebslinger()
    local nearestPlayer, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).magnitude
            if dist < minDist then
                minDist = dist
                nearestPlayer = p
            end
        end
    end
    if nearestPlayer then
        local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
        player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position, targetPos)
        Rayfield:Notify({
            Title = "Aimbot",
            Content = "Auto-aimed at " .. nearestPlayer.Name,
            Duration = 2,
            Image = IMAGE_ID,
        })
    end
end

local function autoCollect()
    autoCollectEnabled = not autoCollectEnabled
    Rayfield:Notify({
        Title = "Auto Collect",
        Content = autoCollectEnabled and "Auto Collect enabled!" or "Auto Collect disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while autoCollectEnabled and wait(0.5) do
        instantSteal()
    end
end

local function autoFarm()
    autoFarmEnabled = not autoFarmEnabled
    Rayfield:Notify({
        Title = "Auto Farm",
        Content = autoFarmEnabled and "Auto Farm enabled!" or "Auto Farm disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while autoFarmEnabled and wait(1) do
        instantSteal()
        teleportToPlayerBase()
    end
end

local function autoRebirth()
    autoRebirthEnabled = not autoRebirthEnabled
    Rayfield:Notify({
        Title = "Auto Rebirth",
        Content = autoRebirthEnabled and "Auto Rebirth enabled!" or "Auto Rebirth disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while autoRebirthEnabled and wait(5) do
        if ReplicatedStorage:FindFirstChild("Rebirth") then
            ReplicatedStorage.Rebirth:FireServer()
        end
    end
end

local function autoSell()
    autoSellEnabled = not autoSellEnabled
    Rayfield:Notify({
        Title = "Auto Sell",
        Content = autoSellEnabled and "Auto Sell enabled!" or "Auto Sell disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while autoSellEnabled and wait(3) do
        if ReplicatedStorage:FindFirstChild("Sell") then
            ReplicatedStorage.Sell:FireServer()
        end
    end
end

local function antiVoid()
    antiVoidEnabled = not antiVoidEnabled
    Rayfield:Notify({
        Title = "Anti Void",
        Content = antiVoidEnabled and "Anti Void enabled!" or "Anti Void disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while antiVoidEnabled and wait(0.5) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character.HumanoidRootPart.Position.Y < -10 then
                teleportToPlayerBase()
            end
        end
    end
end

local function autoUpgrade()
    autoUpgradeEnabled = not autoUpgradeEnabled
    Rayfield:Notify({
        Title = "Auto Upgrade",
        Content = autoUpgradeEnabled and "Auto Upgrade enabled!" or "Auto Upgrade disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while autoUpgradeEnabled and wait(7) do
        if ReplicatedStorage:FindFirstChild("Upgrade") then
            ReplicatedStorage.Upgrade:FireServer()
        end
    end
end

local function autoPaintball()
    autoPaintballEnabled = not autoPaintballEnabled
    Rayfield:Notify({
        Title = "Auto Paintball",
        Content = autoPaintballEnabled and "Auto Paintball enabled!" or "Auto Paintball disabled!",
        Duration = 2,
        Image = IMAGE_ID,
    })
    while autoPaintballEnabled and wait(2) do
        aimbotWebslinger()
    end
end

local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local MainTab = Window:CreateTab("Main", IMAGE_ID)
MainTab:CreateSection("Game Features")

MainTab:CreateButton({
    Name = "Instant Steal",
    Callback = instantSteal,
})

MainTab:CreateButton({
    Name = "Teleport to Base",
    Callback = teleportToPlayerBase,
})

MainTab:CreateToggle({
    Name = "Moving Platform",
    CurrentValue = false,
    Flag = "PlatformToggle",
    Callback = function(Value)
        if Value then createMovingPlatform() else removePlatform() end
        platformsEnabled = Value
        Rayfield:Notify({
            Title = "Platform",
            Content = "Moving platform " .. (Value and "enabled" or "disabled") .. ".",
            Duration = 2,
            Image = IMAGE_ID,
        })
    end,
})

MainTab:CreateButton({
    Name = "Anti-Ragdoll",
    Callback = antiRagdoll,
})

MainTab:CreateButton({
    Name = "Rage Table",
    Callback = rageTable,
})

MainTab:CreateToggle({
    Name = "Superman's Cape (Fly)",
    CurrentValue = false,
    Flag = "SupermanCape",
    Callback = supermanCape,
})

MainTab:CreateButton({
    Name = "Aimbot (Webslinger Paintball Gun)",
    Callback = aimbotWebslinger,
})

MainTab:CreateButton({
    Name = "Aimbot (Superman's Cape Laser)",
    Callback = aimbotLaserCape,
})

MainTab:CreateButton({
    Name = "Auto Laser Cape",
    Callback = autoLaserCape,
})

MainTab:CreateButton({
    Name = "Auto Collect",
    Callback = autoCollect,
})

MainTab:CreateButton({
    Name = "Auto Farm",
    Callback = autoFarm,
})

MainTab:CreateButton({
    Name = "Auto Rebirth",
    Callback = autoRebirth,
})

MainTab:CreateButton({
    Name = "Auto Sell",
    Callback = autoSell,
})

MainTab:CreateButton({
    Name = "Anti Void",
    Callback = antiVoid,
})

MainTab:CreateButton({
    Name = "Auto Upgrade",
    Callback = autoUpgrade,
})

MainTab:CreateButton({
    Name = "Auto Paintball",
    Callback = autoPaintball,
})

local TeleportSection = MainTab:CreateSection("Teleport System")
MainTab:CreateButton({
    Name = "Set Waypoint",
    Callback = setWaypoint,
})
MainTab:CreateButton({
    Name = "Teleport to Waypoint",
    Callback = teleportToWaypoint,
})

local UtilityTab = Window:CreateTab("Utility", IMAGE_ID)
UtilityTab:CreateSection("Player Utilities")

UtilityTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = setWalkSpeed,
})

UtilityTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 5,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = setJumpPower,
})

UtilityTab:CreateToggle({
    Name = "Brainrot ESP",
    CurrentValue = false,
    Flag = "BrainrotESP",
    Callback = function(Value)
        if Value then enableESP() else disableESP() end
    end,
})

local InfoTab = Window:CreateTab("Info", IMAGE_ID)
InfoTab:CreateSection("Game Information")
InfoTab:CreateLabel("Game: Steal a Brainrot")
InfoTab:CreateLabel("Place ID: " .. tostring(game.PlaceId))
InfoTab:CreateLabel("Player: " .. player.Name)

player.CharacterAdded:Connect(function()
    wait(1)
    if platformsEnabled then createMovingPlatform() end
end)

print("Galaxy Hub loaded - Keyless version!")
print("Game ID: " .. tostring(game.PlaceId))