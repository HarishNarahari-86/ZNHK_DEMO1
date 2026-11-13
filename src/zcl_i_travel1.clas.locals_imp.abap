CLASS lhc_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR travel RESULT result.
    METHODS end_date FOR DETERMINE ON SAVE
       keys FOR travel~end_date.
    METHODS copytravel FOR MODIFY
       keys FOR ACTION travel~copytravel RESULT result.
    METHODS validate_travel FOR VALIDATE ON SAVE
       keys FOR travel~validate_travel.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR travel RESULT result.
    METHODS validate_mandatory FOR VALIDATE ON SAVE
       keys FOR travel~validate_mandatory.
    METHODS earlynumbering_create FOR NUMBERING
       entities FOR CREATE travel.

ENDCLASS.

CLASS lhc_TRAVEL IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD end_date.

    READ ENTITIES OF z_i_travel1 IN LOCAL MODE
    ENTITY travel
    FIELDS ( BeginDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).

      IF <fs_travel>-EndDate IS INITIAL.

        MODIFY ENTITIES OF z_i_travel1 IN LOCAL MODE
        ENTITY travel
        UPDATE FIELDS ( EndDate )
        WITH VALUE #( (  EndDate = <fs_travel>-BeginDate + 30 ) )
        MAPPED DATA(lt_mapped)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_Reported).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_create.

    SELECT MAX( travel_id ) FROM /dmo/travel INTO @DATA(lv_travel).

    DATA : lt_create_travel TYPE TABLE FOR CREATE z_i_travel1.

    DATA : lv_Cid TYPE i.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>).

      APPEND VALUE #(
      %cid = <fs_entity>-%cid
      %is_Draft = <fs_entity>-%is_draft
      travelid = lv_travel + 1

       ) TO mapped-travel.

    ENDLOOP.

  ENDMETHOD.

  METHOD copytravel.

    SELECT MAX( travel_id ) FROM /dmo/travel INTO @DATA(lv_travel).

    DATA : lt_copy_travel TYPE TABLE FOR CREATE z_i_travel1.

    READ ENTITIES OF z_i_travel1 IN LOCAL MODE
    ENTITY travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    lt_copy_travel = VALUE #( FOR ls_travel IN lt_travel (
    %cid = |ls_travel{ lv_travel }|
    AgencyId = ls_TRavel-AgencyId
    CustomerId = ls_travel-CustomerId
    CurrencyCode = ls_travel-CurrencyCode
    %control-AgencyId = if_abap_behv=>mk-on
    %control-customerid = if_abap_behv=>mk-on
    %control-CurrencyCode = if_abap_behv=>mk-on
    ) ).

    MODIFY ENTITIES OF z_i_travel1 IN LOCAL MODE
     ENTITY travel
     CREATE FROM lt_copy_travel
     MAPPED DATA(lt_mapped)
     FAILED DATA(lt_failed)
     REPORTED DATA(lt_reported).

    result = VALUE #( FOR source IN keys INDEX INTO idx
      LET new_cid = lt_copy_travel[ idx ]-%cid IN (

      %cid_ref = source-%cid_ref
      %key = keys[ idx ]-%key
      %param-TravelId = lt_mapped-travel[ %cid = new_cid ]-TravelId

  ) ).

  ENDMETHOD.

  METHOD validate_travel.

    READ ENTITIES OF z_i_travel1 IN LOCAL MODE
    ENTITY travel
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_validate_travel).


    LOOP AT lt_validate_travel ASSIGNING FIELD-SYMBOL(<fs_validate_travel>).

      IF <fs_validate_travel>-bookiNGFEE LE '0.00'.

        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
    ) TO failed-travel.


        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Booking Fee should not be empty'
               )
               %element-bookingfee = if_abap_behv=>mk-on

        ) TO reported-travel.

      ENDIF.

      IF <fs_validate_travel>-totalprice LE '0.00'.

        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
    ) TO failed-travel.


        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Total Price should not be empty'
               )

               %element-totalprice = if_abap_behv=>mk-on

        ) TO reported-travel.
      ENDIF.

      IF <fs_validate_travel>-status IS INITIAL.

        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
    ) TO failed-travel.


        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Status should not be empty'
               )

               %element-status = if_abap_behv=>mk-on
        ) TO reported-travel.

      ENDIF.

      IF <fs_validate_travel>-BeginDate > <fs_validate_travel>-EndDate.

        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
    ) TO failed-travel.


        APPEND VALUE #(
        %tky = <fs_validate_travel>-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'End date should be greater than Start date'
               )
               %element-ENDdATE = if_abap_behv=>mk-on

        ) TO reported-travel.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF z_i_travel1 IN LOCAL MODE
    ENTITY travel
    FIELDS ( AgencyId CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).

      result = VALUE #( FOR keyval IN keys (
      %tky = keyval-%tky
      %features-%field-AgencyId = COND #( WHEN <fs_travel>-AgencyId IS NOT INITIAL THEN if_abap_behv=>fc-f-read_only
      ELSE if_abap_behv=>fc-f-mandatory )
      %features-%field-CustomerId = COND #( WHEN <fs_travel>-CustomerId IS NOT INITIAL THEN if_abap_behv=>fc-f-read_only
      ELSE if_abap_behv=>fc-f-mandatory )

      ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD validate_mandatory.

    READ ENTITIES OF z_i_travel1 IN LOCAL MODE
    ENTITY travel
    FIELDS ( AgencyId CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    LOOP AT lt_travel INTO DATA(ls_travel).

      IF ls_travel-AgencyId IS INITIAL OR ls_Travel-CustomerId IS INITIAL.

        APPEND VALUE #(
        %tky = ls_Travel-%tky
        ) TO failed-travel.

        APPEND VALUE #(
            %tky = ls_travel-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = 'Fill the mandatory fields'
                   )
                   %element-agencyid = if_Abap_behv=>mk-on
                   %element-customerid = if_Abap_behv=>mk-on
        ) TO reported-travel.


      ENDIF.



    ENDLOOP.


  ENDMETHOD.






































ENDCLASS.
