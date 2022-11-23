# Brian Silverman's Wireworld

using Plots

function ∇²(f)
    m = -f + 0.2*(circshift(f,(0,1)) + circshift(f,(0,-1)) + circshift(f,(1,0)) + circshift(f,(-1,0)))
    m += 0.05*(circshift(f,(1,1)) + circshift(f,(1,-1)) + circshift(f,(-1,1)) + circshift(f,(-1,-1)))
       
    return m
end

# Transition rules
function action(u,v)
    F = 0.034
    k = 0.095
    r = 1
    Du = 1
    Dv = 0.5
    
    dt = 0.1
    
    uv² = u.*(v.^2)
    
    un = u + (Du*∇²(u) - r*uv² + F*(1 .- u))*dt
    vn = v + (Dv*∇²(v) + r*uv² - (F + k)*v)*dt
    
    return un,vn
end

#===============================#
A = ones(101,101)
B = zeros(101,101)
B[45:55,45:55] .= 1
 
anim = @animate for i = 1:10000
    global A,B = action(A,B)
    heatmap(B./(A+B),c=:redsblues)
end

gif(anim, "test.gif", fps = 50)
    
            
