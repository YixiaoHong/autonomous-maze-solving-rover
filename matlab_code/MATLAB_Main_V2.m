%/////////////////////Localization Related////////////////////////////////
serialInfo = instrhwinfo('serial');
comPorts = serialInfo.AvailableSerialPorts;
s = serial('COM14'); % creates serial object
s.Baudrate = 115200;
fopen(s); % connects to serial object
pause(0.2);
history = zeros(1,1);
i = 0;
num = 0;
done = 0;
%/////////////////////To Loading Zone Related//////////////////////////////
A = [100 100 100 100 100 100 100 100 100 100; 100 3 2 1 2 100 6 100 8 100; 100 2 3 100 3 4 5 6 7 100; 100 1 100 5 100 100 6 100 8 100;100 2 3 4 5 6 7 100 9 100;100 100 100 100 100 100 100 100 100 100];
B = [5 5 5 5 5 5 5 5 5 5;5 0 3 0 1 2 0 2 0 5; 5 3 0 2 1 0 1 0 1 5; 5 0 2 0 2 2 0 2 0 5; 5 1 0 1 0 0 1 2 0 5;5 5 5 5 5 5 5 5 5 5];
pickup = 0;
%/////////////////////Change the code below for different unloading zone//
C1 = [100 100 100 100 100 100 100 100 100 100; 100 8 7 6 5 100 1 100 5 100; 100 9 8 100 4 3 2 3 4 100; 100 10 100 8 100 100 3 100 5 100;100 9 8 7 6 5 4 100 6 100;100 100 100 100 100 100 100 100 100 100];
C2 = [100 100 100 100 100 100 100 100 100 100; 100 10 9 8 7 100 5 100 1 100; 100 11 10 100 6 5 4 3 2 100; 100 12 100 10 100 100 5 100 3 100;100 11 10 9 8 7 6 100 4 100;100 100 100 100 100 100 100 100 100 100];
C3 = [100 100 100 100 100 100 100 100 100 100; 100 7 8 9 10 100 8 100 10 100; 100 6 7 100 9 8 7 8 9 100; 100 5 100 1 100 100 6 100 10 100;100 4 3 2 3 4 5 100 11 100;100 100 100 100 100 100 100 100 100 100];
C4 = [100 100 100 100 100 100 100 100 100 100; 100 11 10 9 8 100 6 100 4 100; 100 12 11 100 7 6 5 4 3 100; 100 13 100 11 100 100 6 100 2 100;100 12 11 10 9 8 7 100 1 100;100 100 100 100 100 100 100 100 100 100];
D = [5 5 5 5 5 5 5 5 5 5;5 0 0 0 1 2 3 2 3 5; 5 0 0 2 1 0 1 0 1 5; 5 0 2 3 2 2 0 2 0 5; 5 1 0 1 0 0 1 2 3 5;5 5 5 5 5 5 5 5 5 5];
%!!!!!!! CHANGE THIS ONE BASED ON UNLOAD LOCATION !!!!!!///////////////////
C = C2;


%//////////////////////Acutal Program/////////////////////////////////////
correctinput = 0;
while correctinput == 0;
    str = input('Input: ','s');
    if strcmp(str,'go')
        fwrite(s,'0'); % writes letter to Arduino
        correctinput = 1;
    else fprintf('You need to type "go" Or I won''t start!\n');
    end
end


while done == 0
    arduino_response = 0;
while arduino_response == 0
    if s.bytesAvailable> 0  % recieve data from Arduino
        pause(0.1);
        fprintf('Response from Arduino: \n');
        pause(0.4);
        sample =(fscanf(s)); % reads from Arduino
        disp(sample);
        num = str2num(sample);
        disp(num);
        i = i+1;
        fprintf('i value is \n');
        disp(i);
        pause(0.1);
        arduino_response = 1;
    end
    pause(0.05);
