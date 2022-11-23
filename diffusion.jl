using Plots


# Transition rules
function action(grid)
    Ny,Nx = size(grid)
    ngrid = zeros(Ny,Nx)
    
    for j in 1:Nx
        for i in 1:Ny
            if (grid[i,j] > 0)
                # ngrid[i,j] = 0
                # North
                if (i > 1)
                    ngrid[i-1,j] += grid[i,j]*0.2
                end
                # South
                if (i < Ny)
                    ngrid[i+1,j] += grid[i,j]*0.2
                end
                # East
                if (j > 1)
                    ngrid[i,j-1] += grid[i,j]*0.2
                    # North-east
                    if (i > 1)
                        ngrid[i-1,j-1] += grid[i,j]*0.05
                    end
                    # South-east
                    if (i < Ny)
                        ngrid[i+1,j-1] += grid[i,j]*0.05
                    end
                end
                # West
                if (j < Nx)
                    ngrid[i,j+1] += grid[i,j]*0.2
                    # North-west
                    if (i > 1)
                        ngrid[i-1,j+1] += grid[i,j]*0.05
                    end
                    # South-west
                    if (i < Ny)
                        ngrid[i+1,j+1] += grid[i,j]*0.05
                    end
                end
            end
        end
    end
    
    return ngrid
end

#===============================#
state = zeros(50,50)
state[26,26] = 1

# for j in 1:3
#     for i in 1:5
#         println(state[i,:])
#     end
#     global state = action(state)
#     println("=============")
# end
#     
anim = @animate for i = 1:200
    global state = action(state)
    heatmap(state)
end

gif(anim, "test.gif", fps = 10)
    
