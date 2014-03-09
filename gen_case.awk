#!/bin/env awk -f

BEGIN {
    case_pre ="case_"
    case_num = 1
    case_tpl = "case.tpl"
    case_out = "case.out"
    sprintf("sed -n '$p' %s", case_tpl) |getline data_tpl
#    print data_tpl
    system(sprintf("echo '' >%s", case_out))
}

{
    if($0 ~ /正常：/ || $0 ~ /异常：/) {
        sprintf("echo %s |awk -F '：' '{print $2}'", $0) | getline keyword
        sprintf("echo %s |awk -F '_' '{print $NF}'", keyword) | getline arg_name
#        print keyword
#        print "----------------"

        while(1) {
            res = getline rec
            if(res == 0 || rec == "=") break

            sprintf("echo '%s' |awk -F'：' '{print $2}'", rec) |getline data
            sprintf("echo '%s' |sed 's/\\$/\\\\\\\\$/g'", rec) |getline rec_escape
#            print rec_escape

            cmd = " -e 's/$(case_name)/" case_pre case_num "/;'"
            cmd = cmd " -e 's/$(doc)/" rec_escape "/;s/$(keyword)/" keyword "/;'"

            split(data, arr, "、")
            for(i = 0; i < length(arr); i++) {
#                print "doc:" rec " -> " arr[i + 1]
                tpl = data_tpl
                sub(/\$\(args\)/, arg_name "=" arr[i + 1], tpl)
                cmd = cmd " -e '$a\\" tpl "'"
            }

            cmd = "sed " cmd " -e '$d' " case_tpl
#            print cmd
            print "Generate " case_pre case_num ": " rec
            system(sprintf("echo '' >>%s; %s >>%s", case_out, cmd, case_out))

            case_num++
        }
#        print "================="
    }
}
