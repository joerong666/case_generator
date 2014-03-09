#!/bin/awk -f

/正常：|异常：/{
    sprintf("echo %s |awk -F'_' '{print $NF}'", $2) |getline arg
    print "def " $2 "(self, " arg ", **args):"
    print "    pass\n"
}
