function getName()
	return "Second Ice 03"
end

function onMapLoaded()
end

function initMap()
	-- get the current map context
	local map = Map.get()
	map:addTile("tile-background-ice-07", 0, 0)
	map:addTile("tile-background-ice-05", 0, 1)
	map:addTile("tile-background-ice-05", 0, 2)
	map:addTile("tile-background-ice-03", 0, 3)
	map:addTile("tile-background-ice-03", 0, 4)
	map:addTile("tile-background-ice-big-01", 0, 5)
	map:addTile("tile-background-ice-04", 0, 7)
	map:addTile("tile-background-ice-01", 0, 8)
	map:addTile("tile-background-ice-07", 0, 9)
	map:addTile("tile-rock-slope-ice-right-01", 0, 10)
	map:addTile("tile-rock-ice-01", 0, 11)
	map:addTile("tile-background-ice-04", 1, 0)
	map:addTile("tile-background-ice-05", 1, 1)
	map:addTile("tile-background-ice-06", 1, 2)
	map:addTile("tile-background-ice-05", 1, 3)
	map:addTile("tile-background-ice-01", 1, 4)
	map:addTile("tile-background-ice-04", 1, 7)
	map:addTile("tile-background-ice-big-01", 1, 8)
	map:addTile("tile-background-ice-01", 1, 10)
	map:addTile("tile-rock-ice-02", 1, 11)
	map:addTile("tile-background-ice-06", 2, 0)
	map:addTile("tile-background-ice-01", 2, 1)
	map:addTile("tile-background-ice-02", 2, 2)
	map:addTile("tile-rock-slope-ice-left-01", 2, 3)
	map:addTile("tile-rock-ice-02", 2, 4)
	map:addTile("tile-rock-slope-ice-left-02", 2, 5)
	map:addTile("tile-background-ice-05", 2, 6)
	map:addTile("tile-background-ice-01", 2, 7)
	map:addTile("tile-background-ice-04", 2, 10)
	map:addTile("tile-rock-ice-01", 2, 11)
	map:addTile("tile-background-ice-06", 3, 0)
	map:addTile("tile-background-ice-06", 3, 1)
	map:addTile("tile-background-ice-07", 3, 2)
	map:addTile("tile-ground-ice-03", 3, 3)
	map:addTile("tile-rock-ice-01", 3, 4)
	map:addTile("tile-rock-ice-01", 3, 5)
	map:addTile("tile-background-ice-06", 3, 6)
	map:addTile("tile-background-ice-07", 3, 7)
	map:addTile("tile-background-ice-06", 3, 8)
	map:addTile("tile-background-ice-05", 3, 9)
	map:addTile("tile-rock-slope-ice-left-01", 3, 10)
	map:addTile("tile-rock-ice-02", 3, 11)
	map:addTile("tile-background-ice-02", 4, 0)
	map:addTile("tile-background-ice-06", 4, 1)
	map:addTile("tile-background-ice-window-02", 4, 2)
	map:addTile("tile-ground-ice-02", 4, 3)
	map:addTile("tile-rock-ice-02", 4, 4)
	map:addTile("tile-rock-ice-02", 4, 5)
	map:addTile("tile-rock-shim-ice-01", 4, 6)
	map:addTile("tile-background-ice-06", 4, 7)
	map:addTile("tile-background-ice-04", 4, 8)
	map:addTile("tile-background-ice-01", 4, 9)
	map:addTile("tile-ground-ice-04", 4, 10)
	map:addTile("tile-rock-ice-01", 4, 11)
	map:addTile("tile-background-ice-06", 5, 0)
	map:addTile("tile-background-ice-01", 5, 1)
	map:addTile("tile-ground-ice-01", 5, 3)
	map:addTile("tile-rock-ice-01", 5, 4)
	map:addTile("tile-rock-slope-ice-right-02", 5, 5)
	map:addTile("tile-background-ice-06", 5, 6)
	map:addTile("tile-background-ice-06", 5, 7)
	map:addTile("tile-background-ice-02", 5, 8)
	map:addTile("tile-background-ice-07", 5, 9)
	map:addTile("tile-ground-ice-03", 5, 10)
	map:addTile("tile-rock-ice-02", 5, 11)
	map:addTile("tile-rock-ice-01", 6, 0)
	map:addTile("tile-ground-ice-03", 6, 1)
	map:addTile("tile-rock-ice-big-01", 6, 2)
	map:addTile("tile-rock-slope-ice-right-02", 6, 4)
	map:addTile("tile-background-ice-05", 6, 5)
	map:addTile("tile-background-ice-06", 6, 6)
	map:addTile("tile-background-ice-05", 6, 7)
	map:addTile("tile-background-ice-04", 6, 8)
	map:addTile("tile-background-ice-02", 6, 9)
	map:addTile("tile-ground-ice-04", 6, 10)
	map:addTile("tile-rock-ice-01", 6, 11)
	map:addTile("tile-rock-ice-big-01", 7, 0)
	map:addTile("tile-background-ice-04", 7, 4)
	map:addTile("tile-background-ice-06", 7, 5)
	map:addTile("tile-background-ice-06", 7, 6)
	map:addTile("tile-background-ice-01", 7, 7)
	map:addTile("tile-background-ice-02", 7, 8)
	map:addTile("tile-background-ice-03", 7, 9)
	map:addTile("tile-ground-ice-03", 7, 10)
	map:addTile("tile-rock-ice-02", 7, 11)
	map:addTile("tile-rock-ice-01", 8, 2)
	map:addTile("tile-ground-ledge-ice-right-01", 8, 3)
	map:addTile("tile-background-ice-04", 8, 4)
	map:addTile("tile-background-ice-03", 8, 5)
	map:addTile("tile-background-ice-06", 8, 6)
	map:addTile("tile-background-ice-01", 8, 7)
	map:addTile("tile-background-ice-06", 8, 8)
	map:addTile("tile-background-ice-05", 8, 9)
	map:addTile("tile-background-ice-05", 8, 10)
	map:addTile("bridge-wall-ice-left-01", 8, 10)
	map:addTile("tile-rock-ice-02", 8, 11)
	map:addTile("tile-rock-ice-02", 9, 0)
	map:addTile("tile-rock-ice-02", 9, 1)
	map:addTile("tile-rock-slope-ice-right-02", 9, 2)
	map:addTile("tile-background-ice-03", 9, 3)
	map:addTile("tile-background-ice-04", 9, 4)
	map:addTile("tile-background-ice-06", 9, 5)
	map:addTile("tile-background-ice-05", 9, 6)
	map:addTile("tile-background-ice-06", 9, 7)
	map:addTile("tile-background-ice-04", 9, 8)
	map:addTile("tile-background-ice-06", 9, 9)
	map:addTile("tile-background-ice-04", 9, 10)
	map:addTile("bridge-plank-ice-01", 9, 10)
	map:addTile("tile-rock-ice-01", 9, 11)
	map:addTile("tile-rock-ice-01", 10, 0)
	map:addTile("tile-rock-ice-02", 10, 1)
	map:addTile("tile-background-ice-06", 10, 2)
	map:addTile("tile-background-ice-big-01", 10, 3)
	map:addTile("tile-background-ice-07", 10, 5)
	map:addTile("tile-background-ice-05", 10, 6)
	map:addTile("tile-background-ice-01", 10, 7)
	map:addTile("tile-background-ice-03", 10, 8)
	map:addTile("tile-background-ice-06", 10, 9)
	map:addTile("tile-background-ice-01", 10, 10)
	map:addTile("bridge-plank-ice-01", 10, 10)
	map:addTile("tile-rock-ice-02", 10, 11)
	map:addTile("tile-rock-ice-big-01", 11, 0)
	map:addTile("tile-background-ice-06", 11, 2)
	map:addTile("tile-background-ice-04", 11, 5)
	map:addTile("tile-ground-ice-03", 11, 6)
	map:addTile("tile-rock-slope-ice-left-02", 11, 7)
	map:addTile("tile-background-ice-01", 11, 8)
	map:addTile("tile-background-ice-03", 11, 9)
	map:addTile("tile-background-ice-06", 11, 10)
	map:addTile("bridge-wall-ice-right-01", 11, 10)
	map:addTile("tile-rock-ice-02", 11, 11)
	map:addTile("tile-background-ice-06", 12, 2)
	map:addTile("tile-background-ice-02", 12, 3)
	map:addTile("tile-background-ice-06", 12, 4)
	map:addTile("tile-background-ice-06", 12, 5)
	map:addTile("tile-packagetarget-ice-01-idle", 12, 6)
	map:addTile("tile-rock-ice-01", 12, 7)
	map:addTile("tile-rock-ice-02", 12, 8)
	map:addTile("tile-rock-ice-02", 12, 9)
	map:addTile("tile-rock-ice-03", 12, 10)
	map:addTile("tile-rock-ice-02", 12, 11)
	map:addTile("tile-rock-ice-01", 13, 0)
	map:addTile("tile-rock-ice-02", 13, 1)
	map:addTile("tile-rock-slope-ice-left-02", 13, 2)
	map:addTile("tile-background-ice-06", 13, 3)
	map:addTile("tile-background-ice-04", 13, 4)
	map:addTile("tile-background-ice-06", 13, 5)
	map:addTile("tile-ground-ice-03", 13, 6)
	map:addTile("tile-rock-ice-02", 13, 7)
	map:addTile("tile-rock-ice-01", 13, 8)
	map:addTile("tile-rock-ice-big-01", 13, 9)
	map:addTile("tile-rock-ice-01", 13, 11)
	map:addTile("tile-rock-ice-big-01", 14, 0)
	map:addTile("tile-rock-ice-02", 14, 2)
	map:addTile("tile-rock-shim-ice-01", 14, 3)
	map:addTile("tile-background-ice-06", 14, 4)
	map:addTile("tile-background-ice-window-01", 14, 5)
	map:addTile("tile-ground-ice-01", 14, 6)
	map:addTile("tile-rock-ice-big-01", 14, 7)
	map:addTile("tile-rock-ice-02", 14, 11)
	map:addTile("tile-rock-ice-02", 15, 2)
	map:addTile("tile-background-ice-04", 15, 3)
	map:addTile("tile-background-ice-06", 15, 4)
	map:addTile("tile-ground-ice-03", 15, 6)
	map:addTile("tile-rock-ice-01", 15, 9)
	map:addTile("tile-rock-ice-02", 15, 10)
	map:addTile("tile-rock-ice-01", 15, 11)

	map:addCave("tile-cave-ice-02", 5, 2, "none", 1000)
	map:addCave("tile-cave-ice-01", 15, 5, "none", 1500)

	map:addEmitter("item-package-ice", 0, 9, 1, 0, "")
	map:addEmitter("item-package-ice", 3, 9, 1, 0, "")
	map:addEmitter("tree", 6, 8, 1, 0, "")
	map:addEmitter("item-stone", 8, 9, 1, 0, "")
	map:addEmitter("npc-walking", 10, 9, 1, 0, "right=false")
	map:addEmitter("item-stone", 13, 5, 1, 0, "")

	map:setSetting("fishnpc", "true")
	map:setSetting("flyingnpc", "false")
	map:setSetting("gravity", "9.81")
	map:setSetting("height", "12")
	map:setSetting("packagetransfercount", "3")
	map:addStartPosition("11", "5")
	map:setSetting("points", "100")
	map:setSetting("referencetime", "40")
	map:setSetting("theme", "ice")
	map:setSetting("waterheight", "1.8")
	map:setSetting("waterchangespeed", "0")
	map:setSetting("waterrisingdelay", "0")
	map:setSetting("width", "16")
	map:setSetting("wind", "0.0")
end
