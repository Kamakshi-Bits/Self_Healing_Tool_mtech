*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Resource    Self_Heaaling_Moniker.robot 
Resource   Bits_Site_keyword.robot
Resource   Bits_Site_Variable.robot
Suite Setup    Suite_Setup_Keyword 
Test Setup   Run keywords     Test_setup_keyword
...    AND    Open URL    ${URL}    Chrome 

*** Test Cases ***
Test1 - Verify Home Page Details
    [Documentation]    Verify the home page details of the BITS site
    Validate Home Page Details
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   run keywords    Failed Teardown
    ...    AND    Print File Lines One By One    ${log to console File}

Test2 - Verify If User Is Able To Fill Student Info And Validate It
    Fill Student From
    Validate Form Details
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   run keywords    Failed Teardown
    ...    AND    Print File Lines One By One     ${log to console File}

Test3 - Verify Important Details
    [Documentation]    Verify the important details of the BITS site
    Validate Important Details
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   run keywords    Failed Teardown
    ...    AND    Print File Lines One By One     ${log to console File}

Test4 - Verify Course Details
    [Documentation]    Verify the course details of the BITS site
    Validate Course Deatils
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   run keywords    Failed Teardown
    ...    AND    Print File Lines One By One     ${log to console File}
