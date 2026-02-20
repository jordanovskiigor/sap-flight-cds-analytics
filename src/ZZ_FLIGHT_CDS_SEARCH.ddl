@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view search'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZZ_FLIGHT_CDS_SEARCH
  as select from sflight
  association [1..1] to scarr as _Carrier    on  $projection.Carrid = _Carrier.carrid
  association [1..1] to spfli as _Connection on  $projection.Carrid = _Connection.carrid
                                             and $projection.Connid = _Connection.connid

{
  key carrid                as Carrid,
  key connid                as Connid,
  key fldate                as Fldate,
      @Semantics.amount.currencyCode: 'Currency'
      price                 as Price,
      currency              as Currency,
      planetype             as Planetype,
      seatsmax              as Seatsmax,
      seatsocc              as Seatsocc,
      @Semantics.amount.currencyCode: 'Currency'
      paymentsum            as Paymentsum,
      seatsmax_b            as SeatsmaxB,
      seatsocc_b            as SeatsoccB,
      seatsmax_f            as SeatsmaxF,
      seatsocc_f            as SeatsoccF,

      _Carrier.carrname     as Carrname,
      _Connection.cityfrom  as Cityfrom,
      _Connection.cityto    as Cityto,
      _Connection.countryfr as Countryfr,
      _Connection.countryto as Countryto,

      cast(
           (
              (seatsocc + seatsocc_b + seatsocc_f) * 100
           /
              (seatsmax + seatsmax_b + seatsmax_f)
           )
           as abap.dec(5, 2)

      )                     as Occupation,

      case
      when
       cast(
           (
              (seatsocc + seatsocc_b + seatsocc_f) * 100
           /
              (seatsmax + seatsmax_b + seatsmax_f)
           )
           as abap.dec(5, 2)

      ) > 90
      then 'A'
      else 'B'
      end                   as Popularity,

      case
      when _Connection.countryfr = _Connection.countryto
      then 'Domestic'
      else 'International'
      end                   as Scope

}

where
  currency = 'EUR'