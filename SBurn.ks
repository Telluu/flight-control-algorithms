@lazyGlobal off.

local touchDownSpeed to 1.
local softLandProfileHeight to 15.
local prevSampleTime to 0.
local prevError to 0.
local i to 0.

function clamp {
    parameter value, min, max.
    return min(max(value, min), max).
}

function PIDController {
    parameter setPoint, input, minOutput, maxOutput, sampleTime.
    parameter kP is 1, kI is 0, kD is 0.

    local error to setPoint - input.
    local dt to sampleTime - prevSampleTime.

    local p to Kp * error.
    set i to Ki * clamp(i + error * dt, minOutput, maxOutput).
    local d to Kd * ((error - prevError) / dt).

    set prevSampleTime to sampleTime.
    set prevError to error.

    return clamp(p + i + d, minOutput, maxOutput).
}

until false {
    local AGL to ship:bounds:bottomaltradar.
    local engAccel to ship:availablethrust / ship:mass.

    local timeToImpact to AGL / abs(ship:verticalspeed).
    local timeToStop to ship:airspeed / engAccel.
    local timeToBurn to timeToImpact - timeToStop.

    local solution to 1 - timeToBurn.

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
