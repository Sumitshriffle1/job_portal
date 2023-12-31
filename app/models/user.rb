class User < ApplicationRecord
  has_one :profile,dependent: :destroy
  has_many :applies,dependent: :destroy
  has_many :jobs,dependent: :destroy
  has_secure_password

  validates :name, :email, :password_digest, :contact, :type, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "email is not valid"}
  validates :password_digest, length: { minimum: 8 }
  validates :contact,format: {with:/\d[0-9]\z/}, length: { is: 10 }, uniqueness: true


  def self.ransackable_associations(auth_object = nil)
    ["applies", "jobs", "profile"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["contact", "created_at", "email", "id", "name", "password_digest", "type", "updated_at"]
  end

  def generate_password_token
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def password_reset(password_digest)
    self.reset_password_token = nil
    self.password_digest = password_digest
    save!
  end

  private
  def generate_token
    SecureRandom.hex(10)
  end
end
