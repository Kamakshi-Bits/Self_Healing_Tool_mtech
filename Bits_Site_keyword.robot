*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Resource   Self_Heaaling_Moniker.robot 
Library    Collections

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
    Save Current Run Web Source 
    SeleniumLibrary.Scroll Element Into View 	 ${Validation_Path} 
    ${validate_Text}    SeleniumLibrary.Get Text 	 ${Validation_Path}
    Should Be Equal As Strings    ${validate_Text}    ${From_Validate_text}


Fill Student From
    Click Element 	 ${student_Form_Button}
    Save Current Run Web Source 
    input text 	 ${Name_Xpath} 	 Kamakshi
    input text   ${DOB_Xpath}    02-07-1997
    Select from dropdown    ${gender_Xpath}    female
    input text    ${email_Xpath}     2023mt932170@gmail.com
    input text    ${phone_xpath}    9811286701
    Select from dropdown    ${Department_Xpath}    Computer Science
    input text    ${address_xpath}    Rohini sector -9
    input text    ${Student_ID_Xpath}    235mt57654
    Click Element 	   ${Sports_Xpath}
    Click Element 	   ${Music_Xpath}
    Click Element 	 ${Register_Button}
    Handle Alert    action=ACCEPT

Select from dropdown
    [Arguments]    ${dropdown_Xpath}    ${Select_from_dropdown}
    Select From List By Value   ${dropdown_Xpath}    ${Select_from_dropdown}

Validate Form Details
    Click Element 	   ${student_detail_button} 
    Save Current Run Web Source 
    ${Student_id}    Get text and Return   ${studentiddisplay_Xpath}
    should be Equal as Strings    ${Student_id}    235mt57654
    ${Student_name}    Get text and Return   ${studentfullnamedisplay_Xpath}
    should be Equal as Strings    ${Student_name}    Kamakshi
    ${Student_course}    Get text and Return   ${studentcoursedisplay_Xpath}
    should be Equal as Strings    ${Student_course}    Computer Science
    ${Student_DOB}    Get text and Return   ${studentdobdisplay_Xpath}
    should be Equal as Strings    ${Student_DOB}    02-07-1997
    ${Student_gender}    Get text and Return   ${studentgenderdisplay_Xpath}
    should be Equal as Strings    ${Student_gender}    female
    ${Student_phone}    Get text and Return   ${studentphonedisplay_Xpath}
    should be Equal as Strings    ${Student_phone}    9811286701
    ${Student_Hoobby}    Get text and Return   ${studenthobbiedisplay_Xpath}
    should be Equal as Strings    ${Student_Hoobby}    sports, music
    
Get text and Return
    [Arguments]    ${display_field_Xpath}
    Save Current Run Web Source 
    ${text}    get text    ${display_field_Xpath}
    RETURN     ${text}

Validate Important Details
    Click Element 	 ${important_Updates_button}
    Validate Sections    ${admission_Deatils_Xpath}    🔥 Admissions Open for 2025-26\nLast Date to Apply: July 15, 2025\nLocation: BITS Pilani, All Campuses\nApply Now
    Validate Sections     ${Rank_details_Xpath}      🎓 BITS Pilani Ranked Among Top 10 Universities in India!\nRanked #7 in NIRF 2025 Rankings\nRecognized as a Top Global Institute for Engineering & Science
    Validate Sections     ${placemnt_details_Xpath}    📄 Placement Report 2024\nHighest Package: ₹1.5 Cr PA\nAverage Package: ₹28 LPA\nTop Recruiters: Google, Microsoft, Amazon, Tesla
    Validate Sections     ${course_details_Xpath}    📢 New Courses Introduced\nAI & Machine Learning\nCybersecurity & Ethical Hacking\nBlockchain & FinTech
    Validate Sections     ${campus_details_xpath}     🏛️ Campus Expansion\nNew Research Center Opening at BITS Pilani, Goa Campus\nFocus Areas: Quantum Computing, Space Tech & AI
    Validate Sections     ${upcoming_details_xpath}    🎉 Upcoming Events\nBITS Tech Fest 2025 – August 10-12, 2025\nGuest Speaker: Sundar Pichai (CEO, Google)\nHackathon with ₹10L Prize Pool!   

Validate Sections   
    [Arguments]    ${Section_Xpath}    ${Validate_Section}
    Save Current Run Web Source 
    ${Section_deatils}    Get text and Return    ${Section_Xpath}
    ${Section_list}=    Get your string to List    ${Section_deatils} 
    ${validation_list}    Get your string to List    ${Validate_Section}
    Lists Should Be Equal     ${Section_list}   ${validation_list} 

Get your string to List
    [Arguments]     ${string}
    Save Current Run Web Source 
    ${string_list}=    Split String    ${string}    \n
    RETURN   ${string_list}
    
Validate Course Deatils
    Click Element 	 ${course_button}
    Save Current Run Web Source 
    Validate Sections    ${cs_info_xpath}    💻 B.Tech in Computer Science & Engineering\nLearn cutting-edge technologies like **AI, Machine Learning, Cloud Computing, and Cybersecurity**.
    Validate Sections    ${ECE_info_xpath}    📡 B.Tech in Electronics & Communication Engineering\nSpecialize in **VLSI Design, Embedded Systems, and IoT** for a career in **semiconductors and telecommunications**.
    Validate Sections    ${ME_info_xpath}    ⚙️ B.Tech in Mechanical Engineering\nMaster **robotics, automotive engineering, and product design** with industry-relevant projects.
    Validate Sections    ${CE_info_xpath}     🏗️ B.Tech in Civil Engineering\nGain expertise in **structural engineering, smart cities, and sustainable construction**.
    Validate Sections    ${Qntum_info_xpath}     🔬 M.Sc. in Physics\nDeep dive into **Quantum Mechanics, Nanotechnology, and Astrophysics** with research-driven learning.
    Validate Sections    ${DSA_info_xpath}     📊 M.Sc. in Data Science & Analytics\nSpecialize in **Big Data, Machine Learning, and Artificial Intelligence** with real-world applications.
    Validate Sections    ${DBM_info_xpath}     🖥️ MBA in Digital Business Management\nLearn **Digital Marketing, E-commerce, and AI-driven business strategies**.
    Validate Sections    ${bio_info_xpath}     🧬 Ph.D. in Biotechnology\nResearch in **Genomics, Bioinformatics, and Advanced Drug Development**.

   