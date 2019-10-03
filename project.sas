
/*--------Importing the training and test data-----*/
/*-------------------------------*/
proc import datafile="C:\Users\fkiai\OneDrive\Desktop\DSPS\DIAMONDS\DATA\TRAINING\diamonds.csv"
     out=diamonds_raw 
     dbms=csv
     replace;
     guessingrows=Max; /* or guessingrows=100 to improve load; performance */     
     getnames=yes;     /* datarow=1 if no header name */
run;
/*labeling the indexes with rec_id and move to fkiaie lib*/
Data fkiaie.diamonds;
     Format rec_id BEST12.;
     Set diamonds_raw;
     rec_id = input(VAR1, BEST12.);
     Drop VAR1;
Run;

proc import datafile="C:\Users\fkiai\OneDrive\Desktop\DSPS\DIAMONDS\DATA\TEST\new-diamonds.csv"
     out=testdiamonds_raw 
     dbms=csv
     replace;
     guessingrows=Max; /* or guessingrows=100 to improve load; performance */     
     getnames=yes;     /* datarow=1 if no header name */
run;
/*labeling the indexes with rec_id and move to fkiaie lib*/
Data fkiaie.testdiamonds;
     Format rec_id BEST12.;
     Set testdiamonds_raw;
     rec_id = input(VAR1, BEST12.);
     Drop VAR1;
Run;

/*-----------Data Cleaning-------*/
/*-------------------------------*/
/***remove duplicate record and separate to dup_diamonds*/
/**exception report1 */
proc sort data=fkiaie.diamonds(drop=rec_id) nodupkey
out=sorted_daimonds
dupout=dup_diamonds;/*separate to dup_diamonds*/
by _all_;
run;

/*using SQL to create duplication**/
proc sql;
Create table fkiaie.diamins_sql_dup as 
select carat, cut, color,
	   clarity, depth, table,
	   price, x, y, z, count(*) as dupcount
from fkiaie.diamonds
group by carat, cut, color,
		 clarity, depth, table,
		 price, x,y,z
having count(*) >1
order by dupcount desc
;
quit;

/*next step is joining this result with the diamond */
PROC SQL;
   CREATE TABLE WORK.QUERY_FOR_DIAMINS_SQL_DUP_0000 AS 
   SELECT t2.rec_id, 
          t2.carat, 
          t2.cut, 
          t2.color, 
          t2.clarity, 
          t2.depth, 
          t2.table, 
          t2.price, 
          t2.x, 
          t2.y, 
          t2.z
      FROM FKIAIE.DIAMINS_SQL_DUP t1, FKIAIE.DIAMONDS t2
      WHERE (t1.carat = t2.carat AND t1.cut = t2.cut AND t1.color = t2.color AND t1.clarity = t2.clarity AND t1.depth = 
           t2.depth AND t1.table = t2.table AND t1.price = t2.price AND t1.x = t2.x AND t1.y = t2.y AND t1.z = t2.z);
QUIT;

/*Query to find No Duplicated and distinct*/
PROC SQL;
   CREATE TABLE WORK.QUERY_NO_DUPLICATED AS 
   SELECT DISTINCT t1.carat, 
          t1.cut, 
          t1.color, 
          t1.clarity, 
          t1.depth, 
          t1.table, 
          t1.price, 
          t1.x, 
          t1.y, 
          t1.z
      FROM FKIAIE.DIAMONDS t1;
QUIT;
	   
/***remove invalid data (x=y=z=0)***/
/**exception report 2 */
PROC SQL;
   CREATE TABLE WORK.QUERY_FOR_QUERY_NO_DUPLICATED AS 
   SELECT t1.carat, 
          t1.cut, 
          t1.color, 
          t1.clarity, 
          t1.depth, 
          t1.table, 
          t1.price, 
          t1.x, 
          t1.y, 
          t1.z
      FROM WORK.QUERY_NO_DUPLICATED t1
      WHERE t1.x = 0 OR t1.y = 0 OR t1.z = 0;
