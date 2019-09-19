#!/bin/bash

arrayOfCoverageTypes=("EXCEPTION" "BRANCH" "CBRANCH" "STRONGMUTATION" "WEAKMUTATION" "MUTATION" "STATEMENT" "IBRANCH" "ONLYBRANCH" "ONLYMUTATION" "METHODTRACE" "METHOD" "METHODNOEXCEPTION" "LINE" "ONLYLINE" "OUTPUT" "INPUT" "METHODPAIR")

arrayOfDuos=("METHODPAIR:OUTPUT" "METHODPAIR:CBRANCH" "OUTPUT:ONLYBRANCH" "METHOD:OUTPUT" "METHODPAIR:BRANCH" "OUTPUT:STATEMENT" "INPUT:OUTPUT" "METHODPAIR:MUTATION" "OUTPUT:MUTATION")

testingZone=testingZone40

for a in {21..40}
do
    for i in "${arrayOfDuos[@]}"
    do
        for ii in {1..3}
        do
            echo "$i $ii"
            cd /home/ciaran/Desktop/defects4j-java-8-support/framework/bin/
            /home/ciaran/Desktop/defects4j-java-8-support/framework/bin/run_evosuite.pl -p Lang -v "$a"b -n 1 -o /tmp/"$testingZone" -c "$i"
            cd /tmp/"$testingZone"/Lang/evosuite-"$i"/1
            dir_old=evosuite-"$i"
            echo "$dir_old"
            dir_name="${dir_old//:/}"; #mv "$dir" "$dir_name" && cd "$dir_name"
            cd ..
            cd ..

                mkdir "$dir_name"
                cd "$dir_name"
                mkdir 1
                cd /tmp/"$testingZone"/Lang/"$dir_old"/1
                file_old=Lang-"$a"b-"$dir_old".1.tar.bz2
                file_new=Lang-"$a"b-"$dir_name".1.tar.bz2
                mv "$file_old" /tmp/"$testingZone"/Lang/"$dir_name"/1/
                cd ..
                rmdir 1
                cd /tmp/"$testingZone"/Lang/"$dir_name"/1
                mv "$file_old" "$file_new"

            /home/ciaran/Desktop/clean_java_8_defects4j/defects4j/framework/util/fix_test_suite.pl -p Lang -d . -v "$a"b
            /home/ciaran/Desktop/clean_java_8_defects4j/defects4j/framework/bin/run_bug_detection.pl -p Lang -d . -o /Users/ciaranmurphy/Desktop/test8

            rm "$file_new"
            rm fix_test_suite.compile.log
            rm fix_test_suite.summary.log
            rm fix_test_suite.run.log
            cd ..
            rmdir 1
            ls
            cd ..
            rmdir "$dir_old"
            rmdir "$dir_name"
        done
    done
done