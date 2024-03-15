require "./reactivity"

local s1 = signal(0)
local s2 = signal(0)
local s3 = signal(0)

effect(function()
    
    untrack(function ()
        print(s1.get(), s2.get(), s3.get())
        



    end)
end)
print(isReactive(nil))
--[[ effect(function()
    print("s2", s2.get())
end) ]]

--[[ batch(function()
    s1.set(11)
    s1.set(12)
    s1.set(13)
    s2.set(21)
    --s3.set(31)

    batch(function()
        s3.set(32)

        batch(function()
            s3.set(33)
        end)
    end)
end)
 ]]
 


 s3.set(1)
 --[[  untrack(function ()
    print(s3.get())
 end) ]]

 --print(s3.peek())