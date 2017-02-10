function [ P ] = getPoint( timeRatio, n, u)

    timeRatioRad = timeRatio * 2 * pi;
    P = cos(timeRatioRad) * u + sin(timeRatioRad) * cross(n, u);

end