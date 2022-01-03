set touchDownSpeed to 1.
set softLandProfileHeight to 15.
set prevSampleTime to 0.
set prevError to 0.
set i to 0.

function PIDController {
    parameter setPoint.
    parameter input.
    parameter minOutput.
    parameter maxOutput.
    parameter sampleTime.
    parameter kP is 1.
    parameter kI is 0.
    parameter kD is 0.

    set error to setPoint - input.
    set dt to sampleTime - prevSampleTime.

    set p to Kp * error.
    set i to Ki * (i + error * dt).
    set d to Kd * ((error - prevError) / dt).

    set prevSampleTime to sampleTime.
    set prevError to error.

    return min(max(p + i + d, minOutput), maxOutput).
}

until false {
    set AGL to ship:bounds:bottomaltradar.
    set engAccel to ship:availablethrust / ship:mass.

    set timeToImpact to AGL / abs(ship:verticalspeed).
    set timeToStop to ship:airspeed / engAccel.
    set timeToBurn to timeToImpact - timeToStop.

    set solution to 1 - timeToBurn.

    clearScreen.
    print "AGL: " + round(AGL) + "m".
    print "Time to impact: " + round(timeToImpact, 1) + "s".
    print "Time to stop: " + round(timeToStop, 1) + "s".
    print "Time to burn: " + round(timeToBurn, 1) + "s".
    print "Delta-v needed: " + round(timeToStop * engAccel, 1) + "m/s".
    print "Q: " + round(ship:q * constant:atmtokpa, 1) + "kPa".

    if AGL < softLandProfileHeight {
        lock throttle to PIDController(
            -touchDownSpeed,
            ship:verticalspeed,
            0,
            1,
            time:seconds,
            0.25
        ).
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

    wait 0.
}
