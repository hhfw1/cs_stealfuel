-------------------
-- CONFIG --
-------------------
CodeStudio = {}


CodeStudio.FuelType = 'abrp_fuel'  --Your Fuel Sysytem LegacyFuel/ps-fuel or if you have any other add here
CodeStudio.StealTime = 10    --Time to Steal in seconds
CodeStudio.RefuellingTime = 10   --Time to Refuel Fuel in seconds
CodeStudio.ExplodeOnFail = true  ---Explode Vehicle on Failing to do mini game
CodeStudio.RemoveOnFail = true -- Remove Empty Gas Can on Failing to do mini game

CodeStudio.Seconds = math.random(15,20) --Amount of Time to complete minigame
CodeStudio.Circles = math.random(1,2) --Amount of Circle for the minigame



----SHOPS-----

CodeStudio.EnableShops = true  ---Enable Disable Shops
CodeStudio.Target = 'abrp_target' 
CodeStudio.ShopPed = 's_m_m_movprem_01'
CodeStudio.Location = {    ---Shop Location add as many as you want
    vector4(299.04, -578.75, 43.26, 91),
}
CodeStudio.ToolItems = {  ---Shop Items add whatever you want
    label = 'Gasoline Shop',
    slots = 30,
    items = {
        { name = "mechanic_tools", price = 15000, amount = 10, info = {}, type = "item", slot = 1,},
    },
}

