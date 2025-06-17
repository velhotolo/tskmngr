local Task = require("Task")

TaskList = {}
TaskList.__index = TaskList

function TaskList:new()
	local tskInstance = {}
	setmetatable(tskInstance, { __index = TaskList })
	local tasks = {}

	function tskInstance:listTask()
		print("Listing tasks...")
		if #tasks == 0 then
			print("No tasks in the list.")
		else
			for i, task_item in ipairs(tasks) do
				print(i)
				task_item:showInfo()
				print("------------------------------")
			end
		end
	end

	function tskInstance:addTask(task)
		if getmetatable(task).__index == Task then
			table.insert(tasks, task)
			print("Task " .. task:getDescription() .. " added successfully!")
		else
			print("An error ocurred while trying to add the task.")
		end
	end

	function tskInstance:removeTask(tskNumber)
		if type(tskNumber) == "number" and tskNumber <= #tasks and tskNumber > 0 then
			table.remove(tasks, tskNumber)
		else
			print("Invalid input. Please try again.")
		end
	end
	return tskInstance
end

return TaskList
