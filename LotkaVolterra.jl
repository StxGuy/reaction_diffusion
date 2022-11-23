using Plots, Images

# Lotka-Volterra
function LV(v)
    # Parameters
    Ly,Lx = size(v)     # Board size

    α = 1.0
    β = 1.0
    δ = 1.0
    γ = 1.0

    M = [0 α;
         -α  0]
    P = [ 0;
         -0]

    # Initial conditions
    nv = zeros(Ly,Lx,2)

    # Scan board
    for j in 1:Lx
        for i in 1:Ly

            # Find neighborhood
            Nb = zeros(2)
            for vj in -1:1
                x = 1+(j+vj-1+2Lx)%Lx
                for vi in -1:1
                    y = 1+(i+vi-1+2Ly)%Ly

                    Nb = Nb + v[y,x,:]
                end
            end
            Nb = Nb/9

            # Update
            nv[i,j,1] = Nb[1] + 0.01*Nb[1]*(α - β*Nb[2])
            nv[i,j,2] = Nb[2] + 0.01*Nb[2]*(δ*Nb[1] - γ)
        end
    end

    return nv#clamp.(nv,0,1)
end

#=========================================================#
#                          MAIN                           #
#=========================================================#
L = 200
v = 2*(rand(L,L,2).-0.5)
p = zeros(L,L,3)

anim = @animate for i = 1:200
    global v = LV(v)
    p[:,:,1:2] = v
    img = colorview(RGB,permutedims(p,(3,1,2)))
    #plot(1:L,1:L,img)
    heatmap(img,interpolate=true)
end

gif(anim, "test.gif", fps = 10)