QUIT;

PROC SQL;
   CREATE TABLE WORK.QUERY_FOR_QUERY_NO_DUPLICAT_0001 AS 
   SELECT t2.rec_id, 
          t2.carat, 
          t2.cut, 
          t2.color, 
          t2.clarity, 
          t2.depth, 
          t2.table, 
          t2.price, 
          t2.x, 
          t2.y, 
          t2.z
      FROM WORK.QUERY_FOR_QUERY_NO_DUPLICATED t1, FKIAIE.DIAMONDS t2
      WHERE (t1.carat = t2.carat AND t1.cut = t2.cut AND t1.color = t2.color AND t1.clarity = t2.clarity AND t1.depth = 
           t2.depth AND t1.table = t2.table AND t1.price = t2.price AND t1.x = t2.x AND t1.y = t2.y AND t1.z = t2.z);
QUIT;

/*Removing the not valid and duplicate to get clean*/
PROC SQL;
   CREATE TABLE WORK.QUERY_FOR_QUERY_NO_DUPLICAT_0004 AS 
   SELECT t1.carat, 
          t1.cut, 
          t1.color, 
          t1.clarity, 
          t1.depth, 
          t1.table, 
          t1.price, 
          t1.x, 
          t1.y, 
          t1.z
      FROM WORK.QUERY_NO_DUPLICATED t1
      WHERE t1.x > 0 AND t1.y > 0 AND t1.z > 0;
QUIT;

/***remove missing values***/
PROC SQL;
   CREATE TABLE WORK.QUERY_FOR_SORTED_DAIMONDS AS 
   SELECT /* NMISS_DISTINCT_of_carat */
            (NMISS(DISTINCT(t1.carat))) AS NMISS_DISTINCT_of_carat, 
          /* NMISS_of_cut */
            (NMISS(t1.cut)) AS NMISS_of_cut, 
          /* NMISS_of_color */
            (NMISS(t1.color)) AS NMISS_of_color, 
          /* NMISS_of_clarity */
            (NMISS(t1.clarity)) AS NMISS_of_clarity, 
          /* NMISS_DISTINCT_of_depth */
            (NMISS(DISTINCT(t1.depth))) AS NMISS_DISTINCT_of_depth, 
          /* NMISS_of_table */
            (NMISS(t1.table)) AS NMISS_of_table, 
          /* NMISS_of_price */
            (NMISS(t1.price)) AS NMISS_of_price, 
          /* NMISS_of_x */
            (NMISS(t1.x)) AS NMISS_of_x, 
          /* NMISS_of_y */
            (NMISS(t1.y)) AS NMISS_of_y, 
          /* NMISS_of_z */
            (NMISS(t1.z)) AS NMISS_of_z
      FROM WORK.SORTED_DAIMONDS t1;
QUIT;
/*Results show there is no missing value to remove*/

/**Visualizing Missing**/
proc format ;
    value $missfmt ' '="Missing" other="Not Missing";
    value nmissfmt .  ="Missing" other="Not Missing";
run;

