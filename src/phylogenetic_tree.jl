module Tree

using Distributions

struct PhyloLeaf
  label::String
  to_parent::Float64
end

struct PhyloTree
  left::Union{PhyloTree, PhyloLeaf}
  right::Union{PhyloTree, PhyloLeaf}
  to_parent::Float64
end

function initialize_tree(labels::AbstractVector{String}, branch_dist::ContinuousUnivariateDistribution)::Union{PhyloLeaf, PhyloTree}
  to_parent = rand(branch_dist)
  if length(labels) < 2
    return PhyloLeaf(labels[1], to_parent)
  end
  p_dist = Binomial(length(labels) - 1, 0.5)
  pivot = rand(p_dist)
  @views left = initialize_tree(labels[1:pivot], branch_dist)
  @views right = initialize_tree(labels[(pivot+1):end], branch_dist)
  return PhyloTree(left, right, to_parent)
end

function mutate_tree(tree::PhyloTree)::Tuple{PhyloTree, Float64}
  return deepcopy(tree)
end

export initialize_tree

end
