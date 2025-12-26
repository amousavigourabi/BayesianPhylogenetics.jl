module Likelihood

using BayesianPhylogenetics

const PhyloTree = BayesianPhylogenetics.Tree.PhyloTree
const PhyloLeaf = BayesianPhylogenetics.Tree.PhyloLeaf

const StrD{T} = Dict{String, T}
const LangWordD{T} = StrD{StrD{T}}
const WordEmbedding = Vector{Float64}
const SenseEmbeddings = Vector{WordEmbedding}

function assess_tree(tree::PhyloTree, record::LangWordD{SenseEmbeddings})::Tuple{StrD{SenseEmbeddings}, Float64, Float64}
  to_parent = tree.to_parent
  left_state, left_init_logp, left_dist = assess_tree(tree.left, record)
  right_state, right_init_logp, right_dist = assess_tree(tree.right, record)
  return (left_init_logp + right_init_logp)
end

function assess_tree(tree::PhyloLeaf, record::LangWordD{Vector{WordEmbedding}})::Tuple{StrD{SenseEmbeddings}, Float64, Float64}
  return record[tree.label], 0.0, tree.to_parent
end

export assess_tree

end
