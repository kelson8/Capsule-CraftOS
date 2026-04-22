local logger = {}

-- Source
-- https://pastebin.com/abFf6TPB

-- Logger util for Capsule

logger.levels = {
    DEBUG = {"DEBUG", 1},
    INFO = {"INFO", 2},
    WARNING = {"WARNING", 3},
    ERROR = {"ERROR", 4},
    CRITICAL = {"CRITICAL", 5},
}

-- Defaults
local logFilePath = "/tmp/logger.log"
local logToFile = true
local logToConsole = true
local includeScreenTimestamp = true
local logLevel = logger.levels.INFO

-- internal functions
local function getTimeStamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

local function writeLog(level, message)
    if level[2] < logLevel[2] then
        return
    end

    local stampped = string.format("[%s] [%s] %s", getTimeStamp(), level[1], message)
    local unstampped = string.format("[%s] %s", level[1], message)

    if logToConsole then
        if includeScreenTimestamp then
            print(stampped)
        else
            print(unstampped)
        end
    end

    if logToFile then
        local handle = fs.open(logFilePath, "a")
        if handle then
            handle.writeLine(stampped)
            handle.close()
        else
            logToFile = false
            writeLog(logger.levels.ERROR, "Internal > Unable to log into file, disabling file log")
        end
    end
end

function logger.debug(message)
    writeLog(logger.levels.DEBUG, message)
end

function logger.info(message)
    writeLog(logger.levels.INFO, message)
end

function logger.warning(message)
    writeLog(logger.levels.WARNING, message)
end

function logger.error(message)
    writeLog(logger.levels.ERROR, message)
end

function logger.critical(message)
    writeLog(logger.levels.CRITICAL, message)
end

function logger.configure(options)
    if options.filePath then
        logFilePath = options.filePath
    end
    if options.logToFile ~= nil then
        logToFile = options.logToFile
    end
    if options.logToConsole ~= nil then
        logToConsole = options.logToConsole
    end
    if options.stampScreen ~= nil then
        includeScreenTimestamp = options.stampScreen
    end
    if options.logLevel then
        logLevel = options.logLevel
    end
end

return logger