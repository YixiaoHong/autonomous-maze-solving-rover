function [new_a,new_b,pickup] = Head_West(a,b,B,s)
%Turn cmd, sends target angle to Arduino
fwrite(s,'6'); % writes letter to Arduino
n=1;
arduino_response = 0;

for n=1:10
    if B(a,b-n)==1 || B(a,b-n)== 3 || B(a,b) == 3
        break;
    end

end
    
new_a = a;
new_b = b-n;
pickup = 0;

if B(new_a,new_b)==3
    pickup=1;
end

pause(0.2);

while arduino_response == 0

    while s.bytesAvailable> 0  % recieve data from Arduino
        pause(0.05);
        sample =(fscanf(s)); % reads from Arduino
        fprintf('In Head_West --> Arduino Says : \n');
        disp(sample);
        arduino_response = 1;
    end

end

end