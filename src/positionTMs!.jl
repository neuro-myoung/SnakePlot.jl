function positionTMs!(df, side)
		
    sub = filter(x -> x.element == "tm", df)
    grps = groupby(sub, :structMap)
    membHeight = 1
    
    for g in 1:length(grps)
            
        TempX = grps[g].structMap[1]
        if side == -1
            TempY = 0
        else
            TempY = 1
        end
        n = length(grps[g].res)
        nTurns = floor(n/3) -1
        
        turn = 1
        count = 1
        resPerTurn = 3
        
        for residue in 1:n
            x = TempX
            y = TempY
            if count % resPerTurn == 0
                if side == -1
                    TempY = turn * membHeight/nTurns
                else
                    TempY = 1-(turn * membHeight/nTurns)
                end
                TempX = grps[g].structMap[1]
                turn += 1
                count = 0

                if resPerTurn == 3
                    resPerTurn = 4
                    TempX -= 0.1
                else
                    resPerTurn = 3
                end
            else
                TempX += 0.22
                TempY -= 0.02*side
            end
            grps[g][residue, :x] = x
            grps[g][residue, :y] = y
            
            count += 1
        end
        side *= -1
    end
    
    df[df[!,:element] .== "tm", :] = transform(grps)
    return df
    
end