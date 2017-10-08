load EclectronicsCSV.csv;  
shift = EclectronicsCSV(:,2) - 1.65 ;       % dc offset to ensure voltage passes zero
times = EclectronicsCSV(:,1);
simrow = 1;
dcount = 1; 
datacol = 1; 
checks = 1; 

while simrow < 36780                        % number of rows of data 
    
    if (-0.23 < shift(simrow)) && (shift(simrow) < 0.23)        % if the voltage crosses zero
        data(dcount, datacol) = times(simrow);                  % record the time when it happened
        dcount = dcount + 1; 
        simrow = simrow + 1; 
    else 
        simrow = simrow + 1; 
    end
    
    if times(simrow+1) < times(simrow)      % if you reach a new simulation's data, start a new column
            datacol = datacol+1; 
            dcount =  1;
    end
end

while checks < 88               % subtract the times from one another. adjacent times were sometimes half a period, so the nest time was also calcuated
    timediff(checks,1) = data(2,checks) - data(1,checks) ; 
    timediff(checks,2) = data(3,checks) - data(1,checks) ; 
    checks = checks + 1; 
end 

checks = 1; 

while checks < 88           % put a 1 in the finalcheck matrix if one of the calculated values was within the tolerance
    if (timediff(checks,1) > 0.85) && (timediff(checks,1) > 0.85) 
        finalcheck(checks,1) = 1;        
    elseif (timediff(checks,2) > 0.85) && (timediff(checks,2) > 0.85) 
        finalcheck(checks,1) = 1; 
    else
        finalcheck(checks,1) = 0; 
    end     
    checks = checks + 1; 
end 


hertz = -1*(1 ./ timediff ) ;           % out of 87 trials, only one was out of tolerance
