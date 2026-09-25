Task = {}
Task.__index = Task
Task.nextId = 1
-- Class constructor
function Task:new(description, deadline, id)
	local obj = setmetatable({}, Task) -- Instances look for info in the main Class
	obj.description = description or "no description"
	obj.deadline = deadline or "no deadline"
	obj.status = "Pending"
	if id then
		obj.id = id
	else
		obj.id = Task.nextId
		Task.nextId = Task.nextId + 1
	end

	return obj
end

function Task:overdueCheck(id, taskListObj)
	local chosenOne = taskListObj.tasks[id]
	local deadlineDate = os.time({
		year = tonumber(string.sub(chosenOne.deadline, 1, 4)) or 2026,
		month = tonumber(string.sub(chosenOne.deadline, 6, 7)) or 1,
		day = tonumber(string.sub(chosenOne.deadline, 9, 10)) or 1,
	})

	local currentDate = os.time() -- catches current timestamp
	if currentDate > deadlineDate then
		print("The task is overdue")
	else
		print("The task is alright")
	end
end

function Task:showInfo()
	print(
		"Task Description: "
			.. self.description
			.. " Deadline: "
			.. self.deadline
			.. " Status: "
			.. self.status
			.. " ID "
			.. self.id
	)
end
return Task
