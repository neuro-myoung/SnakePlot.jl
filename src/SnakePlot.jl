module SnakePlot

using DataFrames
using Statistics 
using GLMakie

include("readFasta.jl")
include("fasta2df.jl")
include("assignStructure.jl")
include("positionTMs!.jl")

export readFasta, fasta2df, assignStructure, positionTMs!
end
