@lazyGlobal off.

function clamp {
    parameter value, min, max.

    if min:typename = "scalar" and value < min return min.
    else if min:typename = "scalar" and value > max return max.
    return value.
}
