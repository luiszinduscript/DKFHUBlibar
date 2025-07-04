--[[
    Script Corrigido e Finalizado por Gemini
    - Fly corrigido
    - Server Hop implementado corretamente
    - Instant Proximity Prompt implementado
    - Lógica de todos os botões finalizada
    - Adicionado verificações de segurança para evitar erros
]]

local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- URL para obter a key
local keySiteURL = "https://seusite.com/key" -- Substitua pela sua URL real
local keyCorreta = "SUA-KEY-AQUI" -- Substitua pela key real que deseja validar

--[[
    ==== KEY GUI ====
--]]

local KeyGui = Instance.new("ScreenGui", PlayerGui)
KeyGui.Name = "KeyGui"
KeyGui.ResetOnSpawn = false

local FrameKey = Instance.new("Frame", KeyGui)
FrameKey.Name = "FrameKey"
FrameKey.Size = UDim2.new(0, 317, 0, 251)
FrameKey.Position = UDim2.new(0.5, -158, 0.5, -125) -- Centralizado
FrameKey.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
FrameKey.Draggable = true -- Permite arrastar a janela

local PutKey = Instance.new("TextBox", FrameKey)
PutKey.Name = "PutKey"
PutKey.Size = UDim2.new(0, 301, 0, 50)
PutKey.Position = UDim2.new(0.025, 0, 0.57, 0)
PutKey.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PutKey.PlaceholderText = "Put Key Here"
PutKey.Font = Enum.Font.SourceSansBold
PutKey.TextSize = 26
PutKey.TextColor3 = Color3.new(1, 1, 1)
PutKey.ClearTextOnFocus = true

local ConfirmKey = Instance.new("TextButton", FrameKey)
ConfirmKey.Name = "ConfirmKey"
ConfirmKey.Size = UDim2.new(0, 301, 0, 41)
ConfirmKey.Position = UDim2.new(0.025, 0, 0.8, 0)
ConfirmKey.BackgroundColor3 = Color3.fromRGB(53, 255, 83)
ConfirmKey.Text = "Confirm Key"
ConfirmKey.Font = Enum.Font.SourceSansBold
ConfirmKey.TextSize = 26
ConfirmKey.TextColor3 = Color3.new(1, 1, 1)

local GetKey = Instance.new("TextButton", FrameKey)
GetKey.Name = "GetKey"
GetKey.Size = UDim2.new(0, 301, 0, 41)
GetKey.Position = UDim2.new(0.025, 0, 0.38, 0)
GetKey.BackgroundColor3 = Color3.fromRGB(21, 76, 255)
GetKey.Text = "Get Key"
GetKey.Font = Enum.Font.SourceSansBold
GetKey.TextSize = 26
GetKey.TextColor3 = Color3.new(1, 1, 1)

local function createTutorial(name, position, text)
    local label = Instance.new("TextLabel", FrameKey)
    label.Name = name
    label.Size = UDim2.new(0, 250, 0, 20)
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
end

createTutorial("Tutorial1", UDim2.new(0.1, 0, 0.11, 0), "1- Click Get Key")
createTutorial("Tutorial2", UDim2.new(0.1, 0, 0.17, 0), "2- Copy Link In Your Browser")
createTutorial("Tutorial3", UDim2.new(0.1, 0, 0.23, 0), "3- Put The Key You Got")

local Tutorial = Instance.new("TextLabel", FrameKey)
Tutorial.Name = "Tutorial"
Tutorial.Size = UDim2.new(0, 200, 0, 50)
Tutorial.Position = UDim2.new(0.18, 0, -0.05, 0)
Tutorial.BackgroundTransparency = 1
Tutorial.Text = "How To Get The Key"
Tutorial.Font = Enum.Font.SourceSansBold
Tutorial.TextSize = 18
Tutorial.TextColor3 = Color3.new(1, 1, 1)

local Fechar = Instance.new("ImageButton", FrameKey)
Fechar.Name = "Fechar"
Fechar.Size = UDim2.new(0, 30, 0, 30)
Fechar.Position = UDim2.new(1, -35, 0, 5)
Fechar.BackgroundTransparency = 1
Fechar.Image = "rbxassetid://7072723347"

