module Engine

using BayesianPhylogenetics

const PhyloTree = BayesianPhylogenetics.Tree.PhyloTree

const StrD{T} = Dict{String, T}
const LangWordD{T} = StrD{StrD{T}}
const WordEmbedding = Vector{Float64}
const SenseEmbeddings = Vector{WordEmbedding}

struct McmcParameters
  branch_dist::ContinuousUnivariateDistribution
  N::Integer
  burn_in::Integer
  sample_rate::Integer
end

function sample_parameters(branch_dist::ContinuousUnivariateDistribution, N::Integer, burn_in::Integer, sample_rate::Integer)
  return McmcParameters(branch_dist, N, burn_in, sample_rate)
end

function sample(labels::Vector{String}, record::LangWordD{SenseEmbeddings}, params::McmcParameters)::Vector{PhyloTree}
  tree = BayesianPhylogenetics.Tree.initialize_tree(labels, params.branch_dist)::PhyloTree
  old_log_likelihood = BayesianPhylogenetics.Likelihood.assess_tree(tree, record)
  samples = Vector{PhyloTree}((params.N - params.burn_in) ÷ params.sample_rate)
  for i ∈ 1..params.N
    proposed_tree, q_prob = BayesianPhylogenetics.Tree.mutate_tree(tree)
    proposed_log_likelihood = BayesianPhylogenetics.Likelihood.assess_tree(proposed_tree, record)
    log_draw = log(rand())
    if log_draw < proposed_log_likelihood - old_log_likelihood + q_prob
      old_log_likelihood = proposed_log_likelihood
      tree = deepcopy(proposed_tree)
    end
    if i % params.sample_rate ≡ 0 ⩓ i < params.burn_in
      push!(samples, deepcopy(tree))
    end
  end
  return samples
end

export sample, sample_parameters

end
