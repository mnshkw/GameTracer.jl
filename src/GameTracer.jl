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

function _ipa(
    nums_actions::NTuple{N,Int},
    payoffs::Vector{Float64},
    ray::Vector{Float64},
    zh::Vector{Float64},
    alpha::Float64,
    fuzz::Float64,
) where N
    num_players = Cint(N)
    actions_c = Cint[a for a in nums_actions]
    M = sum(nums_actions)
    ans = zeros(Float64, M)
    ret = ccall(
        (:ipa, libgametracer), Cint,
        (Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble, Cdouble, Ptr{Cdouble}),
        num_players, actions_c, payoffs, ray, zh, alpha, fuzz, ans
    )

    converged = ret >= 0
    if ret < 0
        @warn "IPA returned error code $ret"
    end

    return (ans, converged)
end

function _gnm(
    nums_actions::NTuple{N,Int},
    payoffs::Vector{Float64},
    ray::Vector{Float64},
    steps::Integer,
    fuzz::Float64,
    lnmfreq::Integer,
    lnmmax::Integer,
    lambdamin::Float64,
    wobble::Integer,
    threshold::Float64,
) where N
    num_players = Cint(N)
    actions_c   = Cint[a for a in nums_actions]
    M           = sum(nums_actions)
    answers_ref = Ref{Ptr{Cdouble}}(C_NULL)

    num_eq = ccall(
        (:gnm, libgametracer), Cint,
        (Cint, Ptr{Cint}, Ptr{Cdouble},
         Ptr{Cdouble}, Ref{Ptr{Cdouble}},
         Cint, Cdouble, Cint, Cint, Cdouble, Cint, Cdouble),
        num_players, actions_c, payoffs,
        ray, answers_ref,
        Cint(steps), fuzz, Cint(lnmfreq), Cint(lnmmax),
        lambdamin, Cint(wobble), threshold
    )

    if num_eq < 0
        @warn"GNM returned error code $num_eq"
        return Vector{Vector{Float64}}()
    end

    num_eq == 0 && return Vector{Vector{Float64}}()

    ptr = answers_ref[]
    if ptr == C_NULL
        @warn "GNM returned num_eq=$num_eq but answers pointer was NULL"
        return Vector{Vector{Float64}}()
    end

    answers = try
        answers_view = unsafe_wrap(Array, ptr, (M, Int(num_eq)); own=false)
        copy(answers_view)
    finally
        _gametracer_free(ptr)
    end

    return [answers[:, j] for j in 1:Int(num_eq)]
end

function _gametracer_free(ptr::Ptr{Cdouble})
    ccall((:gametracer_free, libgametracer), Cvoid, (Ptr{Cvoid},), ptr)
end






end
