


proc import datafile = 'C:\Users\mfatemeh\Desktop\SAS project\diamonds.csv'
 out = pro
 dbms = CSV
 ;
run;

proc import datafile = 'C:\Users\mfatemeh\Desktop\SAS project\new-diamonds.csv'
 out = pro2
 dbms = CSV
 ;
run;

PROC CONTENTS DATA=pro;
RUN;
