ODS graphics on;

proc freq data=MCT.diamonds_clean2;
    tables cut*(color clarity) / chisq plots=mosaicplot(square);
    tables color*clarity / chisq plots=mosaicplot(square);
    
Run;