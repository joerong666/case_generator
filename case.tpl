$(case_name)
    [Documentation]    $(doc)
    [Tags]  $(keyword)
    [Template]  $(keyword)
    :FOR  ${desc}  ${addr}  IN  Proxy  ${proxy_addr}
    \\     $(args)  desc=${desc}  addr=${addr}
