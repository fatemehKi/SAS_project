ODS graphics on;

PROC CORR DATA=MCT.diamonds_clean2 PLOTS(MAXPOINTS=None)=Matrix(nvar=all);
   VAR price carat depth table x y z;
RUN;

PROC CORR DATA=MCT.diamonds_clean2 NOSIMPLE PEARSON SPEARMAN;
   VAR price carat depth table x y z;
RUN; 

ODS graphics on;
Proc sgscatter data=MCT.diamonds_clean2;
    matrix carat depth price table x y z / diagonal=(histogram);
run;

ODS graphics on;
Proc sgscatter data=MCT.diamonds_clean2;
    matrix carat price / diagonal=(histogram normal);
run;