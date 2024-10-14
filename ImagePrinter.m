function DeltaV = ImagePrinter(Title, Bodys)
  figure('visible', 'off');
  title(Title);
  axis([-5 3 -4 3 -1 1], 'equal');
  grid on;
  hold on;
  
  plot3(0,0,0,'*','color','b');
  lgd = {"Sun"};
  for i = 1:length(Bodys)
    plot3(Bodys(i).OrbitPosition(1,:),Bodys(i).OrbitPosition(2,:),Bodys(i).OrbitPosition(3,:),'tag',strjoin({Bodys(i).Tag, "OrbitPosition"},';'));
    lgd(end+1) = strjoin({Bodys(i).Name, " orbit e = ", num2str(Bodys(i).Excentricity), ", a = ", num2str(Bodys(i).SemiMajorAxis), " au"}, '');
    
    plot3(Bodys(i).OrbitPerigee(1),Bodys(i).OrbitPerigee(2),Bodys(i).OrbitPerigee(3),'*','tag',strjoin({Bodys(i).Tag, "OrbitPerigee"},';'));
    lgd(end+1) = strjoin({Bodys(i).Name, " perigee V = ", num2str(Bodys(i).VelocityAtPerigee)," au/d"},'');
    
    plot3(Bodys(i).OrbitApogee(1),Bodys(i).OrbitApogee(2),Bodys(i).OrbitApogee(3),'*','tag',strjoin({Bodys(i).Tag, "OrbitApogee"},';'));
    lgd(end+1) = strjoin({Bodys(i).Name, " apogee V = ", num2str(Bodys(i).VelocityAtApogee)," au/d"},'');
    
    if strcmp(Bodys(i).Type, 'body')
      plot3(Bodys(i).Position(1),Bodys(i).Position(2),Bodys(i).Position(3),'*','tag',strjoin({Bodys(i).Tag, "Position"},';'));
      lgd(end+1) = strjoin({Bodys(i).Name, ", true anomaly = ", num2str(Bodys(i).TrueAnomaly), " deg V = ", num2str(Bodys(i).Velocity)," au/d"},'');
    end 
  end
  legendHandle = legend(lgd, 'location', 'eastoutside');
  
  hold off;

  print(strjoin({Title,".png"},''));
end