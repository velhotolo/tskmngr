Task = {}
Task.__index = Task

function Task:new(initialDescription, initialDeadline)
	local instance = {}
	setmetatable(instance, { __index = Task })
	local description = initialDescription or "Nova Tarefa"
	local deadline = initialDeadline or "Sem prazo"
	local status = "Pending"

	function instance:getDescription()
		return description
	end

	function instance:setDescription(newDescription)
		if type(newDescription) == "string" and #newDescription > 0 then
			description = newDescription
			print("Task updated: " .. description)
		else
			print("Error: invalid description.")
		end
	end

	function instance:getDeadline()
		return deadline
	end

	function instance:setDeadline(newDeadline) --TO DO: Implement with TimeStamp
		if newDeadline > 0 then
			deadline = newDeadline
			print("Task scheduled.")
		else
			print("Deadline can't be less than 0.")
		end
	end

	function instance:setStatus()
		if status == "Pending" then
			status = "Complete"
		else
			status = "Pending"
		end
	end

	function instance:showInfo()
		print(
			"Task description: "
				.. instance:getDescription()
				.. " Deadline: "
				.. instance:getDeadline()
				.. " Status: "
				.. status
		)
	end

	return instance
end

return Task
