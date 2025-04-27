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
${academic_info_xpath}   //p[@id='academics_id']
${academic_info_text}    BITS Pilani offers Undergraduate, Postgraduate, and Ph.D. programs in engineering, management, and research.
${placement_info_xpath}   //p[@id='placement_id1']
${placement_info_text}    Our students are placed in top companies like Google, Microsoft, Amazon, Tesla, and many more.

###################### FILL FORM #############
${Name_Xpath}    //input[@id="fullName"]
${DOB_Xpath}     //input[@id="dob"]
${gender_Xpath}   //select[@id="gender"]
${email_Xpath}    //input[@id="email"]
${phone_xpath}    //input[@id="phone"]
${Department_Xpath}    //select[@id="department"]
${address_xpath}    //textarea[@id="address"]
${Student_ID_Xpath}    //input[@id="studentID"]
${Sports_Xpath}     //input[@id="sports"]
${Reading_Xpath}    //input[@id="reading"]
${Music_Xpath}    //input[@id="music"]
${Register_Button}   //input[@type="submit"]
${student_Form_Button}    //li/a[@id="Form"]

##################Form Validation ###############
${student_detail_button}    //a[@id="details"]
${studentiddisplay_Xpath}     //span[@id="displaystudentid"]
${studentfullnamedisplay_Xpath}     //span[@id="displayFullName"]
${studentcoursedisplay_Xpath}     //span[@id="displayCourse"]
${studentdobdisplay_Xpath}      //span[@id="displaydob"]
${studentgenderdisplay_Xpath}      //span[@id="displaygender"]
${studentphonedisplay_Xpath}      //span[@id="displayphone"]
${studenthobbiedisplay_Xpath}      //span[@id="displayHobbies"]

#################Important details##################
${important_Updates_button}    //a[@id="updates"]
${admission_Deatils_Xpath}   //div[@id="admissons_id"]
${Rank_details_Xpath}     //div[@id="rank_id"]
${placemnt_details_Xpath}     //div[@id="placement_id"]
${course_details_Xpath}     //div[@id="course_intro_id"]
${campus_details_xpath}     //div[@id="campus_id"]
${upcoming_details_xpath}     //div[@id="upcoming_id"]

###########Course Details ################
${course_button}   //a[@id="courses"]
${cs_info_xpath}   //div[@id="cs_info_id"]
${ECE_info_xpath}   //div[@id="ECE_info_id"]
${ME_info_xpath}   //div[@id="ME-info_id"]
${CE_info_xpath}      //div[@id="CE_info_id"]
${Qntum_info_xpath}     //div[@id="Qntum_info_id"]
${DSA_info_xpath}     //div[@id="DSA_info_id"]
${DBM_info_xpath}     //div[@id='DBM_info_id1' and @class='update-box']
${bio_info_xpath}     //div[@id="bio_info_id"]