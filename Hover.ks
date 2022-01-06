@lazyGlobal off.

local selALT to 1000.
local solution to 0.
lock throttle to solution.

on ag1 { set selALT to selALT - 10. return true. }
on ag2 { set selALT to selALT + 10. return true. }
on ag3 { set selALT to selALT - 100. return true. }
on ag4 { set selALT to selALT + 100. return true. }

until false {
    local AGL to ship:bounds:bottomaltradar.

    local metersToStop to ship:verticalspeed * (ship:verticalspeed / ship:sensors:grav:mag).
    if ship:verticalspeed < 0 set metersToStop to -metersToStop.

    set solution to selALT - AGL - metersToStop.

    clearScreen.
    print "Selected ALT: " + selALT + "m".
    print "AGL: " + round(AGL) + "m".
    print "Solution: " + round(solution, 1).
    print "Meters to stop: " + round(metersToStop, 1) + "m".

    wait 0.
}
