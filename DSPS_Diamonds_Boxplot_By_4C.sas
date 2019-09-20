ODS graphics on /reset width=12in height=5in;

title 'Diamonds Price by Cut';

proc sgplot data=MCT.diamonds_clean2;    
    vbox price / category=cut
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black)  
                 connect=mean connectattrs=(color=red);
run;

title 'Diamonds Price by Color';
proc sgplot data=MCT.diamonds_clean2;    
    vbox price / category=color
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black)  
                 connect=mean connectattrs=(color=red);
run;

title 'Diamonds Price by Clarity';
proc sgplot data=MCT.diamonds_clean2;    
    vbox price / category=clarity
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black) 
                 connect=mean connectattrs=(color=red);
run;

title 'Diamonds Price by Carat';
proc sgplot data=MCT.diamonds_clean2;    
    vbox price / category=carat
                 dataskin=sheen 
                 nooutliers 
                 connect=mean connectattrs=(color=red);
    xaxis display=(novalues);    
run;
