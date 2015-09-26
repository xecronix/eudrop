#!/usr/bin/env eui
include eudrop/eudropper.e
include std/map.e
include std/filesys.e

function main()
    map:map opts = map:new()
    map:put(opts, "project_name", "fixme")
    map:put(opts, "project_path", current_dir())
    create_project(opts)
    return 0
end function

main()
