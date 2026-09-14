print("🚀 Script iniciado!")

repeat task.wait() until game:IsLoaded()
print("✅ Jogo carregado!")

local npcName = "Janus"

local function serverHop()
    print("🔄 Iniciando server hop...")
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local serversUrl = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)
    
    if success and result and result.data then
        print("📊 Servidores encontrados: " .. #result.data)
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                print("🌐 Teleportando para servidor: " .. server.id)
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
                end)
                task.wait(1)
            end
        end
    else
        print("❌ Erro ao buscar servidores")
    end
end

local function checkJanus()
    print("🔍 Procurando por " .. npcName .. "...")
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == npcName then
            print("✨ NPC " .. npcName .. " encontrado!")
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "NPC Encontrado!",
                Text = npcName .. " está neste servidor!",
                Duration = 15
            })
            return true
        end
    end
    print("⚠️ " .. npcName .. " não encontrado neste servidor")
    return false
end

task.wait(3)
if not checkJanus() then
    serverHop()
end

print("✅ Script finalizado!")