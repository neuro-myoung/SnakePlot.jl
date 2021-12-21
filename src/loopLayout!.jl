function loopLayout!(loop, nTurns, n, prevX, nxtX, prevY, side; yOffset = 0.1, expand=0)
	yOffset=0.1
    rem = (n - nTurns*2) % nTurns
	turnSize = div((n-rem-nTurns*2), nTurns)
    lftleg = 1:div(nTurns*2,2)
    rgtleg = (n-div(nTurns*2,2)+1):n
    turns = []
    position = lftleg[end] + 1

    for i in 1:nTurns
        if rem != 0
            push!(turns, position:position+turnSize)
            position += turnSize+1
            rem -= 1
        else
            push!(turns, position:position+turnSize-1)
            position += turnSize
        end
    end

    if nTurns < 5
        dX = (nxtX-prevX)/(nTurns-1)
        if side == 1
            expand = 1
        end
    else
        dX = (nxtX-prevX)/5
    end
    dY = 0.1

    ## position legs
	for i in lftleg
        loop[i, :x] = prevX
        loop[i, :y] = prevY + side*(yOffset + i * dY)
	end

    loop[rgtleg, :x] .= nxtX

    ## check for loop expand
    if expand > 0
        dX2 = 0.2
        for i in 0:expand
            if expand-i == expand
                loop[collect(lftleg)[end-i], :y] = loop[collect(lftleg)[end]-(expand+1), :y] + side*dY
                loop[collect(lftleg)[end-i], :x] -= (expand-i) * dX2 
            else
                loop[collect(lftleg)[end-i], :y] = loop[collect(lftleg)[end]-(expand+1), :y]
                loop[collect(lftleg)[end-i], :x] -= (expand-(i-1)) * dX2 
            end
            
            if i == 1
                loop[collect(rgtleg)[i], :x] = nxtX + expand*dX2 
            end
            loop[collect(rgtleg)[i+2], :x] = nxtX + (expand-i)*dX2 
        end
        
        prevX -= expand * dX2 
        nxtX += expand * dX2 
        dX = (nxtX-prevX)/(nTurns-1)
    end

    loop[rgtleg, :y] = reverse(loop[lftleg, :y])
    
    ## position first turn
    for i in turns[1]
        loop[i, :x] = prevX
        loop[i, :y] = prevY + side*(yOffset + (i-expand)*dY)
    end

    for i in 2:length(turns)
        loop[turns[i], :x] .= prevX + dX*(i-1)
        if i%2 == 0
            loop[turns[i], :y] = reverse(loop[turns[1],:y])[end-length(turns[i])+1:end]
        else
            loop[turns[i], :y] = loop[turns[1],:y][1:length(turns[i])]
        end
    end

    xOffset = (nxtX - prevX)/((nTurns-1)*2)
    for i in 2:length(turns)
        if loop[turns[i][1], :y] != loop[turns[i-1][end], :y]
            loop[turns[i-1][end], :x] += xOffset
            loop[turns[i-1][end], :y] += side*0.5*dY*(-1^(i+1))
        else
            loop[turns[i-1][end], :x] += xOffset/2
            loop[turns[i][1], :x] -= xOffset/2
        end
    end
end