-- Script otimizado para Delta Executor - Blox Fruits
local StarterGui = game:GetService("StarterGui")
local npcName = "Janus"
local found = false

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- Aguarda jogo carregar
notify("⏳ Iniciando", "Aguardando jogo carregar...", 3)
repeat task.wait(0.5) until game:IsLoaded()

task.wait(1)
notify("✅ Jogo Carregado", "Procurando " .. npcName .. "...", 3)

-- Procura o NPC
task.wait(1)
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Model") and obj.Name == npcName then
        found = true
        notify("🎉 " .. npcName .. " Encontrado!", "NPC está neste servidor!", 10)
        break
    end
end

-- Se não encontrou, tenta server hop
if not found then
    notify("❌ " .. npcName .. " Não Encontrado", "Buscando em outro servidor...", 5)
    
    task.wait(2)
    
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    
    local serversUrl = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                notify("🌐 Server Hop", "Teleportando...", 3)
                task.wait(1)
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
                end)
                break
            end
        end
    else
        notify("⚠️ Erro", "Não foi possível buscar servidores", 5)
    end
else
    notify("✨ Concluído", "Script finalizado com sucesso!", 5)
end