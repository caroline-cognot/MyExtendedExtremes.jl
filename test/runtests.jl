using Aqua
using Distributions
using MyExtendedExtremes
using Test

@testset "Aqua.jl" begin
    Aqua.test_deps_compat(MyExtendedExtremes)
end

@testset "MyExtendedExtremes Tests" begin
    # Create a MixedUniformTail instance for testing
    uniform_dist = Uniform(0.0, 1.0)
    tail_dist = Exponential(1.0)
    mixed_dist = MixedUniformTail(0.3, uniform_dist, tail_dist, 0.1, 0.5)

    # Test pdf function
    @test pdf(mixed_dist, 0.05) ≈ 0.0
    @test pdf(mixed_dist, 0.3) ≈ 0.3 * pdf(uniform_dist, 0.3)
    @test pdf(mixed_dist, 0.6) ≈ (1 - 0.3) * pdf(tail_dist, 0.6 - 0.5)

    # Test cdf function
    @test isnan(cdf(mixed_dist, 0.05))
    @test cdf(mixed_dist, 0.3) ≈ 0.3 * cdf(uniform_dist, 0.3)
    @test cdf(mixed_dist, 0.6) ≈ 0.3 + (1 - 0.3) * cdf(tail_dist, 0.6 - 0.5)

    # Test rand function
    rand_value = rand(mixed_dist)
    @test rand_value >= mixed_dist.a && rand_value <= mixed_dist.b || rand_value > mixed_dist.b
end

