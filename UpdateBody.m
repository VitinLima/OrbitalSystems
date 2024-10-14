function Body = UpdateBody(Body, opt, opt_value)
  
  GM = 2.9591309705483544E-04; %au³/days²
  
  if strcmp(opt, 'time')
    Body.Time = opt_value;
    Body = UpdateByTime(Body);
  elseif strcmp(opt, 'trueanomaly')
    Body.TrueAnomaly = opt_value;
    Body = UpdateByTrueAnomaly(Body);
  elseif strcmp(opt, 'eccentricanomaly')
    Body.EccentricAnomaly = opt_value;
    Body = UpdateByEccentricAnomaly(Body);
  elseif strcmp(opt, 'meananomaly')
    Body.MeanAnomaly = opt_value;
    Body = UpdateByMeanAnomaly(Body);
  else
    disp('Option not valid');
    return;
  endif
  
  Body.Radius = Body.SemiLatus/(1 + Body.Excentricity*cosd(Body.TrueAnomaly));
  Body.Position = Body.RotMatrix*[Body.Radius*cosd(Body.TrueAnomaly) Body.Radius*sind(Body.TrueAnomaly) 0]';
  Body.Velocity = Body.Energy + GM/Body.Radius;
  Body.Velocity = sqrt(2*Body.Velocity);
end

function Body = UpdateByTime(Body)
  Body.TrueAnomaly = interp1(Body.OrbitTime, Body.OrbitTrueAnomaly, rem(Body.Time + Body.TimeReference, Body.Period) - Body.TimeReference);
  Body.EccentricAnomaly = interp1(Body.OrbitTime, Body.OrbitEccentricAnomaly, rem(Body.Time+Body.TimeReference, Body.Period) - Body.TimeReference);
  Body.MeanAnomaly = interp1(Body.OrbitTime, Body.OrbitMeanAnomaly, rem(Body.Time + Body.TimeReference, Body.Period) - Body.TimeReference);
end

function Body = UpdateByTrueAnomaly(Body)
  Body.Time = interp1(Body.OrbitTrueAnomaly, Body.OrbitTime, Body.TrueAnomaly);
  Body.EccentricAnomaly = interp1(Body.OrbitTrueAnomaly, Body.OrbitEccentricAnomaly, Body.TrueAnomaly);
  Body.MeanAnomaly = interp1(Body.OrbitTrueAnomaly, Body.OrbitMeanAnomaly, Body.TrueAnomaly);
end

function Body = UpdateByEccentricAnomaly(Body)
  Body.Time = interp1(Body.OrbitEccentricAnomaly, Body.OrbitTime, Body.EccentricAnomaly);
  Body.TrueAnomaly = interp1(Body.OrbitEccentricAnomaly, Body.OrbitTrueAnomaly, Body.EccentricAnomaly);
  Body.MeanAnomaly = interp1(Body.OrbitEccentricAnomaly, Body.OrbitMeanAnomaly, Body.EccentricAnomaly);
end

function Body = UpdateByMeanAnomaly(Body)
  Body.Time = interp1(Body.OrbitMeanAnomaly, Body.OrbitTime, rem(Body.MeanAnomaly + Body.MeanAnomalyReference, 360) - Body.MeanAnomalyReference);
  Body.TrueAnomaly = interp1(Body.OrbitMeanAnomaly, Body.OrbitTrueAnomaly, rem(Body.MeanAnomaly + Body.MeanAnomalyReference, 360) - Body.MeanAnomalyReference);
  Body.EccentricAnomaly = interp1(Body.OrbitMeanAnomaly, Body.OrbitEccentricAnomaly, rem(Body.MeanAnomaly + Body.MeanAnomalyReference, 360) - Body.MeanAnomalyReference);
end