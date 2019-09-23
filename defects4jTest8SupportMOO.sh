#!/bin/bash

arrayOfCoverageTypes=("EXCEPTION" "BRANCH" "CBRANCH" "STRONGMUTATION" "WEAKMUTATION" "MUTATION" "STATEMENT" "IBRANCH" "ONLYBRANCH" "ONLYMUTATION" "METHODTRACE" "METHOD" "METHODNOEXCEPTION" "LINE" "ONLYLINE" "OUTPUT" "INPUT" "METHODPAIR")

arrayOfDuos=("METHODPAIR:OUTPUT" "METHODPAIR:CBRANCH" "OUTPUT:ONLYBRANCH" "METHOD:OUTPUT" "METHODPAIR:BRANCH" "OUTPUT:STATEMENT" "INPUT:OUTPUT" "METHODPAIR:MUTATION" "OUTPUT:MUTATION")

testingZone=testingZone40

for a in {1..65}
do
    for i in "${arrayOfDuos[@]}"
    do
        for ii in {1..3}
        do
            echo "*** Starting processing for: $i $ii ***"
            cd $TESTGEN/test-generation-defects4j/framework/bin
            echo "*** Generating Test Suite ***"
            $TESTGEN/test-generation-defects4j/framework/bin/run_evosuite.pl -p Lang -v "$a"b -n 1 -o $TESTGEN/"$testingZone" -c "$i"
            echo "*** Test Suite Generated ***"
            cd $TESTGEN/"$testingZone"/Lang/evosuite-"$i"/1
            dir_old=evosuite-"$i"
            dir_name="${dir_old//:/}";
            cd ..
            cd ..

            mkdir "$dir_name"
            cd "$dir_name"
            mkdir 1
            cd $TESTGEN/"$testingZone"/Lang/"$dir_old"/1
            file_old=Lang-"$a"b-"$dir_old".1.tar.bz2
            file_new=Lang-"$a"b-"$dir_name".1.tar.bz2
            mv "$file_old" $TESTGEN/"$testingZone"/Lang/"$dir_name"/1/
            cd ..
            rmdir 1
            cd $TESTGEN/"$testingZone"/Lang/"$dir_name"/1
            mv "$file_old" "$file_new"

            echo "*** Fixing Test Suite ***"
            $TESTGEN/test-generation-defects4j/framework/util/fix_test_suite.pl -p Lang -d . -v "$a"b
            echo "*** Test Suite Fixed ***"
			echo "*** Running Bug Detection ***"
            $TESTGEN/test-generation-defects4j/framework/bin/run_bug_detection.pl -p Lang -d . -o $TESTGEN/d4j_output
            echo "*** Bug Detection Run ***"
			
			echo "*** Cleaning Up Files ***"
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
            echo "*** Finished processing for: $i $ii ***"
        done
    done
done