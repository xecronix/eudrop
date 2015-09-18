namespace eudropper
include std/map.e
include std/filesys.e

function create_default_eucfg(sequence dir)
    sequence filename = join_path({dir, "eu.cfg"})
    integer fp = open(filename, "w")
    printf(fp, "../")
    close (fp)
    return 0
end function

function create_default_doc(sequence project_path, sequence project_name)
    sequence filename = join_path({project_path, "docs", sprintf("%s.creole", {project_name})})
    integer fp = open(filename, "w")
    printf(fp, "==%s", {project_name})
    close (fp)
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
    sequence project_name = map:get(opts, "project_name", "eudropper")
    sequence project_path = map:get(opts, "project_path", current_dir())
    create_directory(join_path({project_path, "extsrc"}))
    create_file(join_path({project_path, "extsrc", "Makefile"}))
    create_directory(join_path({project_path, "demo"}))
    create_directory(join_path({project_path, "demo", "build"}))
    create_directory(join_path({project_path, "demo", "bin"}))
    create_directory(join_path({project_path, "demo", "resources"}))
    create_file(join_path({project_path, "demo", "Makefile"}))
    create_default_eucfg(join_path({project_path, "demo"}))
    create_file(join_path({project_path, "demo", sprintf("%s.ex",{project_name})}))
    create_directory(join_path({project_path, "docs"}))
    create_directory(join_path({project_path, "docs", "resources"}))
    create_file(join_path({project_path, "docs", "Makefile"}))
    create_default_doc(project_path, project_name)
    create_directory(join_path({project_path, project_name}))
    create_directory(join_path({project_path, project_name, "ext"}))
    create_directory(join_path({project_path, project_name, "resources"}))
    create_file(join_path({project_path, project_name, "Makefile"}))
    create_file(join_path({project_path, project_name, sprintf("%s.e",{project_name})}))
    create_directory(join_path({project_path, "test"}))
    create_file(join_path({project_path, "test", "Makefile"}))
    create_default_eucfg(join_path({project_path, "test"}))
    create_file(join_path({project_path, "Makefile"}))
    create_file(join_path({project_path, "README.md"}))
    create_file(join_path({project_path, "eudrop.xml"}))
    return 0
end function 
