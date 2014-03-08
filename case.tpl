$(case_name)
    [Documentation]    $(doc)
    [Template]  $(keyword)
    :FOR  ${desc}  ${addr}  IN  Proxy  ${proxy_addr}
    \\     ${desc}  ${addr}  $(args)
