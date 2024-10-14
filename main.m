clear;
close all;
clc;

% Orbital elements are a collection of parameters that can describe a body's orbit:
%  Semi Major Axis
%  Excentricity
%  Inclination
%  Argument of Perifocus
%  Longitude of Ascending Node
%  Mean Anomaly Reference
% https://en.wikipedia.org/wiki/Orbital_elements

% InitializeBody takes the orbital parameters of the body and return a struct that can be passed to other functions
% InitializeBody: Name, Type ["body", "trajectory"], SemiMajorAxis, Excentricity, Inclination, ArgumentOfPerifocus, LongitudeOfAscendingNode, MeanAnomalyReference
% Or, for simplicity:
% InitializeBody: Name, Type ["body", "trajectory"], args

% https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html
args.SemiMajorAxis = 1.00000011;
args.Excentricity = 0.01671022;
args.Inclination = 0.00005;
args.ArgumentOfPerifocus = [];
args.LongitudeOfPerihelion = 102.94719;
args.LongitudeOfAscendingNode = -11.26064;
##args.MeanAnomalyReference = 0;
args.MeanAnomalyReference = 8.858042911360415E+01;
Earth = InitializeBody("Earth", "body", args);

Psyche = InitializeBody("Psyche", "body", 2.923542111961733, 0.337218354448035, 3.096519296601589, 229.0863985936534, 150.0369635049537, 6.709929643322734E+01);

% https://nssdc.gsfc.nasa.gov/planetary/factsheet/marsfact.html
args.SemiMajorAxis = 1.52366231;
args.Excentricity = 0.09341233;
args.Inclination = 1.85061;
args.ArgumentOfPerifocus = [];
args.LongitudeOfPerihelion = 336.04084;
args.LongitudeOfAscendingNode = 49.57854;
args.MeanAnomalyReference = 0;
Mars = InitializeBody("Mars", "body", args);

##ImagePrinter("System", [Earth, Mars, Psyche]);
##GifPrinter("System", [Earth, Mars, Psyche], 36);

##% Reinitialize Psyche with different orbital parameters
##Psyche = InitializeBody("Psyche", 'body', 2.923542111961733, 0.337218354448035, 0, 30, 0, 6.709929643322734E+01);
THpsyche = HohmannTrajectory("Transfer orbit", Earth, Psyche);

##ImagePrinter("EarthPsycheTransferSystem", [Earth, Psyche, THpsyche]); % Save image
ImageMaker("EarthPsycheTransferSystem", [Earth, Psyche, THpsyche]); % Display image
##GifPrinter("EarthPsycheTransferSystem", [Earth, Psyche, THpsyche], 360); % Save a gif animation

THmars = HohmannTrajectory("Transfer orbit", Earth, Mars);

##ImagePrinter("EarthMarsTransferSystem", [Earth, Mars, THmars]); % Save image
##ImageMaker("EarthMarsTransferSystem", [Earth, Mars, THmars]); % Display image
##GifPrinter("EarthMarsTransferSystem", [Earth, Mars, THmars], 36); % Save a gif animation
