@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Processor travel 1'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo.typeName: 'Travel'
@UI.headerInfo.typeNamePlural: 'Travel Details'

define root view entity z_p_travel1
  as projection on z_i_travel1
{

      @UI.facet: [{ type: #IDENTIFICATION_REFERENCE, purpose: #STANDARD, label: 'Travel', position: 10 },
                  {id: 'Booking', targetElement: '_booking', type: #LINEITEM_REFERENCE, purpose: #STANDARD, label: 'Bookings', position: 20 }]

      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'z_i_travel1',element: 'TravelId'} }]
  key TravelId,

      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Agency',element: 'AgencyID'} }]
      @ObjectModel.text.element: [ 'agency' ]
      AgencyId,
      _agency.Name        as agency,

      @UI.selectionField: [{ position: 30 }]
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Customer',element: 'CustomerID'} }]
      @ObjectModel.text.element: [ 'customer' ]
      CustomerId,
      _customer.FirstName as customer,

      @UI.identification: [{ position: 40 }]
      BeginDate,

      @UI.identification: [{ position: 50 }]
      EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.identification: [{ position: 60 }]
      BookingFee,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 70 }]
      TotalPrice,

      CurrencyCode,

      @UI.identification: [{ position: 80 }]
      Description,

      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 90 }]
      Status,

      @UI.lineItem: [{ position: 10, label: 'Copy Travel', type: #FOR_ACTION, dataAction: 'copytravel' }]
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,

      _agency,
      _customer,
      _booking : redirected to composition child z_p_book1




}
