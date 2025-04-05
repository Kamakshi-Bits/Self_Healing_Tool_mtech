*** Settings ***
Library    OperatingSystem
Library    Self_Heaaling_py.py
Library    String
Library    Process

*** Keywords ***
Passed Teardown
    Copy Files   ${CURDIR}\\Current_logs${/}*    ${CURDIR}\\Passed_Logs

Save Current Run Web Source
    ${Page_title}    SeleniumLibrary.Get Title
    ${Page_Source}   Get Source
    Create File     ${CURDIR}\\Current_logs\\${Page_title}.txt     ${Page_Source}

Failed Teardown
    Verify Folder Exists And Is Not Empty
    ${Is_self_heal_Applicable}    Validate Error and Proceed  ${TEST MESSAGE}   
    IF  '${Is_self_heal_Applicable}'=='True'
        log  ${TEST MESSAGE}    
        ${Page_title}    SeleniumLibrary.Get Title
        Get New Xpath and Update    ${Page_title}   ${TEST MESSAGE}
        SeleniumLibrary.Close Browser
        log to console  Re-Running Test Suite......
        ${current_Suite}   Get Current Running File
        Run Process    robot    ${current_Suite}
    ELSE
        FAIL    Potienial Error Found
    END

Get New Xpath and Update
    [Arguments]  ${File_Name}   ${TEST MESSAGE}
    ${xpath_condition}    extract_xpath_info    ${TEST MESSAGE}
    ${Changes_Tag_Line}   find_lines     ${CURDIR}\\Passed_Logs\\${File_Name}.txt    ${xpath_condition}
    log    ${Changes_Tag_Line} 
    ${Similarity_And_Check}    find_most_similar_line_sbert      ${Changes_Tag_Line}     ${CURDIR}\\Current_logs\\${File_Name}.txt 
    log  ${Similarity_And_Check}
    log  ${Similarity_And_Check[0]}
    log  ${Similarity_And_Check[1]}
    IF    ${Similarity_And_Check[1]}<= 95
        Get Desired Change Path     ${Changes_Tag_Line}    ${File_Name}
    ELSE
        ${Desired_Xpath}    generate_xpath    ${Similarity_And_Check[0]}
        ${Current_Xpath}=  Get Regexp Matches  ${TEST MESSAGE}    (//.*?])
        find_and_replace_text    ${CURDIR}    ${Current_Xpath[0]}     ${Desired_Xpath}
    END

Get Desired Change Path
    [Arguments]     ${Line}    ${File_Name}   ${Count}=0
    ${Count}   Evaluate   ${Count}+1
    ${Surrounded_line}    get_above_line    ${CURDIR}\\Passed_Logs\\${File_Name}.txt     ${Line}
    ${Similarity_And_Check}    find_most_similar_line_sbert      ${Surrounded_line}    ${CURDIR}\\Current_logs\\${File_Name}.txt 
    log  ${Similarity_And_Check[0]}
    log  ${Similarity_And_Check[1]}
    ${isfirst}   is_start_of_file   ${CURDIR}\\Passed_Logs\\${File_Name}.txt    ${Surrounded_line}
    IF   ${isfirst} == False
        IF    ${Similarity_And_Check[1]}<= 95
            Get Desired Change Path     ${Surrounded_line}    ${File_Name}   ${Count} 
        ELSE
            ${Changed_line}   get_next_line    ${CURDIR}\\Current_logs\\${File_Name}.txt   ${Similarity_And_Check[0]}     ${Count}
            ${Desired_Xpath}    generate_xpath    ${Changed_line}      
            ${Current_Xpath}=  Get Regexp Matches  ${TEST MESSAGE}    (//.*?])
            find_and_replace_text    ${CURDIR}    ${Current_Xpath[0]}     ${Desired_Xpath}
        END
    END


Verify Folder Exists And Is Not Empty
    Directory Should Exist    ${CURDIR}\\Passed_Logs    No Passed logs Found
    ${FILES}=    List Files In Directory   ${CURDIR}\\Passed_Logs
    Should Not Be Empty    ${FILES}   No Passed logs Found

Validate Error and Proceed
    [Arguments]    ${error_message}
    ${error_message_lower}    Convert To Lower Case    ${error_message}
    ${condition_1}    Run Keyword And Return Status    Should Contain    ${error_message_lower}    element with locator  
    ${condition_2}    Run Keyword And Return Status    Should Contain    ${error_message_lower}    element not visible
    IF    ${condition_1} or ${condition_2}
            Return From Keyword   True
    ELSE
            Return From Keyword   False
    END

Get Current Running File
    ${path}=    Get Variable Value    ${SUITE SOURCE}
    ${filename}=    Split String From Right    ${path}    \\    1
    RETURN    ${filename[1]}