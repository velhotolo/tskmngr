local Task = require("Task") --Loading the "Task.lua"
local Colours = require("Colours")
TaskList = {} -- Creating TaskList class
TaskList.__index = TaskList

-- Task List constructor
function TaskList:new()
	local abj = setmetatable({}, TaskList)
	abj.tasks = {} -- Table object to insert objects into
	abj.dataFilename = "tasks.csv"
	return abj
end

local Colorizer = Colours:new(Colours.color_code, Colours.message, Colours.warning)

-- Add Task function
function TaskList:addTask(task)
	if not task.deadline:match("%d%d%d%d%-%d%d%-%d%d") and #task.deadline == 10 then
		Colorizer:print_colored(
			Colorizer.ANSI.RED,
			"Error: you must write the deadline in YYYY-MM-DD format",
			Colorizer.warning
		)
	else
		month = tonumber(string.sub(task.deadline, 6, 7)) or 01
		day = tonumber(string.sub(task.deadline, 9, 10)) or 01
	end

	if month >= 1 and month <= 12 and day >= 1 and day <= 31 then
		table.insert(self.tasks, task)
		Colorizer:print_colored(
			Colorizer.ANSI_GREEN,
			"Task " .. task.description .. " added successfully",
			Colorizer.warning
		)
	else
		Colorizer:print_colored(Colorizer.ANSI_RED, "Error: invalid deadline date", Colorizer.warning)
	end
end

function TaskList:saveToCSV()
	local file = io.open(self.dataFilename, "a")
	if file then
		if #self.tasks > 0 then
			Colorizer:print_colored(
				Colorizer.ANSI_BOLD,
				"Saving " .. #self.tasks .. " tasks to " .. self.dataFilename .. "..." .. Colorizer.warning
			)
			for _, task in ipairs(self.tasks) do
				local desc = task.description or "No description"
				local deadln = task.deadline or "No deadline"

				file:write(desc .. "," .. deadln .. "\n")
			end
			file:close()
			Colorizer:print_colored(Colorizer.ANSI_GREEN, "Tasks saved successfully!" .. Colorizer.warning)
		else
			Colorizer:print_colored(Colorizer.ANSI_RED, "No new tasks to save." .. Colorizer.warning)
		end
	end
end

function TaskList:saveRemove()
	local file = io.open(self.dataFilename, "w")
	if file then
		Colorizer:print_colored(
			Colorizer.ANSI_BG_GREEN,
			"Saving " .. #self.tasks .. " tasks to " .. self.dataFilename .. "..." .. Colorizer.warning
		)
		for _, task in ipairs(self.tasks) do
			local desc = task.description or "No description"
			local deadln = task.deadline or "No deadline"

			file:write(desc .. "," .. deadln .. "\n")
		end
		file:close()
		Colorizer:print_colored(Colorizer.ANSI_BG_GREEN, "Tasks saved successfully!" .. Colorizer.warning)
	else
		Colorizer:print_colored(
			Colorizer.ANSI_BG_RED,
			"Error: Could not open file " .. self.dataFilename .. " for writing." .. Colorizer.warning
		)
	end
end

function TaskList:loadFromCSV()
	if not self.dataFilename then
		Colorizer:print_colored(
			Colorizer.ANSI_BG_RED,
			"Erro: O nome do arquivo CSV não foi definido em dataFilename!" .. Colorizer.warning
		)
		return
	end
	local file = io.open(self.dataFilename, "r")
	if not file then
		return
	end

	self.tasks = {}
	for line in file:lines() do
		local desc, deadline = line:match("^(.-),(.-)$")

		if desc and deadline then
			desc = desc:match("^%s*(.-)%s*$")
			deadline = deadline:match("^%s*(.-)%s*$")
			local t = Task:new(desc, deadline)
			table.insert(self.tasks, t)
		end
	end
	file:close()
	Colorizer:print_colored(Colorizer.ANSI_BLUE, "Loaded tasks successfully" .. Colorizer.warning)
end

function TaskList:listTask()
	Colorizer:print_colored(Colorizer.ANSI_BOLD, "Listing tasks..." .. Colorizer.warning)
	if #self.tasks == 0 then -- checking for empty inputs
		Colorizer:print_colored(Colorizer.ANSI_RED, "No tasks in the list." .. Colorizer.warning)
	else
		for _, task_item in ipairs(self.tasks) do -- "task_item" just refers to an item inside tasks table.
			Task:showInfo(task_item) -- showInfo is a function from the Task class.
			Colorizer:print_colored(Colorizer.ANSI_BLUE, "------------------", Colorizer.warning)
		end
	end
end

-- Remove Task function
function TaskList:removeTask(ids)
	self:loadFromCSV()

	self.tasks = self.tasks or {}

	if not ids then
		Colorizer:print_colored(Colorizer.ANSI_RED, "Error: no ID provided" .. Colorizer.warning)
		return false
	end

	if type(ids) ~= "table" then
		local singleId = tonumber(ids)
		if singleId then
			ids = { singleId }
		else
			Colorizer:print_colored(Colorizer.ANSI_RED, "Error: invalid ID" .. Colorizer.warning)
		end
	end

	local validIds = {}
	local uniqueCheck = {}

	for _, id in ipairs(ids) do
		if id and id >= 1 and id <= #self.tasks then
			if not uniqueCheck[id] then
				uniqueCheck[id] = true
				table.insert(validIds, id)
			end
		else
			Colorizer:print_colored(
				Colorizer.ANSI_RED,
				"Warning: The ID "
					.. tostring(id)
					.. " is invalid or doesn't exist. Ignoring it..."
					.. Colorizer.warning
			)
		end
	end

	if #validIds == 0 then
		Colorizer:print_colored(Colorizer.ANSI_RED, "Error: no valid ID to remove" .. Colorizer.warning)
		return false
	end

	table.sort(validIds, function(a, b)
		return a > b
	end)

	local removedNames = {}

	for _, id in ipairs(validIds) do
		local removedTask = table.remove(self.tasks, id)
		local desc = removedTask.description or ("Task ID " .. id)
		table.insert(removedNames, desc)
	end

	self:saveRemove()

	Colorizer:print_colored(Colorizer.ANSI_GREEN, "Success! " .. #validIds .. " removed tasks!" .. Colorizer.warning)
	for _, name in ipairs(removedNames) do
		print("-" .. name)
	end
	return true
end

function TaskList:removeAll()
	Colorizer:print_colored(Colorizer.ANSI_RED, "Are you sure you want to remove ALL TASKS?? y/n" .. Colorizer.warning)
	local answer = tostring(io.read())
	if answer == "y" or answer == "Y" then
		Colorizer:print_colored(Colorizer.ANSI_BLUE, "Ok!" .. Colorizer.warning)
		local file = io.open("tasks.csv", "w")
		if not file then
			Colorizer:print_colored(Colorizer.ANSI_RED, "Error: Couldn't open file" .. Colorizer.warning)
			return
		end
		file:write(" ")
		file:close()
	else
		Colorizer:print_colored(Colorizer.ANSI_BLUE, "Ok, tasks preserved." .. Colorizer.warning)
	end
end

return TaskList
