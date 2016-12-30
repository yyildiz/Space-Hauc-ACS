function slide42(omega)
    %shape vertices
	a = [-2 -2 -2;
		-2 2 -2;
		6 2 -2;
		6 -2 -2;
		-2 -2 2;
		-2 2 2;
		6 2 2;
		6 -2 2];
	%shape faces (numbers in each row repersents vertices of face)
	b = [1 2 6 5;
		2 3 7 6;
		3 4 8 7;
		4 1 5 8;
		1 2 3 4;
		5 6 7 8];
    %unused omega variable
    w = [1 1 1; 
        2 2 2;
        3 3 3; 
        4 4 4; 
        5 5 5;
        6 6 6;];
	%creates the shape 
	p1 = patch('faces',b,...
		'vertices',a,...
		'facecolor',[.5 .5 .5],...
		'edgecolor',[1,1,1],...
		'facealpha',0.5);
	
	view(3)
	axis([-3 7 -3 5 -3 5])
	grid on
	
    
% 	line([1.5 1.5],[-2 2],[.5 .5],...
% 		'linewidth',3,...
% 		'color',[0,0,0]);
	i = 1;
   while true
    
       finalTime = datenum(clock + [0, 0, 0, 0, 0, 0.01]); 
       rotate(p1,[1,0,0],omega(20*i,2)*0.1,[0 0 0]);
       while datenum(clock) < finalTime
           
            drawnow
       end
       i = i + 1;
       disp(i);
   end
end