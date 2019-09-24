ODS graphics on;

proc freq data=MCT.diamonds_clean2;
    tables cut*(color clarity) / chisq plots=freqplot;
    tables color*clarity / chisq plots=freqplot;
    
Run;