*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*&--------------------------------------------------------
*& lcl_mail_facade implementation
*&--------------------------------------------------------
class lcl_bcs implementation.

  method create_persistent.
    mo_send_request = cl_bcs=>create_persistent( ).
  endmethod.

  method create_document.
    mo_document = cl_document_bcs=>create_document(
      i_type = i_type
      i_text = i_text
      i_subject = i_subject
    ).
  endmethod.

  method set_document.
    mo_send_request->set_document( mo_document ).
  endmethod.

  method create_sender.
    mo_sender = cl_sapuser_bcs=>create( i_user ).
  endmethod.

  method set_sender.
    mo_send_request->set_sender( mo_sender ).
  endmethod.

  method create_internet_address.
    mo_receiver = cl_cam_address_bcs=>create_internet_address( i_address_string ).
  endmethod.

  method add_recipient.
    data recipient type ref to if_recipient_bcs.
    if iv_recipient is not initial.
      try.
          recipient = cl_cam_address_bcs=>create_internet_address( iv_recipient ).
        catch cx_root.
      endtry.
    else.
      recipient = mo_receiver.
    endif.

    mo_send_request->add_recipient(
      i_recipient = recipient
      i_copy = iv_copy
      i_blind_copy = iv_blind_copy
      i_no_forward = iv_no_forward
    ).
  endmethod.

  method send_immediately.
    mo_send_request->set_send_immediately( i_send_immediately ).
  endmethod.

  method send.
    if i_priority is not initial.
      mo_send_request->set_priority( i_priority  ).
    endif.
    mo_send_request->send( ).
  endmethod.

endclass.
