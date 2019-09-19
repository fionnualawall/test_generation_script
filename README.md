# Setup
## Prerequisites
Before starting the setup, ensure that the following are installed on the machine where the process will be run:

- Git
- Java 8
- Maven >= 3.1
- Perl >= 5.0.10
- Perl DBI
- Perl DBD::CSV

## Initial Setup

1. Create or choose a directory where all files and scripts for the test generation process will be stored.
2. Create an environment variable that holds the full path of the chosen directory by adding the following line to your .bashrc file:

    ```export TESTGEN=full/path/to/chosen/directory```

3. Navigate to the directory:

    ```cd $TESTGEN```

4. Clone the test_generation_script repository as follows & enter valid credentials when prompted:

    ```git clone (add link)```

## EvoSuite Setup
Follow the below steps to set up EvoSuite:

1.	Navigate to the TESTGEN directory:

    ```cd $TESTGEN```

2.	Clone the EvoSuite repository as follows & enter valid credentials when prompted:

    ```git clone https://github.com/aventresque/test-generation-evosuite.git```

3.	Navigate into the repository:

    ```cd $TESTGEN/test-generation-evosuite```

4.	Compile EvoSuite using Maven:

    ```mvn compile```

5.	Build the EvoSuite jar files:

    ```mvn package```

6.	Navigate to the directory where jar files should be generated:

    ```cd $TESTGEN/test-generation-evosuite/master/target```

7.	Verify that the following jar files have been generated:

    - original-evosuite-master-1.0.6-SNAPSHOT.jar
    - evosuite-master-1.0.6-SNAPSHOT.jar
    - evosuite-master-1.0.6-SNAPSHOT-tests.jar

8.	Navigate to the directory where the standalone-runtime jars should be generated:

    ```cd $TESTGEN/test-generation-evosuite/standalone_runtime/target```

9.	Verify that the following jar files have been generated:

    - original-evosuite-standalone-runtime-1.0.6-SNAPSHOT.jar
    - evosuite-standalone-runtime-1.0.6-SNAPSHOT.jar
    - evosuite-standalone-runtime-1.0.6-SNAPSHOT-tests.jar


## Defects4J Setup

Follow the below steps to set up Defects4J:

1.	Navigate to the TESTGEN directory:

    ```cd $TESTGEN```

2.	Clone the D4J repository as follows & enter valid credentials when prompted:

    ```git clone https://github.com/aventresque/test-generation-defects4j.git```

3.	Navigate into the repository:

    ```cd $TESTGEN/test-generation-defects4j```

4.	Initialise D4J:

    ```./init.sh```

5.	Add D4J executables to PATH by adding the following line to your .bashrc file:

    ```export PATH=$PATH:$TESTGEN/test-generation-defects4j/framework/bin```

6.	Copy the altered EvoSuite jars to D4J:

    ```cp $TESTGEN/test-generation-evosuite/master/target/evosuite-master-1.0.6-SNAPSHOT.jar $TESTGEN/test-generation-defects4j/framework/lib/test_generation/generation```

    ```cp $TESTGEN/test-generation-evosuite/standalone_runtime/target/evosuite-standalone-runtime-1.0.6-SNAPSHOT.jar $TESTGEN/test-generation-defects4j/framework/lib/test_generation/runtime```

7.	Update symlinks to point to the altered EvoSuite jars:

    ```cd $TESTGEN/test-generation-defects4j/framework/lib/test_generation/generation```

    ```ln -sfn evosuite-master-1.0.6-SNAPSHOT.jar evosuite-current.jar```

    ```cd $TESTGEN/test-generation-defects4j/framework/lib/test_generation/runtime```

    ```ln -sfn evosuite-standalone-runtime-1.0.6-SNAPSHOT.jar evosuite-rt.jar```