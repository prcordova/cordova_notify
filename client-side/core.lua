-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
Player = GetPlayerServerId(PlayerId())

local ValidNotify = {
    ["negado"] = true,
    ["sucesso"] = true,
    ["importante"] = true,
    ["azul"] = true,
    ["sangramento"] = true,
    ["compras"] = true,
    ["fome"] = true,
    ["sede"] = true,
    ["police"] = true,
    ["paramedic"] = true,
    ["admin"] = true,
    ["dica"] = true,
    ["amor"] = true,
    ["airdrop"] = true,
}

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(Css,Message,Timer,Title)
    if ValidNotify[Css] then
        SendNUIMessage({ Action = "Notify", Css = Css, Message = Message, Timer = Timer or 5000, Title = Title })
    else
        SendNUIMessage({ Action = "Notify", Css = "importante", Message = Message, Title = Title, Timer = Timer or 5000 })
    end
end)

RegisterNetEvent("Notify:Text")
AddEventHandler("Notify:Text",function(Text)
    SendNUIMessage({ Action = "Text", Message = Text})
end)

RegisterNetEvent("Announce")
AddEventHandler("Announce",function(Css,Message,Timer,Title)
    if ValidNotify[Css] then
        SendNUIMessage({ Action = "Announce", Css = Css, Message = Message, Timer = Timer or 5000, Title = Title })
    else
        SendNUIMessage({ Action = "Announce", Css = "admin", Message = Message, Title = Title, Timer = Timer or 5000 })
    end
end)

local infoHelp = true

-- Flag para evitar chamadas múltiplas em um curto período
local isRestoringControls = false

-- Função de fechamento de menu com proteção contra múltiplas chamadas
function ForceCloseMenu()
    if isRestoringControls then
        return
    end
    
    isRestoringControls = true
    
    -- Chamamos ForceRestoreControls que já contém a lógica necessária
    ForceRestoreControls()
    
    -- Liberamos a flag após um intervalo
    Citizen.SetTimeout(500, function()
        isRestoringControls = false
    end)
end

-- Modificar a função openCloseShortCuts para usar nossa nova função protegida
function openCloseShortCuts()
    if not infoHelp then
        -- Abrir o menu
        TriggerEvent("help:open")
        infoHelp = true
        
        -- Enviar mensagem para a interface
        SendNUIMessage({ Action = "Tutorial", Status = true, Reset = true })
        
        -- Ativar o cursor ao final
        Citizen.Wait(100)
        SetNuiFocus(true, true)
        display = true
    else
        -- Fechar o menu usando a função dedicada
        ForceCloseMenu()
    end
end

RegisterCommand("help2",openCloseShortCuts)
RegisterKeyMapping("help2","Open/Close HELP","keyboard","EQUALS")

RegisterNetEvent("notify:Tutorial")
AddEventHandler("notify:Tutorial",function()
    openCloseShortCuts()
end)


local HelpNotify = {
    "Você sabia que não pode ser assaltado enquanto estiver no modo safe?",
    "Trabalho de Pescador, Minerador e Agricultor estão bufados! [Procure no Mapa]",
    "Você pode fazer TestDrive gratuitamente de carros vips diretamente na concessionária da cidade!",
    "Em breve punições serão aplicadas em jogadores com muitos deslikes.",
    "Você pode denúnciar um jogador que deslogou em meio a uma ação através da box deixada no local da morte! [Advertência Automática]",
    "Trabalho de Mineração de Bitcoin te permite ganhar dinheiro mesmo enquanto está AFK! [Próximo ao Cassino]",
    "Você ganha 💎 diamantes por tempo online, use o comando /diamantes para acessar a loja de diamantes!",
    "Você pode avaliar outro jogador (👍/👎) segurando ALT e mirando sobre ele!",
    "Você sabia que o SantaGroup é uma empresa com atualmente 9 cidades de sucesso online e que já completou 3 anos de vida?",
    "Você sabia que o SantaGroup foi um patrocinador de BGS 2022? [Acesse nosso instagram @santagroup_]",
    "Você sabia que hoje mais de 40 colaboradores trabalham full-time no SantaGroup?",
    "Você sabia que carros vip além de te dar mais respeito com os amigos correm mais que os demais carros da cidade?",
    "Você sabia que Anti-RP não são bem vindos aqui? E que você pode denúnciar um mau jogador? [Aperte F5]",
    "Você sabia que existe um FAQ de Dúvidas Frequentes na cidade? [Aperte F5]",
    "Você sabia que pode abrir a loja vip da cidade a qualquer momento através do comando /lojavip?",
    "Você sabia que pode avaliar um Staff como positivo ou negativo na prefeitura do Pier?",
    "Recrutamentos para a polícia são feitos diariamente! [Procure no Mapa]",
    "Jogadores ganham benefícios por recrutar iniciantes para Polícia, Hospital e Facções!",
    "O Pier é o Ponto Central da Cidade e onde os moradores se socializam! [Procure no Mapa]",
    "Você ganha benefícios gratuitamente por estar online através do BattlePass! [Aperte F4]",
    "Os produtos mais vendidos na loja vip atualmente são o Vip Ouro e BattlePass! [digite /lojavip]",
    "Seu personagem não morre mais de fome e sede enquanto você estiver AFK!",
    "Em breve jogadores que receberem muitas avaliações como toxicas terão sérios problemas?",   
    "Você sabia que o BattlePass é renovado todo dia 01 de cada mês?",
    "Você sabia que Médico é uma profissão legal que paga muito bem?",
    "Você sabia que pode salvar sua o preset da sua roupa atual e voltar facilmente pra ela depois? [F9/Roupas/Guardar]"
}

