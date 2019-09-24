ods graphics / reset width=8in height=5in;
title 'Diamonds Price Proportion by Carat';

proc sgpie data=MCT.diamonds_clean2;
    donut carat / response=price 
                  datalabeldisplay=all
                  datalabelloc=outside
                  sliceorder=respdesc;
run;