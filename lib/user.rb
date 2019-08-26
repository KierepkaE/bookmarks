require 'bcrypt'
require_relative './database_connection.rb'
class User
  attr_reader :id, :email

def initialize(id:, email:)
  @id= id
  @email = email
end

  def self.create(email:, password:)
    password = BCrypt::Password.create(password)
    result = DatabaseConnection.query(
      "INSERT INTO users (email, password) VALUES('#{email}', '#{password}') RETURNING id, email;")
      User.new(id: result[0]['id'], email: result[0]['email'])
  end

  def self.find(user_id:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = #{user_id};")
    User.new(id: result[0]['id'], email: result[0]['email'])
  end

  def self.authenticate(email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE email = '#{email}'")
    return unless result.any?
    User.new(id: result[0]['id'], email:result[0]['email'])
  end
end
