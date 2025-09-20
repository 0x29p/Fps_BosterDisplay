-- 🔥 Roblox FPS Booster + Display (Universal) 🔥  
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
fpsLabel.Position = UDim2.new(1, -260, 1, -60) -- kanan bawah, agak naik
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
fpsLabel.TextStrokeTransparency = 0.6
fpsLabel.TextSize = 18
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Booster Settings
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100
    Lighting.Brightness = 2

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
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

        -- Warna FPS (hijau kalau >=30, merah kalau <30)
        local fpsColor = currentFPS >= 30 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)

        -- Warna Ping
        local pingColor
        if ping < 100 then
            pingColor = Color3.fromRGB(0,255,0)
        elseif ping < 200 then
            pingColor = Color3.fromRGB(255,255,0)
        else
            pingColor = Color3.fromRGB(255,0,0)
        end

        fpsLabel.Text = string.format("FPS: %d | Ping: %dms", math.floor(currentFPS), ping)
        fpsLabel.TextColor3 = fpsColor
        fpsLabel.TextStrokeColor3 = pingColor
    end
end)
