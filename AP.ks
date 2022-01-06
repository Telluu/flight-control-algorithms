@lazyGlobal off.

until false {
    local selectedMenu to "main".
    on ag1 { set selectedMenu to "hover". return true. }
    on ag2 { set selectedMenu to "sburn". return true. }
    on ag10 { set selectedMenu to "main". return true. }

    if selectedMenu = "main" {
        clearScreen.
        print "####################".
        print "1). Hover".
        print "2). Auto land".
        print "0). Back".
        print "####################".
    }
    else if selectedMenu = "hover" { runPath("Hover"). }
    else if selectedMenu = "sburn" { runPath("SBurn"). }
}
