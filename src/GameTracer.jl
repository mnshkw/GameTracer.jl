module GameTracer

# TODO: Remove hardcoded dylib path after Phase B
# Temporary: Using local dylib until Phase B is complete
const libgametracer = "/tmp/gametracer_prefix/lib/libgametracer.dylib"

export ipa, gnm, gametracer_free

function ipa(
    nums_actions::NTuple{N,Integer},
    payoffs::Vector{Float64},
    g::Vector{Float64},
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
        num_players, actions_c, payoffs, g, zh, alpha, fuzz, ans
    )
    ret < 0 && error("ipa returned error code $ret")
    return ans
end

function gnm(
    nums_actions::NTuple{N,Integer},
    payoffs::Vector{Float64},
    g::Vector{Float64},
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
        g, answers_ref,
        Cint(steps), fuzz, Cint(lnmfreq), Cint(lnmmax),
        lambdamin, Cint(wobble), threshold
    )

    num_eq < 0 && error("gnm returned error code $num_eq")
    num_eq == 0 && return Vector{Vector{Float64}}()

    ptr = answers_ref[]
    ptr != C_NULL || error("gnm returned num_eq=$num_eq but answers pointer was NULL")

    answers = try
        answers_view = unsafe_wrap(Array, ptr, (M, Int(num_eq)); own=false)
        copy(answers_view)
    finally
        gametracer_free(ptr)
    end

    return [answers[:, j] for j in 1:Int(num_eq)]
end

function gametracer_free(ptr::Ptr{Cdouble})
    ccall((:gametracer_free, libgametracer), Cvoid, (Ptr{Cvoid},), ptr)
end

end # module GameTracer