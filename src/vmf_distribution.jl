module VmfDistribution

using LinearAlgebra
using Roots
using SpecialFunctions

struct Vmf
  d::Integer
  μ::Vector{Float32}
  κ::Float32
end

function A_d(κ::Float32, d::Integer)::Float32
  ν = d/2
  return besseli(ν, κ) / besseli(ν-1, κ)
end

function convolve(dist::Vmf, τ::Integer)::Vmf
  κ_d = dist.κ
  d = length(dist.μ)
  r = A_d(κ_d, d) * A_d(100.0f0, d)^τ # TODO this fixed number ought to be a max marg estimation
  κ_out = find_zero(κ -> A_d(κ, d) - r, κ_d)
  return Vmf(dist.d, dist.μ, κ_out)
end

function pointwise(dist_1::Vmf, dist_2::Vmf)::Vmf
  η = dist_1.κ .* dist_1.μ .+ dist_2.κ .* dist_2.μ
  κ = norm(η)
  μ = iszero(κ) ? η : η ./ κ
  return Vmf(dist_1.d, μ, κ)
end

export Vmf, pointwise, convolve

end
