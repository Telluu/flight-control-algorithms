
until false {
    lock throttle to PIDController(100, ship:bounds:bottomaltradar, 0, 1, time:seconds, 10, 10, 100).
}

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

    clearScreen.
    print "P: " + p.
    print "I: " + i.
    print "D: " + d.
    print "Change Rate: " + changeRate.
    print "Error: " + errorValue.

    set lastSampleTime to sampleTime.
    set lastInput to input.

    return clamp(p + i + d, minOutput, maxOutput).
}
