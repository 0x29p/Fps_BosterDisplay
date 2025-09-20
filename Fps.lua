-- 🔥 Roblox FPS Booster + Display (Extreme Playable) 🔥  
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
fpsLabel.Size = UDim2.new(0, 280, 0, 24)
fpsLabel.Position = UDim2.new(1, -290, 1, -60) -- kanan bawah agak naik
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255,255,255) -- default putih
fpsLabel.TextStrokeTransparency = 0.2
fpsLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0) -- outline hitam tipis
fpsLabel.TextSize = 18
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.RichText = true

-- 🔧 EXTREME BOOSTER (masih playable)
pcall(function()
    -- Atur lighting
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 40 -- bisa diganti 10–100 (semakin kecil makin ringan)
    Lighting.Brightness = 2
    Lighting.EnvironmentSpecularScale = 0
    Lighting.EnvironmentDiffuseScale = 0

    -- Hapus efek berat di Lighting
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BlurEffect") 
        or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") 
        or v:IsA("DepthOfFieldEffect") or v:IsA("BloomEffect") then
            v.Enabled = false
        end
    end

    -- Bersihkan textures & partikel
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            obj.Enabled = false
        elseif obj:IsA("Shirt") or obj:IsA("Pants") then
            obj.Parent = nil -- hilangin baju avatar
        elseif obj:IsA("Accessory") then
            obj:Destroy() -- hilangin aksesori (rambut/topi)
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

        -- Ping
        local pingVal = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        local ping = math.floor(pingVal)

        -- Warna FPS angka
        local fpsColor = currentFPS >= 30 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        -- Warna Ping angka
        local pingColor = ping < 100 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)

        -- Display text
        fpsLabel.Text = string.format(
            "FPS: <font color='rgb(%d,%d,%d)'>%d</font> | Ping: <font color='rgb(%d,%d,%d)'>%dms</font>",
            fpsColor.R*255, fpsColor.G*255, fpsColor.B*255, math.floor(currentFPS),
            pingColor.R*255, pingColor.G*255, pingColor.B*255, ping
        )
    end
end)
