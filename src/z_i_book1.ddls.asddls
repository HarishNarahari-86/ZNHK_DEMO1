@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Book1'
@Metadata.ignorePropagatedAnnotations: true
define view entity z_i_book1
  as select from /dmo/booking_m as _booking

  association [1] to /DMO/I_Carrier     as _carrier  on  $projection.CarrierId = _carrier.AirlineID
  association [1] to /DMO/I_Connection  as _connect  on  $projection.CarrierId    = _connect.AirlineID
                                                     and $projection.ConnectionId = _connect.ConnectionID
  association [1] to /DMO/I_Customer    as _customer on  $projection.CustomerId = _customer.CustomerID

  association     to parent z_i_travel1 as _travel   on  $projection.TravelId = _travel.TravelId

{

  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      last_changed_at as LastChangedAt,

      _carrier,
      _connect,
      _customer,
      _travel

}
