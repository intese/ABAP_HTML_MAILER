interface zif_mailer
  public .

  methods create
    importing
      iv_recipient type adr6-smtp_addr
      iv_subject   type so_obj_des
      it_body      type soli_tab.

  methods !build
    raising zcx_mailer.

  methods !send
    importing
              immediately type abap_bool default abap_false
              commit_work type abap_bool default abap_false
              i_priority  type so_snd_pri optional
    raising   zcx_mailer.

  methods add_recipient
    importing
      iv_recipient  type adr6-smtp_addr optional
      iv_copy       type os_boolean optional
      iv_blind_copy type os_boolean optional
      iv_no_forward type os_boolean optional
    raising
      cx_send_req_bcs .
endinterface.
