using Plots, Images

# Cahn-Hilliard
function CH(c)
    # Parameters
    Ly,Lx = size(c)     # Board size

    D = 0.1
    γ = 0.5
    Δx² = 1
    Δy² = 1
    Δt = 0.5

    # Scan board and compute the chemical potential
    μ = zeros(Ly,Lx)

    for j in 1:Lx
        for i in 1:Ly
            wj = 1 + (j-2+2Lx)%Lx
            ej = 1 + (j+2Lx)%Lx
            ni = 1 + (i-2+2Ly)%Ly
            si = 1 + (i+2Ly)%Ly

            ∇²x = (c[i,wj] + c[i,ej] - 2*c[i,j])/Δx²
            ∇²y = (c[ni,j] + c[si,j] - 2*c[i,j])/Δy²
            ∇²c = ∇²x + ∇²y

            μ[i,j] = c[i,j]^3 - c[i,j] - γ*∇²c
        end
    end

    # Scan board to find new concentrations
    nc = zeros(Ly,Lx)

    for j in 1:Lx
        for i in 1:Ly
            wj = 1 + (j-2+2Lx)%Lx
            ej = 1 + (j+2Lx)%Lx
            ni = 1 + (i-2+2Ly)%Ly
            si = 1 + (i+2Ly)%Ly

            ∇²x = (μ[i,wj] + μ[i,ej] - 2*μ[i,j])/Δx²
            ∇²y = (μ[ni,j] + μ[si,j] - 2*μ[i,j])/Δy²
            ∇²μ = ∇²x + ∇²y

            nc[i,j] = c[i,j] + Δt*D*∇²μ
        end
    end

    return nc
end

#=========================================================#
#                          MAIN                           #
#=========================================================#
L = 200
v = 2*(rand(L,L) .- 0.5)

anim = @animate for i = 1:200
    global v = CH(v)

    heatmap(v,interpolate=true,clim=(-1,1))
end

gif(anim, "test.gif", fps = 10)

