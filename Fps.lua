-- 🔥 Universal FPS Booster + Display (Bluestacks Optimized)

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Hapus GUI lama
if player.PlayerGui:FindFirstChild("FPSPingGUI") then
    player.PlayerGui.FPSPingGUI:Destroy()
end

-- Buat GUI FPS+Ping
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "FPSPingGUI"

local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 260, 0, 22)
fpsLabel.Position = UDim2.new(0, 10, 0, 10) -- pojok kiri atas
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
fpsLabel.TextStrokeTransparency = 0.6
fpsLabel.TextSize = 18
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 🔧 Booster Settings
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100
    Lighting.Brightness = 1
    for _, effect in ipairs({"Blur", "SunRays", "Atmosphere", "Bloom"}) do
        local e = Lighting:FindFirstChildOfClass(effect)
        if e then e:Destroy() end
    end

    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 1
    workspace.Terrain.Decoration = false

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") then
            obj.Enabled = false
        elseif obj:IsA("Explosion") then
            obj.Visible = false
        elseif obj:IsA("Fire") then
            obj.Enabled = false
        end
    end

    for _, s in pairs(workspace:GetDescendants()) do
        if s:IsA("Sound") and s.Playing then
            s.Volume = 0
        end
    end
end)

-- Variabel FPS
local lastUpdate, frames, currentFPS = tick(), 0, 60

RunService.RenderStepped:Connect(function()
    frames += 1
    local now = tick()
    if now - lastUpdate >= 1 then
        currentFPS = frames / (now - lastUpdate)
        frames = 0
        lastUpdate = now

        -- Ambil Ping
        local pingVal = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        local ping = math.floor(pingVal)

        -- Warna FPS
        local fpsColor
        if currentFPS >= 60 then
            fpsColor = Color3.fromRGB(0,255,0) -- hijau
        elseif currentFPS >= 30 then
            fpsColor = Color3.fromRGB(255,255,0) -- kuning
        else
            fpsColor = Color3.fromRGB(255,0,0) -- merah
        end

        -- Warna Ping
        local pingColor
        if ping < 100 then
            pingColor = Color3.fromRGB(0,255,0)
        elseif ping < 200 then
            pingColor = Color3.fromRGB(255,255,0)
        else
            pingColor = Color3.fromRGB(255,0,0)
        end

        -- Update teks
        fpsLabel.Text = string.format("FPS: %d | Ping: %dms", math.floor(currentFPS), ping)
        fpsLabel.TextColor3 = fpsColor
        fpsLabel.TextStrokeColor3 = pingColor
    end
end)
