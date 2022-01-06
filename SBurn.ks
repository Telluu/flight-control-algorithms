@lazyGlobal off.
runOncePath("PID").

local myPID to PID(0.5).
local throttleSolution to 0.
local steeringSolution to (-1) * ship:velocity:surface.
lock throttle to throttleSolution.
lock steering to steeringSolution.

until false {
    local AGL to ship:bounds:bottomaltradar.
    local engAccel to ship:availablethrust / ship:mass.

    local timeToImpact to AGL / abs(ship:verticalspeed).
    local timeToStop to ship:airspeed / engAccel.
    local timeToBurn to timeToImpact - timeToStop.

    if ship:verticalspeed > 0 {
        set steeringSolution to ship:velocity:surface.
    }
    else if AGL < 20 and ship:groundspeed < 5 {
        set throttleSolution to myPID:update(ship:verticalspeed, -0.5, time:seconds).
        set steeringSolution to up:vector.
    }
    else {
        set throttleSolution to 1 - timeToBurn.
        set steeringSolution to (-1) * ship:velocity:surface.
    }

    if timeToImpact < 5 and not gear { gear on. }
    if ship:status = "LANDED" or ship:status = "SPLASHED" { break. }

    clearScreen.
    print "AGL: " + round(AGL) + "m".
    print "Time to impact: " + round(timeToImpact, 1) + "s".
    print "Time to stop: " + round(timeToStop, 1) + "s".
    print "Time to burn: " + round(timeToBurn, 1) + "s".
    print "Delta-v needed: " + round(timeToStop * engAccel, 1) + "m/s".
    print "Q: " + round(ship:q * constant:atmtokpa, 1) + "kPa".

    wait 0.
}
