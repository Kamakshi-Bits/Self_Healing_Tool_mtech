*** Settings ***
Library    OperatingSystem
Library    Self_Heaaling_py.py
Library    String
Library    Process
Library    DateTime
Library    BuiltIn
Library    JSONLibrary

*** Variables ***
${validator_file}   validator.txt
${IS_RERUN}    False
${log to console File}   log_to_console_text.txt

*** Keywords ***
Passed Teardown
    ${Page_title}    SeleniumLibrary.Get Title
    Copy Files  ${CURDIR}\\Current_logs\\${Page_title}.txt    ${CURDIR}\\Passed_Logs
    SeleniumLibrary.Close Browser

Save Current Run Web Source
    ${Page_title}    SeleniumLibrary.Get Title
    ${Page_Source}   Get Source
    Create File     ${CURDIR}\\Current_logs\\${Page_title}.txt     ${Page_Source}

Failed Teardown
    Verify Folder Exists And Is Not Empty
    ${Is_self_heal_Applicable}    Validate Error and Proceed  ${TEST MESSAGE}   
    IF  '${Is_self_heal_Applicable}'=='True'
        log  ${TEST MESSAGE}    
        ${xpath_condition} =   Extract Xpath Info   ${TEST MESSAGE}
        ${status}   Check_Iteration_For_Testcase    ${xpath_condition}
        log  ${status}
        IF   ${status} == ${False}
            ${Page_title}    SeleniumLibrary.Get Title
            SeleniumLibrary.Close Browser
            Get New Xpath and Update    ${Page_title}   ${TEST MESSAGE}
            ${re_run_var}    Get validator File Content
            Append To File    ${log to console File}   Updated Xpath ${xpath_condition} to ${Desired_Xpath}${\n} 
            ${timestamp}=    	Get Current Date   result_format=%Y_%m_%d_%H_%M_%S
            ${log_folder}=   Set Variable    Re_Run_logs/${timestamp}/${TEST_NAME}
            Create Directory    ${log_folder}
            ${current_Suite}   Get Current Running File
            ${result}=    Run Process  robot    --test    ${TEST_NAME}    --outputdir    ${log_folder}    --variable    IS_RERUN:True     ${current_Suite}   stdout=STDOUT    stderr=STDERR
            Log    ${result.stdout} 
            log    ${result.stderr}
            Run Keyword If    ${result.rc} == 0    Append To File    ${log to console File}  Test case Passed Check Re-Run Logs....${\n}
             ...    ELSE    get_stdout_error   ${result.stdout}
        ELSE
            FAIL    Manuel Intervention Required.
            SeleniumLibrary.Close Browser
        END
    ELSE
            FAIL    Potienial Error Found
            SeleniumLibrary.Close Browser
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
        ${Desired_Xpath}    Get Desired Change Path     ${Changes_Tag_Line}    ${File_Name}
    ELSE
        ${Desired_Xpath}    generate_xpath    ${Similarity_And_Check[0]}
        ${Current_Xpath}=  Get Regexp Matches  ${TEST MESSAGE}    (//.*?])
        set test variable   ${Desired_Xpath} 
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
            set test variable   ${Desired_Xpath} 
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

Suite_Setup_Keyword
    Set Screenshot Directory    ${CURDIR}\\Screenshots

Test_setup_keyword
    ${timestamp}=    	Get Current Date   result_format=%Y_%m_%d_%H_%M_%S
    IF     '${IS_RERUN}' == 'False'        
        Create File    ${validator_file}    ${timestamp}${\n}
        ${re_run_flag}    create dictionary
        Append to file    ${validator_file}    ${re_run_flag}${\n}
        ${console_list}    create list
        Append to file    ${validator_file}    ${console_list}${\n}
        Create File   ${log to console File}
    END
 
Check_Iteration_For_Testcase
    [Arguments]   ${TEST MESSAGE}
    ${variable_Name}   ${path}    find_variable_and_value    ${CURDIR}   ${TEST MESSAGE}
    ${re_run_var}    Get validator File Content
    ${re_run_flag}=    parse_string_to_dict    ${re_run_var[1]}
    ${status}   run keyword and return status     Dictionary Should Contain Key   ${re_run_flag}    ${variable_Name}_${path} 
    IF   ${status}==True
        ${value}    Get From Dictionary     ${re_run_flag}    ${variable_Name}_${path}        
        IF   '${value}'>='2'            
            log to console  out:${value}
            Set List Value      ${re_run_var}    1    ${re_run_flag} 
            log   ${re_run_var}
            Rewrite_file_With_update   ${validator_file}      ${re_run_var}
            Return From Keyword    ${True}
        ELSE
            ${value}    Evaluate    ${value} + 1
            log to console  new:${value}
            Set To Dictionary   ${re_run_flag}    ${variable_Name}_${path}    ${value}
            Set List Value      ${re_run_var}    1    ${re_run_flag} 
            log   ${re_run_var}
            Rewrite_file_With_update   ${validator_file}      ${re_run_var}
            Return From Keyword    ${False}
        END
    ELSE            
        ${count}    set variable   1
        log to console  extremenew:${count}
        Set To Dictionary     ${re_run_flag}    ${variable_Name}_${path}   ${count}
        Set List Value      ${re_run_var}    1    ${re_run_flag} 
        log   ${re_run_var}
        Rewrite_file_With_update   ${validator_file}      ${re_run_var}
        Return From Keyword    ${False}
    END
    Set List Value      ${re_run_var}    1    ${re_run_flag} 
    log   ${re_run_var}
    Rewrite_file_With_update   ${validator_file}      ${re_run_var}

Get Last Block As Clean List
    [Arguments]    ${file}
    ${content}=    Get File    ${file}
    ${lines}=    Split To Lines    ${content}
    ${cleaned}=    Evaluate    [line for line in ${lines} if line.strip() != '']
    RETURN    ${cleaned}

Get validator File Content 
    ${re_run_var}   Get Last Block As Clean List    ${validator_file}
    RETURN   ${re_run_var}
    
    
Rewrite_file_With_update
    [Arguments]   ${file}   ${updated_content}
    Create File    ${validator_file}    ${updated_content[0]}\n${updated_content[1]}\n${updated_content[2]}


get_stdout_error
    [Arguments]     ${result}
    ${stdout}=    Set Variable    ${result}
    ${lines}=    Split To Lines    ${stdout}
    ${length}=    Get Length    ${lines}
    FOR    ${index}    IN RANGE    1    ${length}
        ${line}=    Get From List    ${lines}    ${index}
        ${Is_self_heal_Applicable}       Run Keyword If    '''----------------''' in '''${line} '''   run keywords    check for error     ${lines}[${index - 1}]
        ...    AND    Exit For Loop
    END


check for error 
    [Arguments]     ${test_line}
    ${Is_self_heal_Applicable}    Validate Error and Proceed   ${test_line}  
    IF  '${Is_self_heal_Applicable}'=='False'
       Append To File    ${log to console File}   Potienial Error Found After Re-Run${\n}
    END


Print File Lines One By One
    [Arguments]    ${FILE_PATH}
    ${content}=    Get File    ${FILE_PATH}
    ${lines}=    Split To Lines    ${content}
    ${length}=    Get Length    ${lines}
    IF    ${length} == 0
        Log    No content to print
    ELSE
        FOR    ${line}    IN    @{lines}
            Log to console    ${line}
        END
    END