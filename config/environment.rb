require "pry"

require 'sqlite3'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}

# binding.pry

# puts "Just hang the students in the ceiling fan if they misbhave"
