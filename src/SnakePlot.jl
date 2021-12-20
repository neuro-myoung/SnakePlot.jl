module SnakePlot

using DataFrames
using Statistics 
using GLMakie

include("readFasta.jl")
include("fasta2df.jl")

export readFasta, fasta2df
end
