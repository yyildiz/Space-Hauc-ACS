
function mag = getMagneticField(theta, time)
    theta = theta / 360.0 * 2 * pi;
    totalTime = 90;
    u = [1 0 0];
    n = [0 sin(theta) cos(theta)]; 
    P = getPoint(1.0 * time / totalTime, n, u);
    P_no_z = [P(1) P(2) 0];
    latitude = atan2d(norm(cross(P,P_no_z)),dot(P,P_no_z));
    longitude = atan2d(norm(cross(u,P_no_z)),dot(u,P_no_z));
    mag = igrf(7.3671e+05, latitude, longitude, 350);
end
%{

theta = 60 / 360.0 * 2 * pi;

u = [1 0 0];
n = [0 sin(theta) cos(theta)];

totalTime = 90;

runningTime = 45;
lat = [];
long = [];

for time = 1:runningTime
    
    P = getPoint(1.0 * time / totalTime, n, u);
    P_no_z = [P(1) P(2) 0];
    latitude = atan2d(norm(cross(P,P_no_z)),dot(P,P_no_z));
    longitude = atan2d(norm(cross(u,P_no_z)),dot(u,P_no_z));
    lat(time) = latitude;
    if time > 45
        longitude = 360 - longitude;
    end
    long(time) = longitude;
    igrf(now,latitude, longitude, 600)
end

x = linspace(1, runningTime, runningTime);
plot(x, long);
%}

