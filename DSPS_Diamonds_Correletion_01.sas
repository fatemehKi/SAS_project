ODS graphics on;

PROC CORR DATA=MCT.diamonds_clean2 PLOTS(MAXPOINTS=None)=Matrix(Histogram);
   VAR price carat depth table x y z;
RUN;

PROC CORR DATA=MCT.diamonds_clean2 NOSIMPLE PEARSON SPEARMAN;
   VAR price carat depth table x y z;
RUN; 
