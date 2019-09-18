/* Apply Feature Engineering and Log Transformation */
Data MCT.Diamonds_FE;
    Set MCT.diamonds_clean2;
    logprice = log(1+price);             
    logcarat = log(1+carat);

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
