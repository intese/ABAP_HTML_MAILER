# ZABAP_HTML_MAILER
Mail wrapper utilities for CL_BCS framework

## How to use ZCL_HTML_BUILDER
```abap
    data(lo_div) = new zcl_html_builder( ).
    lo_div->create_element( 'div' ).
    lo_div->add_attribute( attr = 'id' val = 'mydiv' ).

    data(lo_tab) = new zcl_html_builder( ).
    lo_tab->create_element( 'table' ).
    lo_tab->add_attribute( attr = 'class' val = 'maintab' ).

    data(lo_tr) = new zcl_html_builder( ).
    lo_tr->create_element( 'tr' ).

    do 5 times.
      data(lo_td) = new zcl_html_builder( ).
      lo_td->create_element( 'td' ).
      lo_td->add_inner_html( 'Col' ).
      lo_tr->append_child( lo_td ).
    enddo.

    lo_tab->append_child( lo_tr ).
    lo_div->append_child( lo_tab ).
    data(result) = lo_div->get_html( ).
    " <div id='mydiv'><table class='maintab'><tr><td>Col</td><td>Col</td><td>Col</td><td>Col</td><td>Col</td></tr></table></div>
```

## How to use ZCL_MAILER
```abap
* first create your html-based mail with zcl_html_builder...
data(lo_builder) = new zcl_html_builder( ).
* ...

* then create new object with zcl_mailer
data(lo_mailer) = new zcl_mailer( ).
lo_mailer->create(
    iv_recipient = 'recipient@mail.example'
    iv_subject = 'Your subject'
    it_body = lo_builder->html_as_soli_tab( )
).

* then send your mail...
try.
lo_mailer->send(
    immediately = abap_false " send via SCOT Queue or with abap_true for immediately
    commit_work = abap_true " run commit_work after execute
    i_priority = 2 " set your priority
).
catch zcx_mailer.
    " Error handling here...
endtry.
```
