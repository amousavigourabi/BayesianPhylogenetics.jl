module Tree

struct PhyloTree
  to_parent::Float64
  left::Union{PhyloTree, PhyloLeaf}
  right::Union{PhyloTree, PhyloLeaf}
end

struct PhyloNode
  label::String
  to_parent::Float64
end

end
