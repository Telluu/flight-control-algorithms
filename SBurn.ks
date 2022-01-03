function clamp {
    parameter value.
    parameter min.
    parameter max.
    return min(max(value, min), max).
}

set lastSampleTime to 0.
set lastInput to 0.
function PIDController {
    parameter setPoint.
    parameter input.
    parameter minOutput.
    parameter maxOutput.
    parameter sampleTime.
    parameter kP is 1.
    parameter kI is 0.
    parameter kD is 0.

    set p to 0.
    set i to 0.
    set d to 0.

    set dt to sampleTime - lastSampleTime.
    set errorValue to setPoint - input.
    set changeRate to (input - lastInput) / dt.

    set p to Kp * errorValue.
    set i to Ki * (i + errorValue * dt).
    set d to Kd * -changeRate.

    set lastSampleTime to sampleTime.
    set lastInput to input.

    return clamp(p + i + d, minOutput, maxOutput).
}

set touchDownSpeed to 0.5.
set softLandProfileHeight to 10.

until false {
    set AGL to ship:bounds:bottomaltradar.
    set engAccel to ship:availablethrust / ship:mass.

    set timeToImpact to AGL / abs(ship:verticalspeed).
    set timeToStop to ship:airspeed / engAccel.
    set timeToBurn to timeToImpact - timeToStop.

    set solution to 1 - timeToBurn.

    clearScreen.
    print "AGL: " + ceiling(AGL) + "m".
    print "Time to impact: " + ceiling(timeToImpact, 1) + "s".
    print "Time to stop: " + ceiling(timeToStop, 1) + "s".
    print "Time to burn: " + ceiling(timeToBurn, 1) + "s".
    print "Delta-v needed: " + ceiling(timeToStop * engAccel, 1) + "m/s".
    print "Q: " + ceiling(ship:q * constant:atmtokpa, 1) + "kPa".

    if AGL < softLandProfileHeight {
        lock throttle to PIDController(-AGL - touchDownSpeed, ship:verticalspeed, 0, 1, time:seconds).
    } else if ship:verticalspeed < 0 {
        lock throttle to solution.
    }

    if ship:status = "LANDED" or ship:status = "SPLASHED" { break. }

    if ship:verticalspeed < 0 {
        if AGL < softLandProfileHeight and ship:groundspeed < 5 {
            lock steering to up:vector.
        } else {
            lock steering to (-1) * ship:velocity:surface.
        }
    } else {
        lock steering to ship:velocity:surface.
    }

    if timeToImpact < 5 and not gear { gear on. }
}
