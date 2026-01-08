-- Ned's Hammerspoon config

-- reload on save: https://github.com/Porco-Rosso/PorcoSpoon/blob/main/init.lua#L1-L14
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon loaded")

-- MouseCircle example (tweaked)
mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.absolutePosition()
    -- Prepare a big red circle around the mouse pointer
    local r = 30
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x - r, mousepoint.y - r, 2 * r, 2 * r))
    mouseCircle:setStrokeColor({red=1, blue=0, green=0, alpha=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 2 seconds
    mouseCircleTimer = hs.timer.doAfter(2, function()
        mouseCircle:delete()
        mouseCircle = nil
    end)
end
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "O", mouseHighlight)


-- AClock spoon
hs.loadSpoon("AClock")
spoon.AClock["textColor"] = {red=.6, alpha=.75}
spoon.AClock["textFont"] = "Recursive Casual Bold"
spoon.AClock["textSize"] = 300
spoon.AClock["format"] = "%I:%M"
spoon.AClock["height"] = 600
spoon.AClock["width"] = 1000
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K", function()
    spoon.AClock:toggleShow()
end)
clock_screen_watcher = hs.screen.watcher.newWithActiveScreen(
    function() spoon.AClock:init() end
):start()


-- https://github.com/miromannino/miro-windows-manager
hs.loadSpoon("MiroWindowsManager")

local mirohyper = {"shift", "alt", "cmd"}
hs.window.animationDuration = 0.0
spoon.MiroWindowsManager.sizes = {4/3, 3/2, 2/1, 3/1, 1}
spoon.MiroWindowsManager:bindHotkeys({
    up = {mirohyper, "up"},
    right = {mirohyper, "right"},
    down = {mirohyper, "down"},
    left = {mirohyper, "left"},
    fullscreen = {mirohyper, "f"},
    nextscreen = {mirohyper, "n"}
})

-- Text-mode "menu bar indicator" replacement
canvas = nil
function createCanvas()
    if canvas then
        canvas:hide()
    end
    local screen = hs.screen.primaryScreen()
    local frame = screen:frame()
    local fullFrame = screen:fullFrame()
    canvas = hs.canvas.new({
        x = fullFrame.x,
        y = frame.y - 1,    -- Tahoe left a 1-pixel gap
        w = frame.x - fullFrame.x,
        h = fullFrame.h / 2,
    })
    canvas[1] = {
        type = "rectangle",
        action = "fill",
        fillColor = {hex="#D0D0D0"},
    }
    canvas[2] = {
        type = "text",
        frame = {x=2, y=1, h="100%", w="100%"},
        textFont = "SF Pro Text",
        textSize = 14,
        textColor = {hex="#000000"},
    }
    canvas:show()
    canvas:sendToBack()
    drawInfo()
end

function drawInfo()
    lines = {}

    time = os.date("%I:%M"):gsub("^0", "")
    table.insert(lines, time)
    date = os.date("%b %d"):gsub(" 0", " ")
    table.insert(lines, date)

    if hs.battery.isCharging() then
        charge = "+"
    elseif hs.battery.isCharged() then
        charge = "="
    else
        charge = "-"
    end
    table.insert(lines, string.format("%d%%%s", hs.battery.percentage(), charge))

    audio = hs.audiodevice.current()
    if audio.muted then
        vol = "<|"
        vol = "\u{2297}"
    elseif audio.volume then
        vol = string.format("\u{229A}%d", math.floor(audio.volume + 0.5))
    else
        vol = "\u{2296}\u{2192}"  -- EM DASH
    end
    table.insert(lines, vol)

    wifirate = hs.wifi.interfaceDetails().transmitRate
    table.insert(lines, string.format("%d\u{2933}", wifirate))  -- WAVE ARROW POINTING DIRECTLY RIGHT

    -- Have to enable location services for Hammerspoon to get the wifi name.
    -- https://github.com/Hammerspoon/hammerspoon/issues/3537
    -- Run this in the hammerspoon console to get Hammerspoon into the location
    -- services control panel:  hs.location.get()
    ssid = hs.wifi.currentNetwork() or "None"
    if string.len(ssid) > 5 then
        ssid = string.sub(ssid, 1, 3) .. string.sub(ssid, string.len(ssid)-1)
    end
    table.insert(lines, ssid)

    canvas[2].text = table.concat(lines, "\n")
end

createCanvas()

