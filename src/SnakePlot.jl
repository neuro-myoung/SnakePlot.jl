module SnakePlot

using DataFrames
using Statistics 
using GLMakie

include("readFasta.jl")
include("fasta2df.jl")
include("assignStructure.jl")

export readFasta, fasta2df, assignStructure
end
