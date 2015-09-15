namespace eudropper
include std/map.e
include std/filesys.e

function create_default_eucfg(sequence dir)
    sequence filename = join_path({dir, "eu.cfg"})
    integer fp = open(filename[2..$], "w")
    printf(fp, "../")
    close (fp)
    return 0
end function

function create_default_doc(sequence project_name)
    sequence filename = join_path({"docs", project_name})
    integer fp = open(filename[2..$], "w")
    printf(fp, "==%s.creole", project_name)
    close (fp)
    return 0
end function

public function create_app_project(map:map opts)
--    bin/ - compiled binaries (*.dll, .exe, *.so)
--    build/ - translated files (*.c, *.h, *.mak)
--    demo/ - demos/examples (*.ex)
--    dist/ - distribution files (*.zip)
--    docs/ - documentation (*.html, etc.)
--    include/ - include files (*.e)
--    resources/ - static resources (*.png, etc.)
--    src/ - project source files (*.ex)
--    test/ - unit testing files (t_*.e)
--    Makefile - the Makefile to translate and build the application 

    return 0
end function 

public function create_lib_project(map:map opts)
    create_directory("extsrc")
    create_file("extsrc/Makefile")
    create_directory("demo")
    create_directory("demo/build")
    create_directory("demo/bin")
    create_directory("demo/resources")
    create_file("demo/Makefile")
    create_default_eucfg("demo")
    create_file("demo/eudropper.ex")
    create_directory("docs")
    create_directory("docs/resources")
    create_file("docs/Makefile")
    create_default_doc("eudropper")
    create_directory("eudropper")
    create_directory("eudropper/ext")
    create_directory("eudropper/resources")
    create_file("eudropper/Makefile")
    create_file("eudropper/eudropper.e")
    create_directory("test")
    create_file("test/Makefile")
    create_default_eucfg("test")
    create_file("Makefile")
    create_file("README.md")
    create_file("eudrop.xml")
    return 0
end function 
