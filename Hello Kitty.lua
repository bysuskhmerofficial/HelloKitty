local version = 1.1


------ CHECK GAMEPASS ------

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local HttpService = game:GetService("HttpService")
local LogoID = "rbxassetid://000"
local backgroundID = "rbxassetid://000"


local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local premium = false
local player = Players.LocalPlayer
local gamepassID = 1963837218


local function checkGamepass()
    local success, hasPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassID)
    end)

    if success then
        if hasPass then
            premium = true
            print(" Player Owns Gamepass!")
        else
            premium = false
            print(" Player DOES NOT own Gamepass.")
        end
    else
        warn(" Failed to check Gamepass: " .. tostring(hasPass))
    end
end

checkGamepass()

wait(0.5)

local lock = not premium

local function HelloKitty()
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Hello kitty",
    Icon = "zap",
    Author = "by .zorx",
    BackgroundImageTransparency = 0.42,
    Background = backgroundID,
})

Window:Tag({
    Title = "v" ..version,
    Icon = "octagon-alert",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13, -- from 0 to 13
})
Window:Tag({
    Title = "Beta",
    Icon = "shield-check",
    Color = Color3.fromHex("#FF0000"),
    Radius = 13, -- from 0 to 13
})

Window:EditOpenButton({
    Title = "Open Example UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = false,
    Draggable = false,
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =========================
-- Create GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "MyToggleGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- =========================
-- Image Button
-- =========================

local button = Instance.new("ImageButton")
button.Name = "ToggleButton"
button.Size = UDim2.fromOffset(50, 50)
button.Position = UDim2.new(0, 25, 0.5, -35)

button.BackgroundTransparency = 1
button.BorderSizePixel = 0
button.AutoButtonColor = false

button.Image = "rbxassetid://102815775006103"
button.ScaleType = Enum.ScaleType.Fit

button.Parent = gui

-- =========================
-- Make Image Circular
-- =========================

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = button

-- =========================
-- Settings
-- =========================

local IMAGE_OFF = "rbxassetid://102815775006103"
local IMAGE_ON = "rbxassetid://102815775006103"

local HOLD_TIME = 0.5

local isToggled = false
local isHolding = false
local holdStartTime = 0
local connection = nil

-- =========================
-- Toggle
-- =========================

local function setToggleState(state)

	isToggled = state

	if state then
		button.Image = IMAGE_ON
		print("Toggle ON")
	else
		button.Image = IMAGE_OFF
		print("Toggle OFF")
	end

end

-- =========================
-- Hold
-- =========================

local function startHold()

	if isHolding then
		return
	end

	isHolding = true
	holdStartTime = tick()

	TweenService:Create(
		button,
		TweenInfo.new(HOLD_TIME),
		{
			ImageTransparency = 0.4
		}
	):Play()

	connection = RunService.Heartbeat:Connect(function()

		if isHolding and tick() - holdStartTime >= HOLD_TIME then

			setToggleState(not isToggled)

			isHolding = false

			if connection then
				connection:Disconnect()
				connection = nil
			end

			TweenService:Create(
				button,
				TweenInfo.new(0.15),
				{
					ImageTransparency = 0
				}
			):Play()

		end

	end)

end

local function cancelHold()

	if not isHolding then
		return
	end

	isHolding = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	TweenService:Create(
		button,
		TweenInfo.new(0.15),
		{
			ImageTransparency = 0
		}
	):Play()

end

-- =========================
-- Drag System
-- =========================

local dragging = false
local dragStart
local startPosition

button.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = button.Position

		startHold()

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		button.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,

			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

	end

end)

button.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

		cancelHold()

	end

end)

-- =========================
-- Start

button.MouseButton1Click:Connect(function()
    Window:Toggle()
end)
-- =========================

setToggleState(false)

Window:DisableTopbarButtons({
    "Close", 
    "Minimize", 
    "Fullscreen",
})
------ FUNCTION REQUEST ---------

local function noti(title, content, duration)
    WindUI:Notify({
        Title = title or "",
        Content = content or "",
        Duration = duration or 5,
    })
end

local URL = ""

function run(scriptUrl)
    local HttpService = game:GetService("HttpService")
    local urlLower = scriptUrl:lower()
    local typescript = "Unknown"

    if string.find(urlLower, "github") then
        typescript = "Github"
    elseif string.find(urlLower, "pastebin") then
        typescript = "Pastebin"
    elseif string.find(urlLower, "gist") then
        typescript = "Gist"
    elseif string.find(urlLower, "hastebin") then
        typescript = "Hastebin"
    elseif string.find(urlLower, "ghostbin") then
        typescript = "Ghostbin"
    elseif string.find(urlLower, "controlc") then
        typescript = "ControlC"
    elseif string.find(urlLower, "rentry") then
        typescript = "Rentry"
    elseif string.find(urlLower, "sourcebin") then
        typescript = "SourceBin"
    elseif string.find(urlLower, "pastie") then
        typescript = "Pastie"
    elseif string.find(urlLower, "haste.host") then
        typescript = "HasteHost"
    elseif string.find(urlLower, "safetycode") then
        typescript = "SafetyCode-API"
    end

    WindUI:Notify({
        Title = "Script Run Please Wait",
        Content = "Wait",
        Duration = 5,
    })

    local startTime = os.clock()

    local success, err = pcall(function()
        local data = game:HttpGet(scriptUrl)

        local isJson, parsed = pcall(function()
            return HttpService:JSONDecode(data)
        end)

        if isJson and parsed.code then
            loadstring(parsed.code)()
        else
            -- ករណីគ្រាន់តែ Lua code
            loadstring(data)()
        end
    end)

    local endTime = os.clock()
    local elapsedTime = string.format("%.2f", endTime - startTime)

    if success then
        WindUI:Notify({
            Title = "Script Successful",
            Content = "Time Script done: " .. elapsedTime .. "s",
            Duration = 5,
        })
    else
        WindUI:Notify({
            Title = "Script Error",
            Content = "Error: " .. err .. "/Timer : " .. elapsedTime .. "s",
            Duration = 5,
        })
    end
end

------- TAB AND SCRIPT TAB1---------

local t1 = Window:Tab({
    Title = "Main",
    Icon = "shield-half",
    Locked = false,
})

Window:SelectTab(1) 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- Wait for player
repeat task.wait() until LocalPlayer and LocalPlayer:IsA("Player")

local info = t1:Paragraph({
    Title = "You Information",
    Desc = "Please Wait",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})


local currentFPS = 0
local frames = 0
local lastFPSUpdate = os.clock()

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local now = os.clock()
    if now - lastFPSUpdate >= 1 then
        currentFPS = frames
        frames = 0
        lastFPSUpdate = now
    end
end)

