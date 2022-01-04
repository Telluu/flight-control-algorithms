@lazyGlobal off.

local selectedALT to 2000.
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

on ag1 { set selectedALT to selectedALT - 10. return true. }
on ag2 { set selectedALT to selectedALT + 10. return true. }
on ag3 { set selectedALT to selectedALT - 100. return true. }
on ag4 { set selectedALT to selectedALT + 100. return true. }

until false {
    lock throttle to PIDController(
        selectedALT,
        alt:radar,
        0,
        1,
        time:seconds,
        0.025,
        0.975,
        0.25
    ).

    wait 0.
}