end
    pause(0.2);
    
    history(1,i) = num;
    fprintf('Rover Sensor History is \n');
    disp(history);
    Location (1,1) = 66;
    if isequal(history,[11 11])
        Coordinate = [5 6];
        Location (1,1) = 99;
    else
    [Location , Coordinate] = Stephen_Localization(history);
    end
    
    if Location (1,1) == 99
       fprintf('The current location is unique, the rover has finished localization! \n');
       fprintf('The current robot location is shown in the matrix below: \n');
       disp(Location);
       fprintf('Final Location is \n');
       disp(Coordinate);
       done = 1;
    else
       fprintf('The current location is NOT unique, the rover MUST KEEP MOVING!\n') ;
       if num == 11
           fwrite(s,'3');
           fprintf('I gave uno cmd: 3 !\n') ;
       end
       if num == 22 || num == 55
           fwrite(s,'4');
           fprintf('I gave uno cmd: 4 !\n') ;
       end
       if num == 33
           fwrite(s,'2');
           fprintf('I gave uno cmd: 2 !\n') ;
       end
       if num == 44
           fwrite(s,'1');
           fprintf('I gave uno cmd: 1 !\n') ;
       end
    end
    
    pause (0.2);
    
    fprintf('cycle done \n') ;
    
end
%////////////Localization Finish, To Loading Zone Begins//////////////////
fprintf('Localization Finish, Proceeding to Loading Zone \n') ;
pause (0.2);
fwrite(s,'99');
pause (0.2);
arduino_response = 0;
while arduino_response == 0
    if s.bytesAvailable> 0  % recieve data from Arduino
        pause(0.1);
        fprintf('Response from Arduino: \n');
        pause(0.4);
        sample =(fscanf(s)); % reads from Arduino
        disp(sample);
        pause(0.1);
        arduino_response = 1;
    end
end

a = Coordinate(1,1); %inputs final location to a,b
b = Coordinate(1,2);

new_a = 0;
new_b = 0;
%Check if heading east, west, south, or north.
while pickup~=1
    
if A(a,b)>A(a,b+1)
    [new_a,new_b,pickup]=Head_East(a,b,B,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
elseif A(a,b)>A(a,b-1)
    [new_a,new_b,pickup]=Head_West(a,b,B,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
elseif  A(a,b)>A(a+1,b)
    [new_a,new_b,pickup]=Head_South(a,b,B,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
elseif A(a,b)>A(a-1,b)
    [new_a,new_b,pickup]=Head_North(a,b,B,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
else
    fprintf('current coordinate: \n');
    pickup = 1;
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
end
a = new_a;
b = new_b;

LED_display(new_a,new_b,s);


end

fprintf('At entrance of Loading Zone #:');
disp(Coordinate);

%Send command to pickup block
fwrite(s,'9');
pause(0.2);
arduino_response = 0;
while arduino_response == 0
    if s.bytesAvailable> 0  % recieve data from Arduino
            pause(0.1);
            sample =(fscanf(s)); % reads from Arduino
            disp(sample);
            if strcmp(sample(1,1:end-2),'i got block')
            fprintf('robot got the block!\n');
            arduino_response = 1;
            else fprintf('robot said nothing\n');
            end
    end
    pause(0.1);
end
%Finish Picking up block, proceed to unloading zone.
fprintf('Block Pickup Finish, Proceeding to UNLoading Zone \n') ;
a = 2; %inputs final location to a,b
b = 2;

new_a = 0;
new_b = 0;
finish = 0;
%Check if heading east, west, south, or north.
while finish~=1
if C(a,b)>C(a,b+1)
    [new_a,new_b,finish]=Head_East(a,b,D,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
elseif C(a,b)>C(a,b-1)
    [new_a,new_b,finish]=Head_West(a,b,D,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
elseif  C(a,b)>C(a+1,b)
    [new_a,new_b,finish]=Head_South(a,b,D,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
elseif C(a,b)>C(a-1,b)
    [new_a,new_b,finish]=Head_North(a,b,D,s);
    fprintf('current coordinate: \n');
    Coordinate (1,1) = new_a;
    Coordinate (1,2) = new_b;
    disp(Coordinate);
end
a = new_a;
b = new_b;

if finish~=1
LED_display(new_a,new_b,s);
end

end
fprintf('At UNLoading Zone #:');
disp(Coordinate);
fwrite(s,'10');

arduino_response = 0;

while arduino_response == 0
pause(0.1);
    while s.bytesAvailable> 0  % recieve data from Arduino
        pause(0.05);
        sample =(fscanf(s)); % reads from Arduino
        fprintf('Drop the block - Arduino Says : \n');
        disp(sample);
        arduino_response = 1;
    end


end

fclose(s);