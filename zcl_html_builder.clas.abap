class zcl_html_builder definition
  public
  final
  create public .

  public section.
    methods:
      create_element importing tag type string,   " new element
      add_attribute importing attr type string    " add any attribute
                              val  type string,
      add_inner_html importing val type string,   " Inner text
      append_child                                " Add a child
        importing io_tag type ref to zcl_html_builder,
      get_html
        returning value(rv_string) type string,   " Get HTML string
      as_soli_tab
        returning value(r_tab) type soli_tab.
  private section.
    data: tag type string.
    data: inner_html type string.
    types:
      begin of ty_attr,
        attr type string,
        val  type string,
      end of ty_attr.
    data: attrs type standard table of ty_attr.
    data: children type standard table of ref to zcl_html_builder.
endclass.



class zcl_html_builder implementation.
  method create_element.
    me->tag = tag.
  endmethod.                    "create_element

  method append_child.
    append io_tag to me->children.
  endmethod.                    "append_child

  method add_attribute.
    data: ls_attr like line of me->attrs.
    ls_attr-attr = attr.
    ls_attr-val  = val.
    append ls_attr to me->attrs.
  endmethod.                    "add_attribute

  method add_inner_html.
    me->inner_html = val.
  endmethod.                    "add_inner_html

  method get_html.

    data: lv_string type string.
    data: lv_attr_val type string.
    data: ls_attr like line of me->attrs.
    data: lo_child type ref to zcl_html_builder.
    data: lv_child_html type string.

    " opening bracket
    concatenate `<` me->tag into lv_string.
    loop at me->attrs into ls_attr.
      concatenate ls_attr-attr `='` ls_attr-val `'`
        into lv_attr_val.
      concatenate lv_string lv_attr_val
        into lv_string separated by space.
    endloop.
    concatenate lv_string `>` into lv_string.

    " inner html
    concatenate lv_string me->inner_html into lv_string.

    " child
    loop at me->children into lo_child.
      lv_child_html = lo_child->get_html( ).
      concatenate lv_string lv_child_html
        into lv_string.
      clear lv_child_html.
    endloop.

    " closing
    concatenate lv_string `</` me->tag `>`
     into lv_string.

    " back the HTML
    rv_string = lv_string.

  endmethod.                    "zcl_html_builder

  method as_soli_tab.
    data: lv_string type string.
    data: lv_attr_val type string.
    data: ls_attr like line of me->attrs.
    data: lo_child type ref to zcl_html_builder.

    " opening bracket
    concatenate `<` me->tag into lv_string.
    loop at me->attrs into ls_attr.
      concatenate ls_attr-attr `='` ls_attr-val `'`
        into lv_attr_val.
      concatenate lv_string lv_attr_val
        into lv_string separated by space.
    endloop.
    concatenate lv_string `>` into lv_string.

    " inner html
    concatenate lv_string me->inner_html into lv_string.

    r_tab = value #( base r_tab ( conv soli( lv_string ) ) ).

    clear lv_string.

    " child
    loop at me->children into lo_child.
      data(lt_childs) = lo_child->as_soli_tab( ).
      loop at lt_childs reference into data(ls_child).
        append ls_child->* to r_tab.
      endloop.
    endloop.

    " closing
    concatenate lv_string `</` me->tag `>`
     into lv_string.

    " back the HTML
    r_tab = value #( base r_tab ( conv soli( lv_string ) ) ).
  endmethod.

endclass.