%MACRO Gen_MissingVariable_Bar(ds=);

        ods exclude all;
        ods output onewayfreqs=temp;
        title;
        
        Proc freq data=&ds;
                tables _all_ / MISSING;    
                format _numeric_ nmissfmt. _character_ $missfmt.;
        Run;
        
        Data Wanted;    
            length variable $32. variable_value $50.;
            set temp;
            Variable=scan(table, 2);
            Variable_Value=strip(trim(vvaluex(variable)));
            keep variable variable_value frequency percent;
            label variable='Variable' 
                  variable_value='Variable Value';
        Run;
        
        Data Missing_Report(keep=variable NMiss pct_NMiss);    
            do until (last.variable);
                set Wanted;
                by variable notsorted;        
                select (variable_value);
                        when ('Missing') 
                            do; 
                               NMiss = frequency; 
                               pct_NMiss = percent; 
                            end;
                        when ('Not Missing') 
                            do; 
                               NN = frequency; 
                               pct_NN = percent; 
                            end;
                        Otherwise;
                end;
            end;
            NMiss = coalesce(NMiss, 0);
            pct_NMiss = coalesce(pct_NMiss, 0);
            NN = coalesce(NN, 0);
            pct_NN = coalesce(pct_NN, 0);
        
            Label pct_NMIss = "% Missing";
        Run;
        
        %let softgreen=cx8faf7f;
        ods exclude none;
        ods graphics on / height=5in width=10in;

        title "Missing Values by Variable Visualization";
        Proc sgplot data=Missing_report;
            Format pct_NMiss PERCENT8.4;
            Format NMiss COMMA16.;
            vbar variable / response=pct_NMiss 
                            dataskin=sheen 
                            /*other option: gloss, matte */ 
                            barwidth=0.8 
                            fillattrs=(color=green)
                            datalabel=pct_NMiss;
            xaxis discreteorder=data;
            yaxis display=(noline) grid;
            
        run;
    
%MEND Gen_MissingVariable_Bar;

%Gen_MissingVariable_Bar(ds=fkiaie.diamonds);
/**no missing, therefore nothing in the graph**/
ods _all_ close;

/*------------------EDA----------------*/
/*-------------------------------------*/
/**continues and categorical relation**/
ODS graphics on /reset width=12in height=5in;

title 'Diamonds Price by Cut';

proc sgplot data=fkiaie.Cleaned_data;    
    vbox price / category=cut
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black)  
                 connect=mean connectattrs=(color=red);
run;

title 'Diamonds Price by Color';
proc sgplot data=fkiaie.Cleaned_data;    
    vbox price / category=color
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black)  
                 connect=mean connectattrs=(color=blue);
run;

title 'Diamonds Price by Clarity';
proc sgplot data=fkiaie.Cleaned_data;    
    vbox price / category=clarity
                 dataskin=sheen
                 outlierattrs=(color=green)
                 meanattrs=(color=black)
                 medianattrs=(color=black) 
                 connect=mean connectattrs=(color=black);
run;

title 'Diamonds Price by Carat';
proc sgplot data=fkiaie.Cleaned_data;    
    vbox price / category=carat
                 dataskin=sheen 
                 nooutliers 
                 connect=mean connectattrs=(color=green);
    xaxis display=(novalues);    
run;

/** Plotting the relationship**/

ods graphics / reset width=8in height=5in;
title 'Diamonds Price Proportion by Carat';

proc sgpie data=fkiaie.Cleaned_data;
    donut carat / response=price 
                  datalabeldisplay=all
                  datalabelloc=outside
                  sliceorder=respdesc;
run;


ods graphics / reset width=8in height=5in;
title 'Diamonds Price Proportion by Cut';

proc sgpie data=fkiaie.Cleaned_data;
    donut cut / response=price 
                datalabeldisplay=all
                datalabelloc=outside
                sliceorder=respdesc;
run;

ods graphics / reset width=8in height=5in;
title 'Diamonds Price Proportion by Color';

proc sgpie data=fkiaie.Cleaned_data;
    donut color / response=price 
                  datalabeldisplay=all
                  datalabelloc=outside
                  sliceorder=respdesc;
run;


/***categorical and categorical relations**/
ODS graphics on;

proc freq data=fkiaie.Cleaned_data;
    tables cut*(color clarity) / chisq plots=freqplot(orient=horizontal twoway=stacked scale=percent);
    tables color*clarity / chisq plots=freqplot(orient=horizontal twoway=stacked scale=percent);
    
Run;

/**Heat map and Correlations_Type2**/
%macro prepCorrData(in=,out=);
  /* Run corr matrix for input data, all numeric vars */
  proc corr data=&in. noprint
    pearson
    outp=work._tmpCorr
    vardef=df
  ;
  run;
 
  /* prep data for heat map */
