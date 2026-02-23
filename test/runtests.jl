using GameTracer
using Test

@testset "GameTracer.jl" begin

    @testset "ipa: 3x2 game (von Stengel 2007)" begin
        nums_actions = (3, 2)
        M = sum(nums_actions)
        payoffs = Float64[3.0, 2.0, 0.0, 3.0, 5.0, 6.0,
                          3.0, 2.0, 3.0, 2.0, 6.0, 1.0]
        ray  = Float64[0.0, 0.0, 1.0, 0.0, 1.0]
        zh   = Float64[1/3, 1/3, 1/3, 1/2, 1/2]
        ans  = GameTracer.ipa(nums_actions, payoffs, ray, zh, 0.02, 1e-6)
        @test length(ans) == M
        @test all(isfinite, ans)
        @test all(x -> x >= -1e-9, ans)
    end

    @testset "gnm: 3x2 game (von Stengel 2007)" begin
        nums_actions = (3, 2)
        M = sum(nums_actions)
        payoffs = Float64[3.0, 2.0, 0.0, 3.0, 5.0, 6.0,
                          3.0, 2.0, 3.0, 2.0, 6.0, 1.0]
        ray = Float64[0.0, 0.0, 1.0, 0.0, 1.0]
        eqs = GameTracer.gnm(nums_actions, payoffs, ray,
                             100, 1e-12, 3, 10, -10.0, 0, 1e-2)
        @test length(eqs) == 3
        @test all(eq -> length(eq) == M, eqs)
        @test all(eq -> all(isfinite, eq), eqs)
    end

end