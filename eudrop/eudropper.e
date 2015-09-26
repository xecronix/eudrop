namespace eudropper
include std/map.e
include std/filesys.e
include mightyeagle/mightyeagle.e

--** 
-- This is your new EuDrop.  In here will be everything
-- another developer needs to use your EuDrop.
sequence project_trees = {}
sequence project_files = {}

sequence eudrop_directory_tree = {
		{"{=project_name :}", "ext"},
		{"{=project_name :}", "resources"}
}
project_trees = append(project_trees, eudrop_directory_tree)

--** 
-- By default eudropper assumes you'll need a Makefile, 
-- a eu.cfg, and of course the EuDrop it's self.

sequence eudrop_files = {
		{"{=project_name :}", "Makefile"},
		{"{=project_name :}", "{=project_name :}.e"},
		{"{=project_name :}", "eu.cfg"},
		{"{=project_name :}", "LICENSE"}
}
project_files = append(project_files, eudrop_files)

--**
-- A good EuDrop will come with an example on how it's used.

sequence demo_directory_tree = {
		{"demo", "bin"},
		{"demo", "build"},
		{"demo", "resources"}
}
project_trees = append(project_trees, demo_directory_tree)

--** 
-- By default eudropper assumes you'll need a Makefile, 
-- a eu.cfg, and of course the demo it's self.

sequence demo_files = {
		{"demo", "eu.cfg"},
		{"demo", "Makefile"},
		{"demo", "{=project_name :}.ex"}
}
project_files = append(project_files, demo_files)

--**
-- We'll also put the docs in the EuDrop directory
-- The rational is that it's difficult for a developer to 
-- use your new EuDrop without docs.  And remember... The 
-- EuDrop directory is supposed to have contained within 
-- everything a developer will need to use your EuDrop

sequence docs_directory_tree = {
		{"{=project_name :}", "docs", "resources"}
}
project_trees = append(project_trees, docs_directory_tree)

--** 
-- A make task is used to build docs from source.
sequence docs_files = {
		{"{=project_name :}", "docs", "Makefile"},
		{"{=project_name :}", "docs", "{=project_name :}.creole"}
}
project_files = append(project_files, docs_files)

--**
-- Assuming your not reinventing the wheel for every EuDrop you
-- write, there's a chance that you're EuDrop will depend on other 
-- EuDrops.  This is where they go.
sequence eudrops_directory_tree = {
		{"eudrops"}
}
project_trees = append(project_trees, eudrops_directory_tree)

--**
-- If your EuDrop has code for an extention such as a DLL, Executable, or 
-- Java jar file,  This is where the source for that goes.

sequence extension_directory_tree = {
		{"extsrc"}
}
project_trees = append(project_trees, extension_directory_tree)

--** 
-- A Makefile for the extsrc

sequence extension_files = {
		{"extsrc", "Makefile"}
}
project_files = append(project_files, extension_files)

--** 
-- A good EuDrop developer knows how to 
-- prove his EuDrop works.  This is done by writing good 
-- tests.  

sequence test_directory_tree = {
		{"test"}
}
project_trees = append(project_trees, test_directory_tree)

--** 
-- We'll use Make to build and run tests.  And we'll create a default test to run.
sequence test_files = {
		{"test", "Makefile"},
		{"test", "t_{=project_name :}.e"}
}
project_files = append(project_files, test_files)

function create_default_eucfg(map:map opts, sequence path_to_file)
	mighty_eagle:mighty_eagle_t me = mighty_eagle:new()
	integer fp = open(path_to_file, "w")
	printf(fp, mighty_eagle:parse(me, "../\n../eudrops/\n", opts))
	close (fp)
	return 0
end function

function create_default_doc(map:map opts, sequence path_to_file)
	mighty_eagle:mighty_eagle_t me = mighty_eagle:new()
	integer fp = open(path_to_file, "w")
	printf(fp, mighty_eagle:parse(me, "=={=project_name :}", opts))
	close (fp)
	return 0
end function

function create_default_makefile(map:map opts, sequence path_to_file)
	mighty_eagle:mighty_eagle_t me = mighty_eagle:new()
	integer fp = open(path_to_file, "w")
	printf(fp, mighty_eagle:parse(me, "all:\n\t@echo Nothing to do for all.\n", opts))
	close (fp)
	return 0
end function

function create_tree(map:map opts, sequence project_path, sequence directory_tree)
	mighty_eagle:mighty_eagle_t me = mighty_eagle:new()
	
	for i = 1 to length(directory_tree) do
		sequence parsed_path = {project_path}
		sequence directory_path = directory_tree[i]
		for j = 1 to length(directory_path) do
			sequence path_part = mighty_eagle:parse(me, directory_path[j], opts)
			parsed_path = append(parsed_path, path_part)
		end for
		sequence path_str = join_path(parsed_path)
		printf(1, "%s\n", {path_str})
		create_directory(path_str)
	end for
	return 0
end function 

function create_files(map:map opts, sequence project_path, sequence directory_tree)
	mighty_eagle:mighty_eagle_t me = mighty_eagle:new()
	for i = 1 to length(directory_tree) do
		sequence parsed_path = {project_path}
		sequence directory_path = directory_tree[i]
		for j = 1 to length(directory_path) do
			sequence path_part = mighty_eagle:parse(me, directory_path[j], opts)
			parsed_path = append(parsed_path, path_part)
		end for
		sequence path_str = join_path(parsed_path)
		printf(1, "%s\n", {path_str})
		create_file(path_str)
		if equal(parsed_path[$], "eu.cfg") then
			create_default_eucfg(opts, path_str)
		elsif equal(parsed_path[$], "Makefile") then
			create_default_makefile(opts, path_str)
		elsif match(".creole", path_str) then
			create_default_doc(opts, path_str)
		end if
	end for
	return 0
end function 

function create_structure(map:map opts)
	-- Set up the directories
	printf(1, "==================\n")
	printf(1, "Creating Structure\n")
	printf(1, "==================\n")
	sequence project_path = map:get(opts, "project_path", current_dir())
	for i = 1 to length(project_trees) do
		sequence tree = project_trees[i]
		create_tree(opts, project_path, tree)
	end for
	
	-- Set up the files
	for i = 1 to length(project_files) do
		sequence files = project_files[i]
		create_files(opts, project_path, files)
	end for

	return 0
end function

--** 
-- Creates a new EuDrop project
-- Parameters:
-- ##opts## : A map of options for building the project
-- Supported Options:
-- ||Option||What it's for||Default Value||
-- |project_name|The name of the project|eudropper|
-- |project_path|Full path where the project should be built|Current working directory|

public function create_project(map:map opts)
	-- Make sure we have mandatory values
	sequence project_name = map:get(opts, "project_name", "-1")
	if equal(project_name, "-1") then
		printf(2, "Project name not defined.  Cannot create a project without a name.")
		abort(-1)
	end if
	
	-- If values are optional, then make sure we supply default values
	sequence project_path = map:get(opts, "project_path", current_dir())
	map:put(opts, "project_path",project_path)
	
	create_structure(opts)
	-- TODO setup main Makefile
	-- TODO setup test Makefile
	-- TODO setup doc Makefile
	-- TODO setup README.md
	-- TODO setup main creole doc
	-- TODO setup eudrop.xml
	-- TODO setup LICENSE
	
	return 0
end function
