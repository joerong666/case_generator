#!/bin/env awk -f

BEGIN {
    case_pre ="case_"
    case_num = 1
    case_tpl = "case.tpl"
    case_out = "case.out"
    sprintf("sed -n '$p' %s", case_tpl) |getline data_tpl
    system(sprintf("echo '' >%s", case_out))
}

{
    if($0 ~ /正常：/ || $0 ~ /异常：/) {
        #标识正常还是异常
        sprintf("echo %s |awk -F '：' '{print $1}'", $0) | getline type_desc

        #紧跟"正常：" 或"异常："后面的单词为关键字，只允许有一个关键字
        #如果存在多个用顿号"、"隔开的单词，除了第一个会同时被用作关键字和tag之外，
        #其它单词都将被视为tag，当然，也可以直接用多个空格隔开不同的单词
        sprintf("echo %s |awk -F '[：、 ]' '{print $2}'", $0) | getline keyword
        sprintf("echo %s |awk -F '[：]' '{gsub(/、| /, \"  \", $2); print $2}'", $0) | getline tags

        #关键字以下划线分隔出来的最后一个单词将被视为关键字的参数
        sprintf("echo %s |awk -F '_' '{print $NF}'", keyword) | getline arg_name

        while(1) {
            res = getline rec
            if(res == 0 || rec == "=") break

            sprintf("echo '%s' |awk -F'：' '{print $2}'", rec) |getline data
            sprintf("echo '%s' |sed 's/\\$/\\\\\\\\$/g'", rec) |getline rec_escape
#            print rec_escape

            cmd = " -e 's/$(case_name)/" case_pre case_num "/;'"
            cmd = cmd " -e 's/$(doc)/" type_desc "：" rec_escape "/;'"
            cmd = cmd " -e 's/$(tags)/" tags "/;'"
            cmd = cmd " -e 's/$(keyword)/" keyword "/;'"

            split(data, arr, "、")
            for(i = 0; i < length(arr); i++) {
                tpl = data_tpl

                #指定第一个参数的名称
                sub(/\$\(args\)/, arg_name "=" arr[i + 1], tpl)

                #不指定第一个参数的名称，需小心值带有赋值号的数据
#                sub(/\$\(args\)/, arr[i + 1], tpl)

                cmd = cmd " -e '$a\\" tpl "'"
            }

            cmd = "sed " cmd " -e '$d' " case_tpl
#            print cmd
            print "Generate " case_pre case_num ": " rec
            system(sprintf("echo '' >>%s; %s >>%s", case_out, cmd, case_out))

            case_num++
        }
    }
}
