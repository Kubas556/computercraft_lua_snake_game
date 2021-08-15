local monitor = peripheral.wrap("right")
local modem = peripheral.wrap("left")
monitor.setBackgroundColor(colors.black)
modem.open(2)
monitor.clear()
monitor.setCursorPos(1,1)
monitor.setTextScale(0.5)
local x,y = monitor.getSize()
List = {}
function List.new ()
    return {first = 0, last = -1}
end
function List.pushright (list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end
function List.popright (list)
    local last = list.last
    if list.first > last then error("list is empty") end
    local value = list[last]
    list[last] = nil         -- to allow garbage collection
    list.last = last - 1
    return value
end
function List.popleft (list)
    local first = list.first
    if first > list.last then error("list is empty") end
    local value = list[first]
    list[first] = nil        -- to allow garbage collection
    list.first = first + 1
    return value
end
local snakePos = List.new()
local headPos = {x=1.0,y=1.0}
List.pushright(snakePos, {x=1.0,y=1.0});
local snakeDir = "right"

function round(x)
    return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function controller()
    while true do
        local event, p1, p2, p3, p4 = os.pullEvent()
        if event == "key" then 
            if p1 == keys.enter then
                break
            end
        elseif event == "modem_message" then
            snakeDir = p4
        end
    end
end

function snake()
    while true do
        if snakeDir == "left" then
            local newPos = round(headPos.x - 1)
            headPos.x = newPos < 1 and x or newPos
        elseif snakeDir == "right" then 
            local newPos = round(headPos.x + 1)
            headPos.x = newPos > x and 1 or newPos
        elseif snakeDir == "up" then 
            local newPos = round(headPos.y - 1)
            headPos.y = newPos < 1 and y or newPos
        elseif snakeDir == "down" then 
            local newPos = round(headPos.y + 1)
            headPos.y = newPos > y and 1 or newPos
        end

        List.pushright(snakePos, {x=headPos.x, y=headPos.y})
        for k, v in pairs(snakePos) do
            if type(v) == "table" then
                monitor.setCursorPos(v.x, v.y)
                monitor.blit(" ", "0", "9")
            end
        end

        monitor.setCursorPos(round(x/2), round(y/2))
        monitor.blit(" ", "0", "5")

        if headPos.x == round(x/2) and headPos.y == round(y/2) then
            
        else
            local toRemove = List.popleft(snakePos)
            monitor.setCursorPos(toRemove.x,toRemove.y)
            monitor.blit(" ", "0", "f")
        end
        os.sleep(0.1)
    end
end

parallel.waitForAny(controller,snake)