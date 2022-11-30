
local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name="plugin.bugsnag", publisherId="com.cabagomez", version=1 }

-------------------------------------------------------------------------------
-- BEGIN
-------------------------------------------------------------------------------

local function showWarning(functionName)
    print( functionName .. " WARNING: The bugsnag plugin is only supported on iOS and Android. Please build for device")
end

function lib.init()
    showWarning("bugsnag.init()")
end

function lib.crash()
    showWarning("bugsnag.crash()")
end

function lib.leaveBreadcrumb()
    showWarning("bugsnag.leaveBreadcrumb()")
end


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------

-- Return an instance
return lib
