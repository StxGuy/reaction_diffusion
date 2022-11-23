using Plots, Images

# Brusselator
function react(r,a,b)
    # Parameters
    Ly,Lx,Lz = size(r)     # Board size

    Du = 2.0
    Dv = 16.0
    Δx² = 1
    Δy² = 1
    Δt = 0.01

    # Scan board and compute the chemical potential
    nr = zeros(Ly,Lx,Lz)

    for j in 1:Lx
        for i in 1:Ly
            # Neighboring sites
            wj = 1 + (j-2+2Lx)%Lx
            ej = 1 + (j+2Lx)%Lx
            ni = 1 + (i-2+2Ly)%Ly
            si = 1 + (i+2Ly)%Ly

            # Laplacians
            ∇²x = (r[i,wj,1] + r[i,ej,1] - 2*r[i,j,1])/Δx²
            ∇²y = (r[ni,j,1] + r[si,j,1] - 2*r[i,j,1])/Δy²
            ∇²u = ∇²x + ∇²y

            ∇²x = (r[i,wj,2] + r[i,ej,2] - 2*r[i,j,2])/Δx²
            ∇²y = (r[ni,j,2] + r[si,j,2] - 2*r[i,j,2])/Δy²
            ∇²v = ∇²x + ∇²y

            # f and g functions
            u²v = (r[i,j,1]^2)*r[i,j,2]
            f = a - (b+1)*r[i,j,1] + u²v
            g = b*r[i,j,1] - u²v

            # Temporal update
            nr[i,j,1] = r[i,j,1] + Δt*(Du*∇²u + f)
            nr[i,j,2] = r[i,j,2] + Δt*(Dv*∇²v + g)
        end
    end

    return nr
end

#=========================================================#
#                          MAIN                           #
#=========================================================#
# Steady-state:
# u = a
# v = b/a

L = 200
a = 4.5
b = 6.75

# Perturbation around stead-state
r = zeros(L,L,2)
z = zeros(L,L,3)
r[:,:,1] = 0.1*rand(L,L) .+ a
r[:,:,2] = 0.1*rand(L,L) .+ b/a

anim = @animate for i = 1:500
    global r = react(r,a,b)
    z[:,:,1:2] = r/1.6
    img = colorview(RGB,permutedims(z,(3,1,2)))
    heatmap(r[:,:,1],interpolate=true)#,clim=(0,1.6))
end

gif(anim, "test.gif", fps = 10)

