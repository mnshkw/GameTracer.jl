module GameTracer

using GameTheory: NormalFormGame, GAMPayoffVector

# ------------------------------------------------------------------
# Library Path
# ------------------------------------------------------------------
# TODO: Remove hardcoded dylib path after Phase B
# Temporary: Using local dylib until Phase B is complete
const libgametracer = "/tmp/gametracer_prefix/lib/libgametracer.dylib"

# ------------------------------------------------------------------
# Public API & Result Types
# ------------------------------------------------------------------
export ipa_solve, gnm_solve
export IPAResult, GNMResult

"""
    IPAResult

# Fields TBD

"""
struct IPAResult
    # TBD
end

"""
    GNMResult

# Fields TBD

"""
struct GNMResult
    # TBD
end

"""
    ipa_solve(g::NormalFormGame) -> IPAResult

# Arguements

# Keyword Arguments

# Returns

- IPAResult:

# References

"""
function ipa_solve(g::NormalFormGame)
    
    return IPAResult()
end


"""
    gnm_solve(g::NormalFormGame) -> GNMResult

# Arguements

# Keyword Arguments

# Returns

- GNMResult: 

# References

"""
function gnm_solve(g::NormalFormGame)
    
    return GNMResult()
end


# ------------------------------------------------------------------
# Private API (C ABI wrappers)
# ------------------------------------------------------------------








end
