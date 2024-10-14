function Body = InitializeBody(Name, Type, varargin)
  GM = 2.9591309705483544E-04; %au^?/days^?

  if nargin == 3
    SemiMajorAxis = cell2mat(varargin(1)).SemiMajorAxis;
    Excentricity = cell2mat(varargin(1)).Excentricity;
    Inclination = cell2mat(varargin(1)).Inclination;
    LongitudeOfAscendingNode = cell2mat(varargin(1)).LongitudeOfAscendingNode;
    MeanAnomalyReference = cell2mat(varargin(1)).MeanAnomalyReference;

    ArgumentOfPerifocus = cell2mat(varargin(1)).ArgumentOfPerifocus;
    LongitudeOfPerihelion = cell2mat(varargin(1)).LongitudeOfPerihelion;

    if isempty(ArgumentOfPerifocus)
      ArgumentOfPerifocus = LongitudeOfAscendingNode - LongitudeOfPerihelion;
    endif
  elseif nargin == 8
    SemiMajorAxis = cell2mat(varargin(1));
    Excentricity = cell2mat(varargin(2));
    Inclination = cell2mat(varargin(3));
    ArgumentOfPerifocus = cell2mat(varargin(4));
    LongitudeOfAscendingNode = cell2mat(varargin(5));
    MeanAnomalyReference = cell2mat(varargin(6));
  else
    error("Invalid number of arguments");
  end

  Body.Name = Name;
  Body.Type = Type;
  Body.Tag = strjoin({Body.Name, Body.Type},';');
  Body.Parents = NaN;

  Body.SemiMajorAxis = SemiMajorAxis; %au
  Body.Excentricity = Excentricity;
  Body.Inclination = Inclination; %deg
  Body.ArgumentOfPerifocus = ArgumentOfPerifocus; %deg
  Body.LongitudeOfAscendingNode = LongitudeOfAscendingNode; %deg

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

  if strcmp(Body.Type, 'body')
    Body.MeanAnomalyReference = MeanAnomalyReference; %deg
    Body.TimeReference = sqrt(Body.SemiMajorAxis^3/GM)*Body.MeanAnomalyReference*pi/180; %days
    Body.OrbitMeanAnomaly -= Body.MeanAnomalyReference;
    Body.OrbitTime -= Body.TimeReference;
    Body = UpdateBody(Body, 'time', 0);
    Body.isUpdatable = true;
  elseif strcmp(Body.Type, 'trajectory')
    Body.TrueAnomaly = NaN;
    Body.EccentricAnomaly = NaN;
    Body.MeanAnomaly = NaN;
    Body.MeanAnomalyReference = NaN;
    Body.Time = NaN;
    Body.TimeReference = NaN;
    Body.Radius = NaN;
    Body.Position = NaN;
    Body.Velocity = NaN;
    Body.isUpdatable = false;
  else
    disp("Type not valid");
  endif
end
