time = 0;
i = 1;
mags = zeros(20000,3);
while time <= 20
   mags(i,:) = 1;%getMagneticField(45, time/60);
   i = i + 1;
   time = time + 0.001;
end