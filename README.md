If you need support I now have a discord available, it helps me keep track of issues and give better support.

https://discord.gg/ESwSKregtt

# INSTALLATION

## Dependancies
- This script requires `LegacyFuel/ps-fuel` or any other fuel scirpt
- This script requires `ps-ui` for the minigame to work you can turn this on/off in config
- This script requires `qb-target` if you want to enable shop


---
## Item installation
- Add the image files from the image folder to your `qb-inventory > html > images` folder

- Add these lines to your qb-core > shared lua under the Items section
```lua
		["empty_can"] = {
		["name"] = "empty_can",                                                        
        ["label"] = "Empty Can",
        ["weight"] = 100,
        ["type"] = "item",
        ["image"] = "gascan.png",
        ["unique"] = false,
        ["useable"] = true,
        ["shouldClose"] = true,
        ["combinable"] = nil,
        ["description"] = ""
    },

    ["filled_can"] = {
		["name"] = "filled_can",                                                        
        ["label"] = "Filled Can",
        ["weight"] = 100,
        ["type"] = "item",
        ["image"] = "gascan.png",
        ["unique"] = true,
        ["useable"] = true,
        ["shouldClose"] = true,
        ["combinable"] = nil,
        ["description"] = ""
    },
```


## Item Registration

I have only done this with `qb-inventory` and `lj-inventory` as they are similar

`qb-inventory/html/js/app.js`

- Search for "stickynote" or Scroll down until you find:
```js
        } else if (itemData.name == "stickynote") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>" + itemData.info.label + "</p>");
```
- Directly underneath this add:
```js
        } else if (itemData.name == "filled_can") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>Available Fuel: " + itemData.info.fuel + "</p>");
```
When successfully added the filled gas can in your inventory will show the amount of fuel stored in it