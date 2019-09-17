proc import datafile="C:\DSPS\diamonds.csv"
     out=diamonds_raw 
     dbms=csv
     replace;
     guessingrows=Max; /* or guessingrows=100 to improve load performance */     
     getnames=yes;     /* datarow=1 if no header name */
run;

Data MCT.diamonds;
     Format rec_id BEST12.;
     Set diamonds_raw;
     rec_id = input(VAR1, BEST12.);
     Drop VAR1;
Run;
