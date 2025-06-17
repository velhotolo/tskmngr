Task = require("Task")
TaskList = require("Tasklist")

local whStop = 0
local tasklist = TaskList:new()
local whMenu = 0

while whMenu == 0 do --Main menu loop
	print(
		"Welcome to the Task Manager. Choose an option:\n[1] Add Task\n[2] View Tasks\n[3]Remove Tasks\n[4] Edit Status\n[5] Exit"
	)
	local selector = tonumber(io.read()) --Menu selector
	whStop = 0 --Reset option counter for Add Task

	if selector == 1 then
		while whStop == 0 do
			local task = Task:new()
			print("Insert task description: ")
			local newDescription = io.read()
			if #newDescription > 0 then
				task:setDescription(newDescription)
			else
				print("Empty entries not allowed. Please type a description.")
				whStop = 1
			end
			print("Insert task deadline (in hours): ")
			local newDln = tonumber(io.read())
			if type(newDln) == "number" and newDln > 0 then
				task:setDeadline(newDln)
			else
				print("Invalid input, try again.")
				whStop = 1
			end
			tasklist:addTask(task)
			print("Do you want to add another task? [Y/N]")
			local addMore = io.read()
			if addMore == "y" or addMore == "Y" then
				print("Let's go!")
			else
				whStop = 1
			end
		end
	elseif selector == 2 then
		tasklist:listTask()
	elseif selector == 3 then
		while whStop == 0 do
			tasklist:listTask()
			print("Choose the task to remove by ID:")
			local removeSelect = tonumber(io.read())
			if type(removeSelect) == "number" and removeSelect >= 1 and removeSelect <= #tasklist then
				tasklist:removeTask(removeSelect)
				tasklist:listTask()
			else
				print("Invalid ID. Try again")
				whStop = 1
			end
		end
	elseif selector == 4 then
	--option 4
	elseif selector == 5 then
	-- option 5
	else
		print("Incorrect input. Try again.")
	end
end