data &out.;
  keep cartesian_x cartesian_y r;
  set work._tmpCorr(where=(_TYPE_="CORR"));
  array v{*} _numeric_;
  cartesian_x = _NAME_;
  do i = dim(v) to 1 by -1;
    cartesian_y = vname(v(i));
    r = v(i);
    /* creates a lower triangular matrix */
    if (i<_n_) then
      r=.;
    output;
  end;
run;
/* 
proc datasets lib=work nolist nowarn;
  delete _tmpcorr;
quit;
*/
%mend;

  /* Create a heat map implementation of a correlation matrix */
ods path work.mystore(update) sashelp.tmplmst(read);
 
proc template;
  define statgraph corrHeatmap;
   dynamic _Title;
    begingraph;
      entrytitle _Title;
      rangeattrmap name='map';
      /* select a series of colors that represent a "diverging"  */
      /* range of values: stronger on the ends, weaker in middle */
      /* Get ideas from http://colorbrewer.org                   */
      range -1 - 1 / rangecolormodel=(cxD8B365 cxF5F5F5 cx5AB4AC);
      endrangeattrmap;
      rangeattrvar var=r attrvar=r attrmap='map';
      layout overlay / 
        xaxisopts=(display=(line ticks tickvalues)) 
        yaxisopts=(display=(line ticks tickvalues));
        heatmapparm x = cartesian_x y = cartesian_y colorresponse = r / 
          xbinaxis=false ybinaxis=false
          name = "heatmap" display=all;
        continuouslegend "heatmap" / 
          orient = vertical location = outside title="Pearson Correlation";
      endlayout;
    endgraph;
  end;
run;

/* Build the graphs */
ODS graphics on / reset height=600 width=800;
 
%prepCorrData(in=fkiaie.Cleaned_data(drop=cut color clarity), 
              out=Diamonds_r);
proc sgrender data=Diamonds_r template=corrHeatmap;
   dynamic _title= "Correlation matrix for Diamonds";
run;

ODS graphics off;

/**Histogram**/
ODS graphics on / reset width=8in height=5in;

ODS noproctitle;
Title;

*ODS select histogram ParameterEstimates GoodnessOfFit FitQuantiles;
ODS select histogram;
Title 'Distribution Plot for Diamonds';

proc univariate data=fkiaie.Cleaned_data;
    var price carat depth table x y z;
    
    histogram price carat depth table x y z / kernel;    
    inset Min Max mean median std Q1 Q3 skewness kurtosis / pos=ne;
Run;

/*---------Feature Engineering------------*/
/*-------------------------------------*/

