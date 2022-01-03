set selectedALT to 100.
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

    clearScreen.
    print "Selected ALT: " + selectedALT.
    print "P: " + round(p, 1).
    print "I: " + round(i, 1).
    print "D: " + round(d, 1).
    print "Error: " + round(error, 1).

    return min(max(p + i + d, minOutput), maxOutput).
}

on ag1 { set selectedALT to selectedALT - 10. return true. }
on ag2 { set selectedALT to selectedALT + 10. return true. }
on ag3 { set selectedALT to selectedALT - 100. return true. }
on ag4 { set selectedALT to selectedALT + 100. return true. }

until false {
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
