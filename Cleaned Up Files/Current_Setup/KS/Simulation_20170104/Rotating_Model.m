%  ----------------------- READ ME -----------------------

% To run this program,      NEW RULES
    % 1.  Enter the command 'RunSimulation' in the Command Window.  Done!

% To use this program,      OLD RULES
    % 1.  Navigate to the 'Master_Files' folder
    % 2.  Run the script named 'EulerSolverVariables_Master_20161229.m'
    % 3.  Open the Simulink file named 'EulerSolver_Master_20170103.slx'
    % 4.  Run that Simulink file to generate the omega values
    % 5.  Navigate back to this script
    % 6.  Now, in the Command Window, enter the command:
    %     'Rotating_Model(w3.Data, w2.Data, w1.Data, L3.Data, L2.Data, L1.Data)'


function Rotating_Model(omega1, omega2, omega3, L1, L2, L3)

    % The 'center' vector describes where the center of the model will be.
    center = [0 0 0];
    
    % The model will rotate about this point in space.
    % WARNING: These values are correct ONLY if the dimensions are set to [30 10 10]
    centerOfMass = [2.7 0 0];  % TODO: Confirm center of mass.

    % Create a generic 3D model of the cube sat.
    p1 = createPatch(center);
    
    % This index variable 'i' will be used to iterate through the list of
    % omega values at different times.
    i = 1;
    
    % The following 4 variable are used for coloring.
    r = 0;
    g = 0;
    b = 0;
    state = 0;
    
    % This line represents the x axis of the body.  We will move it in the
    % same fashion as the body itself.
    xAxis = patch('faces', [1,2], 'vertices', [[-15 0 0]+center; [15 0 0]+center], 'edgecolor', 'r');
    
    %patch('faces', [1,2], 'vertices', [center + centerOfMass; 700 0 150], 'edgecolor', 'b');
    
    % Here is the main loop for applying different angular velocities to
    % the patch object.
    while true
       finalTime = datenum(clock + [0, 0, 0, 0, 0, 0.001]); 
       
       % rotAxis is the angular momentum with respect to the body's basis.
       rotAxis = [L1(i) L2(i) L3(i)];
       
       % rotAxisW is the angular momentum with respect to the world's basis.
       rotAxisW = toWorld(rotAxis, p1);
       
       % Begin coloring transitions.
       if mod(i, 1) == 1
           colorData = colorAngularMomentum(r, g, b, state);
           r = colorData(1);
           g = colorData(2);
           b = colorData(3);
           state = colorData(4);
           
           % Draw the presumed angular momentum vector.
           % WARNING: CURRENTLY INCORRECT.  (Angular momentum vector is not
           % constant.  Still trying to determine why.)
           patch('faces', [1,2], 'vertices', [center + centerOfMass; rotAxisW(1) rotAxisW(2) rotAxisW(3)], 'edgecolor', [r g b]);
       end
       % End coloring transitions.
       
       
       % The x, y, and z components of angular momentum are used to
       % determine the direction in which the model should turn, and how
       % fast it should turn.
       v1 = omega1(i)*0.01 * getXAxis(p1);
       v2 = omega2(i)*0.01 * getYAxis(p1);
       v3 = omega3(i)*0.01 * getZAxis(p1);
       
       % These component vectors are combined into one vector.
       v = v1+v2+v3;
       
       % The magnetude is calculated.
       mag = sqrt(v(1)*v(1) + v(2)*v(2) + v(3)*v(3));
       
       % Now the model and the line representing the x axis can both be
       % rotated using the calculated 'v' and 'mag' values.
       rotate(p1,v,mag,center + centerOfMass);
       rotate(xAxis,v,mag,center + centerOfMass);
       
       % Draw the resulting model and its axis to the screen.
       drawnow
       
       % This is a wait loop that will ensure equal time between loop iterations.
       while datenum(clock) < finalTime
            
       end
       
       % Incrementing our index variable to grab the next instance of the
       % omega values.
       i = i + 1;
    end
end

