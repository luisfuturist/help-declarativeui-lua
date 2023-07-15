local context = {}
local isBatching = false
local batches = {}

function signal(initialValue)
    local value = initialValue
    local listeners = {}

    local function sub()
        local current = context[#context]
        if (current) then
            local exists = false
            for i = 1, #listeners do
                if (listeners[i] == current) then
                    exists = true
                    break
                end
            end

            if (not exists) then
                listeners[#listeners + 1] = current
            end
        end
    end

    local function unsub(callback)
        for i = 1, #listeners do
            if (listeners[i] == callback) then
                table.remove(listeners, i)
                break
            end
        end
    end

    local function notify()
        for i = 1, #listeners do
            listeners[i]()
        end
    end

    local function get()
        sub()
        return value
    end

    local function set(newValue)
        if (value == newValue) then return end
        value = newValue

        if (isBatching) then
            batches[#batches] = notify
            return
        end

        notify()
    end

    local function peek()
        return value
    end

    return {
        unsub = unsub,
        set = set,
        get = get,
        peek = peek
    }
end

function effect(callback)
    local disposed = false
    
    local function execute()
        context[#context+1] = execute
        if (not disposed) then
            callback()
        end
        table.remove(context, #context)
    end

    local function dispose()
        disposed = true
    end

    execute()
    return dispose
end

function batch(fn)
    local prevIsBatching = isBatching
    local prevBatch = batches[#batches];
    isBatching = true
    batches[#batches] = {}

    pcall(fn)

    local notify = batches[#batches];
    if (type(notify) == 'function' and not prevIsBatching) then
        notify()
    end

    table.remove(batches)

    isBatching = prevIsBatching
    batches[#batches] = prevBatch
end

function memo(callback)
    local cache = nil

    effect(function()
        if (cache) then
            cache.set(callback())
        else
            cache = signal(callback())
        end
    end)

    return {
        get = cache.get,
        peek = cache.peek
    }
end

function isReactive(value)
    return type(value) == 'table' and type(value.get) == 'function'
end

function safeGet(value, default)
    default = default or 0
    return (value and (isReactive(value) and value.peek() or value) or default)
end

function safeWrap(value)
    return isReactive(value) and value or signal(value)
end