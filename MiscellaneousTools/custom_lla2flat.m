function [ north, east, up ] = custom_lla2flat( llaData, refData )

    % Convert from geodetic latitude, longitude, and altitude to flat Earth position
    format long g
    ellipsoidModel = 'WGS84';
    [NWP,~] = size(llaData);
    lat_DMS = cell(1,NWP);
    lon_DMS = cell(1,NWP);
    lat = cell(1,NWP);
    lon = cell(1,NWP);
    flat = cell(1,NWP);
    north = [];
    east = [];
    up = [];
    
    lat_ref_DMS = [str2double(refData{1,1}) str2double(refData{1,2}) str2double(refData{1,3})];
    lon_ref_DMS = [str2double(refData{1,4}) str2double(refData{1,5}) str2double(refData{1,6})];
    lat_ref =  dms2degrees(lat_ref_DMS);
    lon_ref =  dms2degrees(lon_ref_DMS);
    
    for i = 1:NWP
        lat_DMS{1,i} = [str2double(llaData{i,1}) str2double(llaData{i,2}) str2double(llaData{i,3})];
        lon_DMS{1,i} = [str2double(llaData{i,4}) str2double(llaData{i,5}) str2double(llaData{i,6})];
        lat{1,i} =  dms2degrees(lat_DMS{1,i});
        lon{1,i} =  dms2degrees(lon_DMS{1,i});
        flat{1,i} = lla2flat([lat{1,i} lon{1,i} 20],[lat_ref lon_ref],0,0,ellipsoidModel);
        north = [north ; flat{1,i}(1)];
        east = [east ; flat{1,i}(2)];
        up = [up ; -flat{1,i}(3)];
    end
    
end

