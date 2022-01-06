@lazyGlobal off.
runOncePath("PID").

local myPID to PID(0.025, 1, 0.25, 0, 1).
local selALT to 1000.
local solution to 0.
lock throttle to solution.

on ag1 { set selALT to selALT - 10. return true. }
on ag2 { set selALT to selALT + 10. return true. }
on ag3 { set selALT to selALT - 100. return true. }
on ag4 { set selALT to selALT + 100. return true. }

until false {
    set solution to myPID:update(alt:radar, selALT, time:seconds).

    clearScreen.
    print "Selected ALT: " + selALT + "m".
    print "P: " + round(myPID:p, 1).
    print "I: " + round(myPID:i, 1).
    print "D: " + round(myPID:d, 1).
    print "Error: " + round(myPID:error, 1).

    wait 0.
}
