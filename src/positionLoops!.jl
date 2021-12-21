function positionLoops!(loopdf; yOffset=0.2)
    loopNums = unique(loopdf.structMap)
    for i in loopNums
        loop = @view loopdf[loopdf.structMap .== i, :]
        startRes = loop[1,:resNum]
        n = size(loop, 1)
        prevX = loop.structMap[1] - 0.25
        nxtX = prevX + 1

        ## Check if cytoplasmic or extracellular loop
        if structdf[startRes-1, :y][1] >= 0.5
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
                structdf[loop[i, :resNum], :x] = prevX + dX[1] * (i-1)
                structdf[loop[i, :resNum], :y] = prevY + side * yOffset
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
            dY = 0.15
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
            loopLayout!(loop, 6, n, prevX, nxtX, prevY, side, expand=2)
        elseif n>240 && n<=480
            loopLayout!(loop, 12, n, prevX, nxtX, prevY, side, expand=6)
        else        
            loopLayout!(loop, 20, n, prevX, nxtX, prevY, side, expand=10)
        end
    end
end