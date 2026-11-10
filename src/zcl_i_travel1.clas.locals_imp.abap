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


  ENDMETHOD.

ENDCLASS.
