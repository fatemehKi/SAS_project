/* Remove Overplotting */
ODS graphics on;

Proc sgplot data=MCT.diamonds_clean2;
    scatter x=carat y=price / transparency=0.9
                              markerattrs=(symbol=circlefilled
                                           size=5
                                           color=dodgerblue)                                        
                             ;
    title color=white "ScatterPlot of Price by Carat";
    footnote color=white "Remark: data has carat > 3";
    
    xaxis label="carat"
          labelattrs=(color=dimgray weight=bold)
          values = (0 1 2 3)
          valueattrs=(color=gray)
          minor display=(noline)
          ;
    yaxis label="Price of Diamonds"
          labelattrs=(color=dimgray weight=bold)
          valueattrs=(color=gray)
          grid
          gridattrs=(color=lightgray)
          minorgrid
          minorgridattrs=(color=lightgray)
          display=(noline noticks)
          ;
    format price DOLLAR.;
    
Run;

ODS graphics off;