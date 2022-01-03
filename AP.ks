set selectedALT to 100.
set touchDownSpeed to 1.
set softLandProfileHeight to 15.
set selectedMenu to "main".
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

on ag1 { set selectedMenu to "hover". return true. }
on ag2 { set selectedMenu to "sburn". return true. }
on ag10 { set selectedMenu to "exit". return true. }

on ag3 { set selectedALT to selectedALT - 10. return true. }
on ag4 { set selectedALT to selectedALT + 10. return true. }
on ag5 { set selectedALT to selectedALT - 100. return true. }
on ag6 { set selectedALT to selectedALT + 100. return true. }

until selectedMenu = "exit" {
    until selectedMenu <> "main" {
        clearScreen.
        print "####################".
        print "1). Hover".
        print "2). Auto land".
        print "0). Exit".
        print "####################".

        wait 0.
    }

    until selectedMenu <> "hover" {
        clearScreen.
        print "####################".
        print "1). Hover (ACTIVE)".
        print "2). Auto land".
        print "0). Exit".
        print "####################".
        print "Selected ALT: " + selectedALT + "m".

        lock throttle to PIDController(
            selectedALT,
            ship:altitude,
            0,
            1,
            time:seconds,
            0.025,
            0,
            0.25
        ).

        wait 0.
    }

    until selectedMenu <> "sburn" {
        set AGL to ship:bounds:bottomaltradar.
        set engAccel to ship:availablethrust / ship:mass.

        set timeToImpact to AGL / abs(ship:verticalspeed).
        set timeToStop to ship:airspeed / engAccel.
        set timeToBurn to timeToImpact - timeToStop.

        set solution to 1 - timeToBurn.

        clearScreen.
        print "####################".
        print "1). Hover".
        print "2). Auto land (ACTIVE)".
        print "0). Exit".
        print "####################".
        print "Time to burn: " + round(timeToBurn, 1) + "s".
        print "Delta-v needed: " + round(timeToStop * engAccel, 1) + "m/s".

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

        if ship:status = "LANDED" or ship:status = "SPLASHED" {
            set selectedMenu to "main".
        }

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
}
