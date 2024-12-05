*"* use this source file for your ABAP unit test classes
class ltcl_html_builder definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      created_html_code for testing raising cx_static_check,
      html_as_soli_tab for testing raising cx_static_check.
endclass.


class ltcl_html_builder implementation.

  method created_html_code.
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

    cl_abap_unit_assert=>assert_equals(
      act = lo_div->get_html( )
      exp = |<div id='mydiv'><table class='maintab'><tr><td>Col</td><td>Col</td><td>Col</td><td>Col</td><td>Col</td></tr></table></div>|
    ).

  endmethod.

  method html_as_soli_tab.
    data expected type soli_tab.
    expected = value #(
      ( |<div style='color: red'>Bar| )
      ( |<div style='color: blue'>Foo| )
      ( |<div style='color: green'>Baz| )
      ( |</div>| )
      ( |</div>| )
      ( |</div>| )
    ).

    data(lo_div_1) = new zcl_html_builder( ).
    lo_div_1->create_element( 'div' ).
    lo_div_1->add_attribute(
      exporting
        attr = 'style'
        val  = 'color: red'
    ).
    lo_div_1->add_inner_html( 'Bar' ).

    data(lo_div_2) = new zcl_html_builder( ).
    lo_div_2->create_element( 'div' ).
    lo_div_2->add_attribute(
      exporting
        attr = 'style'
        val  = 'color: blue'
    ).
    lo_div_2->add_inner_html( 'Foo' ).

    data(lo_div_3) = new zcl_html_builder( ).
    lo_div_3->create_element( 'div' ).
    lo_div_3->add_attribute(
      exporting
        attr = 'style'
        val  = 'color: green'
    ).
    lo_div_3->add_inner_html( 'Baz' ).

    lo_div_2->append_child( lo_div_3 ).
    lo_div_1->append_child( lo_div_2 ).

    data(result) = lo_div_1->as_soli_tab( ).

    cl_abap_unit_assert=>assert_equals(
      act = result
      exp = expected
    ).
  endmethod.

endclass.
