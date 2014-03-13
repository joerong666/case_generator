$(case_name)
    [Documentation]    $(doc)
    [Tags]  $(tags)
    [Template]  $(keyword)
    :FOR  ${desc}  ${addr}  IN  Proxy  ${proxy_addr}
    \\     $(args)  desc=${desc}  addr=${addr}
