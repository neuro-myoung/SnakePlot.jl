function positionLoops!(df; yOffset=0.2)
    loops = @view df[df.element .== "loop", :]
    loopNums = unique(loops.structMap)

    for i in loopNums
        loop = @view loops[loops.structMap .== i, :]
        startRes = loop[1,:resNum]
        n = size(loop, 1)
        prevX = median(df[df.structMap .== df[startRes-1, :structMap][1], :x])
        nxtX = median(df[df.structMap .== df[loop[end,:resNum]+1, :structMap][1], :x])

        ## Check if cytoplasmic or extracellular loop
        if df[startRes-1, :y][1] >= 0.5
            side = 1
            prevY = 1
        else
            side = -1
            prevY = 0
        end

        ## Just a line if it is small
        if n <= 5
            dX = (nxtX - prevX)/(n-1)
            for i in 1:size(loop, 1)
                loop[i, :x] = prevX + dX[1] * (i-1)
                loop[i, :y] = prevY + side * yOffset
            end
        
        ## Square parabola if it is fairly small
        elseif n > 5 && n <= 20
            ## Check if the loop has an odd or even length
            if n%2 != 0
                nBot = 5
            else
                nBot = 4
            end

            ## Divide loop among structure
            leg = div(n - nBot, 2)
            lft = 1:leg
            bot = leg+1:leg+1+nBot
            rgt = n-(leg-1):n

            ## Assign positions
            dY = 0.1
            dX = (nxtX-prevX)/(nBot-1)
            for i in lft
                loop[i, :x] = prevX
                loop[i, :y] = prevY + side*(yOffset + (i-1) * dY)
            end
            for i in bot
                loop[i, :x] = prevX + dX * (i-bot[1])
                loop[i, :y] = prevY + side*(yOffset + (bot[1]-1) * dY)
            end
            loop[rgt, :y] = reverse(loop[lft, :y])
            loop[rgt, :x] .= nxtX
        elseif n > 20 && n <= 120
            loopLayout!(loop, 4, n, prevX, nxtX, prevY, side)
        elseif n > 120 && n <= 240
            loopLayout!(loop, 6, n, prevX, nxtX, prevY, side)
        elseif n>240 && n<=480
            loopLayout!(loop, 14, n, prevX, nxtX, prevY, side, expand=10)
        else        
            loopLayout!(loop, 20, n, prevX, nxtX, prevY, side, expand=10)
        end
    end
        
    nt = @view df[df.element .== "nterm", :]
    nnt = size(nt, 1)
    prevXnt = 0.5
    nxtXnt = 1.5
    
    ## Check if cytoplasmic or extracellular loop
    if df[nt[end, :resNum]+1,:y] >= 0.5
        side = 1
        prevYnt = 1
    else
        side = -1
        prevYnt = 0
    end

    ## Just a line if it is small
    if nnt <= 5
        dX = (nxtXnt - prevXnt)/(nnt-1)
        for i in 1:size(nt, 1)
            nt[i, :x] = prevXnt + dX[1] * (i-1)
            nt[i, :y] = prevYnt + side * yOffset
        end
    
    ## Square parabola if it is fairly small
    elseif nnt > 5 && nnt <= 20
        ## Check if the loop has an odd or even length
        if nnt%2 != 0
            nBot = 5
        else
            nBot = 4
        end

        ## Divide loop among structure
        leg = div(nnt - nBot, 2)
        lft = 1:leg
        bot = leg+1:leg+1+nBot
        rgt = nnt-(leg-1):nnt

        ## Assign positions
        dY = 0.1
        dX = (nxtXnt-prevXnt)/(nBot-1)
        for i in lft
            nt[i, :x] = prevXnt
            nt[i, :y] = prevYnt + side*(yOffset + (i-1) * dY)
        end
        for i in bot
            nt[i, :x] = prevXnt + dX * (i-bot[1])
            nt[i, :y] = prevYnt + side*(yOffset + (bot[1]-1) * dY)
        end
        nt[rgt, :y] = reverse(nt[lft, :y])
        nt[rgt, :x] .= nxtXnt
    elseif nnt > 20 && nnt <= 120
        loopLayout!(nt, 4, nnt, prevXnt, nxtXnt, prevYnt, side)
    elseif nnt > 120 && nnt <= 240
        loopLayout!(nt, 6, nnt, prevXnt, nxtXnt, prevYnt, side)
    elseif nnt>240 && nnt<=480
        loopLayout!(nt, 14, nnt, prevXntnt, nxtXnt, prevYnt, side, expand=10)
    else        
        loopLayout!(nt, 20, nnt, prevXnt, nxtXnt, prevYnt, side, expand=10)
    end

    ct = @view df[df.element .== "cterm", :]
    nct = size(ct, 1)
    prevXct = median(df[df.structMap .== maximum(df.structMap)-0.5, :x])
    nxtXct = median(df[df.structMap .== maximum(df.structMap)-0.5, :x]) + 2

    ## Check if cytoplasmic or extracellular loop
    if df[ct[1, :resNum]-1,:y] >= 0.5
        side = 1
        prevYct = 1
    else
        side = -1
        prevYct = 0
    end

    ## Just a line if it is small
    if nct <= 5
        dX = (nxtXct - prevXct)/(nct-1)
        for i in 1:size(nt, 1)
            ct[i, :x] = prevXct + dX[1] * (i-1)
            ct[i, :y] = prevYct + side * yOffset
        end
    
    ## Square parabola if it is fairly small
    elseif nct > 5 && nct <= 20
        ## Check if the loop has an odd or even length
        if nct%2 != 0
            nBot = 5
        else
            nBot = 4
        end

        ## Divide loop among structure
        leg = div(nct - nBot, 2)
        lft = 1:leg
        bot = leg+1:leg+1+nBot
        rgt = nct-(leg-1):nct

        ## Assign positions
        dY = 0.1
        dX = (nxtXct-prevXct)/(nBot-1)
        for i in lft
            ct[i, :x] = prevXct
            ct[i, :y] = prevYct + side*(yOffset + (i-1) * dY)
        end
        for i in bot
            ct[i, :x] = prevXct + dX * (i-bot[1])
            ct[i, :y] = prevYct + side*(yOffset + (bot[1]-1) * dY)
        end
        ct[rgt, :y] = reverse(ct[lft, :y])
        ct[rgt, :x] .= nxtXct
    elseif nct > 20 && nct <= 120
        loopLayout!(ct, 4, nct, prevXct, nxtXct, prevYct, side)
    elseif nct > 120 && nct <= 240
        loopLayout!(ct, 6, nct, prevXct, nxtXct, prevYct, side)
    elseif nct>240 && nct<=480
        loopLayout!(ct, 14, nct, prevXntct, nxtXct, prevYct, side, expand=10)
    else        
        loopLayout!(ct, 20, nct, prevXct, nxtXct, prevYct, side, expand=10)
    end
end