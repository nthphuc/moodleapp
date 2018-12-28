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
      Grades{
        UserID
        CourseID
        StudentID
        StudentName
        Assignment
        Midterm
        Final
      }
    }
  } 
""".replaceAll('\n', '');

String UPDATE_USER="""
  mutation UpdateUser(\$userid: String!, \$fullname: String!, \$email: String!, \$description: String!){
    updateUser(userid:\$userid,fullname:\$fullname,email:\$email,description:\$description){
      UserID
    }
  }
""".replaceAll('\n', '');

String USER_DETAIL="""
  query User(\$id: ID!){
    user(id:\$id){
      UserID
      FullName   
      Email
      Description
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
""".replaceAll('\n', '');