Fechar.MouseButton1Click:Connect(function()
    KeyGui:Destroy()
end)

GetKey.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(keySiteURL)
        StarterGui:SetCore("SendNotification", {
            Title = "Link copiado!",
            Text = "Cole no navegador para obter sua key.",
            Duration = 4
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Erro",
            Text = "Seu executor não suporta copiar link automaticamente.",
            Duration = 4
        })
    end
end)

ConfirmKey.MouseButton1Click:Connect(function()
    local keyInserida = PutKey.Text
    if keyInserida == keyCorreta then
        StarterGui:SetCore("SendNotification", {
            Title = "Key correta!",
            Text = "Aproveite o script.",
            Duration = 4
        })
        KeyGui.Enabled = false
        First_Screen.Enabled = true
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Key incorreta",
            Text = "Verifique e tente novamente.",
            Duration = 4
        })
    end
end)

--[[
    VARIÁVEIS DE ESTADO PARA OS PODERES
]]
local speedBoostAtivo = false
local jumpBoostAtivo = false
local infiniteJumpAtivo = false
local godModeAtivo = false
local espOn = false
local flyOn = false
local instantPromptOn = false


--[[
    ==== FIRST SCREEN ====
]]

local First_Screen = Instance.new("ScreenGui", PlayerGui)
First_Screen.Name = "First_Screen"
First_Screen.ResetOnSpawn = false
First_Screen.Enabled = false -- começa desabilitada

local FrameFirstScreen = Instance.new("Frame", First_Screen)
FrameFirstScreen.Name = "FrameFirstScreen"
FrameFirstScreen.Size = UDim2.new(0, 396, 0, 262)
FrameFirstScreen.Position = UDim2.new(0.03, 0, 0.435, 0)
FrameFirstScreen.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
FrameFirstScreen.Draggable = true

local UICornerFrame = Instance.new("UICorner", FrameFirstScreen)
UICornerFrame.CornerRadius = UDim.new(0, 8)

local function createButton(parent, name, text, position)
    local btn = Instance.new("TextButton", parent)
    btn.Name = name
    btn.Text = text
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 20
    btn.Font = Enum.Font.SourceSansBold
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

local speedBoostBtn = createButton(FrameFirstScreen, "SpeedBoost", "Speed Boost: Off", UDim2.new(0.04, 0, 0.05, 0))
local jumpBoostBtn = createButton(FrameFirstScreen, "JumpBoost", "Jump Boost: Off", UDim2.new(0.04, 0, 0.25, 0))
local infiniteJumpBtn = createButton(FrameFirstScreen, "InfiniteJump", "Infinite Jump: Off", UDim2.new(0.04, 0, 0.45, 0))
local godModeBtn = createButton(FrameFirstScreen, "GodMode", "God Mode: Off", UDim2.new(0.04, 0, 0.65, 0))

local creditLabel1 = Instance.new("TextLabel", FrameFirstScreen)
creditLabel1.Name = "Credits"
creditLabel1.Text = "By LuiszidDuScript"
creditLabel1.Size = UDim2.new(0, 200, 0, 50)
creditLabel1.Position = UDim2.new(0.48, 0, 0.03, 0)
creditLabel1.BackgroundTransparency = 1
creditLabel1.TextColor3 = Color3.fromRGB(243, 243, 243)
creditLabel1.TextSize = 24
creditLabel1.Font = Enum.Font.SourceSansBold

local btnGoSecond = createButton(FrameFirstScreen, "TrocarParaSegundaScreen1", "2", UDim2.new(0.85, 0, 0.8, 0));
btnGoSecond.Size = UDim2.new(0, 45, 0, 40)
btnGoSecond.TextSize = 30
btnGoSecond.BackgroundColor3 = Color3.fromRGB(32, 62, 255)

local btnGoThird = createButton(FrameFirstScreen, "TrocarParaTerceiraScreen1", "3", UDim2.new(0.70, 0, 0.8, 0));
btnGoThird.Size = UDim2.new(0, 45, 0, 40)
btnGoThird.TextSize = 30
btnGoThird.BackgroundColor3 = Color3.fromRGB(32, 62, 255)

