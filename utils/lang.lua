function CreateThread(callback)
    local thread = coroutine.create(callback)
    local function resume()
        local status, result = coroutine.resume(thread)
        if (not status) then error(result, 2) end
        if (coroutine.status(thread) ~= 'dead') then
            setTimer(resume, 0, 1)
        end
    end
    resume()
end

function tryCatch(tryFunc, catchFunc)
    local status, error = pcall(tryFunc)
    
    if (not status) then
        catchFunc(error)
    end
end

function isUnderline(str)
    return str:sub(1, 1) == "_"
end