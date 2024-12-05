# ZBC_TOOLS_MAILER
Mail wrapper utilities for CL_BCS framework


## How to use ZCL_HTML_BUILDER
```àbap
    data: lo_div type ref to zcl_html_builder.
    data: lo_tab type ref to zcl_html_builder.
    data: lo_tr  type ref to zcl_html_builder.
    data: lo_td  type ref to zcl_html_builder.

    create object lo_div.
    lo_div->create_element( 'div' ).
    lo_div->add_attribute( attr = 'id' val = 'mydiv' ).

    create object lo_tab.
    lo_tab->create_element( 'table' ).
    lo_tab->add_attribute( attr = 'class' val = 'maintab' ).

    create object lo_tr.
    lo_tr->create_element( 'tr' ).

    do 5 times.
      create object lo_td.
      lo_td->create_element( 'td' ).
      lo_td->add_inner_html( 'Col' ).
      lo_tr->append_child( lo_td ).
    enddo.

    lo_tab->append_child( lo_tr ).
    lo_div->append_child( lo_tab ).
    data(result) = lo_div->get_html( ).
    " <div id='mydiv'><table class='maintab'><tr><td>Col</td><td>Col</td><td>Col</td><td>Col</td><td>Col</td></tr></table></div>
```
