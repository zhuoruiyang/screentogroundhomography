clc;
close all;
clear all;

orggps = [-72.528881 42.39354]; 
referencegps1 = [-72.528994 42.393508];
referencegps2 = [-72.529096 42.393473];
referencegps3 = [-72.529126 42.393619];
referencegps4 = [-72.529172 42.393756];

%referencegps1 = [-72.529412 42.393265]; %%West Fire hydrant
%referencegps2 = [-72.529126 42.393593]; %%Center Cover
%referencegps3 = [-72.528703 42.393429]; %%Knowles East Corner
%referencegps4 = [-72.529255 42.393245]; %%Knowles northest West Corner
%referencegps5 = [-72.529272 42.393143]; %%Knowles southest West Corner
%referencegps6 = [-72.529255 42.393179]; %%Knowles middle WestCorner
%referencegps7 = [-72.529038 42.393717]; %%East Cover near Marston
%referencegps8 = [-72.528972 42.393375]; %%East Knowles Gate Corner
%referencegps9 = [-72.529013 42.39336]; %%West Knowles Gate Corner


rot=[cos(0.4178) sin(0.4178); -sin(0.4178) cos(0.4178)];

reference1loc = rot*(6371000*sin((referencegps1-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399)';
reference2loc = rot*(6371000*sin((referencegps2-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399)';
reference3loc = rot*(6371000*sin((referencegps3-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399)';
reference4loc = rot*(6371000*sin((referencegps4-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399)';

screencoord = [513, 599; 833, 585; 1217, 561; 1417, 677; 1227, 957]';
groundcoord = [0, 0; round(reference1loc(1)), round(reference1loc(2)); round(reference2loc(1)), round(reference2loc(2)); round(reference3loc(1)), round(reference3loc(2)); round(reference4loc(1)), round(reference4loc(2))]';

screencoord = [screencoord; ones(1, size(screencoord, 2))];
groundcoord = [groundcoord; ones(1, size(groundcoord, 2))];

H = homography2d(screencoord, groundcoord);  

estimatedgroundcoord=H*screencoord;

for i = 1:size(estimatedgroundcoord,2);
    estimatedgroundcoord(:,i) = estimatedgroundcoord(:,i)/estimatedgroundcoord(3,i);
end

% Victims on the picture
victimtagscreenlocincam = [1037, 621];
%victimtagscreenlocincam = [1150, 487; 1283, 617];
%victimtagscreenlocincam = [205, 461; 1445, 311; 1597, 447];

vicitmtaggroundlocfromcam = H*[victimtagscreenlocincam ones(size(victimtagscreenlocincam, 1),1)]';
for i = 1:size(vicitmtaggroundlocfromcam,2);
    vicitmtaggroundlocfromcam(:,i) = vicitmtaggroundlocfromcam(:,i)/vicitmtaggroundlocfromcam(3,i);
end

UpLeft = [42.393534  -72.529557];
Origin = [42.393283 , -72.529400];
DownRight = [42.393391 , -72.529058];
changerateverticallat = (UpLeft(1) - Origin(1))/100;
changerateverticallong = (UpLeft(2) - Origin(2))/100;
changeratehorizontallat = (DownRight(1) - Origin(1))/100;
changeratehorizontallong = (DownRight(2) - Origin(2))/100;

for i = 1: size(vicitmtaggroundlocfromcam, 2);
    victimgpsground(1, i) = orggps(2) + vicitmtaggroundlocfromcam(2, i)*changerateverticallat + vicitmtaggroundlocfromcam(1, i)*changeratehorizontallat;
    victimgpsground(2, i) = orggps(1) + vicitmtaggroundlocfromcam(2, i)*changerateverticallong + vicitmtaggroundlocfromcam(1, i)*changeratehorizontallong;
end








