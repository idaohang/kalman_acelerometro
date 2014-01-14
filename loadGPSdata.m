function loadGPSdata(nombre_archivo)
%loadGPSdata Carga las coordenadas desde <nombre_archivo>.nmea
% Guarda el resultado en COORD_DEG y COORD_KM

GPSData = fopen([nombre_archivo '.nmea'],'r');
Data = textscan(GPSData,'%s');

N = size(Data{1},1);

COORD_DEG = zeros(N,2);
COORD_KM = zeros(N,2);

for i=1:N
    % Ver el Mapping Toolbox, las coordenadas vienen en grados
    coord_tmp = strsplit(Data{1}{i},',');
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
end

fclose(GPSData);

save([nombre_archivo '.mat'],'COORD_DEG','COORD_KM');

end