-- Helper Functions
local function formatTime(seconds)
    seconds = math.floor(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function getPing()
    local ping = "N/A"
    pcall(function()
        local item = Stats:FindFirstChild("Network")
        if item then
            local stats = item:FindFirstChild("ServerStatsItem")
            if stats then
                local data = stats:FindFirstChild("Data Ping")
                if data then
                    ping = string.format("%d ms", math.floor(data:GetValue()))
                end
            end
        end
    end)
    return ping
end

local function getDevice()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "📱 Mobile"
    elseif UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then
        return "🎮 Console"
    elseif UserInputService.KeyboardEnabled then
        return "💻 PC"
    else
        return "❓ Unknown"
    end
end

local function getPlatform()
    local success, platform = pcall(function()
        return UserInputService:GetPlatform()
    end)
    if success and platform then
        return tostring(platform):gsub("Enum.Platform.", "")
    end
    return "Unknown"
end

local function getMemory()
    local memory = "N/A"
    pcall(function()
        memory = string.format("%.1f MB", Stats:GetTotalMemoryUsageMb())
    end)
    return memory
end

local startTime = os.clock()

-- Update Loop
task.spawn(function()
    while task.wait(1) do
        local success, accountAge = pcall(function()
            return LocalPlayer.AccountAge
        end)
        
        local playerCount = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers

        local gameName = "Unknown"
        pcall(function()
            local info = MarketplaceService:GetProductInfo(game.PlaceId)
            gameName = info.Name
        end)

        local jobId = game.JobId
        if jobId == "" then jobId = "🏠 Studio / Local Server" end

        local device = getDevice()
        local platform = getPlatform()
        local ping = getPing()
        local memory = getMemory()

        local camera = Workspace.CurrentCamera
        local resolution = "N/A"
        if camera then
            local viewport = camera.ViewportSize
            resolution = string.format("%d x %d", math.floor(viewport.X), math.floor(viewport.Y))
        end

        local currentTime = os.date("%H:%M:%S")

        local desc = string.format(
            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "👤 ACCOUNT\n" ..
            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "Name        : %s\n" ..
            "Display     : %s\n" ..
            "User ID     : %d\n" ..
            "Account Age : %d Days\n\n" ..

            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "🎮 GAME\n" ..
            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "Game Name   : %s\n" ..
            "Place ID    : %d\n" ..
            "Players     : %d/%d\n" ..
            "Job ID      : %s\n\n" ..

            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "⚡ PERFORMANCE\n" ..
            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "Play Time   : %s\n" ..
            "Ping        : %s\n" ..
            "FPS         : %d\n" ..
            "Memory      : %s\n\n" ..

            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "💻 DEVICE\n" ..
            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "Device      : %s\n" ..
            "Platform    : %s\n" ..
            "Resolution  : %s\n\n" ..

            "━━━━━━━━━━━━━━━━━━━━━━\n" ..
            "🕐 %s\n" ..
            "━━━━━━━━━━━━━━━━━━━━━━",

            LocalPlayer.Name,
            LocalPlayer.DisplayName,
            LocalPlayer.UserId,
            accountAge or 0,
            gameName,
            game.PlaceId,
            playerCount,
            maxPlayers,
            jobId,
            formatTime(os.clock() - startTime),
            ping,
            currentFPS,
            memory,
            device,
            platform,
            resolution,
            currentTime
        )

        pcall(function()
            info:SetDesc(desc)
        end)
    end
end)

local Paragraph = t1:Paragraph({
    Title = "Hello Kitty Is in Beta — Sorry for the Bugs",
    Desc = "I'm working on the next update.",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

local HttpService = game:GetService("HttpService")

-- =========================
-- Theme Save Settings
-- =========================



local FOLDER = "Hellokitty"
local FILE = FOLDER .. "/theme.json"

local function saveTheme(themeName)
    if not writefile then
        warn("writefile is not supported")
        return
    end

    if makefolder and isfolder and not isfolder(FOLDER) then
        makefolder(FOLDER)
    end

    local data = {
        Theme = themeName
    }

    writefile(FILE, HttpService:JSONEncode(data))
end

local function loadTheme()
    if not readfile or not isfile then
        return nil
    end

    if not isfile(FILE) then
        return nil
    end

    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(FILE))
    end)

    if success and result and result.Theme then
        return result.Theme
    end

    return nil
end

-- =========================
-- Get All WindUI Themes
-- =========================

local themes = WindUI:GetThemes()
local themeList = {}

for name, _ in pairs(themes) do
    table.insert(themeList, tostring(name))
end

table.sort(themeList)

-- =========================
-- Load Saved Theme
-- =========================

local savedTheme = loadTheme()

if savedTheme and themes[savedTheme] then
    WindUI:SetTheme(savedTheme)
end

-- =========================
-- Theme Dropdown
-- =========================

local Dropdown = t1:Dropdown({
    Title = "Theme",
    Desc = "Select your UI theme",

    Values = themeList,

    Value = (savedTheme and themes[savedTheme])
        and savedTheme
        or themeList[1],

    Callback = function(option)
        option = tostring(option)

        -- Apply theme
        WindUI:SetTheme(option)

        -- Save theme
        saveTheme(option)

        print("Theme Saved: " .. option)
    end
})

-------- TAB 2 -----------

local t2 = Window:Tab({
    Title = "Local Player",
    Icon = "user",
    Locked = false,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local hrp = character:FindFirstChild("HumanoidRootPart")

if not humanoid then
    warn("[❌] Humanoid not found.")
end
if not hrp then
    warn("[❌] HumanoidRootPart not found.")
end

-- Settings
getgenv().loopW = false
getgenv().loopJ = false
getgenv().InfJ = false

local speed = humanoid and humanoid.WalkSpeed or 16
local jump = humanoid and humanoid.JumpPower or 50

-- Input Speed
t2:Input({
    Title = "Enter Your Speed",
    Desc = "Walkspeed Value",
    Value = speed,
    Placeholder = "Enter speed...",
    Callback = function(val)
        local n = tonumber(val)
        if n and humanoid then
            speed = n
            humanoid.WalkSpeed = speed
        end
    end
})

-- Toggle Walk Loop
t2:Toggle({
    Title = "Loop Speed",
    Desc = "Auto maintain WalkSpeed",
    Default = false,
    Callback = function(v)
        getgenv().loopW = v
    end
})

-- Input Jump
t2:Input({
    Title = "Enter Your Jump",
    Desc = "JumpPower Value",
    Value = jump,
    Placeholder = "Enter jump power...",
    Callback = function(val)
        local n = tonumber(val)
        if n and humanoid then
            jump = n
            humanoid.JumpPower = jump
        end
    end
})

-- Toggle Jump Loop
t2:Toggle({
    Title = "Loop Jump",
    Desc = "Auto maintain JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().loopJ = v
    end
})

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().InfJ then
        local c = player.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

t2:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump anytime",
    Default = false,
    Callback = function(v)
        getgenv().InfJ = v
    end
})

-- Loops
local speedLoop, jumpLoop

local function bindLoops(char)
    humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if speedLoop then speedLoop:Disconnect() end
    if jumpLoop then jumpLoop:Disconnect() end

    speedLoop = RunService.Heartbeat:Connect(function()
        if getgenv().loopW then
            pcall(function()
                humanoid.WalkSpeed = speed
            end)
        end
    end)

    jumpLoop = RunService.Heartbeat:Connect(function()
        if getgenv().loopJ then
            pcall(function()
                humanoid.JumpPower = jump
            end)
        end
    end)
end

if player.Character then bindLoops(player.Character) end
player.CharacterAdded:Connect(bindLoops)

-- Noclip
local noclipLoop
local Clip = true

local function noclip()
    Clip = false
    if noclipLoop then noclipLoop:Disconnect() end
    noclipLoop = RunService.Stepped:Connect(function()
        if not Clip and character then
            for _, v in ipairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function clip()
    Clip = true
    if noclipLoop then
        noclipLoop:Disconnect()
        noclipLoop = nil
    end
end

t2:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Default = false,
    Callback = function(v)
        if v then
            noclip()
        else
            clip()
        end
    end
})

local TpSpeed = 1
local tpwalkConnection = nil

local Input = t2:Input({
    Title = "Input Tpwalk",
    Desc = "Input Tpwalk speed",
    Value = "1",
    InputIcon = "",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter Tpwalkspeed...",
    Callback = function(text) 
        local num = tonumber(text)
        if num then
            TpSpeed = num
        end
    end
})

local Toggle = t2:Toggle({
    Title = "Tpwalk Status",
    Desc = "Tpwalk Status",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer

        if state then
            tpwalkConnection = RunService.Heartbeat:Connect(function()
                local chr = player.Character
                local hum = chr and chr:FindFirstChildOfClass("Humanoid")
                
                if hum and hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection * TpSpeed)
                end
            end)
        else
            if tpwalkConnection then
                tpwalkConnection:Disconnect()
                tpwalkConnection = nil
            end
        end
    end
})

