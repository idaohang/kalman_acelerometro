%path(path,'./geodetic');
clear all;
IMUData = fopen('IMUQuieta.txt','r');

Data = textscan(IMUData,'%s');%,'Delimiter', '\n');

N = size(Data{1},1);
% COORD = zeros(N*0.5,2);
COORD_DEG = zeros(N*0.5,2);
COORD_KM = zeros(N*0.5,2);
ACCEL = zeros(N*0.5,3);

for i=1:N*0.5
    % Ver el Mapping Toolbox, las coordenadas vienen en grados
    coord_tmp = strsplit(Data{1}{2*i-1},',');
    % La latitud viene xxmm.dddd (xx=degrees, mm=minutes, dddd=decimal of
    % minutes)
    aux = char(coord_tmp(4));
    COORD_DEG(i,1) = dm2degrees([str2double(aux(1:2)) str2double(aux(3:end))]);
    if strcmp(coord_tmp(5),'S')
        COORD_DEG(i,1) = -COORD_DEG(i,1);
    end
    % La longitud viene yyymm.dddd (yyy=degrees, mm=minutes, dddd=decimal of
    % minutes)
    aux = char(coord_tmp(6));
    COORD_DEG(i,2) = dm2degrees([str2double(aux(1:3)) str2double(aux(4:end))]);
    if strcmp(coord_tmp(7),'W')
        COORD_DEG(i,2) = -COORD_DEG(i,2);
    end
    %Coordenadas en km
    COORD_KM(i,1) = deg2km(COORD_DEG(i,1));
    COORD_KM(i,2) = deg2km(COORD_DEG(i,2));
    accel_tmp = strsplit(Data{1}{2*i},',');
    ACCEL(i,1) = str2double(accel_tmp(1));
    ACCEL(i,2) = str2double(accel_tmp(2));
    ACCEL(i,3) = str2double(accel_tmp(3));
end

fclose(IMUData);

save('IMU.mat','ACCEL','COORD_DEG','COORD_KM');
