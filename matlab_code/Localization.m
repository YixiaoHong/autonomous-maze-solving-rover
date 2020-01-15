function [Location , Coordinate] = Stephen_Localization(read)
Map = [0 0 0 0 0 0 0 0 0 0; 0 1 2 11 3 0 22 0 22 0; 0 4 33 0 44 11 5 11 6 0; 0 55 0 22 0 0 55 0 55 0; 0 44 11 7 11 11 33 0 8 0; 0 0 0 0 0 0 0 0 0 0]; %this is the map of the world
Coordinate = [0 0];
x = 0;
y = 0;
P = zeros(size(Map,1),size(Map,2),2); %make a blank probability matrix
P(2:5 , 2:9 , 1) = 1;
step = size(read,2);
for i = 1:step %check each number that was read
    for j = 2:size(Map,1)-1 %check all row and col for map. If the conditions match the readings, fill in 1, else fill in 0 in the P matrix
        for k = 2:size(Map,2)-1
            if Map(j,k) == read(i)
                P(j,k,i+1) = 1;
            else
                P(j,k,i+1) = 0;
            end %end of if statement
        
        end %end of for k statement
    
    end %end of for j statement
    
end %end of i statement


for i = 2:step+1 %elimination from last step
    for j = 2:size(Map,1)-1 
        for k = 2:size(Map,2)-1
            if P(j,k,i) == 1
                if P(j+1,k,i-1) ~= 1 && P(j-1,k,i-1) ~= 1 && P(j,k+1,i-1) ~= 1 && P(j,k-1,i-1) ~= 1
                P(j,k,i) = 0;
                end %end of inner if
            end %end of outer if
        end %end of for k
    end %end of for J
end %end of for i

unique_counter = 0;

for j = 2:size(Map,1)-1 %check for uniqueness of current position and direction
    for k = 2:size(Map,2)-1
        if P(j,k,step+1) == 1
            unique_counter = unique_counter+1;
            x = j;
            y = k;
        end %end of outer if
    end %end of for k
end %end of for J
Location = P(:,:,step+1);
if unique_counter == 1 
    Location (1,1) = 99;
    Coordinate = [x y];
else
    Location (1,1) = 66;
end

disp(Coordinate);
end