local stateFly = false
    local FlySpeed = 25

local Input = t2:Input({
    Title = "Input Fly Speed",
    Desc = "Input Fly speed",
    Value = "25",
    InputIcon = "",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter Speed Fly...",
    Callback = function(val) 
        FlySpeed = val
    end
})

local Toggle = t2:Toggle({
    Title = "Fly Status",
    Desc = "Fly Status",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(v) 
        stateFly = v
if stateFly == false then
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler:Destroy()
game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler:Destroy()
game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
end
end
while stateFly do
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(9e9,9e9,9e9)
game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(9e9,9e9,9e9)
game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.CFrame = Workspace.CurrentCamera.CoordinateFrame
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = Vector3.new()
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * FlySpeed)
end
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X < 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * FlySpeed)
end
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * FlySpeed)
end
if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z < 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * FlySpeed)
end
elseif game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") == nil then
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")

bv.Name = "VelocityHandler"
bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
bv.MaxForce = Vector3.new(0,0,0)
bv.Velocity = Vector3.new(0,0,0)

bg.Name = "GyroHandler"
bg.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
bg.MaxTorque = Vector3.new(0,0,0)
bg.P = 1000
bg.D = 50
end
task.wait()
end
    end
})


--------- TAB 3 -------------

local t3 = Window:Tab({
    Title = "Script",
    Icon = "code",
    Locked = false,
})

local function ScriptAdd(title, raw)
local Button = t3:Button({
    Title = title,
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run(raw)
    end
})
end

