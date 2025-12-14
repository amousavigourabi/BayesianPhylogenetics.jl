module Record

const LabelLookup = Map{String, Map{String, Vector{String}}} # first maps to language, then maps to all word senses
const Embeddings = Map{String, Vector{Float64}}

const Handles = Vector{String}

struct FullRecord
  translation::LabelLookup
  embeddings::Embeddings
end

# function import_embeddings(handles::Handles)::FullRecord
#   TODO import embeddings
# end

end
