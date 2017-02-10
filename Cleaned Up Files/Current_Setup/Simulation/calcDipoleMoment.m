function D = calcDipoleMoment(B, L)
    Lp = L - (dot(L, B) * B) / (norm(B) * norm(B));
    T = -Lp;
    Dmag = norm(T)/norm(B);
    D = cross(Lp / norm(Lp), B / norm(B));
    D = D * Dmag;
end