--[[
    ==== SECOND SCREEN ====
]]

local Second_Screen = Instance.new("ScreenGui", PlayerGui)
Second_Screen.Name = "Second_Screen"
Second_Screen.ResetOnSpawn = false
Second_Screen.Enabled = false

local FrameSecondScreen = Instance.new("Frame", Second_Screen)
FrameSecondScreen.Name = "FrameSecondScreen"
FrameSecondScreen.Size = UDim2.new(0, 396, 0, 262)
FrameSecondScreen.Position = UDim2.new(0.03, 0, 0.435, 0)
FrameSecondScreen.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
FrameSecondScreen.Draggable = true

local UICorner2 = Instance.new("UICorner", FrameSecondScreen)
UICorner2.CornerRadius = UDim.new(0, 8)

local espBtn = createButton(FrameSecondScreen, "EspPlayers", "Esp Players: Off", UDim2.new(0.04, 0, 0.05, 0))
local flyBtn = createButton(FrameSecondScreen, "Fly", "Fly: Off", UDim2.new(0.04, 0, 0.25, 0))
local tpSkyBtn = createButton(FrameSecondScreen, "TeleportSky", "Teleport Sky", UDim2.new(0.04, 0, 0.45, 0))
local hopBtn = createButton(FrameSecondScreen, "HopServer", "Hop Server", UDim2.new(0.04, 0, 0.65, 0))

local creditLabel2 = Instance.new("TextLabel", FrameSecondScreen)
creditLabel2.Name = "TextLabel"
creditLabel2.Text = "By LuiszidDuScript"
creditLabel2.Size = UDim2.new(0, 200, 0, 50)
creditLabel2.Position = UDim2.new(0.48, 0, 0.03, 0)
creditLabel2.BackgroundTransparency = 1
creditLabel2.TextColor3 = Color3.fromRGB(243, 243, 243)
creditLabel2.TextSize = 24
creditLabel2.Font = Enum.Font.SourceSansBold

local btn1Second = createButton(FrameSecondScreen, "TrocarParaPrimeiraScreen2", "1", UDim2.new(0.04, 0, 0.8, 0));
btn1Second.Size = UDim2.new(0, 45, 0, 40)
btn1Second.TextSize = 30
btn1Second.BackgroundColor3 = Color3.fromRGB(34, 49, 255)

local btn3Second = createButton(FrameSecondScreen, "TrocarParaTerceiraScreen2", "3", UDim2.new(0.85, 0, 0.8, 0));
btn3Second.Size = UDim2.new(0, 45, 0, 40)
btn3Second.TextSize = 30
btn3Second.BackgroundColor3 = Color3.fromRGB(32, 62, 255)


--[[
    ==== THIRD SCREEN ====
]]

local ThirdScreenGui = Instance.new("ScreenGui", PlayerGui)
ThirdScreenGui.Name = "ThirdScreenGui"
ThirdScreenGui.ResetOnSpawn = false
ThirdScreenGui.Enabled = false

local FrameThird = Instance.new("Frame", ThirdScreenGui)
FrameThird.Name = "FrameThirdScreen"
FrameThird.Size = UDim2.new(0, 396, 0, 262)
FrameThird.Position = UDim2.new(0.03, 0, 0.435, 0)
FrameThird.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
FrameThird.Draggable = true

local UICornerThird = Instance.new("UICorner", FrameThird)
UICornerThird.CornerRadius = UDim.new(0, 8)

local instantBtn = createButton(FrameThird, "InstantProximityPrompt", "ProximityPrompt: Off", UDim2.new(0.04, 0, 0.05, 0))

local creditLabel3 = Instance.new("TextLabel", FrameThird)
creditLabel3.Name = "TextLabel"
creditLabel3.Text = "By LuiszidDuScript"
creditLabel3.Size = UDim2.new(0, 200, 0, 50)
creditLabel3.Position = UDim2.new(0.48, 0, 0.03, 0)
creditLabel3.BackgroundTransparency = 1
creditLabel3.TextColor3 = Color3.fromRGB(243, 243, 243)
creditLabel3.TextSize = 24
creditLabel3.Font = Enum.Font.SourceSansBold

