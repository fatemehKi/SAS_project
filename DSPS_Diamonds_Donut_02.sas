ods graphics / reset width=8in height=5in;
title 'Diamonds Price Proportion by Color';

proc sgpie data=MCT.diamonds_clean2;
    donut color / response=price 
                  datalabeldisplay=all
                  datalabelloc=outside
                  sliceorder=respdesc;
run;