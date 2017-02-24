function D = findDVector(B,L)
%Using the magnetic field (B) vector and angular momentum (L) vector, 
%calculates the dipole (D) vector needed to generate a torque equal to the
%negative of the component vector of L perpendicular to B

    %find the unit vector in the B direction
    Bunit = B/norm(B);
    %find component of L perpendicular to B
    Lp = L - dot(B,L)/(norm(B))^2*B;
    %find the unit vector in the Lp direction
    Lpunit = Lp/norm(Lp);
    
    %find unit vector in D direction
    Dunit = cross(Lpunit, Bunit);
    
    %find the magnitude of the D vector
    Dnorm = norm(Lp)/norm(B);
    
    %create the D vector
    D = Dnorm*Dunit;
    
end