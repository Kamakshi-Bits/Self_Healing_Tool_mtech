*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Resource   Self_Heaaling_Moniker.robot 
Suite Setup    Set Screenshot Directory    ${CURDIR}\\Screenshots

*** Keywords ***
Open URL
    [Arguments]    ${URL}    ${browser}
    Open Browser   ${URL}     ${browser}   options=add_experimental_option("detach",True) 
    SeleniumLibrary.Maximize Browser Window

Validate Home Page Details
    Save Current Run Web Source 
    Validate Text On Home Page   ${about_bits_info_xpath}     ${about_bits_text}
    Validate Text On Home Page   ${Choose_Bits_reason1_xpath}     ${Choose_Bits_reason1}
    Validate Text On Home Page   ${Choose_Bits_reason2_xpath}     ${Choose_Bits_reason2}
    Validate Text On Home Page   ${Choose_Bits_reason3_xpath}     ${Choose_Bits_reason3}
    Validate Text On Home Page   ${Choose_Bits_reason4_xpath}     ${Choose_Bits_reason4}
    Validate Text On Home Page   ${campus1_xpath}     ${campus1_text}
    Validate Text On Home Page   ${campus2_xpath}     ${campus2_text}
    Validate Text On Home Page   ${campus3_xpath}     ${campus3_text}
    Validate Text On Home Page   ${campus4_xpath}     ${campus4_text}
    Validate Text On Home Page   ${academic_info_xpath}     ${academic_info_text}
    Validate Text On Home Page   ${placement_info_xpath}     ${placement_info_text}
    
Validate Text On Home Page 
    [Arguments]    ${Validation_Path}  ${From_Validate_text}
    SeleniumLibrary.Scroll Element Into View 	 ${Validation_Path} 
    ${validate_Text}    SeleniumLibrary.Get Text 	 ${Validation_Path}
    Should Be Equal As Strings    ${validate_Text}    ${From_Validate_text}


*** Test Cases ***
Test1 - Verify If User Is Able To Validate Home Page Details
    Open URL    ${URL}    Chrome   
    Validate Home Page Details
    [Teardown]   run keywords    Run Keyword If    '${TEST STATUS}' == 'PASS'   Passed Teardown
    ...    AND   Run Keyword If    '${TEST STATUS}' == 'FAIL'   Failed Teardown

*** Variables ***
${URL}     file:///C:/Users/Microsoft/Desktop/Bits/Website/index.html
${about_bits_info_xpath}    //p[@id='about_bits']
${about_bits_text}     Birla Institute of Technology and Science (BITS Pilani) is a premier institute in India, excelling in education, research, and innovation since 1964.
${Choose_Bits_reason1_xpath}    //li[@id='choose1']
${Choose_Bits_reason1}    ✅ Ranked among India’s top private universities
${Choose_Bits_reason2_xpath}    //li[@id='choose2']
${Choose_Bits_reason2}   ✅ Flexible academic structure with research opportunities
${Choose_Bits_reason3_xpath}    //li[@id='choose3']
${Choose_Bits_reason3}    ✅ Industry collaborations with Google, Microsoft, Tesla
${Choose_Bits_reason4_xpath}    //li[@id='choose4']
${Choose_Bits_reason4}   ✅ 50,000+ Global Alumni Network
${campus1_xpath}    //div[@id="campus1"]
${campus1_text}     📍 Pilani (Main Campus)
${campus2_xpath}    //div[@id="campus2"]
${campus2_text}     📍 Goa Campus
${campus3_xpath}    //div[@id="campus3"]
${campus3_text}     📍 Hyderabad Campus
${campus4_xpath}    //div[@id="campus4"]
${campus4_text}     📍 Dubai Campus
${academic_info_xpath}   //p[@id="academics_id"]
${academic_info_text}    BITS Pilani offers Undergraduate, Postgraduate, and Ph.D. programs in engineering, management, and research.
${placement_info_xpath}   //p[@id='placement_id1']
${placement_info_text}    Our students are placed in top companies like Google, Microsoft, Amazon, Tesla, and many more.


