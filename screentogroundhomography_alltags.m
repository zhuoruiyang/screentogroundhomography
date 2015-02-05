%using all tags is much much better!!!!

%use 14:30:00 as 0 time
%29.9915 fps, 0.34s shift in 1200s, negligible

%can also use intercamera homography!!


%VID_20130115_143727

%video are calibrated to 100x100, so rotate gps?



%for a tag, there are large readings occationally with no reason, so use
%all tags, but don't take anverage, take min,

%loss rate is not right because window is not right should only do i-1:i,
%two seconds, still, not much loss


NumofRefTags=11;
orggps=[-72.529399 42.393284 ];
cam1gps=[-72.528947 42.393350];  % VID_20130115_143727
cam2gps=[-72.529278 42.393171 ]; %VID_20130115_143820
cam3gps=[-72.528708 42.393679];  %VID_20130115_143819


linep1gps=[-72.529191 42.393270];
linep2gps=[-72.528947 42.39335];

6371000*sin((cam2gps-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399
%atan(y/x) for line= 0.4178
%counter clock rotate gps coord

rot=[cos(0.4178) sin(0.4178); -sin(0.4178) cos(0.4178)];

cam1loc=rot*(6371000*sin((cam1gps-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399)'
cam2loc=rot*(6371000*sin((cam2gps-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399)'
cam3loc=rot*(6371000*sin((cam3gps-orggps)/180*pi).*[cos(42.393284/180*pi) 1 ]*3.2808399)'

save camloc cam1loc cam2loc cam3loc
%cam not on the ground, doesn't matter,only if cam is upright. otherwise,
%target y and depth will affect x on the screen!!! don't know if it is
%still linear
%for simplicity, use homography
%when cam is close to the ground, homography not accrate in terms of depth,
%sensitive to foot loc, so you project point from homography to get a line
%test the effect in simulation/game?

%you can think that there is a virtual horizon for the camera, when cam is
%rotated, the line is rotated. so degree on the ground plan will depend on
%projection to that horizontal line!! which depends on both screen x and y
%so no way you can get deg from interpolating x!!!

fps=6
screencoord=[350, 178; 23, 248; 686, 213; 402, 320; 1002, 431; 1155, 260]';
groundcoord=[0, 100; 0, 50; 50, 100; 50, 50; 100, 50; 100, 100]';



screencoord=[screencoord; ones(1,size(screencoord,2))];
groundcoord=[groundcoord; ones(1,size(groundcoord,2))];

%H - the 3x3 homography such that x2 = H*x1
H = homography2d(screencoord, groundcoord);  

estimatedgroundcoord=H*screencoord;




for i=1:size(estimatedgroundcoord,2);
    estimatedgroundcoord(:,i)=estimatedgroundcoord(:,i)/estimatedgroundcoord(3,i);
end
estimatedgroundcoord
groundcoord


reftagscreenlocincam1=[1080 267
    736 459
    826 303
    259 501
    507 331
    611 275
    606 219
    172 297
    -9999 -9999
    337 203
    -9999 -9999];

    
reftaggroundlocfromcam1=H*[reftagscreenlocincam1 ones(11,1)]';
for i=1:size(reftaggroundlocfromcam1,2);
    reftaggroundlocfromcam1(:,i)=reftaggroundlocfromcam1(:,i)/reftaggroundlocfromcam1(3,i);
end
reftaggroundlocfromcam1


fid = fopen('VID_20130115_143727.txt', 'r');
line = fgetl(fid);
recordindex=1

while 1
    if line==-1
        break
    end  
    if strcmp(line(1:4), ['f','o','o','t'])==0
        line = fgetl(fid);
        continue;
    end
    temp1=findstr(line,':');
    temp2=findstr(line,',');
    temp3=findstr(line,';');
    temp4=[line(temp1(1)+1:temp2(1)-1),',', line(temp2(1)+2:temp2(2)-1),',' , line(temp2(2)+2:temp2(3)-1),',' line(temp2(3)+2:temp3(1)-1)];
   
    %video at 5fps, starts at 14:37:27, use 14:30:00 as 0 time
    videorecord(recordindex,1)=sscanf(line(temp1(1)+1:temp2(1)-1),'%d')/fps+447; %time
    videorecord(recordindex,2)=sscanf(line(temp2(1)+2:temp2(2)-1),'%d'); %tracklet id
    videorecord(recordindex,3)=sscanf(line(temp2(2)+2:temp2(3)-1),'%d'); %screen x
    videorecord(recordindex,4)=sscanf(line(temp2(3)+1:temp3(1)-1),'%d'); %screen y
    videorecord(recordindex,5)=1; %cam id
    x1=[videorecord(recordindex,3);videorecord(recordindex,4);1];
    x2=H*x1;
    x2=x2/x2(3);
    videorecord(recordindex,6)=x2(1); %ground x
    videorecord(recordindex,7)=x2(2); %ground y

    recordindex=recordindex+1;
    line = fgetl(fid);

end


%VID_20130115_143820
screencoord=[423,264; 340,381; 848, 254; 954, 361; 1142, 308; 1053, 493; 122, 695 ; 686, 697  ]';
groundcoord=[0, 100; 0, 50; 50, 100; 50, 50; 75, 75; 50, 25; 0, 0; 25,0]';

screencoord=[screencoord; ones(1,size(screencoord,2))];
groundcoord=[groundcoord; ones(1,size(groundcoord,2))];

%H - the 3x3 homography such that x2 = H*x1
H = homography2d(screencoord, groundcoord); 
estimatedgroundcoord=H*screencoord;

for i=1:size(estimatedgroundcoord,2);
    estimatedgroundcoord(:,i)=estimatedgroundcoord(:,i)/estimatedgroundcoord(3,i);
end
estimatedgroundcoord
groundcoord


reftagscreenlocincam2=[-9999 -9999
    -9999 -9999
   -9999 -9999
    -9999 -9999
    1058 378
    964 318
    796 272
    669 401
    511 606
    505 289
    385 411];

reftaggroundlocfromcam2=H*[reftagscreenlocincam2 ones(11,1)]';
for i=1:size(reftaggroundlocfromcam2,2);
    reftaggroundlocfromcam2(:,i)=reftaggroundlocfromcam2(:,i)/reftaggroundlocfromcam2(3,i);
end
reftaggroundlocfromcam2

fid = fopen('VID_20130115_143820.txt', 'r');
line = fgetl(fid);

while 1
    if line==-1
        break
    end  
    if strcmp(line(1:4), ['f','o','o','t'])==0
        line = fgetl(fid);
        continue;
    end
    temp1=findstr(line,':');
    temp2=findstr(line,',');
    temp3=findstr(line,';');
    temp4=[line(temp1(1)+1:temp2(1)-1),',', line(temp2(1)+2:temp2(2)-1),',' , line(temp2(2)+2:temp2(3)-1),',' line(temp2(3)+2:temp3(1)-1)];
   
    %video at 5fps, starts at 14:38:20, use 14:30:00 as 0 time
    videorecord(recordindex,1)=sscanf(line(temp1(1)+1:temp2(1)-1),'%d')/fps+500; %time
    videorecord(recordindex,2)=sscanf(line(temp2(1)+2:temp2(2)-1),'%d'); %tracklet id
    videorecord(recordindex,3)=sscanf(line(temp2(2)+2:temp2(3)-1),'%d'); %x
    videorecord(recordindex,4)=sscanf(line(temp2(3)+1:temp3(1)-1),'%d'); %y
    videorecord(recordindex,5)=2; %cam id

    x1=[videorecord(recordindex,3);videorecord(recordindex,4);1];
    x2=H*x1;
    x2=x2/x2(3);
    videorecord(recordindex,6)=x2(1);
    videorecord(recordindex,7)=x2(2);

    recordindex=recordindex+1;
    line = fgetl(fid);

end



%VID_20130115_143819
%ground not flat, manually set gound plane, you know camera upright, so y
%must be the same for some coord?
%yes, after this adjustment, residual error is much smaller, i.e. ref
%points closer to ref plane. now ground height will only cause extention
%alone camera center
screencoord=[447, 185; 960 186;168,152;748,168-16;472,162-10]';
groundcoord=[100,50;100 100;0,0;0,100;0,50]';

screencoord=[screencoord; ones(1,size(screencoord,2))];
groundcoord=[groundcoord; ones(1,size(groundcoord,2))];

%H - the 3x3 homography such that x2 = H*x1
H = homography2d(screencoord, groundcoord); 
estimatedgroundcoord=H*screencoord;
for i=1:size(estimatedgroundcoord,2);
    estimatedgroundcoord(:,i)=estimatedgroundcoord(:,i)/estimatedgroundcoord(3,i);
end
estimatedgroundcoord
groundcoord


fid = fopen('VID_20130115_143819.txt', 'r');
line = fgetl(fid);

while 1
    if line==-1
        break
    end  
    %use target blob foot loc
    if strcmp(line(7:10),  ['f','o','o','t'])==0
        line = fgetl(fid);
        continue;
    end
    temp1=findstr(line,':');
    temp2=findstr(line,',');
    temp3=findstr(line,';');
    temp4=[line(temp1(1)+1:temp2(1)-1),',', line(temp2(1)+2:temp2(2)-1),',' , line(temp2(2)+2:temp2(3)-1),',' line(temp2(3)+2:temp3(1)-1)];
   
    %video at 5fps, starts at 14:38:19, use 14:30:00 as 0 time
    videorecord(recordindex,1)=sscanf(line(temp1(1)+1:temp2(1)-1),'%d')/fps+499; %time
    videorecord(recordindex,2)=sscanf(line(temp2(1)+2:temp2(2)-1),'%d'); %tracklet id
    videorecord(recordindex,3)=sscanf(line(temp2(2)+2:temp2(3)-1),'%d'); %x
    videorecord(recordindex,4)=sscanf(line(temp2(3)+1:temp3(1)-1),'%d'); %y
    videorecord(recordindex,5)=3; %cam id

    x1=[videorecord(recordindex,3);videorecord(recordindex,4);1];
    x2=H*x1;
    x2=x2/x2(3);
    videorecord(recordindex,6)=x2(1);
    videorecord(recordindex,7)=x2(2);

    recordindex=recordindex+1;
    line = fgetl(fid);

end





save videorecord videorecord

%can't do extrapolation, too sensitive to local trend, cubic interpo is not
%cubic matching!!
%also, rule out small tracklet here?
load videorecord
interpolatedvideorecord=[];
for camid=1:2
    v1=videorecord(find(videorecord(:,5)==camid),:);
    
    idmax=max(videorecord(:,2));
    for ididx=0:idmax %id start from 0!
        trackletidx=find(v1(:,2)==ididx);
        tracklet=v1(trackletidx,:);
        valididx=find(tracklet(:, 3)~=-1);
        %only interpolate between min and max valididx
        %only interpolate ground loc, leave screen as raw so you can process
        %later. set invalid ground loc to -99999
        
        
        %use movement to filter out clutter
        %why (:,3)=-1 and (:,6)=-99999 idxs not the same? because this?
        if length(valididx)<2
            v1(trackletidx,6)=-99999;
            v1(trackletidx,7)=-99999;
            continue;
        end
        
        
        %plot(tracklet(:, 1), tracklet(:, 6), '.r');
        %hold on
        %no sharp turns, so 2s moving anverage, can help short tracklets. at
        %most 1s lag, 5 feet walking speed. still, rf is too inaccurate.
        %this is mostly used to help smooth video visualization
        tracklet(valididx(1):valididx(end), 6) = smooth(interp1(tracklet(valididx, 1), tracklet(valididx, 6) ,tracklet(valididx(1):valididx(end), 1), 'cubic'),11);
        tracklet(valididx(1):valididx(end), 7) = smooth(interp1(tracklet(valididx, 1), tracklet(valididx, 7) ,tracklet(valididx(1):valididx(end), 1), 'cubic'),11);
        
         
        
        tracklet(1:valididx(1)-1, 6)=-99999;
        tracklet(valididx(end)+1:end,6)=-99999;
        tracklet(1:valididx(1)-1, 7)=-99999;
        tracklet(valididx(end)+1:end,7)=-99999;
        %plot(tracklet(valididx(1):valididx(end), 1), tracklet(valididx(1):valididx(end), 6), '.r');
        %hold on
        %plot(tracklet(valididx(1):valididx(end), 1), smooth(tracklet(valididx(1):valididx(end), 6)+10,11), '.g');
        %hold off
        
        
        tracklet(valididx(1):valididx(end), 3) = smooth(interp1(tracklet(valididx, 1), tracklet(valididx, 3) ,tracklet(valididx(1):valididx(end), 1), 'cubic'),11);
        tracklet(valididx(1):valididx(end), 4) = smooth(interp1(tracklet(valididx, 1), tracklet(valididx, 4) ,tracklet(valididx(1):valididx(end), 1), 'cubic'),11);
        
        
        v1(trackletidx,:)=tracklet(:, :);
        
    end
    interpolatedvideorecord=[interpolatedvideorecord; v1];
end


%for cam 3, no need for interpolation, but should remove end of tracklet if
%y jumps, loss track as two blob merge
for camid=3:3
    v1=videorecord(find(videorecord(:,5)==camid),:);
    
    idmax=max(videorecord(:,2));
    for ididx=0:idmax %id start from 0!
        trackletidx=find(v1(:,2)==ididx);
        tracklet=v1(trackletidx,:);
        
        for timeidx=max(size(tracklet,1)-10,1):size(tracklet,1)-1
            if abs(tracklet(timeidx+1, 4)-tracklet(timeidx, 4))>20
                break;
            end
        end
        
        tracklet(timeidx:end, 3)=-99999;
        tracklet(timeidx:end, 4)=-99999;
        tracklet(timeidx:end, 6)=-99999;
        tracklet(timeidx:end, 7)=-99999;
        
        
        
        v1(trackletidx,:)=tracklet(:, :);
        
    end
    interpolatedvideorecord=[interpolatedvideorecord; v1];
end



save interpolatedvideorecord interpolatedvideorecord


fid = fopen('VID_20130115_143727filtered.txt', 'w');
for i=1:size(interpolatedvideorecord,1)
    if interpolatedvideorecord(i, 5)~=1
        continue
    end
    fprintf(fid,'%d %d %f %f %f %f\n', round((interpolatedvideorecord(i,1)-447)*fps), interpolatedvideorecord(i,2), interpolatedvideorecord(i,3), interpolatedvideorecord(i,4) , interpolatedvideorecord(i,6)*4, 400-4*interpolatedvideorecord(i,7) );
    
end


fid = fopen('VID_20130115_143820filtered.txt', 'w');
for i=1:size(interpolatedvideorecord,1)
    if interpolatedvideorecord(i, 5)~=2
        continue
    end
    fprintf(fid,'%d %d %f %f %f %f\n', round((interpolatedvideorecord(i,1)-500)*fps), interpolatedvideorecord(i,2), interpolatedvideorecord(i,3), interpolatedvideorecord(i,4), interpolatedvideorecord(i,6)*4, 400-4*interpolatedvideorecord(i,7) );
    
end

fid = fopen('VID_20130115_143819filtered.txt', 'w');
for i=1:size(interpolatedvideorecord,1)
    if interpolatedvideorecord(i, 5)~=3
        continue
    end
    fprintf(fid,'%d %d %f %f %f %f\n', round((interpolatedvideorecord(i,1)-499)*fps), interpolatedvideorecord(i,2), interpolatedvideorecord(i,3), interpolatedvideorecord(i,4), interpolatedvideorecord(i,6)*4, 400-4*interpolatedvideorecord(i,7) );
    
end

load rssireading
for i=1:size(rssireading, 1)
    rssireading(i,9)=(rssireading(i,5)-30)*60+rssireading(i,6);
end
save rssireading rssireading

%plot distance to rssi, need ground truth!
load groundtruth


%xunyi james zhuorui guilin jun ye
readerids=[14 31 38 2 18 15]
tagids=[ 222229  00104391 00222269 222277 222241 00222248];

%each row is one person
tagidstotal=[ 00222229 00222230 00222232 00222233 00195946 00222231;
00222271 02222178 00104392 00104391 00195966 00195948;
00195928 00222269 00222266 00195926 00195963 00195920;
00222277 00195953 00195938 00222237 00195939 00222264;
00222241 00222238 00222242 00222240 00222228 00222239;
00104394 00195943 00222248 00222265 00104393 00195964;
];





  


NumofIDTarget=6

%measurement betwen paramedic reader and tag
MeasuredSignalStrengthPair=zeros(1000,NumofIDTarget,NumofIDTarget);

%if you use all 6 tag, loss rate will change.
%now performance is not good enough, it could be 1. noise 2. ill
%configuration.
%you need to improve rf measurement to see why

%the distance-rssi curve is obtained with video-fixed reader.
%now that both target loc from video, noise should be larger!



%starts at 14:38? run for 8 min
for i=480:960
    i
    for j=1:NumofIDTarget
        for l=1:NumofIDTarget %measurement is not symmetric, but let it be for now
            
            idxs=find((rssireading(:,1)== readerids(j))&(ismember(rssireading(:,2),tagidstotal(l,:)))&(rssireading(:,9)>=i-1)&(rssireading(:,9)<=i));
            
                  
            if length(idxs)>0
                MeasuredSignalStrengthPair(i,j,l)=min(rssireading(idxs,3));
            else
                MeasuredSignalStrengthPair(i,j,l)=105;
            end
        end
    end
    
    
end


reftagidtotal=[      222254      195924      222252      195965      222253      195944
      222262      195958      195952      222256      195954      222267
      222246      222247      222244      222245      195949      222243
      222276      222272      222268      222273      222258      222275
      222260       20587       20804       20802       20577      195937
      104397      195956      222235      222234      222249      222236
      195934      222259      222274      222263      195957      195945
      222270      195931      222261      195960      195955      195947
      195961      195951      104389      222255      104398      195917
      195932      222257      104390      222180      195918      195959
      195922      195925      195930      195935      195929      222250];
  
MeasuredSignalStrength=zeros(1000,NumofIDTarget,NumofRefTags);

%starts at 14:38? run for 8 min
for i=480:960
    i
    for j=1:NumofIDTarget
        for l=1:NumofRefTags %measurement is not symmetric, but let it be for now
            
            idxs=find((rssireading(:,1)== readerids(j))&(ismember(rssireading(:,2), reftagidtotal(l,:)))&(rssireading(:,9)>=i-1)&(rssireading(:,9)<=i));
                    
            if length(idxs)>0
                MeasuredSignalStrength(i,j,l)=min(rssireading(idxs,3));
            else
                MeasuredSignalStrength(i,j,l)=105;
            end
        end
    end
    
    
end

save measurements_alltags

plotdataidx=1;
measuredDistance=zeros(100000,1);
rssirecord=zeros(100000,1);

camid=1;
%need dual loop trackletid, 
interpolatedvideorecord=interpolatedvideorecord(find(interpolatedvideorecord(:, 6)~=-99999),:);
interpolatedvideorecord=interpolatedvideorecord(find(interpolatedvideorecord(:, 5)==camid),:);
interpolatedvideorecord=interpolatedvideorecord(find(interpolatedvideorecord(:, 1)>480),:);
interpolatedvideorecord=interpolatedvideorecord(find(interpolatedvideorecord(:, 1)<960),:);
for timeidx=480:960
    timeidx
    idxss=find(interpolatedvideorecord(:,1)==timeidx);
    if length(idxss)==0
                continue;
            end
for ididx1=0:max(interpolatedvideorecord(:,2))
    for ididx2=ididx1+1:max(interpolatedvideorecord(:,2))
        
        
        
            idxs=find(interpolatedvideorecord(idxss,2)==ididx1);
            if length(idxs)==0
                continue;
            end
            loc1=interpolatedvideorecord(idxss(idxs(1)),[6 7]);
            
            
            idxs=find(interpolatedvideorecord(idxss,2)==ididx2);
            if length(idxs)==0
                continue;
            end
            loc2=interpolatedvideorecord(idxss(idxs(1)),[6 7]);
            
            idxs=find(groundtruth(:,1)==ididx1+1&groundtruth(:,3)==camid);
            if length(idxs)==0
                continue;
            end
            trueid1=groundtruth(idxs,2);
            
            
            idxs=find(groundtruth(:,1)==ididx2+1&groundtruth(:,3)==camid);
            if length(idxs)==0
                continue;
            end
            trueid2=groundtruth(idxs,2);
            
            if trueid1>6||trueid2>6
                continue;
            end
            measuredDistance(plotdataidx)=norm(loc1-loc2,'fro');
            rssirecord(plotdataidx)=MeasuredSignalStrengthPair(timeidx, trueid1, trueid2);
            
                    
            plotdataidx=plotdataidx+1;
            
            
        end
    end
end

 ReaderLocation=[ 94.7797   87.7428   79.3606   68.0702   60.8703   58.6580   44.8941   29.0020  16.8   11.1519  5
            94.6380   37.5920   71.6740   19.0069   51.7065   70.9171   92.1894   45.2533  8.8   84.6832  41.5]';
        
% for timeidx=480:960
%     
%     idxss=find(interpolatedvideorecord(:,1)==timeidx);
%     if length(idxss)==0
%         continue;
%     end
%     for ididx1=0:max(interpolatedvideorecord(:,2))
%         for ididx2=1:11
%             
%             
%             
%             idxs=find(interpolatedvideorecord(idxss,2)==ididx1);
%             if length(idxs)==0
%                 continue;
%             end
%             loc1=interpolatedvideorecord(idxss(idxs(1)),[6 7]);
%             
%             
%             
%             loc2=ReaderLocation(ididx2,:);
%             
%             idxs=find(groundtruth(:,1)==ididx1+1&groundtruth(:,3)==camid);
%             if length(idxs)==0
%                 continue;
%             end
%             trueid1=groundtruth(idxs,2);
%             
%             
%             
%             if trueid1>6
%                 continue;
%             end
%             measuredDistance(plotdataidx)=norm(loc1-loc2,'fro');
%             rssirecord(plotdataidx)=MeasuredSignalStrength(timeidx, trueid1, ididx2);
%             plotdataidx=plotdataidx+1;
%             
%         end
%     end
% end

rssirecord=rssirecord(find(measuredDistance>0));
measuredDistance=measuredDistance(find(measuredDistance>0));
    
idxs=find(rssirecord~=105)
p=polyfit(log(measuredDistance(idxs)+1), rssirecord(idxs), 2)
figure
plot(measuredDistance(idxs),rssirecord(idxs),'.')
hold on
plot([1:140],polyval(p,log([1:140]+1)),'.g');
legend('individual measurement','2nd order polynomial fitting')
plot(measuredDistance, rssirecord, '.');
%not very good fit after 100

fiterror=rssirecord-polyval(p,log(measuredDistance+1));
figure
hist(fiterror);
var(fiterror); %around %38. 

%some tracklets mixes two targets, causing outliers in the plot!!

%plot beacon loss
lossrate=zeros(14,1);
for distance=1:14
    rssirecordnow=rssirecord(measuredDistance>(distance-1)&measuredDistance<distance);
    lossrate(distance)=length(find(rssirecordnow==105))/length(rssirecordnow);
end


for i=1:140
    %plot(i,14.1129*(log(i+0.1)-3.555)+88,'.r');
    %plot(i,14.1129*(log(i+0.1)-3.555)+88-20,'.r');
    %plot(i,polyval(p,log(i+1))-10,'.g');
    plot(i,polyval(p,log(i+1)),'.g');
    xlabel('distance in feet')
    ylabel('signal strength in dB')
    hold on
end

%cam2 -1.2273   20.1077   21.8166
%cam1 0.1893   10.5302   38.6134

%different tag on the same person should have same hist?
tagidstotal=[ 00222229 00222230 00222232 00222233 00195946 00222231;
00222271 02222178 00104392 00104391 00195966 00195948;
00195928 00222269 00222266 00195926 00195963 00195920;
00222277 00195953 00195938 00222237 00195939 00222264;
00222241 00222238 00222242 00222240 00222228 00222239;
00104394 00195943 00222248 00222265 00104393 00195964;
];


%check curve for tags on the ground, seems to be off a lot!

  
    

% id=5
%     for i=1:6
%         hist(rssireading(find(rssireading(:,2)==tagidstotal(id,i)),3));
%         figure
%     end

%check pairwise symetric, tested ok, so readers are synced

% close all
% id=2
%     for i=1:6
%         hist(rssireading(find(rssireading(:,2)==reftagidtotal(id,i)),3));
%         figure
%     end


% dataidx=1
% diff=zeros(480*max(interpolatedvideorecord(:,2))*max(interpolatedvideorecord(:,2)),1);
% for timeidx=480:960
%     
% for ididx1=0:max(interpolatedvideorecord(:,2))
%     for ididx2=ididx1+1:max(interpolatedvideorecord(:,2))
%         diff(dataidx)=abs(MeasuredSignalStrengthPair(timeidx, trueid1, trueid2)-MeasuredSignalStrengthPair(timeidx, trueid2, trueid1));
%         dataidx=dataidx+1;
%     end
% end
% end
% figure
% hist(diff);


