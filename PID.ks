@lazyGlobal off.
runOncePath("Utils").

function PID {
    parameter kP is 1, kI is 0, kD is 0, minOutput to false, maxOutput to false.

    local error to 0.
    local p to 0.
    local i to 0.
    local d to 0.
    local prevTime to 0.
    local prevError to 0.

    local struct to lexicon(
        "error", error,
        "p", p,
        "i", i,
        "d", d,
        "update", update@
    ).

    function update {
        parameter setPoint, input, sampleTime is time:seconds.

        set error to setPoint - input.
        local dt to sampleTime - prevTime.

        set p to kP * error.
        if prevTime < sampleTime {
            set i to clamp(kI * error * dt + i, minOutput, maxOutput).
            set d to kD * (error - prevError) / dt.
        }

        set prevError to error.
        set prevTime to sampleTime.

        set struct:p to p.
        set struct:i to i.
        set struct:d to d.
        set struct:error to error.

        return clamp(p + i + d, minOutput, maxOutput).
    }

    return struct.
}