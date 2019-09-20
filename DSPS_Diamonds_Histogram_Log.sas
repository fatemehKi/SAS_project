ODS graphics on / reset width=8in height=5in;
ODS noproctitle;

*ODS select histogram ParameterEstimates GoodnessOfFit FitQuantiles;
ODS select histogram;

Title 'Distribution Plot for Diamonds';

proc univariate data=MCT.diamonds_FE;
    histogram logprice logcarat / normal;
    inset Min Max mean median std Q1 Q3 skewness kurtosis / pos=ne;
Run;

Title;

proc univariate data=MCT.diamonds_FE noprint;    
    qqplot logprice / normal(mu=7.7878 sigma=1.0139)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (LogPrice)';
    qqplot logcarat / normal(mu=0.5553 sigma=0.2446)
                   odstitle = 'Normal Quartile-Quartile Plot for Diamonds (LogCarat)';
run;

ODS graphics off;