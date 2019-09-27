#!/bin/bash

arrayOfCoverageTypes=("EXCEPTION" "BRANCH" "CBRANCH" "STRONGMUTATION" "WEAKMUTATION" "MUTATION" "STATEMENT" "IBRANCH" "ONLYBRANCH" "ONLYMUTATION" "METHODTRACE" "METHOD" "METHODNOEXCEPTION" "LINE" "ONLYLINE" "OUTPUT" "INPUT" "METHODPAIR")

arrayOfDuos=("METHODPAIR:OUTPUT" "METHODPAIR:CBRANCH" "OUTPUT:ONLYBRANCH" "METHOD:OUTPUT" "METHODPAIR:BRANCH" "OUTPUT:STATEMENT" "INPUT:OUTPUT" "METHODPAIR:MUTATION" "OUTPUT:MUTATION")

testingZone=test_generation_output

# create a directory to store backups of the generated test suites
mkdir test_suite_backup

# create bug_detection file at this stage in case the first iteration of test generation fails
cd $TESTGEN
mkdir bug_detection_output
cd bug_detection_output
touch bug_detection
echo "project_id,version_id,test_suite_source,test_id,test_classification,num_trigger" >> bug_detection

for a in {1..65}
do
    echo "*** Starting processing for Lang version $a ***"
    for i in "${arrayOfDuos[@]}"
    do
        echo "*** Starting processing for criteria $i ***"
        ii=1 # tracks the current iteration number
        success=0 # tracks the number of successful iterations i.e. where a test suite was generated
        while [ $success -lt 3 ];
        do
            echo "*** Starting iteration $ii for criteria $i ***"
            cd $TESTGEN/test-generation-defects4j/framework/bin
            
            echo "*** Generating Test Suite ***"
            $TESTGEN/test-generation-defects4j/framework/bin/run_evosuite.pl -p Lang -v "$a"f -n "$ii" -o $TESTGEN/"$testingZone" -c "$i" -a 600

            # check if a test suite was generated or not
            dir_old=evosuite-"$i"
            dir_name="${dir_old//:/}";
            file=$TESTGEN/"$testingZone"/Lang/$dir_old/"$ii"/Lang-"$a"f-"$dir_old"."$ii".tar.bz2
            if [ -f "$file" ]; then
                echo "*** Test Suite Successfully Generated ***"
                ((success+=1))

                echo "*** Renaming Test Suite Files ***"
                cd $TESTGEN/"$testingZone"/Lang
                mkdir "$dir_name"
                cd "$dir_name"
                mkdir "$ii"
                cd $TESTGEN/"$testingZone"/Lang/"$dir_old"/"$ii"
                file_old=Lang-"$a"f-"$dir_old"."$ii".tar.bz2
                file_new=Lang-"$a"f-"$dir_name"."$ii".tar.bz2
                mv "$file_old" $TESTGEN/"$testingZone"/Lang/"$dir_name"/"$ii"/
                cd ..
                rmdir "$ii"
                cd $TESTGEN/"$testingZone"/Lang/"$dir_name"/"$ii"
                mv "$file_old" "$file_new"

                echo "*** Fixing Test Suite ***"
                $TESTGEN/test-generation-defects4j/framework/util/fix_test_suite.pl -p Lang -d . -v "$a"f
                echo "*** Test Suite Fixed ***"

                echo "*** Running Bug Detection ***"
                $TESTGEN/test-generation-defects4j/framework/bin/run_bug_detection.pl -p Lang -d . -o $TESTGEN/bug_detection_output
                echo "*** Bug Detection Complete ***"
                
                echo "*** Cleaning Up Files ***"
                mv $file_new $TESTGEN/test_suite_backup
                rm fix_test_suite.compile.log
                rm fix_test_suite.summary.log
                rm fix_test_suite.run.log
                cd ..
                rmdir "$ii"
                cd ..
                rmdir "$dir_old"
                rmdir "$dir_name"
            else
                echo "*** Error during Test Suite Generation ***"
                line="Lang,${a}f,${dir_name},${ii},Error,-"
                file_path=$TESTGEN/bug_detection_output
                echo $line >> ${file_path}/bug_detection
                if [ $ii -eq 5 ] && [ $success -eq 0 ]; then
                    break
                elif [ $ii -eq 10 ] && [ $success -eq 1 ]; then
                    break
                elif [ $ii -eq 15 ]; then
                    break
                fi
            fi
            echo "*** Finished processing iteration $ii for criteria $i ***"
            echo "*** $success test suite(s) currently generated ***"
            ((ii+=1))
        done
        echo "*** Finished processing for criteria $i ***"
        echo "*** $success test suite(s) successfully generated for criteria $i ***"
    done
    echo "*** Finished processing for Lang version $a ***"
done