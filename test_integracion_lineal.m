%%
%%
% Obtención de la velocidad y posición por integración de primer orden a
% partir de la aceleración.
%
% Objetivo: comparar con la estimación al utilizar el filtro de kalman.

clc; clear all; close all;

tipo_trayectoria = 'Cuadrado';

% Cargo la aceleración y genero velocidad y posición
a = load(['IMUmovil-' tipo_trayectoria '-data.txt']);

%% Carga de la aceleración de la IMU Quieta
load('IMUQuieta');
a = ACCEL;

%%
bias_acel = 0.0223;
a = a - bias_acel;
a = 9.81 .* a; % 1g --> 9.81 m/s^2
a(:,2) = zeros(size(a,1),1); % anulo gravedad
%%
v = zeros(size(a)); % velocidad
p = zeros(size(a)); % posicion
%%
% Tomo 1 segundo como intervalo de muestreo pero... ¿debería sacarlo de los
% datos del GPS??
dt = 1;
N = size(a,1); % cantidad de muestras
%% Ecuación recursiva de la velocidad
% v(k) = v(k-1) + a(k-1) * dt + 0.5 * (a(k) - a(k-1)) * dt
% v(k) = v(k-1) + 0.5 * (a(k) + a(k-1)) * dt

%% Ecuación recursiva de la posición
% p(k) = p(k-1) + v(k) * dt + 0.5 * (v(k) - v(k-1)) * dt
% p(k) = p(k-1) + 0.5 * (v(k) + v(k-1)) * dt
% p(k) = p(k-1) + 0.5 * ((0.5 * (a(k) + a(k-1)) * dt) + (0.5 * (a(k-1) + a(k-2)) * dt)) * dt
% p(k) = p(k-1) + (0.25 * a(k) + 0.5 * a(k-1) + 0.25 * a(k-2)) * dt^2

% TODO Implementación ineficiente (hacerlo con matrices)

for k = 1:N
    if k<2
        v(k,:) = 0.5 * (a(k,:)) .* dt;
        p(k,:) = (0.25 * a(k,:)) .* dt^2;
    elseif k<3
        v(k,:) = 0.5 * (a(k,:) + a(k-1,:)) .* dt;
        p(k,:) = p(k-1,:) + (0.25 * a(k,:) + 0.5 * a(k-1,:)) .* dt^2;
    else
        v(k,:) = 0.5 * (a(k,:) + a(k-1,:)) .* dt;
        p(k,:) = p(k-1,:) + (0.25 * a(k,:) + 0.5 * a(k-1,:) + 0.25 * a(k-2,:)) * dt^2;
    end
end

%%
subplot(1,2,1)
plot(1:N,p(:,1), 1:N,p(:,2), 1:N,p(:,3))
legend('x','y','z')
subplot(1,2,2)
plot3(p(:,1), p(:,2), p(:,3))

