#!/usr/bin/env eui
include eudropper/eudropper.e
include std/map.e
include std/filesys.e

function main()
    map:map opts = map:new()
    map:put(opts, "project_name", "test_project")
    map:put(opts, "project_path", join_path({current_dir(), "test_project"}))
    create_project(opts)
    return 0
end function

main()
