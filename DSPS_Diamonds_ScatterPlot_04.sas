/* Add a Regression Fit Line */
ODS graphics on;

Proc sgplot data=MCT.diamonds_clean1 noborder noautolegend;
    reg x=carat y=price / lineattrs=(color=red thickness=3 pattern=2)
                          markerattrs=(color=dodgerblue size=5)
                          cli
                          cliattrs=(clilineattrs=(color=green thickness=3 pattern=20))
                          ;
    title color=white "ScatterPlot of Price by Carat with Fit Line";
    footnote color=white "Remark: data has carat > 3";
    
    xaxis label="carat"
          labelattrs=(color=white weight=bold)
          values = (0 1 2 3)
          valueattrs=(color=white)
          minor display=(noline)
          ;
    yaxis label="Price of Diamonds"
          labelattrs=(color=white weight=bold)
          valueattrs=(color=white)
          grid
          gridattrs=(color=lightgray)
          minorgrid
          minorgridattrs=(color=lightgray)
          display=(noline noticks)
          min=0 max=20000
          ;
    format price DOLLAR.;
    
Run;

ODS graphics off;