/* Apply Feature Engineering and Log Transformation */
Data fkiaie.Diamonds_FE (drop=i j k);
    Set fkiaie.Cleaned_data;
    logprice = log(1+price);             
    logcarat = log(1+carat);

    Array cut_grade[5]     $9 _temporary_ ('Fair' 'Good' 'Very Good' 'Premium' 'Ideal');
    Array color_grade[7]   $1 _temporary_ ('J' 'I' 'H' 'G' 'F' 'E' 'D');
    Array clarity_grade[8] $4 _temporary_ ('I1' 'SI2' 'SI1' 'VS2' 'VS1' 'VVS2' 'VVS1' 'IF');
    
    
    Array dummy_cut[*] cut1 - cut5;
    Array dummy_color[*] color1 - color7;
    Array dummy_clarity[*] clarity1 - clarity8;
    
    Do i = 1 to dim(dummy_cut);
        Do j = 1 to dim(dummy_color);
            Do k = 1 to dim(dummy_clarity);
                dummy_cut(i) = 0;
                dummy_color(j) = 0;
                dummy_clarity(k) = 0;
            End;
        End;
    End;
    
    Do i = 1 to dim(cut_grade);
       If cut_grade[i] = Strip(cut) Then dummy_cut[i] = 1;
    End;
    
    Do i = 1 to dim(color_grade);
       If color_grade[i] = Strip(color) Then dummy_color[i] = 1;
    End;
    
    Do I = 1 to dim(clarity_grade);
       If clarity_grade[i] = Strip(clarity) Then dummy_clarity[i] = 1;
    End;
    
    Select (cut);
        when ('Fair')      cut_ord = 1;     /* Lowest level of fire and brilliance */
        when ('Good')      cut_ord = 2;
        when ('Very Good') cut_ord = 3;
        when ('Premium')   cut_ord = 4;
        when ('Ideal')     cut_ord = 5;     /* Highest level of fire and brilliance */
        otherwise
        ;
    End;

    Select (color);
        when ('J') color_ord = 1;
        when ('I') color_ord = 2;
        when ('H') color_ord = 3;
        when ('G') color_ord = 4;           /* G-J = Nearly Colorless */
        when ('F') color_ord = 5;           
        when ('E') color_ord = 6;           
        when ('D') color_ord = 7;           /* D-F = Colorless is highest color grade */
        otherwise
        ;
    End;

    Select (clarity);
        when ('I1')   clarity_ord = 1;      /* Inclusions 1 is the worst */
        when ('SI2')  clarity_ord = 2;      /* Small Inclusions 1 */
        when ('SI1')  clarity_ord = 3;      /* Small Inclusions 2 */
        when ('VS2')  clarity_ord = 4;      /* Very Small Inclusions 1 */
        when ('VS1')  clarity_ord = 5;      /* Very Small Inclusions 2 */
        when ('VVS2') clarity_ord = 6;      /* Very Very Small Inclusions 1 */
        when ('VVS1') clarity_ord = 7;      /* Very Very Small Inclusions 2 */
        when ('IF')   clarity_ord = 8;      /* Internally Flawless is the best */
        otherwise
        ;
    End;
Run;



/*----------------Splitting------------*/
/*-------------------------------------*/
proc surveyselect data=fkiaie.diamonds_FE
    out=Diamonds_Train_Valid
    method=SRS
    samprate=0.7     /* Wanted Training Dataset 70% */
    seed=1357924
    outall; 
run;

Data fkiaie.DiamondsFE_Training fkiaie.DiamondsFE_Validation;
    Set Diamonds_Train_Valid;
    If Selected Then 
        output fkiaie.DiamondsFE_Training;
    Else 
        output fkiaie.DiamondsFE_Validation;
Run;


/*----------------Modeling------------*/
/*-------------------------------------*/
/**building the model**/
ODS graphics on;
Proc GLMSELECT data=fkiaie.DiamondsFE_Training
               outdesign=DiamondsFE_Design;
               
     Class Cut Color Clarity;
     Model logprice = logcarat logcarat|cut|color|clarity @2;
      
Run;

Proc REG Data=DiamondsFE_Design;
     ODS Output ParameterEstimates=fkiaie.Model_C_Parameters;
     MODEL_C: Model logprice = &_GLSMOD;

Run;
ODS graphics off;