local tela1btn = createButton(FrameThird, "TrocarParaPrimeiraScreen3", "1", UDim2.new(0.04, 0, 0.8, 0));
tela1btn.Size = UDim2.new(0, 45, 0, 40)
tela1btn.TextSize = 30
tela1btn.BackgroundColor3 = Color3.fromRGB(34, 49, 255)

local tela2btn = createButton(FrameThird, "TrocarParaSegundaScreen3", "2", UDim2.new(0.20, 0, 0.8, 0));
tela2btn.Size = UDim2.new(0, 45, 0, 40)
tela2btn.TextSize = 30
tela2btn.BackgroundColor3 = Color3.fromRGB(32, 62, 255)


--[[
    ==== Funções para trocar telas ====
]]

local function showScreen(screenToShow)
    First_Screen.Enabled = (screenToShow == First_Screen)
    Second_Screen.Enabled = (screenToShow == Second_Screen)
    ThirdScreenGui.Enabled = (screenToShow == ThirdScreenGui)
end

-- Conectar botões da First_Screen
btnGoSecond.MouseButton1Click:Connect(function() showScreen(Second_Screen) end)
btnGoThird.MouseButton1Click:Connect(function() showScreen(ThirdScreenGui) end)

-- Conectar botões da Second_Screen
btn1Second.MouseButton1Click:Connect(function() showScreen(First_Screen) end)
btn3Second.MouseButton1Click:Connect(function() showScreen(ThirdScreenGui) end)

-- Conectar botões da Third_Screen
tela1btn.MouseButton1Click:Connect(function() showScreen(First_Screen) end)
tela2btn.MouseButton1Click:Connect(function() showScreen(Second_Screen) end)


--================================================================--
--[[
    ==== LÓGICA DAS FUNÇÕES ====
]]
--================================================================--


--[[ TELA 1 - Funções de Personagem ]]

speedBoostBtn.MouseButton1Click:Connect(function()
    speedBoostAtivo = not speedBoostAtivo
    speedBoostBtn.Text = "Speed Boost: " .. (speedBoostAtivo and "On" or "Off")
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = speedBoostAtivo and 100 or 16
    end
end)

godModeBtn.MouseButton1Click:Connect(function()
    godModeAtivo = not godModeAtivo
    godModeBtn.Text = "God Mode: " .. (godModeAtivo and "On" or "Off")
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local humanoid = char.Humanoid
        humanoid.MaxHealth = godModeAtivo and math.huge or 100
        humanoid.Health = godModeAtivo and math.huge or 100
    end
end)

jumpBoostBtn.MouseButton1Click:Connect(function()
    jumpBoostAtivo = not jumpBoostAtivo
    jumpBoostBtn.Text = "Jump Boost: " .. (jumpBoostAtivo and "On" or "Off")
end)

infiniteJumpBtn.MouseButton1Click:Connect(function()
    infiniteJumpAtivo = not infiniteJumpAtivo
    infiniteJumpBtn.Text = "Infinite Jump: " .. (infiniteJumpAtivo and "On" or "Off")
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.UseJumpPower = not infiniteJumpAtivo
    end
end)

-- Lógica do Infinite Jump (em loop)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpAtivo then
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Lógica do Jump Boost (em loop)
RunService.RenderStepped:Connect(function()
    if jumpBoostAtivo then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local root = char.HumanoidRootPart
            if humanoid and root and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                if root.AssemblyLinearVelocity.Y < -10 then -- Só ativa em quedas mais rápidas
                    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 80, root.AssemblyLinearVelocity.Z)
                end
            end
        end
    end
end)


--[[ TELA 2 - Funções de Interação ]]

