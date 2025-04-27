*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Resource   Self_Heaaling_Moniker.robot 
Resource   Bits_Site_keyword.robot
Resource   Bits_Site_Variable.robot
Suite Setup    Set Screenshot Directory    ${CURDIR}\\Screenshots

*** Test Cases ***
Test1 - Verify Home Page Details
    [Setup]    Open URL    ${URL}    Chrome   
    Validate Home Page Details
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   Failed Teardown

Test2 - Verify If User Is Able To Fill Student Info And Validate It
    [Setup]    Open URL    ${URL}    Chrome   
    Fill Student From
    Validate Form Details
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   Failed Teardown

Test3 - Verify Important Details
    [Setup]    Open URL    ${URL}    Chrome   
    Validate Important Details
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   Failed Teardown

Test4 - Verify Course Details
    [Setup]    Open URL    ${URL}    Chrome
    Validate Course Deatils
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   Failed Teardown