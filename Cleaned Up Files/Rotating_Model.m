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

%create cube patch
p1 = patch('faces',b,...
		'vertices',a,...
		'facecolor',[.5 .5 .5],...
		'edgecolor',[1,1,1],...
		'facealpha',0.5);
	
	view(2)
	axis([-3 7 -3 5 -3 5])
	grid on