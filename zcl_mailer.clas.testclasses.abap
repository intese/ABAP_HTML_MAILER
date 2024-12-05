*"* use this source file for your ABAP unit test classes

***************** DOUBLES **************************************************
*&--------------------------------------------------------
*& ltd_lcl_bcs definition
*&--------------------------------------------------------
class ltd_lcl_bcs definition final create public.

  public section.
    interfaces lif_bcs.
    aliases:
      create_persistent for lif_bcs~create_persistent,
      create_document for lif_bcs~create_document,
      set_document for lif_bcs~set_document,
      create_sender for lif_bcs~create_sender,
      set_sender for lif_bcs~set_sender,
      create_internet_address for lif_bcs~create_internet_address,
      add_recipient for lif_bcs~add_recipient,
      send_immediately for lif_bcs~send_immediately,
      send for lif_bcs~send.

    methods constructor
      importing iv_meth_name type string.

  private section.
    data method_to_be_raise type string.

    methods my_name
      returning value(name) type string.

endclass.

*&--------------------------------------------------------
*& ltd_lcl_bcs implementation
*&--------------------------------------------------------
class ltd_lcl_bcs implementation.

  method constructor.
    method_to_be_raise = iv_meth_name.
  endmethod.

  method add_recipient.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_send_req_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method create_document.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_document_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method create_internet_address.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_address_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method create_persistent.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_send_req_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method create_sender.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_address_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method send.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_send_req_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method set_document.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_send_req_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method set_sender.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_send_req_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method send_immediately.
    data(curr_meth_name) = my_name( ).
    if method_to_be_raise eq curr_meth_name.
      raise exception type cx_send_req_bcs
        exporting
          msgv1 = |Exception via { curr_meth_name }|.
    endif.
  endmethod.

  method my_name.
    data lt_callstack type abap_callstack.

    call function 'SYSTEM_CALLSTACK'
      exporting
        max_level = 2
      importing
        callstack = lt_callstack.

    name = lt_callstack[ 2 ]-blockname.
  endmethod.

endclass.
***************** DOUBLES **************************************************

class ltcl_mailer definition deferred.
class zcl_mailer definition local friends ltcl_mailer.
class ltcl_mailer definition final for testing
  duration short
  risk level harmless.

  private section.
    data cut type ref to zcl_mailer.
    methods:
      setup,
      send_mail for testing raising cx_static_check,
      exceptions for testing raising cx_static_check,
      run_test
        importing meth_name type string.

endclass.


class ltcl_mailer implementation.

  method setup.
    cut = new #( ).
  endmethod.

  method send_mail.
    data body type soli_tab.

    data: rc    type                   sy-subrc,
          email type                   string,
          err   type standard table of rpbenerr.

    call function 'HR_FBN_GET_USER_EMAIL_ADDRESS'
      exporting
        user_id       = sy-uname
        reaction      = sy-msgty
      importing
        subrc         = rc
        email_address = email
      tables
        error_table   = err.

    body = value #( ( |<p>Erste <i>Zeile</i></p>| ) ( |<p><b>Zweite Zeile</b></p>| ) ).
    body = value #( base body ( |<p>Dritte <i>Zeile</i></p>| ) ( |<p><b>Vierte Zeile</b></p>| ) ).

    cut->create(
          iv_recipient = conv adr6-smtp_addr( email )
          iv_subject   = 'Test from SAP via UnitTest -> Direktversand'
          it_body      = body
      ).

    data(result) = abap_true.
    try.
        cut->send( immediately = abap_true commit_work = abap_true ).
      catch zcx_mailer into data(exc_error).
        cl_abap_unit_assert=>fail( exc_error->get_text( ) ).
        result = abap_false.
    endtry.

    cl_abap_unit_assert=>assert_true( result ).

  endmethod.

  method exceptions.
    data lt_methods type string_table.
    lt_methods = value #(
      ( |CREATE_PERSISTENT| )
      ( |CREATE_DOCUMENT| )
      ( |SET_DOCUMENT| )
      ( |CREATE_SENDER| )
      ( |SET_SENDER| )
      ( |CREATE_INTERNET_ADDRESS| )
      ( |ADD_RECIPIENT| )
      ( |SEND_IMMEDIATELY| )
      ( |SEND| )
    ).
    loop at lt_methods reference into data(rf_meth).
      me->run_test( rf_meth->* ).
    endloop.
  endmethod.

  method run_test.
    data body type soli_tab.
    data(lo_mailer) = new ltd_lcl_bcs( meth_name ).
    cut->mo_mailer = lo_mailer.
    cut->create(
      exporting
        iv_recipient = 'your_name_here@example.de' " should be in SAP exists!
        iv_subject   = 'Test from SAP via UnitTest -> Direktversand'
        it_body      = body
    ).

    data(result) = abap_false.
    try.
        case meth_name.
          when 'SEND_IMMEDIATELY'.
            cut->send( immediately = abap_true ).
          when 'SEND'.
            cut->send( ).
          when others.
            cut->build( ).
        endcase.
      catch zcx_mailer into data(exc).
        cl_abap_unit_assert=>assert_equals(
          act = exc->t100_msgv1
          exp = |Exception via { meth_name }|
        ).
        result = abap_true.
    endtry.
    cl_abap_unit_assert=>assert_true( result ).
  endmethod.

endclass.
