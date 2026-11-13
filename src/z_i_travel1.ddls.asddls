@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Travel'
@Metadata.ignorePropagatedAnnotations: true

define root view entity z_i_travel1
  as select from /dmo/travel as _travel
  association [1] to /DMO/I_Agency   as _agency   on $projection.AgencyId = _agency.AgencyID
  association [1] to /DMO/I_Customer as _customer on $projection.CustomerId = _customer.CustomerID

  composition [1..*] of z_i_book1    as _booking
{

  key travel_id     as TravelId,
      agency_id     as AgencyId,
      customer_id   as CustomerId,
      begin_date    as BeginDate,
      end_date      as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee   as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price   as TotalPrice,
      currency_code as CurrencyCode,
      description   as Description,
      status        as Status,

      case status
      when  'N' then 5
      when  'B' then 3
      when  'P' then 2
      when  'X' then 1
      else 0
      end           as statuscritical,


      createdby     as Createdby,
      createdat     as Createdat,
      lastchangedby as Lastchangedby,
      lastchangedat as Lastchangedat,

      _agency,
      _customer,
      _booking
}
