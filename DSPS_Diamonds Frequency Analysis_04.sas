ODS graphics on;

proc freq data=MCT.diamonds_clean2;
    tables cut*(color clarity) / chisq plots=freqplot(orient=horizontal twoway=stacked scale=percent);
    tables color*clarity / chisq plots=freqplot(orient=horizontal twoway=stacked scale=percent);
    
Run;