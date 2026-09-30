#!/usr/bin/env lua
Task = require("Task")
TaskList = require("Tasklist")

local taskLister = TaskList:new()

local subCommand = {}
subCommand["add"] = function(args)
	local description = args[1]
	local deadline = args[2]
	local t = Task:new(description, deadline, id)
	taskLister:addTask(t)
	taskLister:saveToCSV()
end

subCommand["list"] = function(args)
	taskLister:loadFromCSV()
	taskLister:listTask()
end

subCommand["remove"] = function(args)
	local inputString = table.concat(args, " ")
	local idsToRemove = {}

	for idStr in inputString:gmatch("%d+") do
		table.insert(idsToRemove, tonumber(idStr))
	end
	if #idsToRemove == 0 then
		print("Error: No valid ID number")
		return
	end

	taskLister:removeTask(idsToRemove)
end

subCommand["status"] = function(args)
	local id = tonumber(args[1])
	taskLister:loadFromCSV()
	Task:overdueCheck(id, taskLister)
end

subCommand["removeall"] = function()
	taskLister:removeAll()
end

local command = arg[1]

local parametros = {}
for i = 2, #arg do
	table.insert(parametros, arg[i])
end

if subCommand[command] then
	subCommand[command](parametros)
else
	print("Not recognized. Typ -h for help")
end
