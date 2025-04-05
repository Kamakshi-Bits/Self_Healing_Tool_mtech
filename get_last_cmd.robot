*** Settings ***
Library    BuiltIn

*** Test Cases ***
Print Current Test File
    ${suite_name}=    Get Variable Value    ${SUITE_NAME}
    Log to    Running file (suite): ${suite_name}
