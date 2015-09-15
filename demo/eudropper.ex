#!/usr/bin/env eui
include eudropper/eudropper.e
include std/map.e

function main()
    map:map opts = map:new()
    create_lib_project(opts)
    return 0
end function

main()
