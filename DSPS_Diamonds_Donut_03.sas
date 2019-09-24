ods graphics / reset width=8in height=5in;
title 'Diamonds Price Proportion by Cut';

proc sgpie data=MCT.diamonds_clean2;
    donut cut / response=price 
                datalabeldisplay=all
                datalabelloc=outside
                sliceorder=respdesc;
run;