local HelpDone = {}

AddStateBagChangeHandler('Active',('player:%s'):format(Player) , function(_, _, Value)
    local Ped = PlayerPedId()
    if Value then
        CreateThread(function()
            Wait(2500)
            while true do
                -- if not LocalPlayer["state"]["Newbie"] then
                --     return
                -- end
                ::Another::
                if #HelpDone == #HelpNotify then
                    HelpDone = {}
                end
                local Random = math.random(1,#HelpNotify)
                if HelpDone[Random] then
                    goto Another
                end
                HelpDone[Random] = true
                TriggerEvent("Notify","dica",HelpNotify[Random],30000,"Dicas")
                Wait(1000*60*5)
            end
        end)
    end 
end)

local display = false

RegisterNUICallback("enableCursor", function(data, cb)
    SetNuiFocus(true, true)
    display = true
    if cb then cb('ok') end
end)

-- Simplificar callbacks - verificar se já está restaurando
RegisterNUICallback("disableCursor", function(data, cb)
    if not isRestoringControls then
        ForceCloseMenu()
    end
    if cb then cb('ok') end
end)

RegisterNUICallback("closeMenu", function(data, cb)
    if not isRestoringControls then
        ForceCloseMenu()
    end
    if cb then cb('ok') end
end)

RegisterNUICallback("ForceRestore", function(data, cb)
    if not isRestoringControls then
        ForceCloseMenu()
    end
    if cb then cb('ok') end
end)

-- Modificar o handler de ESC para verificar se já está restaurando
RegisterCommand("+escapeKey", function()
    if (display or infoHelp) and not isRestoringControls then
        ForceCloseMenu()
    end
end, false)

RegisterKeyMapping("+escapeKey", "Fechar menu ajuda", "keyboard", "ESCAPE")

-- Disparar restauração de controles quando o jogador entrar no jogo
AddEventHandler('playerSpawned', function()
    ForceRestoreControls()
    print("Restaurando controles ao spawn do jogador")
end)

-- Acionado quando o recurso é iniciado
AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    -- Garantir que os controles estejam corretos ao iniciar o recurso
    ForceRestoreControls()
    print("Recurso iniciado: Restaurando controles")
end)

-- Acionado quando o jogador se reconecta
RegisterNetEvent('onClientMapStart')
AddEventHandler('onClientMapStart', function()
    -- Forçar reset em caso de reconexão
    ForceRestoreControls()
    print("Mapa iniciado: Restaurando controles")
end)

-- Primeiro definimos a função ForceRestoreControls que está sendo chamada mas não existe
function ForceRestoreControls()
    -- 1. Primeira desabilitar o foco da NUI
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    
    -- 2. Atualizar variáveis de estado
    display = false
    infoHelp = false
    
    -- 3. Habilitar todos os controles
    EnableAllControlActions(0)
    EnableAllControlActions(1)
    EnableAllControlActions(2)
    
    -- 4. Forçar atualização da UI
    DisplayRadar(false)
    DisplayRadar(true)
    
    -- 5. Fechar o menu na UI
    SendNUIMessage({ Action = "Tutorial", Status = false })
    
    print("Controles restaurados")
end