-- Start over when any screen geometry changes.
watcher = hs.screen.watcher.newWithActiveScreen(createCanvas):start()
-- Redraw every 3 seconds.
timer = hs.timer.doEvery(3, drawInfo)
-- Redraw when any audio setting changes.
for _, dev in ipairs(hs.audiodevice.allOutputDevices()) do
    dev:watcherCallback(drawInfo):watcherStart()
end


--
-- App switching
--

-- print("Running applications:")
for _, app in ipairs(hs.application.runningApplications()) do
    local ok, path = pcall(function() return app:path() end)
    if ok then
        -- print(app)
        -- print(app:path())
        if path and path:find("Messenger") then
            messenger_path = path
        end
    end
end
-- print("-----")

appShortcuts = {
    {"D", "Discord"},
    {"F", "Spotify"},
    {"G", messenger_path},
    {"H", "Google Chrome"},
    {"I", "Textual 7"},
    {"M", "Mail"},
    {"P", "Preview"},
    -- {"Q", "Visual Studio Code"},
    {"S", "Slack"},
    {"T", "iTerm"},
    -- {"U", "Tuple"},
    {"V", "MacVim"},
    {"X", "Firefox"},
    {"Z", "zoom.us"},
}

for _, shortcut in ipairs(appShortcuts) do
    hs.hotkey.bind({"ctrl", "alt", "cmd"}, shortcut[1], function()
        hs.application.launchOrFocus(shortcut[2])
    end)
end

--
-- Media control
--

mediaShortcuts = {
    {"up", "MUTE"},
    {"left", "SOUND_DOWN"},
    {"right", "SOUND_UP"},
    {"end", "NEXT"},
    {"home", "PREVIOUS"},
    {"pageup", "PLAY"},
}

for _, shortcut in ipairs(mediaShortcuts) do
    hs.hotkey.bind({"ctrl", "alt", "cmd"}, shortcut[1], function()
        hs.eventtap.event.newSystemKeyEvent(shortcut[2], true):post()
        hs.eventtap.event.newSystemKeyEvent(shortcut[2], false):post()
    end)
end

--
-- Sound volume overlay, by Claude
--

local volumeCanvas = nil
local volumeTimer = nil
local currentDevice = nil

local function showVolumeOverlay()
    local device = hs.audiodevice.defaultOutputDevice()
    if not device then return end
    
    local volume = device:volume() or 0
    local muted = device:muted()
    
    if volumeCanvas then volumeCanvas:delete() end
    if volumeTimer then volumeTimer:stop() end
    
    local screen = hs.screen.mainScreen():fullFrame()
    local barWidth = 300
    local barHeight = 40
    local x = (screen.w - barWidth) / 2
    local y = (screen.h - barHeight) / 2
    
    volumeCanvas = hs.canvas.new({x = x, y = y, w = barWidth, h = barHeight})
    
    volumeCanvas:appendElements({
        type = "rectangle",
        fillColor = {white = 0.2, alpha = 0.8},
        roundedRectRadii = {xRadius = 5, yRadius = 5},
    })
    
    local displayVolume = muted and 0 or volume
    volumeCanvas:appendElements({
        type = "rectangle",
        frame = {x = 2, y = 2, w = (barWidth - 4) * (displayVolume / 100), h = barHeight - 4},
        fillColor = {blue = 0.6, green = 0.7, alpha = 0.9},
        roundedRectRadii = {xRadius = 3, yRadius = 3},
    })
    
    volumeCanvas:show()
    
    volumeTimer = hs.timer.doAfter(2, function()
        if volumeCanvas then
            volumeCanvas:delete()
            volumeCanvas = nil
        end
    end)
end

local function setupDeviceWatcher()
    if currentDevice then
        currentDevice:watcherCallback(nil)
        currentDevice:watcherStop()
    end
    
    currentDevice = hs.audiodevice.defaultOutputDevice()
    if currentDevice then
        currentDevice:watcherCallback(function(uid, event, scope, element)
            if event == "vmvc" or event == "mute" then
                showVolumeOverlay()
            end
        end)
        currentDevice:watcherStart()
    end
end

-- Set up watcher on current device
setupDeviceWatcher()

-- Re-setup if default device changes
hs.audiodevice.watcher.setCallback(function(event)
    if event == "dOut" then
        setupDeviceWatcher()
    end
end)
hs.audiodevice.watcher.start()
