local Colours = require("Colours")
Task = {}
Task.__index = Task
Task.nextId = 1
-- Class constructor
function Task:new(description, deadline, id)
	local obj = setmetatable({}, Task) -- Instances look for info in the main Class
	if id then
		obj.id = id
	else
		obj.id = Task.nextId
		Task.nextId = Task.nextId + 1
	end
	obj.description = description or "no description"
	obj.deadline = deadline or "no deadline"
	obj.status = "Pending"
	return obj
end
local paint = Colours:new(Colours.color_code, Colours.message, Colours.warning)

function Task:overdueCheck(id, taskListObj)
	if #taskListObj.tasks == 0 then
		taskListObj:loadFromCSV()
	end
	local nId = tonumber(id)
	local chosenOne = taskListObj.tasks[nId]
	if not chosenOne then
		paint:print_colored(paint.ANSI_RED, "Erro: Tarefa não encontrada.", paint.warning)
		return
	end
	local deadlineDate = os.time({
		year = tonumber(string.sub(chosenOne.deadline, 1, 4)) or 2026,
		month = tonumber(string.sub(chosenOne.deadline, 6, 7)) or 1,
		day = tonumber(string.sub(chosenOne.deadline, 9, 10)) or 1,
	})
	local currentDate = os.time() -- catches current timestamp
	if currentDate > deadlineDate then
		paint:print_colored(paint.ANSI_RED, "The task is overdue", paint.warning)
	else
		paint:print_colored(paint.ANSI_GREEN, "The task is alright", paint.warning)
	end
end

function Task:showInfo(item_task)
	paint:print_colored(paint.ANSI_BOLD, "Task Description: ", paint.warning)
	paint:print_colored(paint.ANSI_YELLOW, item_task.description, paint.warning)

	paint:print_colored(paint.ANSI_BOLD, "Deadline: ", paint.warning)
	paint:print_colored(paint.ANSI_YELLOW, item_task.deadline, paint.warning)

	paint:print_colored(paint.ANSI_BOLD, "Status: ", paint.warning)
	paint:print_colored(paint.ANSI_YELLOW, item_task.status, paint.warning)

	paint:print_colored(paint.ANSI_BOLD, "ID: ", paint.warning)
	paint:print_colored(paint.ANSI_YELLOW, tostring(item_task.id), paint.warning)
end
return Task