% Return a unit vector in the direction of the body's x axis.
function [pos] = getXAxis(p1)
    a = p1.Vertices(5,:);
    b = p1.Vertices(8,:);
    c = b - a;
    pos = c / sqrt(c(1)*c(1) + c(2)*c(2) + c(3)*c(3));
end

% Return a unit vector in the direction of the body's y axis.
function [pos] = getYAxis(p1)
    a = p1.Vertices(1,:);
    b = p1.Vertices(2,:);
    c = b - a;
    pos = c / sqrt(c(1)*c(1) + c(2)*c(2) + c(3)*c(3));
end

% Return a unit vector in the direction of the body's z axis.
function [pos] = getZAxis(p1)
    a = p1.Vertices(5,:);
    b = p1.Vertices(1,:);
    c = b - a;
    pos = c / sqrt(c(1)*c(1) + c(2)*c(2) + c(3)*c(3));
end

% Given a vector with respect to the model's basis (v1), compute the
% vector's representation with respect to the world's basis (v2).
function v2 = toWorld(v1, p)
    pX = getXAxis(p);
    pY = getYAxis(p);
    pZ = getZAxis(p);
    
    % Below, a transformation matrix 'T' is created using the basis of the
    % model.
    T = [pX(1) pY(1) pZ(1); pX(2) pY(2) pZ(2); pX(3) pY(3) pZ(3)];
    
    % Multiplying this matrix by a vector will perform the linear
    % transformation.
    v2 = T * transpose(v1);
end

function [res] = colorAngularMomentum(r, g, b, state)
   if state == 0
      r = r + 0.1;
      if r >= 1
          r = 1;
          state = state + 1;
      end
   end
   if state == 1
      g = g + 0.1;
      if g >= 1
          g = 1;
          state = state + 1;
      end
   end
   if state == 2
      r = r - 0.1;
      if r <= 0
          r = 0;
          state = state + 1;
      end
   end
   if state == 3
      b = b + 0.1;
      if b >= 1
          b = 1;
          state = state + 1;
      end
   end
   if state == 4
      g = g - 0.1;
      if g <= 0
          g = 0;
          state = state + 1;
      end
   end
   if state == 5
      r = r + 0.1;
      if r >= 1
          r = 1;
          state = state + 1;
      end
   end
   if state == 6
      b = b - 0.1;
      if b <= 0
          b = 0;
          state = 0;
      end
   end
   res = [r g b state];
end

function p1 = createPatch(center)

    dim = [30 10 10];

    lenX = dim(1) / 2;
    lenY = dim(2) / 2;
    lenZ = dim(3) / 2;
    
    %shape vertices
    a = [-lenX -lenY -lenZ;
        -lenX lenY -lenZ;
        lenX lenY -lenZ;
        lenX -lenY -lenZ;
        -lenX -lenY lenZ;
        -lenX lenY lenZ;
        lenX lenY lenZ;
        lenX -lenY lenZ;
        lenX lenY lenZ+dim(1);
        lenX -lenY lenZ+dim(1);
        lenX -lenY-dim(1) lenZ;
        lenX -lenY-dim(1) -lenZ;
        lenX lenY -lenZ-dim(1);
        lenX -lenY -lenZ-dim(1);
        lenX lenY+dim(1) lenZ;
        lenX lenY+dim(1) -lenZ];
    
    a = a + center;
    
    %shape faces (numbers in each row repersents vertices of face)
    b = [1 2 6 5;
        2 3 7 6;
        3 4 8 7;
        4 1 5 8;
        1 2 3 4;
        5 6 7 8;
        7 8 10 9;
        4 8 11 12;
        3 4 14 13;
        3 7 15 16];

    %create cube patch
    p1 = patch('faces',b,...
            'vertices',a,...
            'facecolor',[.5 .5 .5],...
            'edgecolor',[1,1,1],...
            'facealpha',0.5);
    
    view(2)
    maxVal = max(dim) + 10;
    axis([-maxVal maxVal -maxVal maxVal -maxVal maxVal])
    grid on
end

   