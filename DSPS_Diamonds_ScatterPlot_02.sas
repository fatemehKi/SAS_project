/* Remove Overplotting */
ODS graphics on;

Proc sgplot data=MCT.diamonds_clean2;
    scatter x=carat y=price / transparency=0.9
                              markerattrs=(symbol=circlefilled
                                           size=5
                                           color=coral)                                        
                             ;
    title "Plot of Price by Carat";
Run;

ODS graphics off;