local Task = require("Task") --Loading the "Task.lua"

TaskList = {} -- Creating TaskList class
TaskList.__index = TaskList

-- Task List constructor
function TaskList:new()
	local abj = setmetatable({}, TaskList)
	abj.tasks = {} -- Table object to insert objects into
	abj.dataFilename = "tasks.csv"

	return abj
end

-- Add Task function
function TaskList:addTask(task)
	local isFormatDate = task.deadline:match("%d%d%d%d-%d%d%-%d%d")
	if type(task.deadline) ~= "string" then
		print("Only strings accepted. Please type a string (use ", " in the beginning and ending of a phrase")
		print("No tasks added")
	else
		if isFormatDate == task.deadline:match("%d%d%d%d-%d%d%-%d%d") then
			table.insert(self.tasks, task)
			print("Task " .. task.description .. " added successfully")
		else
			print("Error: Please type in a deadline in YYYY-MM-DD or 'X days' formats")
		end
	end
end

function TaskList:saveToCSV()
	local file = io.open(self.dataFilename, "a")
	if file then
		if #self.tasks > 0 then
			print("Saving " .. #self.tasks .. " tasks to " .. self.dataFilename .. "...")
			for _, task in ipairs(self.tasks) do
				local desc = task.description or "No description"
				local deadln = task.deadline or "No deadline"

				file:write(desc .. "," .. deadln .. "\n")
			end
			file:close()
			print("Tasks saved successfully!")
		else
			print("No new tasks to save.")
		end
	end
end

function TaskList:saveRemove()
	local file = io.open(self.dataFilename, "w")
	if file then
		print("Saving " .. #self.tasks .. " tasks to " .. self.dataFilename .. "...")
		for _, task in ipairs(self.tasks) do
			local desc = task.description or "No description"
			local deadln = task.deadline or "No deadline"

			file:write(desc .. "," .. deadln .. "\n")
		end
		file:close()
		print("Tasks saved successfully!")
	else
		print("Error: Could not open file " .. self.dataFilename .. " for writing.")
	end
end

function TaskList:loadFromCSV()
	if not self.dataFilename then
		print("Erro: O nome do arquivo CSV não foi definido em dataFilename!")
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
	print("Loaded tasks successfully")
end

function TaskList:listTask()
	print("Listing tasks...")
	if #self.tasks == 0 then -- checking for empty inputs
		print("No tasks in the list.")
	else
		for _, task_item in ipairs(self.tasks) do -- "task_item" just refers to an item inside tasks table.
			task_item:showInfo() -- showInfo is a function from the Task class.
			print("------------------------------")
		end
	end
end

-- Remove Task function
function TaskList:removeTask(ids)
	self:loadFromCSV()

	self.tasks = self.tasks or {}

	if not ids then
		print("Error: no ID provided")
		return false
	end

	if type(ids) ~= "table" then
		local singleId = tonumber(ids)
		if singleId then
			ids = { singleId }
		else
			print("Error: invalid ID")
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
			print("Warning: The ID " .. tostring(id) .. " is invalid or doesn't exist. Ignoring it...")
		end
	end

	if #validIds == 0 then
		print("Error: no valid ID to remove")
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

	print("Success! " .. #validIds .. " removed tasks!")
	for _, name in ipairs(removedNames) do
		print("-" .. name)
	end
	return true
end

function TaskList:removeAll()
	print("Are you sure you want to remove ALL TASKS?? y/n")
	local answer = tostring(io.read())
	if answer == "y" or answer == "Y" then
		print("Ok!")
		local file = io.open("tasks.csv", "w")
		file:write("No registered tasks!")
		file:close()
	else
		print("Ok, tasks preserved.")
	end
end

return TaskList
