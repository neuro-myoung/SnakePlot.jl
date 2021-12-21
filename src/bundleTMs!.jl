function bundleTMs!(df, nBundles)
    df.x += floor.((df.structMap .- 1) ./ nBundles) .* 2
end