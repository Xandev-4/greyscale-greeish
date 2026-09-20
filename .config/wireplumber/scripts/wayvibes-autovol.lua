monitor = {}

monitor.script_path = "/home/xandev/.config/niri/scripts/wayvibes-autovol.sh"

Core.connect("device-added", function()
	os.execute(monitor.script_path)
end)

Core.connect("device-removed", function()
	os.execute(monitor.script_path)
end)
