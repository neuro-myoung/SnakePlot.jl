function assignStructure(df, tmArr)
	nrows = size(df, 1)
    df.element = repeat([""], nrows)
    df.structMap = zeros(nrows)
    df.resNum = 1:nrows

    init = 1
    for region in tmArr
        df.element[collect(region)] .= "tm"
        df.structMap[collect(region)] .= init

        init += 1
    end

    init = 0.5
    for row in eachrow(df)
        if row.structMap != 0
            init = row.structMap + 0.5
        else
            row.structMap = init
            row.element = "loop"
        end
    end

    @view df[df.structMap == minimum(df.structMap), :].element .= "nterm" 
    @view df[df.structMap == maximum(df.structMap), :].element .= "cterm" 

    return df
end