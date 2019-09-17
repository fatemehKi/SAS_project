proc template;
    define statgraph hist;
        begingraph;
            layout overlay / yaxisOpts=(griddisplay=on);
                histogram weight / binAxis=false group=sex
                                   datatransparency=0.5 nBins=50
                                   filltype=solid name="h";
                densityPlot weight / group=sex
                                     lineattrs=(thickness=GraphFit:lineThickness);
                discretelegend "h" / location=inside
                                     halign=right valign=top;
            endlayout;
        endgraph;
    end;
run;

proc sgrender data=sashelp.heart template=hist;
run;
