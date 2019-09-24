/* Prepare the correlations coeff matrix: Pearson's r method */
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
 
%prepCorrData(in=MCT.Diamonds_clean2(drop=cut color clarity), 
              out=Diamonds_r);
proc sgrender data=Diamonds_r template=corrHeatmap;
   dynamic _title= "Correlation matrix for Diamonds";
run;

ODS graphics off;