%% Diffusion Simulation
% This is a simple script that calculates the evolution of particle
% concentration in one dimension as a function of time. Then, it outputs a
% GIF file that shows the evolution (not in real time). Initially, all of
% the particles are located at the origin (x = 0). The x-position is
% plotted along the x-axis while the particle concentration is plotted
% along the y-axis.

%% Clear Console

clc
clf
clear all
close all

%% Simulation Parameters
% These are the parameters that you can change in the simulation.
% num_pts is the number of spacial data points that are used.
% D is the mass diffusivity constant (in m^2/s).
% max_time is the end time of the simulation (in seconds). For example, a
% max_time of 1000 means that 1000 seconds are simulated and plotted. It
% does NOT mean that the final GIF image will be 1000 seconds long!

num_pts = 1000;
D = 10;
max_time = 1e-4;

%% Check Values
% A series of checks to make sure that the parameters make sense.

if num_pts < 0
    error('The variable num_pts must be greater than zero.');
end

if mod(num_pts,2) == 1
    num_pts = num_pts + 1;
end

if D < 0
    error('The  variable D must be greater than zero.');
end

%% Heat Kernel
% Calculates the concentration of particles at some position x and some
% time t given an initial delta function concentration.

concentration = @(x, t) exp(-x^2/(4*D*t))/sqrt(4*pi*D*t);

%% Initialize Arrays
% These arrays will contain the final plot information.

particle_concentrations = zeros(1,num_pts);
positions = zeros(1,num_pts);

for i = 1:num_pts
    positions(1,i) = (i - num_pts/2)/1000;
end

%% Create Animation
% This loop will create a short animation showing how the particles will
% evolve in time. This is not in real time! Normally, this process would
% take place in a blink of an eye, so it is slowed down so that you can see
% it.

for i = 1:100
    for j = 1:num_pts
      time = max_time*i/100;
      particle_concentrations(1,j) = concentration(positions(j), time);
    end
    clf
    plot(positions, particle_concentrations)
    set(gca,'FontSize',16);
    axis([positions(1) positions(num_pts) 0 20])
    title('Concentration vs. Position and Time')
    xlabel('Position [m]')
    ylabel('Particle Concentration [number/m]')
    f = getframe;
    im = frame2im(f);
    [imind,cm] = rgb2ind(im,256);
    outfile = 'diffusion.gif';
    if i==1
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf);
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'writemode','append');
    end
end
