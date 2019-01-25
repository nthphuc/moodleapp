String LOGIN="""
  mutation Login(\$email: String!, \$password: String!){
    login(email: \$email, password: \$password)
  }
""".replaceAll('\n', ' ');

String COURSE_LIST="""
  query Courses{
    courses
    {
      id
      CourseCode
      CourseName
      Year
      Semester
      Participants{
        UserID
      }
    }
  }
""".replaceAll('\n', '');

String COURSE_DETAIL="""
  query Course(\$courseid: ID!){
    course(courseid:\$courseid)
    {
      id
      CourseCode
      CourseName
      Semester
      Year
      Participants{
        UserID
        FullName
        Email
      }
<<<<<<< HEAD
      Teachers{
        FullName
      }
      Grades{
        id
        GradeItemName
        Weight
        Max
        CourseID
=======
      Grades{
        UserID
        CourseID
        StudentID
        StudentName
        Assignment
        Midterm
        Final
>>>>>>> ee802170704be7834bef40cb3fc226990f1252c5
      }
    }
  } 
""".replaceAll('\n', '');

String UPDATE_USER="""
<<<<<<< HEAD
  mutation UpdateUser(\$fullname: String, \$email: String, \$city: String, \$country: String, \$description: String){
    updateUser(fullname:\$fullname,email:\$email, city: \$city, country: \$country,description:\$description){
=======
  mutation UpdateUser(\$userid: String!, \$fullname: String!, \$email: String!, \$description: String!){
    updateUser(userid:\$userid,fullname:\$fullname,email:\$email,description:\$description){
>>>>>>> ee802170704be7834bef40cb3fc226990f1252c5
      UserID
    }
  }
""".replaceAll('\n', '');

String USER_DETAIL="""
<<<<<<< HEAD
  query User{
    user{
      UserID
      FullName
      Class
      Email
      Description
      City
      Country
=======
  query User(\$id: ID!){
    user(id:\$id){
      UserID
      FullName   
      Email
      Description
>>>>>>> ee802170704be7834bef40cb3fc226990f1252c5
    }
  }
""".replaceAll('\n', '');

String ENROLL_COURSE="""
  mutation EnrollCourse(\$courseid:ID!){
    enrollCourse(courseid:\$courseid){
      UserID
    }
  }
""".replaceAll('\n', '');

String MODIFY_GRADE="""
  mutation ModifyGrade(\$courseid:String!,\$userid:String!,\$assignment:Float,\$midterm:Float,\$final:Float){
    modifyGrade(courseid:\$courseid,userid:\$userid,assignment:\$assignment,midterm:\$midterm,final:\$final){
      CourseID
    }
  }
<<<<<<< HEAD
""".replaceAll('\n', '');

String ADD_GRADE="""
  mutation AddGrade(\$courseid: String!,\$gradename: String!,\$weight: Float,\$max: Float){
    addGrade(courseid: \$courseid,gradename: \$gradename,weight: \$weight,max: \$max){
      CourseID
      GradeItemName
      Weight
      Max
    }
  }
""".replaceAll('\n', '');

String IMPORT_STUDENT_GRADE="""
  mutation ImportStudentGrade(\$gradeid: String!,\$studentid: String!,\$studentname: String,\$grade: Float!,\$feedback: String){
    importStudentGrade(gradeid: \$gradeid,studentid: \$studentid,studentname: \$studentname,grade: \$grade,feedback: \$feedback){
      StudentID
      StudentName
      Grade
    }
  }
""".replaceAll('\n', '');

String EDIT_GRADE="""
  mutation EditGradeInfo(\$courseid: String!,\$gradeid: String!,\$gradename: String,\$weight: Float, \$max: Float){
    modifyGradeInfo(courseid: \$courseid,gradeid: \$gradeid,gradename: \$gradename,weight: \$weight,max: \$max){
      GradeItemName
      Weight
      Max
    }
  }
""".replaceAll('\n', '');

String GRADE_LIST="""
  query GradeList(\$gradeid:String!,\$courseid:String!){
    gradeList(gradeid:\$gradeid,courseid:\$courseid){
      Grade
      Feedback
    }
  }
=======
>>>>>>> ee802170704be7834bef40cb3fc226990f1252c5
""".replaceAll('\n', '');