local Section = t3:Section({ 
    Title = "Script",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Button = t3:Button({
    Title = "Fly {Fe Gui V3}",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/AVG/refs/heads/main/Fly%20Gui%20V3")
    end
})

local Button = t3:Button({
    Title = "Fly {Vehicle}",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui")
    end
})

ScriptAdd("Fly Car", "https://safetycode-free.vercel.app/api/run?uid=sOVkfQrqmoqsd576b7x")

local Button = t3:Button({
    Title = "Rejoin Game",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

local Button = t3:Button({
    Title = "Rejoin Server",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

ScriptAdd("Chat Bypasser", "https://raw.githubusercontent.com/vqmpjayZ/Bypass/8e92f1a31635629214ab4ac38217b97c2642d113/vadrifts")
ScriptAdd("Webhook Tool", "https://raw.githubusercontent.com/venoxhh/universalscripts/main/webhook_tools")
ScriptAdd("FPS Counter", "https://pastefy.app/c63s1M4w/raw")
ScriptAdd("Old Hitbox Expander", "https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/HitboxExpander.lua")
ScriptAdd("Kawaii Freaky Fling", "https://raw.githubusercontent.com/hellohellohell012321/KAWAII-FREAKY-FLING/main/kawaii_freaky_fling.lua")
ScriptAdd("FE Animation Changer", "https://pastebin.com/raw/6pQYX6gU")
ScriptAdd("Orca Hub (Toggle Key = K)", "https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua")
ScriptAdd("FE (R6/R15) 210+ Emotes / 31 Animations", "https://raw.githubusercontent.com/Eazvy/public-scripts/main/Universal_Animations_Emotes.lua")
ScriptAdd("ShiftLock", "https://pastebin.com/raw/bKMz1DdF")
ScriptAdd("Keyboard", "https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/VirtualKeyboard.lua.txt")
ScriptAdd("Fe Invisible", "https://pastebin.com/raw/3Rnd9rHf")
ScriptAdd("Fps Boost", "https://raw.githubusercontent.com/UhGbaaaa/Script-Roblox-New/refs/heads/main/Fps%20boost%202024")
ScriptAdd("Free Emoji", "https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/Emoji.txt")
ScriptAdd("Wallhop", "https://raw.githubusercontent.com/aceurss/AcxScripter/refs/heads/main/FakeWallHopScript")
ScriptAdd("Aimbot", "https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile")
ScriptAdd("AimBot 2", "https://pastebin.com/raw/qtZt0Nzb")
ScriptAdd("Teleport Player", "https://raw.githubusercontent.com/Infinity2346/Tect-Menu/main/Teleport%20Gui.lua")
ScriptAdd("FE Lag Switch", "https://raw.githubusercontent.com/0Ben1/fe/main/Protected%20-%202023-05-28T225112.055.lua.txt")
ScriptAdd("Gubby Spawner", "https://pastebin.com/raw/Vs4J3jni")

local Button = t3:Button({
    Title = "Fall Gui",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source")
        Ioad("35487fdd8d70227a1537e4dfa2d21e5c")
    end
})

local Button = t3:Button({
    Title = "Anti Kick",
    Desc = "Click For To Load Script",
    Locked = lock,
    Callback = function()
        local old
 old = hookmetamethod(
 game,
 "__namecall",
 function(self, ...)
  local method = tostring(getnamecallmethod())
  if string.lower(method) == "kick" then
     return 
  end
  return old(self, ...)
 end)
    end
})

ScriptAdd("Anti Cheat", "https://safetycode-free.vercel.app/api/run?uid=sOVubU1lEE9IeYI6Mtz8cerjbdzwziq")

local Button = t3:Button({
    Title = "Anti Fling",
    Desc = "Click For To Load Script",
    Locked = lock,
    Callback = function()
        local function NoCollision(plr)
            if AntiFling and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end

        -- Apply to existing players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                RunService.Stepped:Connect(function()
                    NoCollision(player)
                end)
            end
        end

        -- Apply to new players
        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                RunService.Stepped:Connect(function()
                    NoCollision(player)
                end)
            end
        end)
    end
})

local Section = t3:Section({ 
    Title = "SpaceGame",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local GravityOriginal = workspace.Gravity

local Slider = t3:Slider({
    Title = "Gravity",
    Step = 1,
    
    Value = {
        Min = 0,
        Max = 1000,
        Default = GravityOriginal,
    },
    Callback = function(value)
        workspace.Gravity = value
    end
})

local Camera = game.Workspace.CurrentCamera
local PovOriginal = Camera.FieldOfView

local Input = t3:Input({
    Title = "Fov",
    Desc = "Input Fov (1 - 120)",
    Value = tostring(Camera.FieldOfView),
    InputIcon = "",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter Fov...",
    Callback = function(input)
        local num = tonumber(input)
        if num and num >= 1 and num <= 120 then
            Camera.FieldOfView = num
            print("FOV set to:", num)
        else
            warn("Invalid FOV input:", input)
        end
    end
})

local Players = game:GetService("Players")
local PlrNs = Players.LocalPlayer

local DefaultCameraMode = "Classic" -- fallback default

if PlrNs.CameraMode == Enum.CameraMode.LockFirstPerson then
    DefaultCameraMode = "LockFirstPerson"
end

local Dropdown = t3:Dropdown({
    Title = "CameraMode (Select)",
    Values = { "Classic", "LockFirstPerson" },
    Value = DefaultCameraMode,
    Callback = function(option) 
        if option == "Classic" then
            PlrNs.CameraMode = Enum.CameraMode.Classic
        elseif option == "LockFirstPerson" then
            PlrNs.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end
})

local Players = game:GetService("Players")
local PlrNs = Players.LocalPlayer

local modeToIndex = {
    UserChoice = 1,
    Thumbstick = 2,
    DPad = 3,
    Thumbpad = 4,
    ClickToMove = 5,
    Scriptable = 6,
}

local currentModeName = PlrNs.DevTouchMovementMode.Name
local DefaultDexTouchMove = modeToIndex[currentModeName] or 1

local Dropdown = t3:Dropdown({
    Title = "DevTouchMovementMode (Select)",
    Values = { "UserChoice", "Thumbstick", "DPad", "Thumbpad", "ClickToMove", "Scriptable" },
    Value = DefaultDexTouchMove,
    Callback = function(Value)
        local enumValue = Enum.DevTouchMovementMode[Value]
        if enumValue then
            PlrNs.DevTouchMovementMode = enumValue
            print("DevTouchMovementMode changed to:", Value)
        else
            warn("Invalid DevTouchMovementMode selected:", Value)
        end
    end
})

local pp = false
local RunService = game:GetService("RunService")
-- 🔧 Variable Setup
local Lighting = game:GetService("Lighting")

-- 💾 Save Original Lighting Settings
local BrightnessOld = Lighting.Brightness
local ClockTimeOld = Lighting.ClockTime
local FogEndOld = Lighting.FogEnd
local GlobalShadowsOld = Lighting.GlobalShadows
local OutdoorAmbientOld = Lighting.OutdoorAmbient

-- ⚙️ Function to Apply or Reset Lighting
local function updateLighting()
    if pp then
        -- Enable Full Bright
        pcall(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end)
    else
        -- Reset to Original
        pcall(function()
            Lighting.Brightness = BrightnessOld
            Lighting.ClockTime = ClockTimeOld
            Lighting.FogEnd = FogEndOld
            Lighting.GlobalShadows = GlobalShadowsOld
            Lighting.OutdoorAmbient = OutdoorAmbientOld
        end)
    end
end

local Toggle = t3:Toggle({
    Title = "Full Brightness",
    Desc = "Full Brightness ",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        pp = state
        updateLighting()
    end
})

local Player = game.Players.LocalPlayer

local toggleRemoveFogEnd = game.Lighting.FogEnd
local toggleRemoveFogStart = game.Lighting.FogStart
local toggleRemoveFogAmbient = game.Lighting.Ambient
local toggleRemoveFogOutDoors = game.Lighting.OutdoorAmbient

local function ScriptRemoveFog()
    game.Lighting.FogEnd = math.huge
    game.Lighting.FogStart = 0
    game.Lighting.Ambient = Color3.fromRGB(167, 167, 167)
    game.Lighting.OutdoorAmbient = Color3.fromRGB(167, 167, 167)
end

local function ScriptRemoveFogReast()
    game.Lighting.FogEnd = toggleRemoveFogEnd
    game.Lighting.FogStart = toggleRemoveFogStart
    game.Lighting.Ambient = toggleRemoveFogAmbient
    game.Lighting.OutdoorAmbient = toggleRemoveFogOutDoors
end

local Toggle = t3:Toggle({
    Title = "Remove Fog",
    Desc = "Remove Fog ",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        if state then
            ScriptRemoveFog()
        else
            ScriptRemoveFogReast()
        end
    end
})

local Toggle = t3:Toggle({
    Title = "Part Invisible / Show",
    Desc = "Part Invisible / Show ",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        if state then
            -- Make all BaseParts fully visible (Transparency = 0)
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if not descendant:FindFirstChild("OriginalTransparency") then
                        local originalTransparency = Instance.new("NumberValue")
                        originalTransparency.Name = "OriginalTransparency"
                        originalTransparency.Value = descendant.Transparency
                        originalTransparency.Parent = descendant
                    end
                    descendant.Transparency = 0
                end
            end
        else
            -- Restore original transparency values
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local originalTransparency = descendant:FindFirstChild("OriginalTransparency")
                    if originalTransparency then
                        descendant.Transparency = originalTransparency.Value
                    end
                end
            end
        end
    end
})

local Section = t3:Section({ 
    Title = "Script Hub",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

ScriptAdd("Dhelirium Admin", "https://raw.githubusercontent.com/Dhelann/Dhelirium/refs/heads/main/source.luau")

local Button = t3:Button({
    Title = "explorer",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
    end
})

local Button = t3:Button({
    Title = "Infinite Yield",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
})

local Button = t3:Button({
    Title = "GhostPlayer",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub")
    end
})

local Button = t3:Button({
    Title = "Swamp Monster Hub",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        run("https://pastefy.app/2tC7nRAK/raw")
    end
})

---------- TAB 4 -----------

local t4 = Window:Tab({
    Title = "Hitbox / Troll",
    Icon = "box",
    Locked = false,
})

local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- Variables
local HitboxSize = 10
local HitboxTransparency = 0.8
local TeamCheck = false
local HitboxStatus = false
local ToolsHitboxSize = 10
local TypeHitbox = "Player"

local rainbowConnection = nil
local toolConnection = nil
local toolHitboxConnection = nil
local HitboxConnection = nil

-- HSV to RGB converter function
local function HSVToRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return Color3.new(r, g, b)
end

-- Function to apply hitbox on tools
local function applyHitbox(tool)
    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
        local handle = tool.Handle
        handle.Massless = true
        handle.Transparency = 1
        handle.Size = Vector3.new(ToolsHitboxSize, ToolsHitboxSize, ToolsHitboxSize)

        local selectionBox = Instance.new("SelectionBox")
        selectionBox.Adornee = handle
        selectionBox.Parent = handle

        if rainbowConnection then
            rainbowConnection:Disconnect()
        end

        rainbowConnection = RunService.RenderStepped:Connect(function()
            local hue = (tick() % 5) / 5
            selectionBox.Color3 = HSVToRGB(hue, 1, 1)
        end)
    end
end

-- Handle dropdown choice changes
local function onDropdownChoice(choice)
    if toolConnection then
        toolConnection:Disconnect()
        toolConnection = nil
    end
    if toolHitboxConnection then
        toolHitboxConnection:Disconnect()
        toolHitboxConnection = nil
    end
    if HitboxConnection then
        HitboxConnection:Disconnect()
        HitboxConnection = nil
    end

    -- Clear previous SelectionBoxes and reset transparency
    for _, tool in ipairs(Player.Character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            for _, obj in ipairs(tool.Handle:GetChildren()) do
                if obj:IsA("SelectionBox") then
                    obj:Destroy()
                end
            end
            tool.Handle.Transparency = 0
        end
    end

    -- Reset other players' HumanoidRootPart
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player then
            pcall(function()
                local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Color = Color3.new(0.5, 0.5, 0.5)
                    hrp.Material = Enum.Material.Plastic
                    hrp.CanCollide = false
                end
            end)
        end
    end

    TypeHitbox = choice
    print("[Hitbox] Switched to:", choice)
end

-- Handle toggle hitbox status
local function onToggleStatus(state)
    if TypeHitbox == "Tools" then
        if state then
            -- Apply hitbox to existing tools
            for _, tool in ipairs(Player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                    applyHitbox(tool)
                end
            end

            -- Listen for new tools
            toolConnection = Player.Character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") and child:FindFirstChild("Handle") then
                    applyHitbox(child)
                end
            end)

            -- Check for tools missing SelectionBox
            toolHitboxConnection = RunService.Heartbeat:Connect(function()
                for _, tool in ipairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        if not tool.Handle:FindFirstChildOfClass("SelectionBox") then
                            applyHitbox(tool)
                        end
                    end
                end
            end)
        else
            -- Turn off tool hitbox
            if toolConnection then
                toolConnection:Disconnect()
                toolConnection = nil
            end
            if toolHitboxConnection then
                toolHitboxConnection:Disconnect()
                toolHitboxConnection = nil
            end
            for _, tool in ipairs(Player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                    for _, obj in ipairs(tool.Handle:GetChildren()) do
                        if obj:IsA("SelectionBox") then
                            obj:Destroy()
                        end
                    end
                    tool.Handle.Transparency = 0
                end
            end
        end
    else
        HitboxStatus = state

        if HitboxConnection then
            HitboxConnection:Disconnect()
            HitboxConnection = nil
        end

        if state then
            HitboxConnection = RunService.RenderStepped:Connect(function()
                local rainbowHue = (tick() % 5) / 5
                local rainbowColor = HSVToRGB(rainbowHue, 1, 1)
                for _, v in ipairs(game.Players:GetPlayers()) do
                    if v ~= Player then
                        local sameTeam = (v.Team == Player.Team)
                        if (TeamCheck and not sameTeam) or (not TeamCheck) then
                            pcall(function()
                                local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                                    hrp.Transparency = HitboxTransparency
                                    hrp.Color = rainbowColor
                                    hrp.Material = Enum.Material.Neon
                                    hrp.CanCollide = false
                                end
                            end)
                        end
                    end
                end
            end)
        else
            for _, v in ipairs(game.Players:GetPlayers()) do
                if v ~= Player then
                    pcall(function()
                        local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                            hrp.Color = Color3.new(0.5, 0.5, 0.5)
                            hrp.Material = Enum.Material.Plastic
                            hrp.CanCollide = false
                        end
                    end)
                end
            end
        end
    end
end

local Dropdown = t4:Dropdown({
    Title = "Choose Hitbox",
    Values = { "Player", "Tools"},
    Value = "Player",
    Callback = function(option) 
        onDropdownChoice(option)
    end
})

local Slider = t4:Slider({
    Title = "Hitbox Size",
    Step = 0.1,   
    Value = {
        Min = 1,
        Max = 150,
        Default = 10,
    },
    Callback = function(value)
           HitboxSize = value
            ToolsHitboxSize = value
    end
})

local Slider = t4:Slider({
    Title = "Hitbox Transparency",
    Step = 0.01,   
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.8,
    },
    Callback = function(value)
        HitboxTransparency = value
    end
})

local Toggle = t4:Toggle({
    Title = "Team Check",
    Desc = "Check Team ",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        TeamCheck = state
    end
})

local Toggle = t4:Toggle({
    Title = "Hitbox Status",
    Desc = "Hitbox Status ",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        onToggleStatus(state)
    end
})

local Section = t4:Section({ 
    Title = "Script | Troll",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Button = t4:Button({
    Title = "saMtiek2",
    Desc = "Click For to Run Script",
    Locked = false,
    Callback = function()
        run("https://pastebin.com/raw/saMtiek2")
    end
})

local Button = t4:Button({
    Title = "TrollGui",
    Desc = "Click For to Run Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/AVG/refs/heads/main/Fe%20Troll%20Fling")
    end
})

local Button = t4:Button({
    Title = "Auto Fling Player",
    Desc = "Click For to Run Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Auto%20Fling%20Player")
    end
})

local Button = t4:Button({
    Title = "Touch Fling GUi",
    Desc = "Click For to Run Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI")
    end
})

local Button = t4:Button({
    Title = "FE Fling Panel",
    Desc = "Click For to Run Script",
    Locked = false,
    Callback = function()
        load("FE Fling Panel.txt")
    end
})


------ TAB 5 ------------

local t5 = Window:Tab({
    Title = "Game",
    Icon = "gamepad-2",
    Locked = false,
})


function AddGame(name)
    local Section = t5:Section({ 
    Title = name,
    TextXAlignment = "Left",
    TextSize = 25, 
})
end

function AddScript(name, url)
    local Button = t5:Button({
    Title = name,
    Desc = "Click For to Run Script",
    Locked = false,
    Callback = function()
        if not url then
            print("Url not have")
        else
            run(url)
        end
    end
})
end

AddGame("Murder Mystery 2")
AddScript("Murder Mystery 2", "https://pastebin.com/raw/Vec48eZf")

AddGame("Steal A Brainrot")
AddScript("Steal A Brainrot", "https://raw.githubusercontent.com/Gregy677/Gunmods-strucid/main/Steal%20a%20brain%20rot")

AddGame("Ink Game")
AddScript("Ink Game", "https://raw.githubusercontent.com/fqfqfqfqwgqghadfaffg/TeslHubCode/refs/heads/main/bob")

AddGame("99 Night in the Forest")
AddScript("99 Night in the Forest", "https://pastebin.com/raw/CgiJB7mR")

AddGame("Death Penalty")
AddScript("Death Penalty", "https://api.luarmor.net/files/v3/loaders/8c08b8f2252eec7dbb77d253d269bb65.lua")

AddGame("Survive The Killer")
AddScript("Survive The Killer", "https://raw.githubusercontent.com/Milan08Studio/ChairWare/main/main.lua")

AddGame("The Rake REMASTERED")
AddScript("The Rake REMASTERED 1", "https://raw.githubusercontent.com/ScriptsLynX/LynX/main/KeySystem/Loader.lua")
AddScript("The Rake REMASTERED 2", "https://raw.githubusercontent.com/Djskinybinn/The-Rake-Remastered-Script-Keyless/refs/heads/main/ObfuscatedRakeScript.lua")

AddGame("BloxFruits")
AddScript("BloxFruits", "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")

AddGame("T-Titans Battlegroundsn")
AddScript("T-Titans Battlegroundsn", "https://pastefy.app/CPymuwSW/raw")

AddGame("Grow a Garden")
AddScript("Grow a Garden 1", "https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/loader")
AddScript("Grow a Garden 2", "https://raw.githubusercontent.com/Ayvathion/AV-On-Top/refs/heads/main/GrowAGarden.lua")

AddGame("The Floor Is LAVA")
AddScript("The Floor Is LAVA", "https://pastebin.com/raw/yn39XZ6R")

AddGame("Brookhaven")
AddScript("Brookhaven 1", "https://raw.githubusercontent.com/Daivd977/Deivd999/refs/heads/main/pessal")
AddScript("Brookhaven 2", "https://safetycode-free.vercel.app/api/run?uid=sOVADqgSEOWfKJeo23vm")

AddGame("Build a battle")
AddScript("Build a battle 1", "https://rawscripts.net/raw/NUKE!-Build-and-Battle!-limnchhubRevorkTEST-24053")
AddScript("Build a battle 2", "https://raw.githubusercontent.com/UhGbaaaa/Game-script-/main/Build%20a%20battle.txt")
AddScript("Build a battle 3", "https://raw.githubusercontent.com/linhmcfake/Script/refs/heads/main/MaxNo1.lua.txt")


-------- TAB 6 -------


local t6 = Window:Tab({
    Title = "Other",
    Icon = "ethernet-port",
    Locked = lock,
})

local gotopartDelay = 0.1
local espTransparency = 0.3  
local speaker = game.Players.LocalPlayer
local espParts = {}
local isEspEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

function AddESP(part)
    if not (PartName and part:IsA("BasePart") and part.Name:lower() == PartName:lower()) then return end
    if part:FindFirstChild(PartName.."_TextESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = PartName.."_TextESP"
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0  -- UI មិនប្រើពន្លឺ
    billboard.Parent = part

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = part.Name
    textLabel.TextColor3 = espColor or Color3.fromRGB(0, 255, 0)
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
end

local PartName = ""
local LoopGoto = false
local LoopBring = false

local Button = t6:Button({
    Title = "Part Name",
    Desc = "Click Run Script Get Part Name",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/partname.lua.txt")
    end
})

local Input = t6:Input({
    Title = "Input Part Name",
    Desc = "How Get Part name Click Script Part Name",
    Value = "",
    InputIcon = "",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter Partname...",
    Callback = function(Value) 
        PartName = Value
        getgenv().PartName = Value
    end
})

local Toggle = t6:Toggle({
    Title = "Part ESP",
    Desc = "part esp for show Direction",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        isEspEnabled = state
        if state then
            if PartName and not table.find(espParts, PartName) then  
                table.insert(espParts, PartName)  
                for _, v in pairs(workspace:GetDescendants()) do  
                    AddESP(v)
                end  
            end  
        else
            espParts = {}  
            for _, part in pairs(workspace:GetDescendants()) do  
                if part:IsA("BasePart") then  
                    local adornment = part:FindFirstChild(PartName.."_TextESP")  
                    if adornment then  
                        adornment:Destroy()  
                    end  
                end  
            end  
        end
    end
})

local Button = t6:Button({
    Title = "Goto",
    Desc = "Goto to Part",
    Locked = false,
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if getgenv().PartName and v.Name:lower() == getgenv().PartName:lower() and v:IsA("BasePart") then
                local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass('Humanoid')
                if humanoid and humanoid.SeatPart then
                    humanoid.Sit = false
                    wait(0.1)
                end
                wait(gotopartDelay or 0)
                local root = getRoot(speaker.Character)
                if root then
                    root.CFrame = v.CFrame
                end
            end
        end
    end
})

local Toggle = t6:Toggle({
    Title = "Loop Goto",
    Desc = "Auto Goto",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(v) 
        LoopGoto = v
    end
})

local Button = t6:Button({
    Title = "Bring",
    Desc = "Bring Part",
    Locked = false,
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if getgenv().PartName and v.Name:lower() == getgenv().PartName:lower() and v:IsA("BasePart") then
                local root = getRoot(speaker.Character)
                if root then
                    v.CFrame = root.CFrame
                end
            end
        end
    end
})

local Toggle = t6:Toggle({
    Title = "Loop Bring",
    Desc = "AutoBring",
    Icon = ToggleUI,
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        LoopBring = state
    end
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")

local function Touch()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower() == (getgenv().PartName or ""):lower() then
            firetouchinterest(humanoidRoot, v, 0)
            firetouchinterest(humanoidRoot, v, 1)
            task.wait(0.1) -- small delay to prevent spamming
        end
    end
end

t6:Button({
    Title = "Touch",
    Desc = "Be careful. Not support for executor",
    Callback = function()
        if typeof(firetouchinterest) ~= "function" then
            WindUI:Notify({
                Title = "Unsupported",
                Content = "firetouchinterest not supported by this executor.",
                Duration = 5
            })
            return
        end
        Touch()
    end
})

workspace.DescendantAdded:Connect(function(part)
    if not PartName or PartName == "" then return end
    if not part:IsA("BasePart") then return end
    if part.Name:lower() ~= PartName:lower() then return end

    -- ESP
    if isEspEnabled then
        AddESP(part)
    end

    -- Goto
    if LoopGoto then
        task.delay(gotopartDelay or 0, function()
            local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.SeatPart then
                humanoid.Sit = false
                task.wait(0.1)
            end
            local root = getRoot(speaker.Character)
            if root then
                root.CFrame = part.CFrame
            end
        end)
    end

    -- Bring
    if LoopBring then
        task.delay(0, function()
            local root = getRoot(speaker.Character)
            if root then
                part.CFrame = root.CFrame
            end
        end)
    end
end)

local Section = t6:Section({ 
    Title = "Support",
    TextXAlignment = "Left",
    TextSize = 25, 
})

local Button = t6:Button({
    Title = "Part Gui",
    Desc = "Run Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source")
        Ioad("583e3bd54554f2bfdcd007a49fa6b035")
    end
})

local Button = t6:Button({
    Title = "position finder gui",
    Desc = "Run Script",
    Locked = false,
    Callback = function()
        run("https://pastebin.com/raw/BjViRedU")
    end
})


local Button = t6:Button({
    Title = "turtle spy",
    Desc = "Run Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/source.lua.txt")
    end
})


local Button = t6:Button({
    Title = "SimpleSpy",
    Desc = "Run Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/UhGbaaaa/Android-Value/main/SimpleSpyMobile.txt")
    end
})

local Button = t6:Button({
    Title = "OctoSpy",
    Desc = "Run Script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/Octo%7ESpy.lua.txt")
    end
})

local Button = t6:Button({
    Title = "Gui Make",
    Desc = "Run script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/Key-System-/refs/heads/main/Gui%20Maker.txt")
    end
})

local Section = t6:Section({ 
    Title = "Tools",
    TextXAlignment = "Left",
    TextSize = 17, 
})

local Button = t6:Button({
    Title = "Telekinesis",
    Desc = "Run script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/qwerty11.lua.txt")
    end
})

local Button = t6:Button({
    Title = "F3X",
    Desc = "Run script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Bysuskhmerops62/script-/refs/heads/main/F3X.LUA.txt")
    end
})

local Button = t6:Button({
    Title = "Click Tp Normal",
    Desc = "Run script",
    Locked = false,
    Callback = function()
        mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click Teleport"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
    end
})

local Section = t6:Section({ 
    Title = "Executor",
    TextXAlignment = "Left",
    TextSize = 17, 
})


local Button = t6:Button({
    Title = "Arceus x",
    Desc = "Run script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Giangplay/Script/main/Arceus_X_V3.lua")
    end
})

local Button = t6:Button({
    Title = "Codex",
    Desc = "Run script",
    Locked = false,
    Callback = function()
        run("https://raw.githubusercontent.com/Giangplay/Script/main/Codex.lua")
    end
})

-------- TAB 7 ----------

local t7 = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SelectedPlayerName = nil

-- បង្កើត Dropdown ជាមុន
local Dropdown = t7:Dropdown({
    Title = "Select Player",
    Values = { "Loading..." },
    Value = "Loading...",
    Callback = function(option)
        SelectedPlayerName = option
    end
})

-- Function ដើម្បីយក player name លើកលែងខ្លួនឯង
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- Function update Dropdown values dynamically
local function UpdateDropdown()
    local players = GetPlayerNames()
    if #players == 0 then
        Dropdown:Refresh({ "No Players" })
        SelectedPlayerName = nil
    else
        Dropdown:Refresh(players)
        if not table.find(players, SelectedPlayerName) then
            SelectedPlayerName = players[1]
        end
    end
end

-- Initial update
UpdateDropdown()

-- Update Dropdown នៅពេលមាន Player ចូល
Players.PlayerAdded:Connect(function()
    task.wait(0.1)
    UpdateDropdown()
end)

-- Update Dropdown នៅពេលមាន Player ចាកចេញ
Players.PlayerRemoving:Connect(function()
    UpdateDropdown()
end)

local Button = t7:Button({
    Title = "🔄 Refresh List",
    Desc = "Manually refresh player list",
    Locked = false,
    Callback = function()
        UpdateDropdown()
    end
})

-- Button: Goto
local Button = t7:Button({
    Title = "Goto",
    Desc = "Teleport to selected player",
    Locked = false,
    Callback = function()
        if not SelectedPlayerName then return end

        local target = Players:FindFirstChild(SelectedPlayerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
        end
    end
})

-- Button: Bring
local Button = t7:Button({
    Title = "Bring",
    Desc = "Bring selected player to you",
    Locked = false,
    Callback = function()
        if not SelectedPlayerName then return end

        local target = Players:FindFirstChild(SelectedPlayerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and
           LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            target.Character:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
        end
    end
})

-------- TAB 8 ---------

------ TAB 9 ------

local t9 = Window:Tab({
    Title = "Premium",
    Icon = "crown",
    Locked = false,
})

if premium then

local Section = t9:Section({ 
    Title = "You Premium : " .. tostring(premium),
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

local Section = t9:Section({ 
    Title = "Thank you for purchasing.",
    TextXAlignment = "Left",
    TextSize = 17, -- Default Size
})

else
local Button = t9:Button({
    Title = "Buy Premium 80 Robux",
    Desc = "Click buy to copy link",
    Locked = false,
    Callback = function()
        setclipboard("https://www.roblox.com/game-pass/1325778239")
    end
})

local Paragraph = t9:Paragraph({
    Title = " What Premium Gives:\n�Unlock Premium Tab\n� Unlock Premium Scripts",
    Desc = " 80 Robux for Premium Access",
    Color = "Blue",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "shopping-cart",
            Title = "Buy Now",
            Callback = function()
                print(" Buy Button Clicked!")
                setclipboard("https://www.roblox.com/game-pass/1963837218")
            end,
        }
    }
})

end

----- TAB 10 ------

local t10 = Window:Tab({
    Title = "Script Premium",
    Icon = "gem",
    Locked = lock,
})

local Button = t10:Button({
    Title = "destroy Delay",
    Desc = "Click For To Load Script",
    Locked = false,
    Callback = function()
        while task.wait(0.3) do
                local hasChanged = false
                
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.HoldDuration ~= 0 then
                        v.HoldDuration = 0
                        hasChanged = true
                    end
                end
                
                if not hasChanged then
                    task.wait(1)
                end
            end
    end
})

end



------------------------------------------------------------
-- RUN
------------------------------------------------------------

------ Wait ------

-- LoadingScreen (LocalScript in StarterGui)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local player = Players.LocalPlayer
ReplicatedFirst:RemoveDefaultLoadingScreen()

-- Root GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolLoadingScreen"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
bg.BorderSizePixel = 0
bg.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 35)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 15, 45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20)),
})
gradient.Rotation = 45
gradient.Parent = bg

-- Logo / Title
local title = Instance.new("TextLabel")
title.Text = "LOADING"
title.Font = Enum.Font.GothamBlack
title.TextSize = 46
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.fromOffset(400, 60)
title.Position = UDim2.new(0.5, -200, 0.4, -30)
title.Parent = bg

-- Pulsing glow behind title
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(140, 90, 255)
glow.Thickness = 2
glow.Transparency = 0.3
glow.Parent = title

-- Progress bar container
local barBack = Instance.new("Frame")
barBack.Size = UDim2.fromOffset(400, 8)
barBack.Position = UDim2.new(0.5, -200, 0.55, 0)
barBack.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
barBack.BorderSizePixel = 0
barBack.Parent = bg

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBack

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(150, 90, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = barFill

local fillGradient = Instance.new("UIGradient")
fillGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 80, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 200)),
})
fillGradient.Parent = barFill

