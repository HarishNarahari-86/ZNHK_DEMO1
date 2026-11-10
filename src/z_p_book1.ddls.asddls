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
      BookingDate,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 40 }]
      @ObjectModel.text.element: [ 'customer' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Customer',element: 'CustomerID'} }]
      CustomerId,
      _customer.FirstName as customer,

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 50 }]
      @ObjectModel.text.element: [ 'carrier' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Carrier',element: 'AirlineID'} }]
      CarrierId,
      _carrier.Name as carrier,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 60 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Connection',element: 'ConnectionID'},
                                           additionalBinding: [{ localElement: 'CarrierId', element: 'AirlineID' }]}]
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
