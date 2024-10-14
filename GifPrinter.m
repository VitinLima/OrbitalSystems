function GifPrinter(Title, Bodys, N)
  function i = fBody(Bodys, Name)
    for i = 1:length(Bodys)
      if strcmp(Bodys(i).Name, Name)
        return;
      endif
    endfor
  endfunction

  WaitbarHandle = waitbar(0);
  Step = 360/N;
  Delay = 10/N;
  Resolution = '-S872,654';

  FigureHandle = figure('visible','off','position', [1 61 1366 634]);
  title(Title);
  axis('equal');
  grid on;
  hold on;
  view(45,25);

  plot3(0,0,0,'*','color','b', 'tag', 'sun');
  lgd = {"Sun"};

  for i = 1:length(Bodys)
    Bodys(i) = UpdateBody(Bodys(i), 'time', 0);

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

  hold off;

  filename = strjoin({Title, ".gif"},'');
  Im = print('-RGBImage', '-Sxsize,ySize', Resolution);
  waitbar(1/N);

  for j = 2:N
    for i = 1:length(Bodys)
      if Bodys(i).isUpdatable
        if strcmp(Bodys(i).Type, 'body')
          Bodys(i) = UpdateBody(Bodys(i), 'time', Bodys(i).Time + Step);
          set(findall(FigureHandle, 'tag',strjoin({Bodys(i).Tag, "Position"},';')), 'xdata', Bodys(i).Position(1), 'ydata', Bodys(i).Position(2), 'zdata', Bodys(i).Position(3));
        elseif strcmp(Bodys(i).Type, 'transfer_orbit')
          Bodys(i) = HohmannTrajectory(Bodys(i).Name, Bodys(fBody(Bodys, Bodys(i).Parents.SniperBody)), Bodys(fBody(Bodys, Bodys(i).Parents.TargetBody)));
          set(findall(FigureHandle, 'tag',strjoin({Bodys(i).Tag, "OrbitPosition"},';')), 'xdata', Bodys(i).OrbitPosition(1,:), 'ydata', Bodys(i).OrbitPosition(2,:), 'zdata', Bodys(i).OrbitPosition(3,:));
        end
      end
    end

    Im(:,:,:,end+1) = print('-RGBImage', '-Sxsize,ySize', Resolution);
    waitbar(j/N);
  endfor
  imwrite(Im, filename, 'WriteMode', "Overwrite", 'DelayTime', Delay);
  close(WaitbarHandle);
end
