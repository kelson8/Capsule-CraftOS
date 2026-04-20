local monitor_util = require("/lib/util/monitor_util")

monitor_util:reset()
monitor_util:write_to_center("Test")
-- print(monitor_util:monitor_write_to_center("Test"))

-- monitor_util.write_to_center("Test")
