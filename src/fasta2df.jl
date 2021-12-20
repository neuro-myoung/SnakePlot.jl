function fasta2df(seq)
    df = DataFrame(:res => split(seq,""))
	df.x = zeros(length(df.res))
	df.y = zeros(length(df.res))
	
    return df
end