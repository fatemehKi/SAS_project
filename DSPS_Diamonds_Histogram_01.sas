ODS graphics on / reset width=8in height=5in;
ODS noproctitle;

ODS select histogram ParameterEstimates GoodnessOfFit FitQuantiles;
Title 'Distribution Plot for Diamonds';

proc univariate data=MCT.diamonds_clean2;
    var price carat depth table x y z;
    
    histogram price carat depth table x y z / normal(color=salmon);
    inset Min Max mean median std Q1 Q3 skewness kurtosis / pos=ne;
Run;

Title;

proc univariate data=MCT.diamonds_clean2 noprint;  
    var price carat depth table x y z; 
      
    qqplot price / normal(mu=3933.1 sigma=3988.1)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (Price)';
    
    qqplot carat / normal(mu=0.7978 sigma=0.4734)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (Carat)';

    qqplot depth / normal(mu=61.748 sigma=1.4299)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (depth)';

    qqplot table / normal(mu=57.458 sigma=2.2337)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (table)';

    qqplot x     / normal(mu=5.7312 sigma=1.1207)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (x)';
                   
    qqplot y     / normal(mu=5.7347 sigma=1.1412)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (y)';
    
    qqplot z     / normal(mu=3.5387 sigma=0.705)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (z)';
run;

ODS graphics off;