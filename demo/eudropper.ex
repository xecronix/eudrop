#!/usr/bin/env eui
include eudrop/eudropper.e
include std/map.e
include std/filesys.e

constant OK = 0

function help(sequence args)
	return 0
end function

function gui(sequence args)
	return 0
end function

function args_to_map(map:map opts, sequence args)
	integer lenarg = length(args)
	for i = 1 to length(args) do
		sequence arg = args[i]
		integer key_end = find('=', arg)
		if key_end then
			sequence k = arg[1..key_end - 1]
			sequence v = arg[key_end + 1..$]
			map:put(opts, k, v)
		end if
	end for
	return opts
end function

function dump_map(map:map opts)
	sequence map_keys = map:keys(opts)
	for i = 1 to length(map_keys) do
		sequence k = map_keys[i]
		sequence v = map:get(opts, k, "")
		printf(1, "key [%s] : value [%s]\n", {k, v})
	end for
	return 0
end function 

function start_project(sequence args)
	integer retval = OK
	integer valid_arg = 0
	map:map opts = map:new()
	-- setup default values
	map:put(opts, "project_path", current_dir())
	opts = args_to_map(opts, args)
	dump_map(opts)
	retval = eudropper:create_project(opts)
	return retval
end function  

function main()
	integer retval = -1
	sequence args = command_line()
	for i = 1 to length(args) do
		sequence arg = args[i]
		if equal(arg, "--gui") then
			retval = gui(args[i..$])
		elsif (equal(arg, "--start")) then
			retval = start_project(args[i..$])
		elsif (equal(arg, "--help")) then
			retval = help(args[i..$])
		end if
	end for
	return retval
end function

abort(main())