-- Percentage text
local percentLabel = Instance.new("TextLabel")
percentLabel.Text = "0%"
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextSize = 18
percentLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
percentLabel.BackgroundTransparency = 1
percentLabel.Size = UDim2.fromOffset(400, 30)
percentLabel.Position = UDim2.new(0.5, -200, 0.57, 15)
percentLabel.Parent = bg

-- Rotating tips
local tips = {
	"Tip: Explore every corner of the map!",
	"Tip: Team up with friends for bonus rewards.",
	"Tip: Check the shop for daily deals.",
	"Tip: Press M to open your inventory.",
}

local tipLabel = Instance.new("TextLabel")
tipLabel.Text = tips[1]
tipLabel.Font = Enum.Font.Gotham
tipLabel.TextSize = 16
tipLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
tipLabel.BackgroundTransparency = 1
tipLabel.Size = UDim2.fromOffset(500, 30)
tipLabel.Position = UDim2.new(0.5, -250, 0.85, 0)
tipLabel.Parent = bg

-- Pulse animation for title glow
task.spawn(function()
	while screenGui.Parent do
		TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.8}):Play()
		task.wait(1)
		TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.2}):Play()
		task.wait(1)
	end
end)

-- Rotate tips every 3 seconds
task.spawn(function()
	local i = 1
	while screenGui.Parent do
		task.wait(3)
		i = (i % #tips) + 1
		TweenService:Create(tipLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		task.wait(0.3)
		tipLabel.Text = tips[i]
		TweenService:Create(tipLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	end
end)

-- Simulated / real loading progress
local function setProgress(alpha)
	alpha = math.clamp(alpha, 0, 1)
	TweenService:Create(barFill, TweenInfo.new(0.2), {Size = UDim2.new(alpha, 0, 1, 0)}):Play()
	percentLabel.Text = math.floor(alpha * 100) .. "%"
end

-- Wait for game to actually finish loading
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Fake progress ramp for visual smoothness (replace with real asset loading progress if you have it)
for i = 1, 20 do
	setProgress(i / 20)
	task.wait(0.20)
end

task.wait(0.5)

-- Fade out and destroy
local fadeTime = 0.6
TweenService:Create(bg, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
for _, obj in ipairs(bg:GetDescendants()) do
	if obj:IsA("TextLabel") then
		TweenService:Create(obj, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
	elseif obj:IsA("Frame") then
		TweenService:Create(obj, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
	elseif obj:IsA("UIStroke") then
		TweenService:Create(obj, TweenInfo.new(fadeTime), {Transparency = 1}):Play()
	end
end

task.wait(fadeTime + 0.1)
screenGui:Destroy()
--==================================================
-- Panda Auth PUSL-V4
-- Key System UI
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- PANDA AUTH
--==================================================

local PUSL

local success, err = pcall(function()
    PUSL = loadstring(game:HttpGet(
        "https://secure.pandauth.com/pv4/lib"
    ))()
end)

if not success or not PUSL then
    warn("[Panda] Library failed to load:", err)
    return
end

if type(PUSL.configure) ~= "function" then
    warn("[Panda] Invalid Panda Auth library.")
    return
end

if type(PUSL.validate) ~= "function" then
    warn("[Panda] validate() is missing.")
    return
end

PUSL.configure({
    serviceId = "zorx",
})

--==================================================
-- CONFIG
--==================================================

local Config = {
    Title = "Key System",
    Subtitle = "Enter your Panda key",

    SaveFile = "PandaKey.txt",

    AccentColor = Color3.fromRGB(90, 100, 255),
    BackgroundColor = Color3.fromRGB(24, 24, 28),
    PanelColor = Color3.fromRGB(30, 30, 36),
}

--==================================================
-- FILE FUNCTIONS
--==================================================

local function saveKey(key)
    pcall(function()
        if writefile then
            writefile(Config.SaveFile, key)
        end
    end)
end

local function loadKey()
    local result

    pcall(function()
        if isfile and readfile and isfile(Config.SaveFile) then
            result = readfile(Config.SaveFile)
        end
    end)

    return result
end

local function deleteKey()
    pcall(function()
        if isfile and delfile and isfile(Config.SaveFile) then
            delfile(Config.SaveFile)
        end
    end)
end

--==================================================
-- VALIDATE
--==================================================

local function validateKey(key)

    if not key or key == "" then
        return false, "Please enter a key."
    end

    local ok, result = pcall(function()
        return PUSL.validate(key)
    end)

    if not ok then
        return false, "Validation error: " .. tostring(result)
    end

    if type(result) ~= "table" then
        return false, "Invalid response from Panda."
    end

    if result.success then
        return true, result
    end

    return false, result.message or "Invalid key."

end

--==================================================
-- AUTO LOGIN
--==================================================

local savedKey = loadKey()

if savedKey and savedKey ~= "" then

    local valid, result = validateKey(savedKey)

    if valid then

        print(
            "[Panda] Authenticated."
        )

        print(
            "[Panda] Premium:",
            tostring(result.isPremium)
        )

        --==========================================
        -- YOUR NORMAL SCRIPT STARTS HERE
        --==========================================

        HelloKitty()

        return

    else

        deleteKey()

        warn(
            "[Panda] Saved key is invalid."
        )

    end
end

--==================================================
-- UI HELPERS
--==================================================

local function create(className, properties)

    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    return object

end

local function corner(parent, radius)

    create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent,
    })

end

local function tween(object, properties, duration, style)

    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.25,
            style or Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    )

    animation:Play()

    return animation

end

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = create("ScreenGui", {
    Name = "PandaKeySystem",
    ResetOnSpawn = false,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local parentSuccess = pcall(function()
    ScreenGui.Parent = CoreGui
end)

if not parentSuccess then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

--==================================================
-- BACKDROP
--==================================================

local Backdrop = create("Frame", {
    Size = UDim2.fromScale(1, 1),

    BackgroundColor3 = Color3.new(0, 0, 0),

    BackgroundTransparency = 1,

    BorderSizePixel = 0,

    ZIndex = 1,

    Parent = ScreenGui,
})

--==================================================
-- PANEL
--==================================================

local Panel = create("Frame", {
    Size = UDim2.fromOffset(360, 220),

    Position = UDim2.new(
        0.5,
        0,
        0.45,
        0
    ),

    AnchorPoint = Vector2.new(0.5, 0.5),

    BackgroundColor3 = Config.PanelColor,

    BackgroundTransparency = 1,

    BorderSizePixel = 0,

    ZIndex = 2,

    Parent = ScreenGui,
})

corner(Panel, 16)

create("UIStroke", {
    Color = Config.AccentColor,

    Transparency = 0.5,

    Thickness = 1.5,

    Parent = Panel,
})

--==================================================
-- ACCENT
--==================================================

local Accent = create("Frame", {
    Size = UDim2.new(1, 0, 0, 4),

    BackgroundColor3 = Config.AccentColor,

    BorderSizePixel = 0,

    ZIndex = 3,

    Parent = Panel,
})

corner(Accent, 2)

--==================================================
-- TITLE
--==================================================

create("TextLabel", {
    Text = Config.Title,

    Font = Enum.Font.GothamBold,

    TextSize = 22,

    TextColor3 = Color3.new(1, 1, 1),

    BackgroundTransparency = 1,

    Size = UDim2.new(1, -40, 0, 30),

    Position = UDim2.new(0, 20, 0, 22),

    TextXAlignment = Enum.TextXAlignment.Left,

    ZIndex = 3,

    Parent = Panel,
})

--==================================================
-- SUBTITLE
--==================================================

create("TextLabel", {
    Text = Config.Subtitle,

    Font = Enum.Font.Gotham,

    TextSize = 14,

    TextColor3 = Color3.fromRGB(
        170,
        170,
        180
    ),

    BackgroundTransparency = 1,

    Size = UDim2.new(1, -40, 0, 20),

    Position = UDim2.new(0, 20, 0, 52),

    TextXAlignment = Enum.TextXAlignment.Left,

    ZIndex = 3,

    Parent = Panel,
})

--==================================================
-- INPUT
--==================================================

local InputFrame = create("Frame", {
    Size = UDim2.new(1, -40, 0, 40),

    Position = UDim2.new(0, 20, 0, 84),

    BackgroundColor3 = Config.BackgroundColor,

    BorderSizePixel = 0,

    ZIndex = 3,

    Parent = Panel,
})

corner(InputFrame, 10)

local KeyBox = create("TextBox", {
    PlaceholderText = "Enter key here...",

    Text = "",

    ClearTextOnFocus = false,

    Font = Enum.Font.Gotham,

    TextSize = 14,

    TextColor3 = Color3.new(1, 1, 1),

    PlaceholderColor3 = Color3.fromRGB(
        120,
        120,
        130
    ),

    BackgroundTransparency = 1,

    Size = UDim2.new(1, -20, 1, 0),

    Position = UDim2.new(0, 10, 0, 0),

    ZIndex = 4,

    Parent = InputFrame,
})

--==================================================
-- STATUS
--==================================================

local Status = create("TextLabel", {
    Text = "",

    Font = Enum.Font.Gotham,

    TextSize = 13,

    TextColor3 = Color3.fromRGB(
        255,
        100,
        100
    ),

    BackgroundTransparency = 1,

    Size = UDim2.new(1, -40, 0, 18),

    Position = UDim2.new(0, 20, 0, 128),

    TextXAlignment = Enum.TextXAlignment.Left,

    ZIndex = 3,

    Parent = Panel,
})

--==================================================
-- SUBMIT
--==================================================

local Submit = create("TextButton", {
    Text = "Submit",

    Font = Enum.Font.GothamBold,

    TextSize = 15,

    TextColor3 = Color3.new(1, 1, 1),

    BackgroundColor3 = Config.AccentColor,

    Size = UDim2.new(1, -40, 0, 38),

    Position = UDim2.new(0, 20, 0, 152),

    BorderSizePixel = 0,

    AutoButtonColor = false,

    ZIndex = 3,

    Parent = Panel,
})

corner(Submit, 10)

--==================================================
-- GET KEY
--==================================================

local GetKey = create("TextButton", {
    Text = "Get Key",

    Font = Enum.Font.Gotham,

    TextSize = 12,

    TextColor3 = Color3.fromRGB(
        190,
        190,
        200
    ),

    BackgroundTransparency = 1,

    Size = UDim2.new(0.5, -22, 0, 20),

    Position = UDim2.new(0, 20, 1, -26),

    ZIndex = 3,

    Parent = Panel,
})

--==================================================
-- OPEN UI
--==================================================

local function openUI()

    Panel.Size = UDim2.fromOffset(
        320,
        190
    )

    tween(
        Backdrop,
        {
            BackgroundTransparency = 0.5
        },
        0.3
    )

    tween(
        Panel,
        {
            BackgroundTransparency = 0,

            Size = UDim2.fromOffset(
                360,
                220
            )
        },
        0.3,
        Enum.EasingStyle.Back
    )

end

--==================================================
-- CLOSE UI
--==================================================

local closing = false

local function closeUI(callback)

    if closing then
        return
    end

    closing = true

    tween(
        Backdrop,
        {
            BackgroundTransparency = 1
        },
        0.25
    )

    tween(
        Panel,
        {
            BackgroundTransparency = 1
        },
        0.25
    )

    task.delay(0.25, function()

        if ScreenGui then
            ScreenGui:Destroy()
        end

        if callback then
            callback()
        end

    end)

end

--==================================================
-- SUBMIT LOGIC
--==================================================

local checking = false

local function submitKey()

    if checking then
        return
    end

    local key = tostring(KeyBox.Text or "")

    key = key:gsub("^%s*(.-)%s*$", "%1")

    if key == "" then

        Status.TextColor3 =
            Color3.fromRGB(
                255,
                100,
                100
            )

        Status.Text =
            "Please enter a key."

        return
    end

    checking = true

    Submit.Text = "Checking..."

    Status.Text = ""

    task.spawn(function()

        local valid, result = validateKey(key)

        if valid then

            Status.TextColor3 =
                Color3.fromRGB(
                    100,
                    255,
                    140
                )

            Status.Text =
                "Key accepted!"

            saveKey(key)

            print(
                "[Panda] Authenticated."
            )

            print(
                "[Panda] Premium:",
                tostring(result.isPremium)
            )

            task.wait(0.5)

            closeUI(function()

                --========================================
                HelloKitty()
                --========================================

                print(
                    "[Panda] Protected code started."
                )

            end)

        else

            Status.TextColor3 =
                Color3.fromRGB(
                    255,
                    100,
                    100
                )

            Status.Text =
                tostring(result)

            Submit.Text = "Submit"

            checking = false

        end

    end)

end

--==================================================
-- BUTTON EVENTS
--==================================================

Submit.MouseButton1Click:Connect(function()
    submitKey()
end)

KeyBox.FocusLost:Connect(function(enterPressed)

    if enterPressed then
        submitKey()
    end

end)

--==================================================
-- GET KEY
--==================================================

GetKey.MouseButton1Click:Connect(function()

    local url

    local ok, result = pcall(function()
        return PUSL.getKeyUrl()
    end)

    if ok then
        url = result
    end

    if url then

        pcall(function()

            if setclipboard then
                setclipboard(url)
            end

        end)

        GetKey.Text = "Copied!"

        task.delay(1.2, function()

            if GetKey then
                GetKey.Text = "Get Key"
            end

        end)

    else

        Status.TextColor3 =
            Color3.fromRGB(
                255,
                100,
                100
            )

        Status.Text =
            "Unable to get key URL."

    end

end)

--==================================================
-- OPEN
--==================================================

openUI()