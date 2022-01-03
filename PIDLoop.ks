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
    print "P: " + round(p, 1).
    print "I: " + round(i, 1).
    print "D: " + round(d, 1).
    print "Error: " + round(error, 1).

    return min(max(p + i + d, minOutput), maxOutput).
}