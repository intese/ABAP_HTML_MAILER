class zcl_mailer definition
  public
  final
  create public.

  public section.
    interfaces zif_mailer.

    aliases send for zif_mailer~send.
    aliases create for zif_mailer~create.
    aliases build for zif_mailer~build.
    aliases add_recipient for zif_mailer~add_recipient.

  protected section.
  private section.

    data mo_mailer type ref to lif_bcs.
    data mv_recipient type adr6-smtp_addr.
    data mv_subject type so_obj_des.
    data mt_body type soli_tab.

    methods raise_exception
      importing obj type ref to cx_bcs
      raising   zcx_mailer.
endclass.


class zcl_mailer implementation.

  method create.
    mv_recipient = iv_recipient.
    mv_subject = iv_subject.
    mt_body = it_body.
  endmethod.

  method build.

    if mo_mailer is not bound.
      mo_mailer = new lcl_bcs( ).
    endif.

    try.
        mo_mailer->create_persistent( ).
      catch cx_send_req_bcs into data(exc_create_persistent).
        raise_exception( exc_create_persistent ).
    endtry.

    try.
        mo_mailer->create_document(
         i_type = 'HTM'
         i_text = mt_body
         i_subject = mv_subject
        ).
      catch cx_document_bcs into data(exc_create_document).
        raise_exception( exc_create_document ).
    endtry.

    try.
        mo_mailer->set_document( ).
      catch cx_send_req_bcs into data(exc_set_document).
        raise_exception( exc_set_document ).
    endtry.

    try.
        mo_mailer->create_sender( sy-uname ).
      catch cx_address_bcs into data(exc_create).
        raise_exception( exc_create ).
    endtry.

    try.
        mo_mailer->set_sender( ).
      catch cx_send_req_bcs into data(exc_set_sender).
        raise_exception( exc_set_sender ).
    endtry.

    try.
        mo_mailer->create_internet_address( mv_recipient ).
      catch cx_address_bcs into data(exc_create_internet_address).
        raise_exception( exc_create_internet_address ).
    endtry.

    try.
        mo_mailer->add_recipient( ).
      catch cx_send_req_bcs into data(exc_add_recipient).
        raise_exception( exc_add_recipient ).
    endtry.
  endmethod.

  method add_recipient.
    try.
        mo_mailer->add_recipient(
          iv_recipient  = iv_recipient
          iv_copy       = iv_copy
          iv_blind_copy = iv_blind_copy
          iv_no_forward = iv_no_forward
        ).
      catch cx_send_req_bcs.
    endtry.
  endmethod.

  method send.
    if mo_mailer is not bound.
      me->build( ).
    endif.

    try.
        if immediately eq abap_true.
          " Sofort senden – nicht in SCOT Queue
          mo_mailer->send_immediately( abap_true ).
        else.
          " Senden über SCOT Queue
          mo_mailer->send( i_priority = i_priority ).
        endif.
      catch cx_send_req_bcs into data(exc_set_send_immediately).
        raise_exception( exc_set_send_immediately ).
    endtry.

    if commit_work eq abap_true.
      commit work.
    endif.
  endmethod.

  method raise_exception.
    raise exception type zcx_mailer
      exporting
        t100_msgid = obj->msgid
        t100_msgno = obj->msgno
        t100_msgv1 = obj->msgv1
        t100_msgv2 = obj->msgv2
        t100_msgv3 = obj->msgv3
        t100_msgv4 = obj->msgv4.
  endmethod.
endclass.
