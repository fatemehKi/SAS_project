ODS graphics on /reset width=12in height=5in;

title 'Diamonds Carat by Cut';

proc sgplot data=MCT.diamonds_clean2;    
    vbox carat / category=cut
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black)  
                 connect=mean connectattrs=(color=red);
run;

title 'Diamonds Carat by Color';
proc sgplot data=MCT.diamonds_clean2;    
    vbox carat / category=color
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black)  
                 connect=mean connectattrs=(color=red);
run;

title 'Diamonds Carat by Clarity';
proc sgplot data=MCT.diamonds_clean2;    
    vbox carat / category=clarity
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black) 
                 connect=mean connectattrs=(color=red);
run;

