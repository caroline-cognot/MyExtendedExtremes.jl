module MyExtendedExtremes

export MixedUniformTail, pdf, cdf, quantile, rand, fit_mix  #I export everything 

using Distributions
using DocStringExtensions
using ExtendedExtremes
using Random 

"""
$(TYPEDEF)

$(TYPEDFIELDS)
 
I wanted to put an uniform on the left part, an EGPD on the bulk and tail. EGPD only works when filtering very low value but I want all the values ! 
"""
struct MixedUniformTail{
    T1<:ContinuousUnivariateDistribution,
    T2<:ContinuousUnivariateDistribution,
} <: ContinuousUnivariateDistribution
    " probability of the left part "
    p::Float64
    " left part "
    uniform_part::T1
    " right part "
    tail_part::T2 
    " minimum value, for precip it is 0.1 "
    a::Float64 
    " threshold between both part, 0.5 for precips (included in left part) "
    b::Float64 
end

import Distributions: pdf

"""
$(SIGNATURES)

PDF
"""
function pdf(d::MixedUniformTail, y::Real)
    if y < d.a
        return 0.0
    elseif y <= d.b
        return d.p * pdf(d.uniform_part, y)
    else
        return (1 - d.p) * pdf(d.tail_part, y - d.b)
    end
end

import Distributions: cdf

"""
$(SIGNATURES)

CDF
"""
function cdf(d::MixedUniformTail, y::Real)
    if y < d.a
        return NaN
    elseif y <= d.b
        return d.p * cdf(d.uniform_part, y)
    else
        return d.p + (1 - d.p) * cdf(d.tail_part, y - d.b)
    end
end

import Distributions: quantile

"""
$(SIGNATURES)

Quantile function
"""
function quantile(d::MixedUniformTail, q::Real)
    if q < 0 || q > 1
        throw(DomainError(q, "Quantile outside [0,1]"))
    end
    if q <= d.p
        return quantile(d.uniform_part, q / d.p)
    else
        return d.b + quantile(d.tail_part, (q - d.p) / (1 - d.p))
    end
end

import Base: rand

function rand(rng::AbstractRNG, d::MixedUniformTail)
    if rand(rng) <= d.p
        return rand(rng, d.uniform_part)
    else
        return d.b + rand(rng, d.tail_part)
    end
end

rand(d::MixedUniformTail) = rand(Random.GLOBAL_RNG, d)

"""
$(SIGNATURES)

estimation
"""
function fit_mix(::Type{MixedUniformTail}, data; left = 0.1, middle = 0.5)
    u = middle
    prop_smallrain = sum(left .<= data .<= u) / sum(data .> 0)
    y = data[data .> u] .- u

    tail_part = fit_mle(ExtendedGeneralizedPareto{TBeta}, y)

    return MixedUniformTail(prop_smallrain, Uniform(left, middle), tail_part, left, middle)
end

end
