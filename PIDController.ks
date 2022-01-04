@lazyGlobal off.

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

    clearScreen.
    print "P: " + round(p, 1).
    print "I: " + round(i, 1).
    print "D: " + round(d, 1).
    print "Error: " + round(error, 1).

    return clamp(p + i + d, minOutput, maxOutput).
}