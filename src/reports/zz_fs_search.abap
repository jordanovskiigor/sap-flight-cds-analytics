*&--------------------------------------------------------------------*
*& Report zz_fs_search
*&--------------------------------------------------------------------*
REPORT zz_fs_search LINE-SIZE 140.

TABLES sscrfields.

DATA:
  gv_date    TYPE s_date,
  gv_country TYPE s_country,
  gv_city    TYPE  s_city,
  gv_price   TYPE s_price.

SELECTION-SCREEN ULINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(18) t_date.
  SELECTION-SCREEN POSITION 20.
  SELECT-OPTIONS so_date FOR gv_date.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(18) t_cfr.
  SELECTION-SCREEN POSITION 20.
  SELECT-OPTIONS so_cfr FOR gv_country.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(18) t_cfrom.
  SELECTION-SCREEN POSITION 20.
  SELECT-OPTIONS so_cfrom FOR gv_city.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(18) t_cto.
  SELECTION-SCREEN POSITION 20.
  SELECT-OPTIONS so_cto FOR gv_country.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(18) t_cityto.
  SELECTION-SCREEN POSITION 20.
  SELECT-OPTIONS so_ctyto FOR gv_city.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 1(18) t_price.
  SELECTION-SCREEN POSITION 20.
  SELECT-OPTIONS so_price FOR gv_price.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN PUSHBUTTON 1(20) pb_clear USER-COMMAND clear.

INITIALIZATION.
  t_date = 'Flight Date'.
  t_cfr = 'Departure Country'.
  t_cfrom = 'Departure City'.
  t_cto = 'Destination Country'.
  t_cityto = 'Destination City'.
  t_price = 'Price'.
  pb_clear = 'Clear Input'.


AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'CLEAR'.

    CLEAR: so_date[], so_cfr[], so_cfrom[],
           so_cto[], so_ctyto[], so_price[].

  ENDIF.

START-OF-SELECTION.

  SELECT
    FROM zz_2007_cds_search
    FIELDS
      fldate,
      carrname,
      connid,
      cityfrom,
      cityto,
      occupation,
      popularity,
      scope,
      price
    WHERE fldate IN @so_date
      AND countryfr IN @so_cfr
      AND cityfrom IN @so_cfrom
      AND countryto IN @so_cto
      AND cityto IN @so_ctyto
      AND price IN @so_price
    INTO TABLE @DATA(lt_result).


  IF sy-subrc <> 0.
    MESSAGE 'No results found.' TYPE 'E'.
  ENDIF.

  WRITE: /'Search found ', sy-dbcnt, 'Flights'.

  ULINE (140).

  FORMAT COLOR COL_KEY.

  WRITE: / sy-vline, 'Date ',
           12 sy-vline, 'Airline ',
           32 sy-vline, 'Flight ',
           42 sy-vline, 'From ',
           60 sy-vline, 'To ',
           78 sy-vline, 'Occ(%) ',
           88 sy-vline, 'Pop ',
           95 sy-vline, 'Scope ',
           115 sy-vline, 'Price ',
           140 sy-vline.

  FORMAT RESET.
  ULINE (140).

  LOOP AT lt_result INTO DATA(ls_row).

    IF ls_row-popularity = 'A'.
      FORMAT COLOR COL_POSITIVE.
    ELSE.
      FORMAT COLOR COL_NEGATIVE.
    ENDIF.

    WRITE: / sy-vline, ls_row-fldate,
           12 sy-vline, ls_row-carrname,
           32 sy-vline, ls_row-connid,
           42 sy-vline, ls_row-cityfrom,
           60 sy-vline, ls_row-cityto,
           78 sy-vline, ls_row-occupation,
           88 sy-vline, ls_row-popularity,
           95 sy-vline, ls_row-scope,
           115 sy-vline, ls_row-price,
           140 sy-vline.

    FORMAT RESET.

  ENDLOOP.

  ULINE (140).