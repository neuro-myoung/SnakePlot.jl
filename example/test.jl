using SnakePlot, GLMakie

path = "SnakePlot/example/piezo2.txt"
tms = [13:24, 31:43, 51:76, 123:141, 222:237, 241:258, 265:287, 336:355,
		493:514, 520:531, 536:562, 584:614, 690:703, 710:728, 738:757, 790:811,
		958:973, 980:989, 998:1018, 1075:1099, 1141:1155, 1158:1171, 1183:1202,
		1240:1260, 1315:1327, 1334:1346, 1356:1381, 1431:1447, 1992:2006, 2014:2025,
		2032:2053, 2087:2105, 2260:2279, 2302:2322, 2327:2350, 2360:2382, 2468:2491,
		2740:2760];

seq = readFasta(path)
seqdf = fasta2df(seq)
structdf = assignStructure(seqdf, tms)
positionTMs!(structdf, -1)


loops = @view structdf[structdf.element .== "loop", :]
loopNums = unique(loops.structMap)

yOffset = 0.2
for i in loopNums
    loop = @view loops[loops.structMap .== i, :]
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
            structdf[loop[i, :resNum], :x] = prevX
            structdf[loop[i, :resNum], :y] = prevY + side*(yOffset + (i-1) * dY)
        end
        for i in bot
            structdf[loop[i, :resNum], :x] = prevX + dX * (i-bot[1])
            structdf[loop[i, :resNum], :y] = prevY + side*(yOffset + (bot[1]-1) * dY)
        end
        structdf[loop[rgt, :resNum], :y] = reverse(loop[lft, :y])
        structdf[loop[rgt, :resNum], :x] .= nxtX
    elseif n > 40 && n <= 120
        loopLayout!(loop, 4, n, prevX, nxtX, prevY, side)
    elseif n > 120 && n <= 240
        loopLayout!(loop, 6, n, prevX, nxtX, prevY, side, expand=2)
    else
        loopLayout!(loop, 12, n, prevX, nxtX, prevY, side, expand=6)
    end
end

f = Figure(resolution=(2000,800))
ax = Axis(f[1, 1], xlabel = "", ylabel = "",
    title = "", grid=:none)
hlines!(ax, 1.1, color=:black, linewidth=2)
hlines!(ax, -0.1, color=:black, linewidth=2)
lines!(structdf.x, structdf.y, strokewidth=1, color = :black)
scatter!(structdf.x, structdf.y, color=:orange, strokewidth=1, strokecolor = :black, markersize=8)
ylims!(ax, -5, 5)
display(f)

