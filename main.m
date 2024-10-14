clear;
close all;
clc;

% Orbital elements are a collection of parameters that can describe a body's orbit:
%  Semi Major Axis
%  Excentricity
%  Inclination
%  Argument of Perifocus or Longitude of Perihelion <- Not equivalent
%  Longitude of Ascending Node
%  Mean Anomaly Reference <- Current position of earth in its orbit
% https://en.wikipedia.org/wiki/Orbital_elements

% !!! Hohmann Transfer only works with bodies with the same orbital plane!!
% -> Same inclination
% -> Same Longitude of ascending node

% InitializeBody takes the orbital parameters of the body and return a struct that can be passed to other functions
% InitializeBody: Name, Type ["body", "trajectory"], SemiMajorAxis, Excentricity, Inclination, ArgumentOfPerifocus, LongitudeOfAscendingNode, MeanAnomalyReference
% Or, for simplicity:
% InitializeBody: Name, Type ["body", "trajectory"], args

% https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html
argsEarth.SemiMajorAxis = 1.00000011;
argsEarth.Excentricity = 0.01671022;
argsEarth.Inclination = 0.00005;
argsEarth.ArgumentOfPerifocus = [];
argsEarth.LongitudeOfPerihelion = 102.94719;
argsEarth.LongitudeOfAscendingNode = -11.26064;
argsEarth.MeanAnomalyReference = 8.858042911360415E+01;
Earth = InitializeBody("Earth", "body", argsEarth);

% https://en.wikipedia.org/wiki/16_Psyche
% https://www.jpl.nasa.gov/missions/psyche/
argsPsyche.SemiMajorAxis = 2.923542111961733;
argsPsyche.Excentricity = 0.337218354448035;
argsPsyche.Inclination = 3.096519296601589;
argsPsyche.ArgumentOfPerifocus = 229.0863985936534;
argsPsyche.LongitudeOfPerihelion = [];
argsPsyche.LongitudeOfAscendingNode = 150.0369635049537;
argsPsyche.MeanAnomalyReference = 6.709929643322734E+01;
Psyche = InitializeBody("Psyche", "body", 2.923542111961733, 0.337218354448035, 3.096519296601589, 229.0863985936534, 150.0369635049537, 6.709929643322734E+01);

% https://nssdc.gsfc.nasa.gov/planetary/factsheet/marsfact.html
argsMars.SemiMajorAxis = 1.52366231;
argsMars.Excentricity = 0.09341233;
argsMars.Inclination = 1.85061;
argsMars.ArgumentOfPerifocus = [];
argsMars.LongitudeOfPerihelion = 336.04084;
argsMars.LongitudeOfAscendingNode = 49.57854;
argsMars.MeanAnomalyReference = 0;
Mars = InitializeBody("Mars", "body", argsMars);

##THpsyche = HohmannTrajectory("Transfer orbit", Earth, Psyche);

##ImagePrinter("EarthMarsTransfer", [Earth, Psyche, THpsyche]); % Save image
##ImageMaker("EarthMarsTransfer", [Earth, Psyche, THpsyche]); % Display image
##GifPrinter("EarthMarsTransfer", [Earth, Psyche, THpsyche], 360); % Save a gif animation

THmars = HohmannTrajectory("Transfer orbit", Earth, Mars);

##ImagePrinter("EarthMarsTransferSystem", [Earth, Psyche, THmars]); % Save image
ImageMaker("EarthMarsTransferSystem", [Earth, Mars, THmars]); % Display image
##GifPrinter("EarthMarsTransferSystem", [Earth, Mars, THmars], 36); % Save a gif animation

disp("Earth to Mars Hohmann transfer:");
disp("Use 'fieldnames(THmars)' to see available data");
disp(["\tVelocity at perigee (Earth): ", num2str(THmars.VelocityAtPerigee), " au/d (Astronautical units per day)"]);
disp(["\tVelocity at Apogee: ", num2str(THmars.VelocityAtApogee), " au/d"]);

% The apogee is not necessarily the point of contact between the hohmann transfer
% and the target's orbit if the target's orbit is elliptical (excentricity != 0)
