-- 🔥 Roblox FPS Booster + Display (Extreme + Versi 1 Style) 🔥
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Hapus GUI lama
if player.PlayerGui:FindFirstChild("FPSPingGUI") then
    player.PlayerGui.FPSPingGUI:Destroy()
end

-- Buat GUI baru
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "FPSPingGUI"

local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 250, 0, 24)
fpsLabel.Position = UDim2.new(1, -260, 1, -60) -- kanan bawah, agak naik biar gak mentok
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255,255,255) -- default putih
fpsLabel.TextStrokeTransparency = 0.2
fpsLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0) -- outline hitam tipis
fpsLabel.TextSize = 18
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- =========================================================
-- 🚀 BOOSTER EXTREME SETTINGS
-- =========================================================
pcall(function()
    -- Lighting optimasi
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 50        -- 👈 bisa diubah: makin kecil makin ringan (default Roblox = 100000)
    Lighting.Brightness = 2     -- 👈 makin kecil makin gelap, makin besar makin terang
    Lighting.EnvironmentSpecularScale = 0
    Lighting.EnvironmentDiffuseScale = 0

    -- Matikan efek atmosfer
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect")
        or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect")
        or effect:IsA("Atmosphere") then
            effect.Enabled = false
        end
    end

    -- Bersihin textures, decals, particles
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire")
        or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("Explosion") then
            obj.Visible = false
        elseif obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            obj.RenderFidelity = Enum.RenderFidelity.Performance -- 👈 paksa low poly
            obj.Material = Enum.Material.SmoothPlastic
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        end
    end

    -- Matikan highlight, beam, light
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") or obj:IsA("Beam") or obj:IsA("PointLight")
        or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        end
    end

    -- Terrain optimasi
    if workspace:FindFirstChildOfClass("Terrain") then
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 -- 👈 paksa ke kualitas paling rendah
    end

    -- Sound optimasi (matikan 3D sound biar ringan)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj.PlaybackSpeed = 1
            obj.EmitterSize = 5
            obj.RollOffMaxDistance = 50
        end
    end
end)

-- =========================================================
-- 📊 FPS & PING DISPLAY
-- =========================================================
local lastUpdate, frames, currentFPS = tick(), 0, 60

RunService.RenderStepped:Connect(function()
    frames += 1
    local now = tick()
    if now - lastUpdate >= 1 then
        currentFPS = frames / (now - lastUpdate)
        frames = 0
        lastUpdate = now

        -- Ping
        local pingVal = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        local ping = math.floor(pingVal)

        -- Warna FPS angka
        local fpsColor = currentFPS >= 30 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        -- Warna Ping angka
        local pingColor = ping < 100 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)

        -- Update text
        fpsLabel.Text = string.format(
            "FPS: %d | Ping: %dms", 
            math.floor(currentFPS), ping
        )
        fpsLabel.TextColor3 = Color3.fromRGB(255,255,255) -- label putih
        fpsLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0) -- outline hitam

        -- Warnai angka fps/ping
        if string.find(fpsLabel.Text, tostring(math.floor(currentFPS))) then
            fpsLabel.Text = string.format(
                "FPS: %s | Ping: %s",
                "<font color='rgb("..math.floor(fpsColor.R*255)..","..math.floor(fpsColor.G*255)..","..math.floor(fpsColor.B*255)..")'>"..math.floor(currentFPS).."</font>",
                "<font color='rgb("..math.floor(pingColor.R*255)..","..math.floor(pingColor.G*255)..","..math.floor(pingColor.B*255)..")'>"..ping.."ms</font>"
            )
            fpsLabel.RichText = true
        end
    end
end)
