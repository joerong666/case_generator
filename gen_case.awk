#!/bin/env awk -f

BEGIN {
    case_pre ="case_"
    case_num = 1
    case_tpl = "case.tpl"
    sprintf("sed -n '$p' %s", case_tpl) |getline data_tpl
#    print data_tpl

}

{
    if($0 ~ /正常：/ || $0 ~ /异常：/) {
        sprintf("echo %s |awk -F '：' '{print $2}'", $0) | getline keyword
#        print keyword
#        print "----------------"

        while(1) {
            res = getline rec
            if(res == 0 || rec == "=") break

            sprintf("echo '%s' |awk -F'：' '{print $2}'", rec) |getline data

            cmd = " -e 's/$(case_name)/" case_pre case_num "/;'"
            cmd = cmd " -e 's/$(doc)/" rec "/;s/$(keyword)/" keyword "/;'"

            split(data, arr, "、")
            for(i = 0; i < length(arr); i++) {
#                print "doc:" rec " -> " arr[i + 1]
                tpl = data_tpl
                aa = sub(/\$\(args\)/, arr[i + 1], tpl)
#                print "aa:" aa "--tpl" tpl
                cmd = cmd " -e '$a\\" tpl "'"
            }

            cmd = "sed " cmd " -e '$d' " case_tpl
#            print cmd
            print ""
            system(cmd)

            case_num++
        }
#        print "================="
    }
}
