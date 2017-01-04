%  ----------------------- READ ME -----------------------
% To use this program, 
    % 1.  Navigate to the 'Master_Files' folder
    % 2.  Run the script named 'EulerSolverVariables_Master_20161229.m'
    % 3.  Open the Simulink file named 'EulerSolver_Master_20170103.slx'
    % 4.  Run that Simulink file to generate the omega values
    % 5.  Navigate back to this script
    % 6.  Now, in the Command Window, enter the command:
    %     'Rotating_Model(w3.Data, w2.Data, w1.Data, L3.Data, L2.Data, L1.Data)'


function Rotating_Model(omega1, omega2, omega3, L1, L2, L3)
    %shape vertices
    a = [-4 -2 -2;
        -4 2 -2;
        4 2 -2;
        4 -2 -2;
        -4 -2 2;
        -4 2 2;
        4 2 2;
        4 -2 2];
    %shape faces (numbers in each row repersents vertices of face)
    b = [1 2 6 5;
        2 3 7 6;
        3 4 8 7;
        4 1 5 8;
        1 2 3 4;
        5 6 7 8];

    %create cube patch
    p1 = patch('faces',b,...
            'vertices',a,...
            'facecolor',[.5 .5 .5],...
            'edgecolor',[1,1,1],...
            'facealpha',0.5);
    
    view(2)
    axis([-5 5 -5 5 -5 5])
    grid on
    
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
    xAxis = patch('faces', [1,2], 'vertices', [getXAxis(p1)-[5 0 0]; getXAxis(p1)+[5 0 0]], 'edgecolor', 'r');
    
    % Here is the main loop for applying different angular velocities to
    % the patch object.
    while true
       finalTime = datenum(clock + [0, 0, 0, 0, 0, 0.001]); 
       
       % rotAxis is the angular momentum with respect to the body's basis.
       rotAxis = [L1(i) L2(i) L3(i)];
       
       % rotAxisW is the angular momentum with respect to the world's basis.
       rotAxisW = toWorld(rotAxis, p1);
       
       % Begin coloring transitions.
       if mod(i, 1) == 0
           colorData = colorAngularMomentum(r, g, b, state);
           r = colorData(1);
           g = colorData(2);
           b = colorData(3);
           state = colorData(4);
           
           % Draw the presumed angular momentum vector.
           % WARNING: CURRENTLY INCORRECT.  (Angular momentum vector is not
           % constant.  Still trying to determine why.)
           patch('faces', [1,2], 'vertices', [0 0 0; rotAxisW(1) rotAxisW(2) rotAxisW(3)], 'edgecolor', [r g b]);
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
       rotate(p1,v,mag,[0 0 0]);
       rotate(xAxis,v,mag,[0 0 0]);
       
       % This is a wait loop that will ensure equal time between loop iterations.
       while datenum(clock) < finalTime
            drawnow
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
    pos = (b - a) / 8;
end

% Return a unit vector in the direction of the body's y axis.
function [pos] = getYAxis(p1)
    a = p1.Vertices(1,:);
    b = p1.Vertices(2,:);
    pos = (b - a) / 4;
end

% Return a unit vector in the direction of the body's z axis.
function [pos] = getZAxis(p1)
    a = p1.Vertices(5,:);
    b = p1.Vertices(1,:);
    pos = (b - a) / 4;
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
      r = r + 0.01;
      if r >= 1
          r = 1;
          state = state + 1;
      end
   end
   if state == 1
      g = g + 0.01;
      if g >= 1
          g = 1;
          state = state + 1;
      end
   end
   if state == 2
      r = r - 0.01;
      if r <= 0
          r = 0;
          state = state + 1;
      end
   end
   if state == 3
      b = b + 0.01;
      if b >= 1
          b = 1;
          state = state + 1;
      end
   end
   if state == 4
      g = g - 0.01;
      if g <= 0
          g = 0;
          state = state + 1;
      end
   end
   if state == 5
      r = r + 0.01;
      if r >= 1
          r = 1;
          state = state + 1;
      end
   end
   if state == 6
      b = b - 0.01;
      if b <= 0
          b = 0;
          state = 0;
      end
   end
   res = [r g b state];
end


   