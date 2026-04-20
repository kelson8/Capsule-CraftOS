local utils = {}

function utils.scrollText(text, pageSize)
    pageSize = pageSize or 10
    local lines = {}
    
    for line in text:gmatch("([^\n]+)") do
        table.insert(lines, line)
    end

    local totalLines = #lines
    local currentLine = 1

    while currentLine <= totalLines do
        term.clear()
        term.setCursorPos(1, 1)

        for i = 0, pageSize - 1 do
            if lines[currentLine + i] then
                print(lines[currentLine + i])
            end
        end

        currentLine = currentLine + pageSize

        if currentLine <= totalLines then
            print("\nPress Enter to continue...")
            while true do
                local eventData = {os.pullEvent()}
                local event = eventData[1]
                
                if event == "key" then
                    if eventData[2] == 257 or eventData[2] == 335 then
                        break
                    end
                end
            end
        end
    end
end

return utils