-- ESP
local espConnections = {}
local function updateESP()
    -- Limpa ESPs antigos
    for p, connection in pairs(espConnections) do
        if connection.gui then connection.gui:Destroy() end
        if connection.charAdded then connection.charAdded:Disconnect() end
        if connection.charRemoving then connection.charRemoving:Disconnect() end
        espConnections[p] = nil
    end

    if not espOn then return end

    local function createEspForPlayer(p)
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local oldEsp = p.Character.Head:FindFirstChild("EspGui")
            if oldEsp then oldEsp:Destroy() end

            local esp = Instance.new("BillboardGui", p.Character.Head)
            esp.Name = "EspGui"
            esp.Size = UDim2.new(0, 100, 0, 40)
            esp.AlwaysOnTop = true
            esp.Adornee = p.Character.Head
            
            local name = Instance.new("TextLabel", esp)
            name.Size = UDim2.new(1, 0, 1, 0)
            name.BackgroundTransparency = 1
            name.Text = p.Name
            name.TextColor3 = Color3.new(1, 0, 0)
            name.TextScaled = true
            name.Font = Enum.Font.SourceSansBold
            
            if espConnections[p] then
                espConnections[p].gui = esp
            end
        end
    end

    for _, p in pairs(game.Players:GetPlayers()) do
        espConnections[p] = {}
        createEspForPlayer(p)
        espConnections[p].charAdded = p.CharacterAdded:Connect(function() createEspForPlayer(p) end)
        espConnections[p].charRemoving = p.CharacterRemoving:Connect(function()
             if espConnections[p] and espConnections[p].gui then
                espConnections[p].gui:Destroy()
                espConnections[p].gui = nil
             end
        end)
    end
end

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = "Esp Players: " .. (espOn and "On" or "Off")
    updateESP()
end)

-- Fly
local flySpeed = 50
flyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    flyBtn.Text = "Fly: " .. (flyOn and "On" or "Off")
end)

RunService.Heartbeat:Connect(function()
    if flyOn then
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if not (char and root and humanoid) then return end
        
        humanoid.PlatformStand = true -- Evita que a gravidade afete
        
        local moveDirection = Vector3.new(0,0,0)
        local cameraCFrame = workspace.CurrentCamera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cameraCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cameraCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cameraCFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cameraCFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0,1,0) end

        -- Normaliza o vetor de movimento para garantir velocidade consistente em todas as direções
        if moveDirection.Magnitude > 0 then
            root.Velocity = moveDirection.Unit * flySpeed
        else
            root.Velocity = Vector3.new(0,0,0) -- Para de se mover se nenhuma tecla for pressionada
        end
    else
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.PlatformStand then
            char.Humanoid.PlatformStand = false
        end
    end
end)


-- Teleport Sky
tpSkyBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(char.HumanoidRootPart.Position + Vector3.new(0, 500, 0))
    end
end)

-- Hop Server
hopBtn.MouseButton1Click:Connect(function()
    local serversUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local request
    pcall(function()
        request = HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)
    
    if request and request.data then
        local servers = {}
        for _, server in ipairs(request.data) do
            if type(server) == 'table' and server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, player)
        else
            StarterGui:SetCore("SendNotification", {Title = "Hop Server", Text = "Nenhum servidor diferente encontrado.", Duration = 4})
        end
    else
        StarterGui:SetCore("SendNotification", {Title = "Hop Server", Text = "Falha ao obter lista de servidores.", Duration = 4})
    end
end)


--[[ TELA 3 - Funções de Utilitários ]]

instantBtn.MouseButton1Click:Connect(function()
    instantPromptOn = not instantPromptOn
    instantBtn.Text = "ProximityPrompt: " .. (instantPromptOn and "On" or "Off")
end)

RunService.Heartbeat:Connect(function()
    if instantPromptOn then
        for _, prompt in pairs(ProximityPromptService:GetPrompts()) do
            if prompt.Enabled and prompt.MaxActivationDistance > 0 then
                -- Calcula a distância entre o jogador e o prompt
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local distance = (char.HumanoidRootPart.Position - prompt.WorldPosition).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        ProximityPromptService:TriggerPrompt(prompt)
                    end
                end
            end
        end
    end
end)

-- Inicializa as telas
First_Screen.Enabled = true -- A First_Screen começa habilitada
KeyGui.Enabled = false     -- A KeyGui começa desabilitada
