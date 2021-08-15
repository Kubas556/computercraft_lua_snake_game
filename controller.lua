local monitor = peripheral.wrap("right")
local modem = peripheral.wrap("left")
monitor.setBackgroundColor(colors.black)
monitor.clear()
monitor.setCursorPos(1,1)
monitor.setTextScale(1.5)
local centerX,centerY = monitor.getSize()
local controlsEnum = {}
modem.open(1)

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

centerX = round(centerX/2)
centerY = round(centerY/2)

function drawControls()
    monitor.setCursorPos(centerX,centerY)
    monitor.blit(" ", "0", "9")
    monitor.setCursorPos(centerX-1,centerY)
    monitor.write("\27")
    controlsEnum[centerX-1] = {}
    controlsEnum[centerX-1][centerY] = "left"
    monitor.setCursorPos(centerX+1,centerY)
    monitor.write("\26")
    controlsEnum[centerX+1] = {}
    controlsEnum[centerX+1][centerY] = "right"
    monitor.setCursorPos(centerX,centerY-1)
    monitor.write("\24")
    controlsEnum[centerX] = {}
    controlsEnum[centerX][centerY-1] = "up"
    monitor.setCursorPos(centerX,centerY+1)
    monitor.write("\25")
    controlsEnum[centerX][centerY+1] = "down"
end

function handleTouch(x, y)
    modem.transmit(2,1,controlsEnum[x][y])
    term.write(controlsEnum[x][y])
end

drawControls()

while true do
    local event, p1, p2, p3 = os.pullEvent()
    if event == "key" then 
        if p1 == keys.enter then
            break
        end
    elseif event == "monitor_touch" then
        handleTouch(p2, p3)
    end
end