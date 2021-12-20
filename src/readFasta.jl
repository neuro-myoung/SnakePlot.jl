function readFasta(path)
    f = open(path, "r")

    seq = ""
    for line in readlines(f)
        if startswith(line, ">")
            continue		
        else
            seq *= line
        end
    end	
    close(f)
    return seq
end