function Body = HohmannTrajectory(Name, SniperBody, TargetBody)
  GM = 2.9591309705483544E-04; %au^?/days^?

  Body.Name = Name;
  Body.Type = 'transfer_orbit';
  Body.Tag = strjoin({Body.Name, Body.Type},';');
  Body.Parents.SniperBody = SniperBody.Name;
  Body.Parents.TargetBody = TargetBody.Name;

  [Body.SemiMajorAxis, Body.Excentricity, Body.ArgumentOfPerifocus] = HohmannCalculations(SniperBody, TargetBody);
  Body.Inclination = 0; %deg
  Body.LongitudeOfAscendingNode = 0; %deg

  Body.SemiLatus = Body.SemiMajorAxis*(1 - Body.Excentricity^2); %au
  Body.SpecificAngularMomentum = sqrt(Body.SemiLatus/GM); %days^?/au^?
  Body.Energy = -GM/2/Body.SemiMajorAxis; %au^?/days^?
  Body.Period = 2*pi*sqrt(Body.SemiMajorAxis^3/GM);
  Body.Perigee = Body.SemiLatus/(1 + Body.Excentricity);
  Body.Apogee = Body.SemiLatus/(1 - Body.Excentricity);

  Body.VelocityAtPerigee = Body.Energy + GM/Body.SemiMajorAxis/(1 - Body.Excentricity);
  Body.VelocityAtPerigee = sqrt(2*Body.VelocityAtPerigee);
  Body.VelocityAtApogee = Body.Energy + GM/Body.SemiMajorAxis/(1 + Body.Excentricity);
  Body.VelocityAtApogee = sqrt(2*Body.VelocityAtApogee);

  Body.Tw = rotz(Body.ArgumentOfPerifocus);
  Body.Ti = rotx(Body.Inclination);
  Body.Tohm = rotz(Body.LongitudeOfAscendingNode);
  Body.RotMatrix = Body.Tohm*Body.Ti*Body.Tw;

  Body.OrbitTrueAnomaly = 0:360;
  Body.OrbitRadius = Body.SemiLatus./(1 + Body.Excentricity*cosd(Body.OrbitTrueAnomaly));
  Body.OrbitPosition = zeros(3,length(Body.OrbitTrueAnomaly)); %au
  Body.OrbitPosition(1,:) = Body.OrbitRadius;
  Body.OrbitEccentricAnomaly = atan2d(sqrt(1-Body.Excentricity^2)*sind(Body.OrbitTrueAnomaly), (1 - Body.Excentricity^2)*cosd(Body.OrbitTrueAnomaly) + Body.Excentricity*(1 + Body.Excentricity*cosd(Body.OrbitTrueAnomaly)));
  Body.OrbitEccentricAnomaly(Body.OrbitEccentricAnomaly < 0) += 360;
  Body.OrbitMeanAnomaly = Body.OrbitEccentricAnomaly - Body.Excentricity*sind(Body.OrbitEccentricAnomaly);
  Body.OrbitMeanAnomaly(Body.OrbitMeanAnomaly < 0) += 360;
  Body.OrbitTime = sqrt(Body.SemiMajorAxis^3/GM)*Body.OrbitMeanAnomaly*pi/180;
  for i = 1:length(Body.OrbitTrueAnomaly)
    Body.OrbitPosition(:,i) = Body.RotMatrix*rotz(Body.OrbitTrueAnomaly(i))*Body.OrbitPosition(:,i);
  end
  Body.OrbitPerigee = Body.RotMatrix*[Body.Perigee 0 0]'; %au
  Body.OrbitApogee = Body.RotMatrix*[-Body.Apogee 0 0]'; %au

  Body.OrbitEccentricAnomaly(end) = 360;
  Body.OrbitMeanAnomaly(end) = 360;
  Body.OrbitTime(end) = Body.Period;

  Body.TrueAnomaly = NaN;
  Body.EccentricAnomaly = NaN;
  Body.MeanAnomaly = NaN;
  Body.MeanAnomalyReference = NaN;
  Body.Time = NaN;
  Body.TimeReference = NaN;
  Body.Radius = NaN;
  Body.Position = NaN;
  Body.Velocity = NaN;
  Body.isUpdatable = true;
end
