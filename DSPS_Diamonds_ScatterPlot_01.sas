ODS graphics on;

Proc sgplot data=MCT.diamonds_clean2;
    scatter x=carat y=price;
    title "Plot of Price by Carat";
Run;

ODS graphics off;