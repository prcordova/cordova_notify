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
function openCloseShortCuts()
    TriggerEvent("help:open")
    infoHelp = not infoHelp
    
    -- Sempre envia um estado inicial limpo quando abre
    if infoHelp then
        -- Se estamos ativando o menu, enviar estado resetado
        SendNUIMessage({ Action = "Tutorial", Status = true, Reset = true })
        -- Forçar ativação do cursor explicitamente
        SetNuiFocus(true, true)
        display = true
    else
        -- Se estamos fechando, apenas fechar
        SendNUIMessage({ Action = "Tutorial", Status = false })
        -- Forçar desativação do cursor explicitamente
        SetNuiFocus(false, false)
        display = false
        
        -- Garantir que o controle seja restaurado
        SetNuiFocusKeepInput(false)
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

RegisterNUICallback("disableCursor", function(data, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    display = false
    
    -- Log para debug
    print("Cursor desativado com sucesso")
    
    if cb then cb('ok') end
end)

-- Adicionar callback para fechar o menu
RegisterNUICallback("closeMenu", function(data, cb)
    -- Desativar o cursor
    SetNuiFocus(false, false)
    display = false
    
    -- Garantir que o controle seja restaurado
    SetNuiFocusKeepInput(false)
    
    -- Atualizar o estado do menu
    infoHelp = false
    
    -- Fechar o menu na UI
    SendNUIMessage({ Action = "Tutorial", Status = false })
    
    -- Log para debug
    print("Menu fechado e cursor desativado")
    
    if cb then cb('ok') end
end)

-- Adicionar uma função para forçar a restauração do controle
function ForceRestoreControls()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    display = false
    infoHelp = false
    
    -- Enviar mensagem NUI para garantir que a UI feche
    SendNUIMessage({ Action = "Tutorial", Status = false })
    
    -- Garantir que todas as teclas sejam habilitadas novamente
    EnableAllControlActions(0)
    EnableAllControlActions(1)
    EnableAllControlActions(2)
    
    -- Log para debug
    print("Controles forçadamente restaurados")
end

-- Comando de emergência para restaurar controles
RegisterCommand("restaurar_controles", function()
    ForceRestoreControls()
    TriggerEvent("Notify", "sucesso", "Controles restaurados com sucesso.", 3000)
end, false)

-- Thread para verificar e restaurar controles em caso de problema
CreateThread(function()
    while true do
        -- Se o menu estiver fechado mas o cursor ainda estiver ativo
        if not infoHelp and display then
            ForceRestoreControls()
            print("Detectado inconsistência: Menu fechado mas cursor ativo. Corrigindo...")
        end
        
        Wait(5000) -- Verificar a cada 5 segundos
    end
end)

-- Registrar evento para o ESC do teclado (complemento ao handler no JavaScript)
RegisterCommand("+escapeKey", function()
    if display or infoHelp then
        infoHelp = false
        display = false
        SendNUIMessage({ Action = "Tutorial", Status = false })
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        print("Restaurando controles via tecla ESC")
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