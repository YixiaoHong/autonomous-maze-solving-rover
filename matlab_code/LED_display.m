function LED_display( row,col,s )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

strrow = int2str(row);
strcol = int2str(col);
str = [strrow strcol];

fwrite(s,str); % writes letter to Arduino

pause(0.2);

arduino_response = 0;

while arduino_response == 0
pause(0.1);
    while s.bytesAvailable> 0  % recieve data from Arduino
        pause(0.05);
        sample =(fscanf(s)); % reads from Arduino
        fprintf('LED Display - Arduino Says : \n');
        disp(sample);
        arduino_response = 1;
    end


end

