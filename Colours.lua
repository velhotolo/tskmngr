Colours = {}
Colours.__index = Colours

function Colours:new(color_code, message, warning)
	local instance = setmetatable({}, Colours)

	instance.color_code = color_code or " "
	instance.message = message or string
	instance.ANSI_RESET = "\27[0m"
	instance.warning = warning or "\27[0m"
	instance.ANSI_BOLD = "\27[1m"
	instance.ANSI_RED = "\27[31m"
	instance.ANSI_GREEN = "\27[32m"
	instance.ANSI_YELLOW = "\27[33m"
	instance.ANSI_BLUE = "\27[34m"
	instance.ANSI_CYAN = "\27[36m"
	instance.ANSI_BG_RED = "\27[41m"
	instance.ANSI_BG_GREEN = "\27[42m"

	return instance
end

function Colours:print_colored(var1, var2, var3)
	self.color_code = var1
	self.message = var2
	var3 = "\27[0m"
	self.warning = var3
	print(self.color_code .. self.message .. self.warning)
end

function Colours:print_colored_double(var1, varExtra, var2, var3)
	self.color_code = var1
	self.typo_condition = varExtra
	self.message = var2
	var3 = "\27[0m"
	self.warning = var3
	print(self.color_code .. self.message .. self.warning)
end

return Colours
