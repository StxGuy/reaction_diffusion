using Plots, Images

# Belousov-Zhabotinsky reaction
function BZ(v)
    # Parameters
    Ly,Lx = size(v)     # Board size

    α = 1.2             # BZ parameters
    β = 1.0
    γ = 1.0

    M = [ 0 α -γ;
         -α 0  β;
          γ -β 0]

    # Initial conditions
    nv = zeros(Ly,Lx,3)

    # Scan board
    for j in 1:Lx
        for i in 1:Ly

            # Find neighborhood
            Nb = zeros(3)
            for vj in -1:1
                x = 1+(j+vj-1+2Lx)%Lx
                for vi in -1:1
                    y = 1+(i+vi-1+2Ly)%Ly

                    Nb = Nb + v[y,x,:]
                end
            end
            Nb = Nb/9

            # Update
            nv[i,j,:] = Nb + Nb.*(M*Nb)
        end
    end

    return clamp.(nv,0,1)
end

#=========================================================#
#                          MAIN                           #
#=========================================================#
L = 200
v = rand(L,L,3)

anim = @animate for i = 1:200
    global v = BZ(v)
    #x = v[:,:,1]
    img = colorview(RGB,permutedims(v,(3,1,2)))
    #plot(1:L,1:L,img)
    heatmap(img,interpolate=true)
end

gif(anim, "test.gif", fps = 10)

