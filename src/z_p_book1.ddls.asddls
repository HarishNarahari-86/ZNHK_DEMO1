@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Processor book 1'
@Metadata.ignorePropagatedAnnotations: true
define view entity z_p_book1
  as projection on z_i_book1
{
      @UI.facet: [{ type: #IDENTIFICATION_REFERENCE, purpose: #STANDARD, label: 'Booking Details', position: 10 }]

      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key TravelId,

      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
  key BookingId,

      @UI.identification: [{ position: 30 }]
//      @Consumption.valueHelpDefinition: [{ entity: {name: '',element: '' } }]
      BookingDate,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 40 }]
      @ObjectModel.text.element: [ 'customer' ]
      CustomerId,
      _customer.LastName as customer,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 50 }]
      @ObjectModel.text.element: [ 'carrier' ]
      CarrierId,
      _carrier.Name as carrier,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 60 }]
      ConnectionId,

      @UI.identification: [{ position: 70 }]
      FlightDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.identification: [{ position: 80 }]
      FlightPrice,

      CurrencyCode,

      BookingStatus,
      LastChangedAt,

      _carrier,
      _connect,
      _customer,
      _travel : redirected to parent z_p_travel1
}
