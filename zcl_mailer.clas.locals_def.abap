*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

interface lif_bcs.
  methods create_persistent
    returning
              value(result) type ref to cl_bcs
    raising   cx_send_req_bcs.

  methods create_document
    importing
      value(i_type)         type so_obj_tp
      value(i_subject)      type so_obj_des
      value(i_length)       type so_obj_len optional
      value(i_language)     type so_obj_la default space
      value(i_importance)   type bcs_docimp optional
      value(i_sensitivity)  type so_obj_sns optional
      !i_text               type soli_tab optional
      !i_hex                type solix_tab optional
      !i_header             type soli_tab optional
      value(i_sender)       type ref to cl_cam_address_bcs optional
      value(iv_vsi_profile) type vscan_profile optional
    raising
      cx_document_bcs.

  methods set_document
    raising
      cx_send_req_bcs.

  methods create_sender
    importing
      value(i_user) type uname
    raising
      cx_address_bcs.

  methods set_sender
    raising
      cx_send_req_bcs.

  methods create_internet_address
    importing
      !i_address_string type adr6-smtp_addr
      i_address_name    type adr6-smtp_addr optional
      !i_incl_sapuser   type os_boolean optional
    raising
      cx_address_bcs.

  methods add_recipient
    importing
      iv_recipient  type adr6-smtp_addr optional
      iv_copy       type os_boolean optional
      iv_blind_copy type os_boolean optional
      iv_no_forward type os_boolean optional
    raising
      cx_send_req_bcs.

  methods send_immediately
    importing
      value(i_send_immediately) type os_boolean
    raising
      cx_send_req_bcs.

  methods send
    importing
      !i_with_error_screen type os_boolean default space
      i_priority           type so_snd_pri optional
    raising
      cx_send_req_bcs.
endinterface.
*&--------------------------------------------------------
*& lcl_mail_facade definition
*&--------------------------------------------------------
class lcl_bcs definition final create public.

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

  private section.
    data: mo_send_request type ref to cl_bcs,
          mo_document     type ref to cl_document_bcs,
          mo_sender       type ref to cl_sapuser_bcs,
          mo_receiver     type ref to if_recipient_bcs.


endclass.
