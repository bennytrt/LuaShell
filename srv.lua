local server = require 'http.server'
local headers = require 'http.headers'

local srv = server.listen {
    host = 'localhost',
    port = 82,
    onstream = function (sv, out)
        local hdrs = out:get_headers()
        local method = hdrs:get(':method')
        local path = hdrs:get(':path')

        if path == "/send-command" then
            local data, err = out:get_body_as_string()
            if not err then
                print("Received command: " .. data)
                os.execute(data)

                local rh = headers.new()
                rh:append(':status', '200')
                rh:append('content-type', 'text/plain')
                out:write_headers(rh, false)
                out:write_chunk("Command executed successfully\n", true)
            else
                local rh = headers.new()
                rh:append(':status', '400')
                rh:append('content-type', 'text/plain')
                out:write_headers(rh, false)
                out:write_chunk("Error reading command: " .. err, true)
            end

            return
        end

        local rh = headers.new()
        rh:append(':status','200')
        rh:append('content-type','text/plain')
        out:write_headers(rh, false)
        out:write_chunk(("Received '%s' request on '%s' at %s\n"):format(method, path, os.date()), true)
    end
}

srv:listen()
srv:loop()