/**Apply Feature Engineering To Test Diamonds**/
/* 
   -Natural Log Transformation for Carat
   -One Hot Encoding for Categorical Variables
   -Ordinal Variable for Categorical Variables
*/
Data fkiaie.TestDiamonds_FE (drop=i j k);
    Set fkiaie.testdiamonds;
    logcarat = log(1+carat);

    Array cut_grade[5]     $9 _temporary_ ('Fair' 'Good' 'Very Good' 'Premium' 'Ideal');
    Array color_grade[7]   $1 _temporary_ ('J' 'I' 'H' 'G' 'F' 'E' 'D');
    Array clarity_grade[8] $4 _temporary_ ('I1' 'SI2' 'SI1' 'VS2' 'VS1' 'VVS2' 'VVS1' 'IF');
    
    
    Array dummy_cut[*] cut1 - cut5;
    Array dummy_color[*] color1 - color7;
    Array dummy_clarity[*] clarity1 - clarity8;
    
    Do i = 1 to dim(dummy_cut);
        Do j = 1 to dim(dummy_color);
            Do k = 1 to dim(dummy_clarity);
                dummy_cut(i) = 0;
                dummy_color(j) = 0;
                dummy_clarity(k) = 0;
            End;
        End;
    End;
    
    Do i = 1 to dim(cut_grade);
       If cut_grade[i] = Strip(cut) Then dummy_cut[i] = 1;
    End;
    
    Do i = 1 to dim(color_grade);
       If color_grade[i] = Strip(color) Then dummy_color[i] = 1;
    End;
    
    Do I = 1 to dim(clarity_grade);
       If clarity_grade[i] = Strip(clarity) Then dummy_clarity[i] = 1;
    End;
    
    Select (cut);
        when ('Fair')      _cut_ord = 1;     /* Lowest level of fire and brilliance */
        when ('Good')      _cut_ord = 2;
        when ('Very Good') _cut_ord = 3;
        when ('Premium')   _cut_ord = 4;
        when ('Ideal')     _cut_ord = 5;     /* Highest level of fire and brilliance */
        otherwise
        ;
    End;

    Select (color);
        when ('J') _color_ord = 1;
        when ('I') _color_ord = 2;
        when ('H') _color_ord = 3;
        when ('G') _color_ord = 4;           /* G-J = Nearly Colorless */
        when ('F') _color_ord = 5;           
        when ('E') _color_ord = 6;           
        when ('D') _color_ord = 7;           /* D-F = Colorless is highest color grade */
        otherwise
        ;
    End;

    Select (clarity);
        when ('I1')   _clarity_ord = 1;      /* Inclusions 1 is the worst */
        when ('SI2')  _clarity_ord = 2;      /* Small Inclusions 1 */
        when ('SI1')  _clarity_ord = 3;      /* Small Inclusions 2 */
        when ('VS2')  _clarity_ord = 4;      /* Very Small Inclusions 1 */
        when ('VS1')  _clarity_ord = 5;      /* Very Small Inclusions 2 */
        when ('VVS2') _clarity_ord = 6;      /* Very Very Small Inclusions 1 */
        when ('VVS1') _clarity_ord = 7;      /* Very Very Small Inclusions 2 */
        when ('IF')   _clarity_ord = 8;      /* Internally Flawless is the best */
        otherwise
        ;
    End;
Run;



/**model prediction and evaluation**/
ODS graphics on;

/* Prepare Unknown dataset for prediction */
Data DiamondsFE_Validation (keep=DS logprice logcarat cut color clarity);
    Retain DS logprice logcarat cut color clarity;
    Set fkiaie.DiamondsFE_Validation;
    Format DS $10.;
    Format cut $11.;
    Format color $3.;
    Format clarity $6.;

    DS = "VALIDATION";    
Run;

Data TestDiamonds_FE (Keep=DS logcarat carat cut color clarity);
    Retain DS logcarat carat cut color clarity;
    Set fkiaie.TestDiamonds_FE;    
    Format DS $10.;
    Format cut $11.;
    Format color $3.;
    Format clarity $6.;

    DS = "TEST";
Run;

Data Unknown_TestDiamonds;
    Set DiamondsFE_Validation TestDiamonds_FE;
Run;

Proc GLMSELECT data=Unknown_TestDiamonds
     PLOTS=ALL;
     Class Cut Color Clarity;
     Model logprice = logcarat|cut|color|clarity @2 / choose =adjrsq 
                                                              showpvalues 
                                                              stats=all;
     output out=Diamonds_Predicted_Model_C 
            predicted=Predicted_Price_C;
Run;

ODS Graphics off;

Data Diamonds_Predicted_Model_C (drop=logprice logcarat);
    Set Diamonds_Predicted_Model_C;
    If DS = "TEST";
    Predicted_Price_C = exp(Predicted_Price_C)-1;
Run;

Proc Sort Data=Diamonds_Predicted_Model_C;
    By carat clarity color cut;
Run;


