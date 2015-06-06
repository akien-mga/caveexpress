function getName()
	return "Package"
end

function onMapLoaded()
end

function initMap()
	-- get the current map context
	local map = Map.get()
	map:addTile("tile-background-03", 0, 0)
	map:addTile("tile-background-04", 0, 1)
	map:addTile("tile-ground-04", 0, 2)
	map:addTile("tile-rock-big-01", 0, 3)
	map:addTile("tile-rock-03", 0, 5)
	map:addTile("tile-rock-big-01", 0, 6)
	map:addTile("tile-rock-03", 0, 8)
	map:addTile("tile-rock-02", 0, 9)
	map:addTile("tile-rock-03", 0, 10)
	map:addTile("tile-rock-03", 0, 11)
	map:addTile("tile-background-03", 1, 0)
	map:addTile("tile-ground-04", 1, 2)
	map:addTile("tile-rock-02", 1, 5)
	map:addTile("tile-rock-02", 1, 8)
	map:addTile("tile-rock-big-01", 1, 9)
	map:addTile("tile-rock-02", 1, 11)
	map:addTile("tile-background-03", 2, 0)
	map:addTile("tile-background-window-02", 2, 1)
	map:addTile("tile-background-big-01", 2, 2)
	map:addTile("tile-background-03", 2, 4)
	map:addTile("tile-ground-03", 2, 5)
	map:addTile("tile-rock-03", 2, 6)
	map:addTile("tile-rock-02", 2, 7)
	map:addTile("tile-rock-03", 2, 8)
	map:addTile("tile-rock-slope-right-02", 2, 11)
	map:addTile("tile-background-01", 3, 0)
	map:addTile("tile-background-03", 3, 1)
	map:addTile("tile-background-02", 3, 4)
	map:addTile("tile-background-02", 3, 5)
	map:addTile("bridge-wall-left-01", 3, 5)
	map:addTile("tile-background-big-01", 3, 6)
	map:addTile("tile-background-cave-art-01", 3, 8)
	map:addTile("tile-background-02", 3, 9)
	map:addTile("tile-background-02", 3, 10)
	map:addTile("tile-background-cave-art-01", 3, 11)
	map:addTile("tile-background-cave-art-01", 4, 0)
	map:addTile("tile-background-02", 4, 1)
	map:addTile("tile-background-big-01", 4, 2)
	map:addTile("tile-background-02", 4, 4)
	map:addTile("tile-background-02", 4, 5)
	map:addTile("bridge-plank-01", 4, 5)
	map:addTile("tile-background-02", 4, 8)
	map:addTile("tile-background-04", 4, 9)
	map:addTile("tile-background-03", 4, 10)
	map:addTile("tile-background-02", 4, 11)
	map:addTile("tile-background-03", 5, 0)
	map:addTile("tile-background-02", 5, 1)
	map:addTile("tile-background-02", 5, 4)
	map:addTile("tile-background-02", 5, 5)
	map:addTile("bridge-wall-right-01", 5, 5)
	map:addTile("tile-background-02", 5, 6)
	map:addTile("tile-background-01", 5, 7)
	map:addTile("tile-background-04", 5, 8)
	map:addTile("tile-background-02", 5, 9)
	map:addTile("tile-background-big-01", 5, 10)
	map:addTile("tile-background-02", 6, 0)
	map:addTile("tile-background-big-01", 6, 1)
	map:addTile("tile-background-02", 6, 3)
	map:addTile("tile-background-window-01", 6, 4)
	map:addTile("tile-ground-03", 6, 5)
	map:addTile("tile-rock-big-01", 6, 6)
	map:addTile("tile-rock-slope-left-02", 6, 8)
	map:addTile("tile-background-04", 6, 9)
	map:addTile("tile-background-02", 7, 0)
	map:addTile("tile-background-01", 7, 3)
	map:addTile("tile-ground-01", 7, 5)
	map:addTile("tile-rock-big-01", 7, 8)
	map:addTile("tile-rock-slope-left-02", 7, 10)
	map:addTile("tile-background-01", 7, 11)
	map:addTile("tile-background-01", 8, 0)
	map:addTile("tile-background-03", 8, 1)
	map:addTile("tile-ground-04", 8, 2)
	map:addTile("tile-rock-02", 8, 3)
	map:addTile("tile-rock-big-01", 8, 4)
	map:addTile("tile-rock-02", 8, 6)
	map:addTile("tile-rock-03", 8, 7)
	map:addTile("tile-rock-03", 8, 10)
	map:addTile("tile-rock-03", 8, 11)
	map:addTile("tile-background-02", 9, 0)
	map:addTile("tile-background-04", 9, 1)
	map:addTile("tile-ground-03", 9, 2)
	map:addTile("tile-rock-03", 9, 3)
	map:addTile("tile-rock-02", 9, 6)
	map:addTile("tile-rock-02", 9, 7)
	map:addTile("tile-rock-02", 9, 8)
	map:addTile("tile-rock-03", 9, 9)
	map:addTile("tile-rock-02", 9, 10)
	map:addTile("tile-rock-02", 9, 11)
	map:addTile("tile-rock-02", 10, 0)
	map:addTile("tile-rock-big-01", 10, 1)
	map:addTile("tile-rock-02", 10, 3)
	map:addTile("tile-rock-02", 10, 4)
	map:addTile("tile-rock-03", 10, 5)
	map:addTile("tile-rock-03", 10, 6)
	map:addTile("tile-rock-02", 10, 7)
	map:addTile("tile-rock-03", 10, 8)
	map:addTile("tile-rock-big-01", 10, 9)
	map:addTile("tile-rock-03", 10, 11)
	map:addTile("tile-rock-03", 11, 0)
	map:addTile("tile-rock-03", 11, 3)
	map:addTile("tile-rock-03", 11, 4)
	map:addTile("tile-rock-02", 11, 5)
	map:addTile("tile-rock-02", 11, 6)
	map:addTile("tile-rock-02", 11, 7)
	map:addTile("tile-rock-02", 11, 8)
	map:addTile("tile-rock-02", 11, 11)
	map:addTile("tile-rock-03", 12, 0)
	map:addTile("tile-rock-02", 12, 1)
	map:addTile("tile-rock-big-01", 12, 2)
	map:addTile("tile-rock-02", 12, 4)
	map:addTile("tile-rock-03", 12, 5)
	map:addTile("tile-rock-02", 12, 6)
	map:addTile("tile-rock-big-01", 12, 7)
	map:addTile("tile-rock-02", 12, 9)
	map:addTile("tile-rock-03", 12, 10)
	map:addTile("tile-rock-03", 12, 11)
	map:addTile("tile-rock-02", 13, 0)
	map:addTile("tile-rock-03", 13, 1)
	map:addTile("tile-rock-03", 13, 4)
	map:addTile("tile-rock-02", 13, 5)
	map:addTile("tile-rock-03", 13, 6)
	map:addTile("tile-rock-02", 13, 9)
	map:addTile("tile-rock-02", 13, 10)
	map:addTile("tile-rock-02", 13, 11)
	map:addTile("tile-rock-big-01", 14, 0)
	map:addTile("tile-rock-03", 14, 2)
	map:addTile("tile-rock-02", 14, 3)
	map:addTile("tile-rock-02", 14, 4)
	map:addTile("tile-rock-02", 14, 5)
	map:addTile("tile-rock-big-01", 14, 6)
	map:addTile("tile-rock-03", 14, 8)
	map:addTile("tile-rock-big-01", 14, 9)
	map:addTile("tile-rock-03", 14, 11)
	map:addTile("tile-rock-02", 15, 2)
	map:addTile("tile-rock-03", 15, 3)
	map:addTile("tile-rock-02", 15, 4)
	map:addTile("tile-rock-02", 15, 5)
	map:addTile("tile-rock-02", 15, 8)
	map:addTile("tile-rock-02", 15, 11)

	map:addCave("tile-cave-01", 1, 1)
	map:addCave("tile-cave-02", 7, 4)

	map:setSetting("width", "16")
	map:setSetting("height", "12")
	map:setSetting("fishnpc", "true")
	map:setSetting("flyingnpc", "false")
	map:setSetting("gravity", "9.81")
	map:setSetting("introwindow", "intropackage")
	map:setSetting("npcs", "1")
	map:setSetting("npctransfercount", "1")
	map:setSetting("packagetransfercount", "2")
	map:setSetting("points", "100")
	map:setSetting("referencetime", "10")
	map:setSetting("sideborderfail", "false")
	map:setSetting("theme", "rock")
	map:setSetting("tutorial", "true")
	map:setSetting("waterchangespeed", "0")
	map:setSetting("waterfallingdelay", "0")
	map:setSetting("waterheight", "5.7")
	map:setSetting("waterrisingdelay", "0")
	map:setSetting("wind", "0")
end
