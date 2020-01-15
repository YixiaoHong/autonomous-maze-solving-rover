serialInfo = instrhwinfo('serial');
comPorts = serialInfo.AvailableSerialPorts;
s = serial('COM4'); % creates serial object
fopen(s); % connects to serial object
pause(0.2);

row = 9;
col = 8;

strrow = int2str(row);
strcol = int2str(col);

str = [strrow strcol];

type = input('Input: ','s');
if strcmp(type,'go')
    fwrite(s,str); % writes letter to Arduino
end

arduino_response = 0;

while arduino_response == 0
pause(0.1);
    while s.bytesAvailable> 0  % recieve data from Arduino
        pause(0.05);
        sample =(fscanf(s)); % reads from Arduino
        fprintf(' Arduino Says : \n');
        disp(sample);
        arduino_response = 1;
    end


end
fclose(s);