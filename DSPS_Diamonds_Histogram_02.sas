ODS graphics on / reset width=8in height=5in;

ODS noproctitle;
Title;

*ODS select histogram ParameterEstimates GoodnessOfFit FitQuantiles;
ODS select histogram;
Title 'Distribution Plot for Diamonds';

proc univariate data=MCT.diamonds_clean2;
    var price carat depth table x y z;
    
    histogram price carat depth table x y z / kernel;    
    inset Min Max mean median std Q1 Q3 skewness kurtosis / pos=ne;
Run;

Title;

proc univariate data=MCT.diamonds_clean2 noprint;
    var price carat depth table x y z;
     
    qqplot price / normal(mu=est sigma=est)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (Price)';
    
    qqplot carat / normal(mu=est sigma=est)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (Carat)';

    qqplot depth / normal(mu=est sigma=est)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (depth)';

    qqplot table / normal(mu=est sigma=est)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (table)';

    qqplot x     / normal(mu=est sigma=est)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (x)';
                   
    qqplot y     / normal(mu=est sigma=est)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (y)';
    
    qqplot z     / normal(mu=est sigma=est)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (z)';
run;

ODS listing;