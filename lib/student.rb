class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    SQL

    rows = DB[:conn].execute(sql)
    rows.map{|e| self.new_from_db(e)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name is ? LIMIT 1
    SQL

    row = DB[:conn].execute(sql, name)
    
    self.new_from_db(row[0])
  end

  def self.all_students_in_grade_9
    self.all.select{|e| e.grade == '9'}
  end

    def self.students_below_12th_grade
    self.all.select{|e| e.grade.to_i < 12}
    end

    def self.first_X_students_in_grade_10(num)
    self.all.select{|e| e.grade == '10'}.shift(num)
    end

    def self.first_student_in_grade_10
       self.all.find{|e| e.grade == '10'}
    end

    def self.all_students_in_grade_X(num)
      self.all.select{|e| e.grade == "#{num}"}
    end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
