%creates variables used in EulerSolverTorque_exp

I = [0.06220455124 0.06220455124 0.03311417]; %moment of inertia about principal axes

N = [0 0 0]; %torque about the principal axes

w = [50 0 40]; %initial angular velocity about principal axes

Ish = [0.06220455124 0.06220455124 0.03311417]; %satellite moment of inertia (kg*m^2)

mags = zeros(20000:3);

magI = 0;

for i = 1:20000
    mags(i,:) = getMagneticField(45, i/60000);
end

ts = timeseries(mags);